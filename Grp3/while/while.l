%{
#include "while.tab.h"
%}

%%

"while"        return WHILE;
"("            return '(';
")"            return ')';
";"            return ';';
[0-9]+         return NUM;
[a-zA-Z_][a-zA-Z0-9_]* return ID;
"=="|"!="|"<="|">="|"<"|">" return RELOP;
[ \t\n]+       ;  // Skip whitespace
.              return yytext[0];  // Return all other characters as-is

%%

int yywrap(void) {
    return 1;
}
