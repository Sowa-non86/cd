%{
#include "switch.tab.h"
%}

%%

"switch"        return SWITCH;
"case"          return CASE;
"default"       return DEFAULT;
"break"         return BREAK;
"("             return '(';
")"             return ')';
"{"             return '{';
"}"             return '}';
":"             return ':';
";"             return ';';
[0-9]+          return NUMBER;
[a-zA-Z_][a-zA-Z0-9_]* return ID;
[ \t\n]+        ;  // Ignore whitespace
.               return yytext[0];

%%

int yywrap(void) {
    return 1;
}
