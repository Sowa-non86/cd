%option noyywrap

%{
#include <stdio.h>
%}

%%
[.!?]          { printf("Punctuation: %s\n", yytext); }
[a-zA-Z]+ing   { printf("Gerund/Verb: %s\n", yytext); }
[a-zA-Z]+ly    { printf("Adverb: %s\n", yytext); }
smart|beautiful|pretty|handsome|clever|crazy|cute|bad      { printf("Adjective: %s\n", yytext); }
[a-zA-Z]+      { printf("Noun: %s\n", yytext); }
[0-9]+         { printf("Number: %s\n", yytext); }
[,;:]         { printf("Punctuation: %s\n", yytext); }
[ \t\n]        { /* Ignore whitespace and newline */ }
.             { printf("Other: %s\n", yytext); }
%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s input_file\n", argv[0]);
        return 1;
    }
    FILE *inputFile = fopen(argv[1], "r");
    if (inputFile == NULL) {
        perror("Error opening file");
        return 1;
    }
    yyin = inputFile;
    yylex();
    fclose(inputFile);
    return 0;
}
