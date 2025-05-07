%{
/* C lexer - for compiler construction lab */
#include <stdio.h>
int lineno = 1;
%}

DIGIT    [0-9]
ID       [a-zA-Z][a-zA-Z0-9]*
WS       [ \t]+
NUM      {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)?

%%
"int"|"char"|"float"|"void"|"if"|"else"|"while"|"for"|"return"   { printf("KeyWord: %s\n", yytext); }

"+"|"-"|"*"|"/"|"%"|"="|"=="|"!="|">"|"<"|">="|"<="|"&&"|"||"   { printf("Operator: %s\n", yytext); }

"("|")"|"{"|"}"|"["|"]"|";"|","   { printf("Punctuation: %s\n", yytext); }

{ID}        { printf("ID: %s\n", yytext); }
{NUM}       { printf("NUM: %s\n", yytext); }
\"[^\"]*\"  { printf("STR: %s\n", yytext); }
\'[^\']\'   { printf("CHAR: %s\n", yytext); }
"//".*      { printf("COMM: %s\n", yytext); }
{WS}        { /* skip whitespace */ }
\n          { lineno++; }
.           { printf("ERR: %s (line %d)\n", yytext, lineno); }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}