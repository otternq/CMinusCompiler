%{
#include <stdio.h>
#include <stdlib.h>
#include "scanType.h"
double vars[26];

#include <string.h>
extern int yylex();
extern FILE *yyin;

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

program         : declaration-list
;

declaration-list    : declaration-list declaration 
                    | declaration 
;

declaration     : var-declaration 
                | fun-declaration 
;

var-declaration     : type-specifier var-decl-list ';' 
;

scoped-var-declaration  : scoped-type-specifier var-decl-list ';' 
;

var-decl-list   : var-decl-list ',' var-decl-initialize 
                | var-decl-initialize 
;

var-decl-initialize : var-decl-id 
                    | var-decl-id ':' simple-expression
;

var-decl-id     : ID 
                | ID '[' NUMCONST ']' 
;

scoped-type-specifier   : STATIC type-specifier 
                        | type-specifier 
;

type-specifier  : INT 
                | BOOLEAN 
                | CHAR 
;

fun-declaration : type-specifier ID '(' params ')' statement 
                | ID '(' params ')' statement 
;

params          : param-list 
                | /* epsilone */ 
;

param-list      : param-list ';' param-type-list 
                | param-type-list 
;

param-type-list : type-specifier param-id-list 
;

param-id-list   : param-id-list ',' param-id 
                | param-id 
;

param-id        : ID 
                | ID '[' ']'
;

statement       : statement_other_than_conditional 
                | unmatched
                | matched
;

statement_other_than_conditional    : expression-stmt 
                                    | compound-stmt 
                                    | iteration-stmt 
                                    | return-stmt 
                                    | break-stmt 
;

compound-stmt   : '{' local-declarations statement-list '}'
;

local-declarations  : local-declarations scoped-var-declaration
                    | /* epsilon */
;

statement-list  : statement-list statement
                | /* epsilon */
;

expression-stmt : expression ';'
                | ';'
;

/*selection-stmt  : IF '(' simple-expression ')' statement ;
                | IF '(' simple-expression ')' statement ELSE statement ;
;*/

matched         : IF '(' simple-expression ')' matched ELSE matched
                | statement_other_than_conditional
;

unmatched       : IF '(' simple-expression ')' matched
                | IF '(' simple-expression ')' unmatched
;

iteration-stmt  : WHILE '(' simple-expression ')' statement 
                | FOREACH '(' mutable IN simple-expression ')' statement 
;

return-stmt     : RETURN ';' 
                | RETURN expression ';' 
;

break-stmt      : BREAK ';' 
;

expression      : mutable '=' expression 
                | mutable PASSIGN expression 
                | mutable MASSIGN expression 
                | mutable INC 
                | mutable DEC 
                | simple-expression 
;

simple-expression   : simple-expression OR and-expression 
                    | and-expression 
;

and-expression  : and-expression AND unary-rel-expression 
                | unary-rel-expression 
;

unary-rel-expression    : NOT unary-rel-expression 
                        | rel-expression 
;

rel-expression  : sum-expression relop sum-expression 
                | sum-expression 
;

relop           : LEQ 
                | '<' 
                | '>' 
                | GEQ 
                | EQ  
                | NEQ 
;

sum-expression  : sum-expression sumop term 
                | term 
;

sumop           : '+' 
                | '-' 
;

term            : term mulop unary-expression 
                | unary-expression 
;

mulop           : '*' 
                | '/' 
                | '%' 
;

unary-expression    : unaryop unary-expression 
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

args            : arg-list 
                | /* epsilon */ 
;

arg-list        : arg-list ',' expression
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
    int i;
    yydebug = 1;

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