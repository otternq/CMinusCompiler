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
        case BOOLEAN:
            return BOOLEAN;
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

"static"            {return setVal(line, STATIC, yytext);}
"int"            {return setVal(line, INT, yytext);}
"bool"            {return setVal(line, BOOLEAN, yytext);}
"char"            {return setVal(line, CHAR, yytext);}
"if"            {return setVal(line, IF, yytext);}
"else"            {return setVal(line, ELSE, yytext);}
"while"            {return setVal(line, WHILE, yytext);}
"foreach"            {return setVal(line, FOREACH, yytext);}
"in"            {return setVal(line, IN, yytext);}
"return"            {return setVal(line, RETURN, yytext);}
"break"            {return setVal(line, BREAK, yytext);}
"or"            {return setVal(line, IF, yytext);}
"and"            {return setVal(line, AND, yytext);}
"true"            {return setVal(line, TRUE, yytext);}
"false"            {return setVal(line, FALSE, yytext);}

[a-zA-Z]+[a-zA-Z0-9\_]*           {return setVal(line, ID, yytext);}
[ \t]           ;

\n              {line++; return setVal(line, yytext[0], yytext); }
.               { return setVal(line, yytext[0], yytext); }
%%