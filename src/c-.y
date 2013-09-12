%{
#include <stdio.h>
#include <stdlib.h>
#include "scanType.h"
double vars[26];

#include <string.h>
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
%token<value> STATIC INT BOOL CHAR IF ELSE WHILE FOREACH IN RETURN BREAK OR AND TRUE FALSE
%%


stmt    : a stmt  ;
        | a       ;
;
a       : ';' { printf("Line %i Token: ;\n", yylval.tokenData->linenum); }
        | ',' { printf("Line %i Token: ,\n", yylval.tokenData->linenum); }
        | ':' { printf("Line %i Token: :\n", yylval.tokenData->linenum); }
        | '[' { printf("Line %i Token: [\n", yylval.tokenData->linenum); }
        | ']' { printf("Line %i Token: ]\n", yylval.tokenData->linenum); }
        | '{' { printf("Line %i Token: {\n", yylval.tokenData->linenum); }
        | '}' { printf("Line %i Token: }\n", yylval.tokenData->linenum); }
        | '(' { printf("Line %i Token: (\n", yylval.tokenData->linenum); }
        | ')' { printf("Line %i Token: )\n", yylval.tokenData->linenum); }
        | '<' { printf("Line %i Token: <\n", yylval.tokenData->linenum); }
        | '>' { printf("Line %i Token: >\n", yylval.tokenData->linenum); }
        | '=' { printf("Line %i Token: =\n", yylval.tokenData->linenum); }
        | '+' { printf("Line %i Token: +\n", yylval.tokenData->linenum); }
        | '-' { printf("Line %i Token: -\n", yylval.tokenData->linenum); }
        | '*' { printf("Line %i Token: *\n", yylval.tokenData->linenum); }
        | '/' { printf("Line %i Token: /\n", yylval.tokenData->linenum); }
        | '%' { printf("Line %i Token: modec\n", yylval.tokenData->linenum); }
        | '!' { printf("Line %i Token: modec\n", yylval.tokenData->linenum); }
        | '\n' ;

        | STATIC { printf("Line %i Token: STATIC\n", yylval.tokenData->linenum); }
        | INT { printf("Line %i Token: INT\n", yylval.tokenData->linenum); }
        | BOOL { printf("Line %i Token: BOOL\n", yylval.tokenData->linenum); }
        | CHAR { printf("Line %i Token: CHAR\n", yylval.tokenData->linenum); }
        | IF { printf("Line %i Token: IF\n", yylval.tokenData->linenum); }
        | ELSE { printf("Line %i Token: ELSE\n", yylval.tokenData->linenum); }
        | WHILE { printf("Line %i Token: WHILE\n", yylval.tokenData->linenum); }
        | FOREACH { printf("Line %i Token: FOREACH\n", yylval.tokenData->linenum); }
        | IN { printf("Line %i Token: IN\n", yylval.tokenData->linenum); }
        | RETURN { printf("Line %i Token: RETURN\n", yylval.tokenData->linenum); }
        | BREAK { printf("Line %i Token: BREAK\n", yylval.tokenData->linenum); }
        | OR { printf("Line %i Token: OR\n", yylval.tokenData->linenum); }
        | AND { printf("Line %i Token: AND\n", yylval.tokenData->linenum); }
        | TRUE { printf("Line %i Token: TRUE\n", yylval.tokenData->linenum); }
        | FALSE { printf("Line %i Token: FALSE\n", yylval.tokenData->linenum); }

        | NUMCONST {printf("Line %i Token: NUMBER Value %s:\n", yylval.tokenData->linenum, yylval.tokenData->tokenStr); }
        | CHARCONST {printf("Line %i Token: CHARCONST Value: %s\n", yylval.tokenData->linenum, yylval.tokenData->tokenStr); }
        | STRINGCONST {printf("Line %i Token: STRINGCONST Value: %s\n", yylval.tokenData->linenum, yylval.tokenData->tokenStr); }
        | ID {printf("Line %i Token: ID Value: %s\n", yylval.tokenData->linenum, yylval.tokenData->tokenStr); }
;
%%

int main() {
    int i;
    yydebug = 0;

    for (i = 0; i < 26; i++) {
        vars[i] = 0;
    }

    yyparse(); //call the parser
}