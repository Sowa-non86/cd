%{
#include "ifelse.tab.h"
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }
"=="|"!="|"<="|">="|"<"|">"   { return RELOP; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
";"         { return ';'; }
[ \t\n]     ;  // skip whitespace
.           { printf("Invalid character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
