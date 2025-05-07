%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
%}

%token WHILE ID NUM RELOP

%left '+' '-'
%left '*' '/'

%%

program:
    stmt
;

stmt:
    WHILE '(' expr ')' simple_stmt        { printf(" Valid while statement\n"); }
  | WHILE '(' error ')' simple_stmt       { yyerror(" Error in condition of while"); yyerrok; }
  | WHILE '(' expr ')' error              { yyerror(" Error in body of while"); yyerrok; }
;

simple_stmt:
    ID '=' expr ';'
;

expr:
    ID
  | NUM
  | expr '+' expr
  | expr '-' expr
  | expr '*' expr
  | expr '/' expr
  | expr RELOP expr
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Enter a while statement (e.g., while (x < 10) y = y + 1;):\n");
    return yyparse();
}
