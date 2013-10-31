%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "scanType.h"
double vars[26];

#include <string.h>
extern FILE *yyin;
extern int yylex();

void yyerror(const char *msg)
{
      printf("ERROR(PARSER): %s\n", msg);
}

%}

%union {
    TokenData * tokenData;
    double value;
}

%token<tokenData> ID NUMCONST CHARCONST STRINGCONST
%token<value> STATIC INT BOOLEAN CHAR IF ELSE WHILE FOREACH IN RETURN BREAK OR AND NOT TRUE FALSE GEQ LEQ EQ NEQ DEC INC PASSIGN MASSIGN
%%

program         : declarationList
;

declarationList    : declarationList declaration 
                    | declaration 
;

declaration     : varDeclaration 
                | funDeclaration 
;

varDeclaration     : typeSpecifier varDeclList ';' 
;

scopedVarDeclaration  : scopedTypeSpecifier varDeclList ';' 
;

varDeclList   : varDeclList ',' varDeclInitialize 
                | varDeclInitialize 
;

varDeclInitialize : varDeclId 
                    | varDeclId ':' simpleExpression
;

varDeclId     : ID 
                | ID '[' NUMCONST ']' 
;

scopedTypeSpecifier   : STATIC typeSpecifier 
                        | typeSpecifier 
;

typeSpecifier  : INT 
                | BOOLEAN 
                | CHAR 
;

funDeclaration : typeSpecifier ID '(' params ')' statement 
                | ID '(' params ')' statement 
;

params          : paramList 
                | /* epsilone */ 
;

paramList      : paramList ';' paramTypeList 
                | paramTypeList 
;

paramTypeList : typeSpecifier paramIdList 
;

paramIdList   : paramIdList ',' paramId 
                | paramId 
;

paramId        : ID 
                | ID '[' ']'
;

statement       : unmatched
                | matched
                | iterationStmt
;

statement_other_than_conditional    : expressionStmt 
                                    | compoundStmt 
                                    | returnStmt 
                                    | breakStmt 
;

compoundStmt   : '{' localDeclarations statementList '}'
;

localDeclarations  : localDeclarations scopedVarDeclaration
                    | /* epsilon */
;

statementList  : statementList statement
                | /* epsilon */
;

expressionStmt : expression ';'
                | ';'
;

/*selection-stmt  : IF '(' simple-expression ')' statement ;
                | IF '(' simple-expression ')' statement ELSE statement ;
;*/

matched         : IF '(' simpleExpression ')' matched ELSE matched
                | statement_other_than_conditional
;

unmatched       : IF '(' simpleExpression ')' matched ELSE unmatched
                | IF '(' simpleExpression ')' statement
;

iterationStmt  : iterationMatched
                | iterationUnmatched
;

iterationMatched   : WHILE '(' simpleExpression ')' matched
                    |   FOREACH '(' simpleExpression ')' matched
;

iterationUnmatched   : WHILE '(' simpleExpression ')' unmatched
                    |   FOREACH '(' simpleExpression ')' unmatched
;

returnStmt     : RETURN ';' 
                | RETURN expression ';' 
;

breakStmt      : BREAK ';' 
;

expression      : mutable '=' expression 
                | mutable PASSIGN expression 
                | mutable MASSIGN expression 
                | mutable INC 
                | mutable DEC 
                | simpleExpression 
;

simpleExpression   : simpleExpression OR andExpression 
                    | andExpression 
;

andExpression  : andExpression AND unaryRelExpression 
                | unaryRelExpression 
;

unaryRelExpression    : NOT unaryRelExpression 
                        | relExpression 
;

relExpression  : sumExpression relop sumExpression 
                | sumExpression 
;

relop           : LEQ 
                | '<' 
                | '>' 
                | GEQ 
                | EQ  
                | NEQ 
;

sumExpression  : sumExpression sumop term 
                | term 
;

sumop           : '+' 
                | '-' 
;

term            : term mulop unaryExpression 
                | unaryExpression 
;

mulop           : '*' 
                | '/' 
                | '%' 
;

unaryExpression    : unaryop unaryExpression 
                    | factor 
;

unaryop         : '-' 
                | '*' 
;

factor          : immutable 
                | mutable 
;

mutable         : ID 
                | ID '[' expression ']' 
;

immutable       : '(' expression ')' 
                | call 
                | constant 
;

call            : ID '(' args ')' 
;

args            : argList 
                | /* epsilon */ 
;

argList        : argList ',' expression
                | expression 
;

constant        : NUMCONST 
                | CHARCONST 
                | STRINGCONST 
                | TRUE 
                | FALSE 
;
%%

int main(int argc, char* argv[]) {

    /*int debug = 0;
    int error = 0;
    int c;
    int index;
    char *cvalue = NULL;*/

    //static char usage[] = "usage: %s [-dmp] -f fname [-s sname] name [name ...]\n";

    int i;
    yydebug = 1;

    /*while (( c == getopt( argc, argv, "d" )) != -1 ) {

        switch ( c )  {
            case 'd':
                debug = 1;
                break;
            case '?':
                error = 1;
                break;
        }

    }

    if (error) {
        fprintf(stderr, usage, argv[0]);
        exit(1);
    }

    if (debug > 0) {
        yydebug = 1;
    }

    for (index = optind; index < argc; index++) {
        printf ("Non-option argument %s\n", argv[index]);
    }
         
    return 0;*/

    if(argc > 1) {
        
        //try to load file
        FILE *myfile = fopen(argv[1], "r");

        if (!myfile) {
            printf("Can't find file: %s\n", argv[1]);
        } else {
            yyin = myfile;
        }
    }

    for (i = 0; i < 26; i++) {
        vars[i] = 0;
    }

    yyparse(); //call the parser
}