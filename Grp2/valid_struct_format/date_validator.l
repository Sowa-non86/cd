%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char day[3], month[3], year[5];  // Added declarations for these arrays

int is_valid_date() {
    int d = atoi(day);
    int m = atoi(month);
    int y = atoi(year);
    
    // Basic validation
    if (d < 1 || d > 31 || m < 1 || m > 12 || y < 1000 || y > 9999)
        return 0;
        
    // Month-specific day validation
    if ((m == 4 || m == 6 || m == 9 || m == 11) && d > 30)
        return 0;
    
    // February validation including leap year check
    if (m == 2) {
        int leap = (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0));
        if (d > 29 || (d == 29 && !leap))
            return 0;
    }
    
    return 1;
}
%}

%%
[0-9]{2}"-"[0-9]{2}"-"[0-9]{4} {
    // Copy parts to corresponding variables
    strncpy(day, yytext, 2);
    day[2] = '\0';
    
    strncpy(month, yytext+3, 2);
    month[2] = '\0';
    
    strncpy(year, yytext+6, 4);
    year[4] = '\0';
    
    if (is_valid_date())
        printf("Valid Date: %s-%s-%s\n", day, month, year);
    else
        printf("Invalid Date\n");
}

\n|[ \t]    ; /* Ignore whitespace */
.           { printf("Invalid format. Use dd-mm-yyyy\n"); }
%%

int main() {
    printf("Enter date in format dd-mm-yyyy: ");
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}