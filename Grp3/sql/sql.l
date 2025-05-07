%{
#include "sql.tab.h"
#include <stdio.h>
%}

%%

"SELECT"        { return SELECT; }
"FROM"          { return FROM; }
"WHERE"         { return WHERE; }
","             { return COMMA; }
"="             { return EQUAL; }
[a-zA-Z][a-zA-Z0-9_]*  { return ID; }
[0-9]+          { return NUMBER; }
[ \t\n]+        ; /* ignore whitespace */
";"             { return ';'; }
.               { return yytext[0]; }

%%

int yywrap(void) {
    return 1;
}