%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
%}

%token SWITCH CASE DEFAULT BREAK ID NUMBER

%%

program:
    switch_stmt
;

switch_stmt:
    SWITCH '(' ID ')' '{' case_list default_case '}'
    {
        printf("Valid switch-case statement\n");
    }
;

case_list:
    case_list case_stmt
  | /* empty */
;

case_stmt:
    CASE NUMBER ':' BREAK ';'
;

default_case:
    DEFAULT ':' BREAK ';'
  | /* optional */
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main() {
    printf("Enter a switch-case statement:\n");
    return yyparse();
}
