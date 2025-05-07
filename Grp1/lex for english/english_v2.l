%{
#include <stdio.h>
%}

%%
[a-zA-Z]+     { printf("WORD: %s\n", yytext); }
[0-9]+        { printf("NUMBER: %s\n", yytext); }
" "|\t|\n     { /* ignore whitespace */ }
.             { printf("UNKNOWN: %s\n", yytext); }
%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
