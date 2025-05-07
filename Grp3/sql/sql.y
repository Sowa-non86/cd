%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
extern char* yytext;
%}

%token SELECT FROM WHERE COMMA EQUAL ID NUMBER

%%

statement:
    select_statement ';' {
        printf("Valid SQL statement\n");
    }
;

select_statement:
    SELECT column_list FROM ID opt_where
;

column_list:
    ID
  | column_list COMMA ID
;

opt_where:
    /* empty */
  | WHERE condition
;

condition:
    ID EQUAL value
;

value:
    ID
  | NUMBER
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main() {
    printf("Enter an SQL query (end with semicolon):\n");
    return yyparse();
}