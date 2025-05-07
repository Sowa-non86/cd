%{
/* C++ scanner - college assignment #2 */
#include <stdio.h>
int lineno = 1;
%}

DIGIT    [0-9]
ID       [a-zA-Z_][a-zA-Z0-9_]*
WS       [ \t]+
NUM      {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)?

%%
"int"|"float"|"void"|"class"|"public"|"private"|"new"|"delete"|"bool"|"this"|"const" { printf("KW: %s\n", yytext); }

"if"|"else"|"while"|"for"|"return"|"break"|"continue" { printf("FLOW: %s\n", yytext); }

"+"|"-"|"*"|"/"|"%"|"="|"=="|"!="|">"|"<"|">="|"<="|"&&"|"||"|"->"|"::" { printf("OP: %s\n", yytext); }

"("|")"|"{"|"}"|"["|"]"|";"|","|":" { printf("PUNCT: %s\n", yytext); }

"#include"|"#define"|"#ifdef"|"#endif" { printf("PREP: %s\n", yytext); }

{ID}        { printf("ID: %s\n", yytext); }
{NUM}       { printf("NUM: %s\n", yytext); }
\"[^\"]*\"  { printf("STR: %s\n", yytext); }
\'[^\']\'   { printf("CHAR: %s\n", yytext); }
"//".*      { printf("COMM: %s\n", yytext); }
"/*"([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+"/" { printf("MCOMM: %s\n", yytext); }
{WS}        { /* ignore spaces */ }
\n          { lineno++; }
.           { printf("ERR: %s (line %d)\n", yytext, lineno); }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}