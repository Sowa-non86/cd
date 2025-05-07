%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern char* yytext;

// Variable storage
typedef struct {
    char name[50];
    int value;
} Var;

Var variables[100];
int var_count = 0;

// Get variable value
int get_var_value(char* name) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(variables[i].name, name) == 0)
            return variables[i].value;
    }
    printf("Error: Undefined variable '%s'\n", name);
    return 0;
}

// Store variable value
void store_var(char* name, int value) {
    // Check if variable exists
    for (int i = 0; i < var_count; i++) {
        if (strcmp(variables[i].name, name) == 0) {
            variables[i].value = value;
            return;
        }
    }
    // Add new variable
    if (var_count < 100) {
        strcpy(variables[var_count].name, name);
        variables[var_count].value = value;
        var_count++;
    }
}
%}

%union {
    int num;
    char var[50];
}

%token <num> NUMBER
%token <var> IDENTIFIER
%token ASSIGN

%type <num> expr

%left '+' '-'
%left '*' '/'

%%
program:
    | program line
    ;

line:
    expr '\n'         { printf("Result = %d\n", $1); }
    | IDENTIFIER ASSIGN expr '\n' {
        store_var($1, $3);
        printf("%s = %d\n", $1, $3);
    }
    | '\n'            /* ignore empty lines */
    | error '\n'      { yyerrok; }
    ;

expr:
    NUMBER              { $$ = $1; }
    | IDENTIFIER        { $$ = get_var_value($1); }
    | expr '+' expr     { $$ = $1 + $3; }
    | expr '-' expr     { $$ = $1 - $3; }
    | expr '*' expr     { $$ = $1 * $3; }
    | expr '/' expr     {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | '(' expr ')'     { $$ = $2; }
    ;
%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Calculator with Variables\n");
    printf("Example: x = 5, y = 10, x + y * 2\n");
    return yyparse();
}