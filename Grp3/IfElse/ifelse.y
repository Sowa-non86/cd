%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(char *s);
%}

%token IF ELSE ID NUMBER RELOP

%%
stmt:
      IF '(' cond ')' stmt
    | IF '(' cond ')' stmt ELSE stmt
    | '{' stmt '}'
    | ID ';'
    ;

cond:
    ID RELOP ID
  | ID RELOP NUMBER
  ;

%%
int main() {
    printf("Enter the if-else code to validate:\n");
    if (yyparse() == 0)
        printf("Input is valid.\n");
    return 0;
}


int yyerror(char *msg) {
    printf("Syntax Error: %s\n", msg);
    return 1;
}
