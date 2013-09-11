%{
    #include "scanType.h"
    #include "cminus.tab.h"

    static int line = 1;

    int setVal(int linenum, int tokenClass, char * svalue) {
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