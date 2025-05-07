%{
#include <stdio.h>

int vowels = 0, consonants = 0, digits = 0, spaces = 0;
%}

%%
[aeiouAEIOU]     { vowels++; }
[a-zA-Z]         { consonants++; }   // will also count vowels, so adjust later
[0-9]            { digits++; }
[ \t\n]          { spaces++; }
.                { } // ignore other characters
%%

int main() {
    printf("Enter input: ");
    yylex();  // start scanning input
    consonants = consonants - vowels;  // correct the consonant count
    printf("\nVowels: %d\n", vowels);
    printf("Consonants: %d\n", consonants);
    printf("Digits: %d\n", digits);
    printf("Whitespaces: %d\n", spaces);
    return 0;
}

int yywrap() {
    return 1;
}
