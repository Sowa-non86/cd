%{
#include <stdio.h>
#include <string.h>


char *keywords[] = {
    "abstract", "assert", "boolean", "break", "byte",
    "case", "catch", "char", "class", "const",
    "continue", "default", "do", "double", "else",
    "enum", "extends", "final", "finally", "float",
    "for", "goto", "if", "implements", "import",
    "instanceof", "int", "interface", "long", "native",
    "new", "package", "private", "protected", "public",
    "return", "short", "static", "strictfp", "super",
    "switch", "synchronized", "this", "throw", "throws",
    "transient", "try", "void", "volatile", "while",
    NULL
};


int isKeyword(char *str) {
    int i = 0;
    while (keywords[i]) {
        if (strcmp(str, keywords[i]) == 0)
            return 1;
        i++;
    }
    return 0;
}


int yywrap() {
    return 1;
}
%}

%%


"//".*                  { printf("Single Line Comment: %s\n", yytext); }


"/*"([^*]|\*+[^*/])*\*+"/"    { printf("Multi Line Comment: %s\n", yytext); }


\"([^\\\"]|\\.)*\"        { printf("String Literal: %s\n", yytext); }


\'([^\\\']|\\.)\'         { printf("Character Literal: %s\n", yytext); }


[a-zA-Z_][a-zA-Z0-9_]*    {
                            if (isKeyword(yytext))
                                printf("Keyword: %s\n", yytext);
                            else
                                printf("Identifier: %s\n", yytext);
                          }


[0-9]+\.[0-9]+            { printf("Float Number: %s\n", yytext); }
[0-9]+                    { printf("Integer Number: %s\n", yytext); }



"++"|"--"|"+="|"-="|"*="|"/="|"%="|"=="|"!="|"<="|">="|">"|"<"|"="|"+"|"-"|"*"|"/"|"%"|"&&"|"||"|"!"|"." {
    printf("Operator: %s\n", yytext);
}


[(){};]    { printf("Delimiter: %s\n", yytext); }


[ \t\n]+                  { /* ignore whitespace */ }


.                         { printf("Unrecognized Token: %s\n", yytext); }

%%


int main() {
    printf("Enter Java code:\n\n");
    yylex();
    return 0;
}
