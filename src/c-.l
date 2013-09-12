%{
#include <iostream>
#include <stdlib.h>
#include "scanType.h"
#include "c-.tab.h"

static int line = 1;

int setVal(int linenum, int tokenClass, char * svalue) {

    yylval.tokenData = new TokenData();
    yylval.tokenData->tokenClass = tokenClass;
    yylval.tokenData->linenum = linenum;
    yylval.tokenData->tokenStr = strdup(svalue);

    switch(tokenClass) {
        case NUMCONST:
            yylval.tokenData->numValue = atof(svalue);
            return NUMCONST;
            break;
        case ID:
            yylval.tokenData->idValue = svalue[0] - 'A';
            return ID;
            break;

        case CHARCONST:
            yylval.tokenData->charValue = svalue[0];
            return CHARCONST;
            break;

        case STRINGCONST:
            yylval.tokenData->stringValue = strdup(svalue);
            return STRINGCONST;
            break;

        case STATIC:
            return STATIC;
            break;
        case INT:
            return INT;
            break;
        case BOOL:
            return BOOL;
            break;
        case CHAR:
            return CHAR;
            break;
        case IF:
            return IF;
            break;
        case ELSE:
            return ELSE;
            break;
        case WHILE:
            return WHILE;
            break;
        case FOREACH:
            return FOREACH;
            break;
        case IN:
            return IN;
            break;
        case RETURN:
            return RETURN;
            break;
        case BREAK:
            return BREAK;
            break;
        case OR:
            return OR;
            break;
        case AND:
            return AND;
            break;
        case TRUE:
            return TRUE;
            break;
        case FALSE:
            return FALSE;
            break;
    }

    return tokenClass;
}

%}
 
%%

"//"(.)*"\n"    {line++;}
[0-9]+          {return setVal(line, NUMCONST, yytext);}
[0-9]*\.[0-9]+  {return setVal(line, NUMCONST, yytext);}

\'.\'   { return setVal(line, CHARCONST, yytext);}
\"(\\.|[^\n"\\])*\" { return setVal(line, STRINGCONST, yytext);}

"STATIC"            {return setVal(line, STATIC, yytext);}
"INT"            {return setVal(line, IF, yytext);}
"BOOL"            {return setVal(line, IF, yytext);}
"CHAR"            {return setVal(line, IF, yytext);}
"IF"            {return setVal(line, IF, yytext);}
"ELSE"            {return setVal(line, ELSE, yytext);}
"WHILE"            {return setVal(line, WHILE, yytext);}
"FOREACH"            {return setVal(line, FOREACH, yytext);}
"IN"            {return setVal(line, IN, yytext);}
"RETURN"            {return setVal(line, RETURN, yytext);}
"BREAK"            {return setVal(line, BREAK, yytext);}
"OR"            {return setVal(line, IF, yytext);}
"AND"            {return setVal(line, AND, yytext);}
"TRUE"            {return setVal(line, TRUE, yytext);}
"FALSE"            {return setVal(line, FALSE, yytext);}

[a-zA-Z]+[a-zA-Z0-9\_]*           {return setVal(line, ID, yytext);}
[ \t]           ;

\n              {line++; return setVal(line, yytext[0], yytext); }
.               { return setVal(line, yytext[0], yytext); }
%%