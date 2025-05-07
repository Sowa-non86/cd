%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function to check if a string is palindrome */
int is_palindrome(const char* str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (str[i] != str[len - i - 1])
            return 0;
    }
    return 1;
}
%}

%option noyywrap

%%
[a-zA-Z0-9]+ {
    printf("You entered: %s\n", yytext);
    if (is_palindrome(yytext)) {
        printf("Result: \"%s\" is a palindrome.\n", yytext);
    } else {
        printf("Result: \"%s\" is not a palindrome.\n", yytext);
    }
    printf("\nEnter another word (press Ctrl+C to exit): ");
}

[\t\n ]+ { /* Ignore whitespace */ }

. { printf("Please enter only alphanumeric characters.\n"); }

%%

int main() {
    printf("Enter a word: ");
    
    /* Set input to stdin */
    yyin = stdin;
    
    /* Process the input */
    yylex();
    
    printf("\nProgram terminated.\n");
    return 0;
}