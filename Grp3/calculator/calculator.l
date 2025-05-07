%{
#include <stdio.h>
#include <string.h>
#include "calc.tab.h"

extern YYSTYPE yylval;
%}

%%
[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z]+   { 
                strncpy(yylval.var, yytext, 49);
                yylval.var[49] = '\0';
                return IDENTIFIER; 
            }
"="         { return ASSIGN; }
[ \t]       { /* Skip whitespace */ }
\n          { return '\n'; }
[-+*/()]    { return yytext[0]; }
.           { printf("Invalid character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
}