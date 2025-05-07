%{
#include <stdio.h>
int vowels = 0, consonants = 0, digits = 0, spaces = 0;
%}

%%
[aeiouAEIOU]      { vowels++; }
[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]  { consonants++; }
[0-9]             { digits++; }
[ \t\n]           { spaces++; }
.                 /* ignore other characters */
%%

int main() {
    FILE *file = freopen("input.txt", "r", stdin);
    if (!file) {
        perror("input.txt");
        return 1;
    }

    yylex();
    printf("Vowels: %d\n", vowels);
    printf("Consonants: %d\n", consonants);
    printf("Digits: %d\n", digits);
    printf("Whitespaces: %d\n", spaces);
    return 0;
}

int yywrap() {
    return 1;
}
