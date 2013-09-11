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

%token<tokenData> NUMBER ID QUIT
%token<value> exp term varornum

%%
stmtlist:   stmt '\n'
            | stmt '\n' stmtlist
            ;
stmt:       ID '=' exp { vars[$1->idValue] = $3;}
            | exp
            | QUIT
            ;
%%

int main() {
    int i;
    yydebug = 1;

    for (i = 0; i < 26; i++) {
        vars[i] = 0;
    }

    yyparse(); //call the parser
}