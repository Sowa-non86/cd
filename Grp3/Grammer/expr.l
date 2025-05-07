%{
#include "expr.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[+\-*/()]   { return yytext[0]; }
[ \t]       ;  // Ignore spaces and tabs
\n          { return '\n'; }
.           { printf("Invalid character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
