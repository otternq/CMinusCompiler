%{
#include <stdlib.h>
#include "scanType.h"
#include "calc.tab.h"

static int line = 1;

int setVal(int linenum, int tokenClass, char * svalue) {

    yylval.tokenData = new TokenData();
    yylval.tokenData->tokenClass = tokenClass;
    yylval.tokenData->linenum = linenum;
    yylval.tokenData->tokenStr = strdup(svalue);

    switch(tokenClass) {
        case NUMBER:
            yylval.tokenData->numValue = atof(svalue);
            break;
        case ID:
            yylval.tokenData->idValue = svalue[0] - 'A';
            break;
        case QUIT:
            yylval.tokenData->numValue = atof(svalue);
            break;
        case exp:
            yylval.tokenData->numValue = atof(svalue);
            break;
        case term:
            yylval.tokenData->numValue = atof(svalue);
            break;
        case varornum:
            yylval.tokenData->numValue = atof(svalue);
            break;
    }
}

%}
 
%%
"quit" {return setVal(line, QUIT, yytext);}
[0-9]+ | [0-9]*\.[0-9]+ {return setVal(line, NUMBER, yytext);}
[a-z] {return setVal(line, yytext[0], yytext);}
[ \t] ;
\n {line++; return setVal(line, yytext[0], yytext); }
. { return setVal(line, yytext[0], yytext); }
%%