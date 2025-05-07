%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Provide a prototype for yywrap
int yywrap(void) {
    return 1;
}
%}

%%

"SELECT"   { printf("[KEYWORD: SELECT]\n"); }
"FROM"     { printf("[KEYWORD: FROM]\n"); }
"WHERE"    { printf("[KEYWORD: WHERE]\n"); }
"INSERT"   { printf("[KEYWORD: INSERT]\n"); }
"INTO"     { printf("[KEYWORD: INTO]\n"); }
"VALUES"   { printf("[KEYWORD: VALUES]\n"); }
"UPDATE"   { printf("[KEYWORD: UPDATE]\n"); }
"SET"      { printf("[KEYWORD: SET]\n"); }
"DELETE"   { printf("[KEYWORD: DELETE]\n"); }
"CREATE"   { printf("[KEYWORD: CREATE]\n"); }
"TABLE"    { printf("[KEYWORD: TABLE]\n"); }
"DROP"     { printf("[KEYWORD: DROP]\n"); }
"ALTER"    { printf("[KEYWORD: ALTER]\n"); }
"JOIN"     { printf("[KEYWORD: JOIN]\n"); }
"ORDER"    { printf("[KEYWORD: ORDER]\n"); }
"BY"       { printf("[KEYWORD: BY]\n"); }
"GROUP"    { printf("[KEYWORD: GROUP]\n"); }
"HAVING"   { printf("[KEYWORD: HAVING]\n"); }

[a-zA-Z_][a-zA-Z0-9_]* { printf("[IDENTIFIER: %s]\n", yytext); }
[0-9]+               { printf("[NUMBER: %s]\n", yytext); }
\"[^\"]*\"           { printf("[STRING_LITERAL: %s]\n", yytext); }
'[^\']*'             { printf("[STRING_LITERAL: %s]\n", yytext); }
[<>=!]+              { printf("[OPERATOR: %s]\n", yytext); }
[,;().]              { printf("[SYMBOL: %s]\n", yytext); }
\n                   { }
[ \t]+               { }

.                    { printf("[UNKNOWN: %s]\n", yytext); }

%%

int main() {
    printf("Enter an SQL query:\n");
    yylex();
    return 0;
}
