%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string>
//#include "treeNode.h"
#include "tree.h"
#include "scanType.h"

using namespace std;

double vars[26];


extern FILE *yyin;
extern int yylex();

void yyerror(const char *msg)
{
      printf("ERROR(PARSER): %s\n", msg);
}

static Tree * savedTree;

%}

%union {
    TokenData * tokenData;
    Tree * tree;
    double value;
}

%token<tokenData> ID NUMCONST CHARCONST STRINGCONST
%token<value> STATIC INT BOOLEAN CHAR IF ELSE WHILE FOREACH IN RETURN BREAK OR AND NOT TRUE FALSE GEQ LEQ EQ NEQ DEC INC PASSIGN MASSIGN

%type<tree> program declarationList declaration varDeclaration scopedVarDeclaration 
%type<tree>varDeclList varDeclInitialize varDeclId scopedTypeSpecifier typeSpecifier funDeclaration 
%type<tree>params paramTypeList paramIdList paramId statement statement_other_than_conditional 
%type<tree>compoundStmt localDeclarations statementList expressionStmt matched unmatched 
%type<tree>iterationMatched iterationUnmatched returnStmt breakStmt
%type<tree>andExpression unaryRelExpression relExpression relop sumExpression sumop term mulop 
%type<tree>unaryExpression unaryop factor mutable immutable call args argList constant

%type<tree> iterationStmt simpleExpression paramList expression

%%

program         : declarationList {savedTree = $1; }
;

declarationList    : declarationList declaration 
                        {
                            $$ = new Tree("declarationList", yylval.tokenData->linenum); 
                            $$->addSibling($2); 
                        }
                    | declaration { $$ = $1; }
;

declaration     : varDeclaration {$$ = $1;}
                | funDeclaration {$$ = $1 }
;

varDeclaration     : typeSpecifier varDeclList ';' 
                        {
                            $$ = new Tree("varDeclaration", yylval.tokenData->linenum); 
                            $1->addSibling($2);
                        }
;

scopedVarDeclaration  : scopedTypeSpecifier varDeclList ';' 
                        {
                            $$ = new Tree("scopedVarDeclaration", yylval.tokenData->linenum); 
                            $$->addSibling($2);
                        }
;

varDeclList   : varDeclList ',' varDeclInitialize 
                        {
                            $$ = new Tree("varDeclList", yylval.tokenData->linenum); 
                            $$->addSibling($3);
                        }
                | varDeclInitialize {$$ = $1;}
;

varDeclInitialize : varDeclId {$$ = $1;}
                    | varDeclId ':' simpleExpression
                        {
                            $$ = new Tree("varDeclInitialize", yylval.tokenData->linenum); 
                            $$->addSibling($3);
                        }
;

varDeclId     : ID {$$ = new Tree("ID", yylval.tokenData->linenum); }
                | ID '[' NUMCONST ']' 
                        {
                            $$ = new Tree("varDeclID", yylval.tokenData->linenum);
                        }
;

scopedTypeSpecifier   : STATIC typeSpecifier
                            {
                                $$ = new Tree("varDeclID", yylval.tokenData->linenum); 
                                $$->addSibling($2);
                            }
                        | typeSpecifier {$$ = $1}
;

typeSpecifier  : INT {$$ = new Tree("int", yylval.tokenData->linenum); }
                | BOOLEAN {$$ = new Tree("boolean", yylval.tokenData->linenum); }
                | CHAR {$$ = new Tree("char", yylval.tokenData->linenum); }
;

funDeclaration : typeSpecifier ID '(' params ')' statement 
                        {
                            $$ = new Tree("funDeclartion", yylval.tokenData->linenum); 
                            $$->addSibling($1);

                            $$->addChild($4);

                            $$->addSibling($6);
                        }
                | ID '(' params ')' statement 
                    {
                        $$ = new Tree("funDeclartion", yylval.tokenData->linenum);
                        $$->addChild($3);
                        $$->addChild($5);
                    }
;

params          : paramList {$$ = $1;}
                | {$$ = NULL} /* epsilone */ 
;

paramList      : paramList ';' paramTypeList
                    {
                        $$ = new Tree("paramList", yylval.tokenData->linenum); 
                        $$->addChild($3);
                    }
                | paramTypeList {$$ = $1;}
;

paramTypeList : typeSpecifier paramIdList 
                    {
                        $$ = new Tree("paramTypeList", yylval.tokenData->linenum);
                        $$->addSibling($2);
                    }
;

paramIdList   : paramIdList ',' paramId 
                    {
                        $$ = new Tree("paramList", yylval.tokenData->linenum);
                        $$->addSibling($3);
                    }
                | paramId {$$ = $1;}
;

paramId        : ID {$$ = new Tree("paramId", yylval.tokenData->linenum);}
                | ID '[' ']' {$$ = new Tree("paramId", yylval.tokenData->linenum);}
;

statement       : unmatched {$$ = $1;}
                | matched {$$ = $1;}
                | iterationStmt {$$ = $1;}
;

statement_other_than_conditional    : expressionStmt {$$ = $1;}
                                    | compoundStmt {$$ = $1;}
                                    | returnStmt {$$ = $1;}
                                    | breakStmt {$$ = $1;}
;

compoundStmt   : '{' localDeclarations statementList '}'
                    {
                        $$ = new Tree("compoundStmt", yylval.tokenData->linenum);
                        $$->addChild($2);
                        $$->addChild($3);
                    }
;

localDeclarations  : localDeclarations scopedVarDeclaration
                    {
                        $$ = new Tree("localDeclarations", yylval.tokenData->linenum);
                        $$->addChild($2);
                    }
                    | {$$ = NULL} /* epsilon */
;

statementList  : statementList statement
                    {
                        $$ = new Tree("statementList", yylval.tokenData->linenum);
                        $$->addChild($2);
                    }
                | {$$ = NULL} /* epsilon */
;

expressionStmt : expression ';' {$$ = $1;}
                | ';' {$$ = new Tree("semi colon", yylval.tokenData->linenum);}
;

/*selection-stmt  : IF '(' simple-expression ')' statement ;
                | IF '(' simple-expression ')' statement ELSE statement ;
;*/

matched         : IF '(' simpleExpression ')' matched ELSE matched
                    {
                        $$ = new Tree("If stmt", yylval.tokenData->linenum);
                        $$->addChild($3);
                        $$->addChild($5);
                        $$->addChild($7);
                    }
                | statement_other_than_conditional {$$ = $1;}
;

unmatched       : IF '(' simpleExpression ')' matched ELSE unmatched
                    {
                        $$ = new Tree("If stmt", yylval.tokenData->linenum);
                        $$->addChild($3);
                        $$->addChild($5);
                        $$->addChild($7);
                    }
                | IF '(' simpleExpression ')' statement
                    {
                        $$ = new Tree("If stmt", yylval.tokenData->linenum);
                        $$->addChild($3);
                        $$->addChild($5);
                    }
;

iterationStmt  : iterationMatched {$$ = $1;}
                | iterationUnmatched {$$ = $1;}
;

iterationMatched   : WHILE '(' simpleExpression ')' matched
                        {
                            $$ = new Tree("iterationMatched", yylval.tokenData->linenum);
                            $$->addSibling($3);
                            $$->addChild($5);
                        }
                    |   FOREACH '(' simpleExpression ')' matched
                        {
                            $$ = new Tree("iterationMatched", yylval.tokenData->linenum);
                            $$->addChild($3);
                            $$->addChild($5);
                        }
;

iterationUnmatched   : WHILE '(' simpleExpression ')' unmatched
                        {
                            $$ = new Tree("iterationUnmatched", yylval.tokenData->linenum);
                            $$->addChild($3);
                            $$->addChild($5);
                        }
                    |   FOREACH '(' simpleExpression ')' unmatched
                        {
                            $$ = new Tree("iterationUnmatched", yylval.tokenData->linenum);
                            $$->addChild($3);
                            $$->addChild($5);
                        }
;

returnStmt     : RETURN ';' {$$ = new Tree("return", yylval.tokenData->linenum);}
                | RETURN expression ';' 
                    {
                        $$ = new Tree("return", yylval.tokenData->linenum);
                        $$->addSibling($2);
                    }
;

breakStmt      : BREAK ';' {$$ = new Tree("break", yylval.tokenData->linenum);}
;

expression      : mutable '=' expression 
                    {
                        $$ = new Tree("expression", yylval.tokenData->linenum);
                        $$->addSibling($1);
                        $$->addSibling($3);
                    }
                | mutable PASSIGN expression 
                    {
                        $$ = new Tree("expression", yylval.tokenData->linenum);
                        $$->addSibling($1);
                        $$->addSibling($3);
                    }
                | mutable MASSIGN expression 
                    {
                        $$ = new Tree("expression", yylval.tokenData->linenum);
                        $$->addSibling($1);
                        $$->addSibling($3);
                    }
                | mutable INC 
                    {
                        $$ = new Tree("expression", yylval.tokenData->linenum);
                        $$->addSibling($1);
                    }
                | mutable DEC 
                    {
                        $$ = new Tree("expression", yylval.tokenData->linenum);
                        $$->addSibling($1);
                    }
                | simpleExpression {$$ = $1}
;

simpleExpression   : simpleExpression OR andExpression 
                        {
                            $$ = new Tree("simpleExpression", yylval.tokenData->linenum);
                            $$->addSibling($1);
                            $$->addSibling($3);
                        }
                    | andExpression {$$ = $1;}
;

andExpression  : andExpression AND unaryRelExpression 
                    {
                        $$ = new Tree("andExpression", yylval.tokenData->linenum);
                        $$->addSibling($1);
                        $$->addSibling($3);
                    }
                | unaryRelExpression {$$ = $1;}
;

unaryRelExpression    : NOT unaryRelExpression 
                            {
                                $$ = new Tree("unaryRelExpression", yylval.tokenData->linenum);
                                $$->addSibling($2);
                            }
                        | relExpression {$$ = $1;}
;

relExpression  : sumExpression relop sumExpression 
                    {
                        $$ = new Tree("relExpression", yylval.tokenData->linenum);
                        $$->addSibling($2);
                        $$->addSibling($3);
                    }
                | sumExpression {$$ = $1;}
;

relop           : LEQ {$$ = new Tree("LEQ", yylval.tokenData->linenum);}
                | '<' {$$ = new Tree("<", yylval.tokenData->linenum);}
                | '>' {$$ = new Tree(">", yylval.tokenData->linenum);}
                | GEQ {$$ = new Tree("GEQ", yylval.tokenData->linenum);}
                | EQ  {$$ = new Tree("EQ", yylval.tokenData->linenum);}
                | NEQ {$$ = new Tree("NEQ", yylval.tokenData->linenum);}
;

sumExpression  : sumExpression sumop term 
                    {
                        $$ = new Tree("sumExpression", yylval.tokenData->linenum);
                        $$->addSibling($2);
                        $$->addSibling($3);
                    }
                | term {$$ = $1;}
;

sumop           : '+' {$$ = new Tree("+", yylval.tokenData->linenum);}
                | '-' {$$ = new Tree("-", yylval.tokenData->linenum);}
;

term            : term mulop unaryExpression 
                    {
                        $$ = new Tree("term", yylval.tokenData->linenum);
                        $$->addSibling($2);
                        $$->addSibling($3);
                    }
                | unaryExpression {$$ = $1;}
;

mulop           : '*' {$$ = new Tree("*", yylval.tokenData->linenum);}
                | '/' {$$ = new Tree("/", yylval.tokenData->linenum);}
                | '%' {$$ = new Tree("%", yylval.tokenData->linenum);}
;

unaryExpression    : unaryop unaryExpression 
                        {
                            $$ = new Tree("unaryExpression", yylval.tokenData->linenum);
                            $$->addSibling($2);
                        }
                    | factor {$$ = new Tree("factor", yylval.tokenData->linenum);}
;

unaryop         : '-' {$$ = new Tree("-", yylval.tokenData->linenum);}
                | '*' {$$ = new Tree("+", yylval.tokenData->linenum);}
;

factor          : immutable {$$ = $1;}
                | mutable {$$ = $1;}
;

mutable         : ID {$$ = new Tree("ID", yylval.tokenData->linenum);}
                | ID '[' expression ']' 
                    {
                        $$ = new Tree("ID", yylval.tokenData->linenum);
                        $$->addChild($3);
                    }
;

immutable       : '(' expression ')' {$$ = $2}
                | call {$$ = $1;}
                | constant {$$ = $1;}
;

call            : ID '(' args ')' 
                    {
                        $$ = new Tree("call", yylval.tokenData->linenum);
                        $$->addSibling($3);
                    }
;

args            : argList {$$ = $1;}
                | {$$ = NULL }/* epsilon */ 
;

argList        : argList ',' expression
                    {
                        $$ = new Tree("arglist", yylval.tokenData->linenum);
                        $$->addSibling($3);
                    }
                | expression {$$ = $1;}
;

constant        : NUMCONST {$$ = new Tree("NUMCONST", yylval.tokenData->linenum);}
                | CHARCONST {$$ = new Tree("CHARCONST", yylval.tokenData->linenum);}
                | STRINGCONST {$$ = new Tree("STRINGCONST", yylval.tokenData->linenum);}
                | TRUE {$$ = new Tree("TRUE", yylval.tokenData->linenum);}
                | FALSE {$$ = new Tree("FALSE", yylval.tokenData->linenum);}
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
    //yydebug = 1;

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

    savedTree->print(0);
}