%{
    #include "scanType.h"
    double var[26];   
%}

%union {
    TokenData * tokenData;
    double value;
}

%token<takenData> NUMBER ID QUIT
%token<value> exp term varornum

%%
    stmtlist:   stmt '\n'
                | stmt '\n' stmtlist
                ;
    stmt:       ID '=' exp { var[$1->idvalue] = $3}
                | exp
                | QUIT
                ;