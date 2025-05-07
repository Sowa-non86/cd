%{
#include <stdio.h>
#include <stdlib.h>

// Declare external functions
int yylex(void);
int yyerror(char *s);
%}

%token NUMBER
%left '+' '-'
%left '*' '/'

%%
input:
    expr '\n'    { printf("Result = %d\n", $1); }
    ;

expr:
      expr '+' expr   { $$ = $1 + $3; }
    | expr '-' expr   { $$ = $1 - $3; }
    | expr '*' expr   { $$ = $1 * $3; }
    | expr '/' expr   {
                        if ($3 == 0) {
                            printf("Error: Division by zero\n");
                            exit(1);
                        } else {
                            $$ = $1 / $3;
                        }
                      }
    | '(' expr ')'    { $$ = $2; }
    | NUMBER          { $$ = $1; }
    ;
%%

int main() {
    printf("Enter expression: ");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    printf("Syntax Error: %s\n", s);
    return 1;
}
