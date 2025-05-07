%{
/* HTML lexer - Systems lab #3 */
#include <stdio.h>
int lineno = 1;
%}

ID    [a-zA-Z][a-zA-Z0-9_\-]*
WS    [ \t]+

%%
"<html>"|"<head>"|"<body>"|"<div>"|"<p>"|"<h1>"|"<h2>"|"<span>" { printf("TAG_S: %s\n", yytext); }
"</html>"|"</head>"|"</body>"|"</div>"|"</p>"|"</h1>"|"</h2>"|"</span>" { printf("TAG_E: %s\n", yytext); }

"<br>"|"<hr>"|"<img>"|"<input>"|"<meta>" { printf("TAG_SC: %s\n", yytext); }

"href"|"src"|"id"|"class"|"style"|"width"|"height"|"type" { printf("ATTR: %s\n", yytext); }

"="       { printf("EQ: %s\n", yytext); }
">"       { printf("TAG_CLOSE: %s\n", yytext); }
"<"       { printf("TAG_OPEN: %s\n", yytext); }

"&lt;"|"&gt;"|"&amp;"|"&quot;"|"&nbsp;" { printf("SPEC: %s\n", yytext); }

\"[^\"]*\" { printf("STR: %s\n", yytext); }
\'[^\']*\' { printf("STR: %s\n", yytext); }
{ID}       { printf("ID: %s\n", yytext); }
"<!--"[^-]*"-->" { printf("COMM: %s\n", yytext); }
{WS}       { /* skip whitespace */ }
\n         { lineno++; }
[^<>\n\t ]+ { printf("TEXT: %s\n", yytext); }
.          { printf("ERR: %s (line %d)\n", yytext, lineno); }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}