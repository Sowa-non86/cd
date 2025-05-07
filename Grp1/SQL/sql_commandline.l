%{
#include <stdio.h>
#include <stdlib.h>
%}

/* Define regular expressions */
digit                   [0-9]
char                    [A-Za-z]
number                  {digit}+
identifier              ({char}|_)({digit}|_|{char})*

%%

CREATE                  { printf("CREATE\n"); }
GLOBAL|LOCAL            { printf("GLOB_LOC\n"); }
TEMPORARY               { printf("TEMPORARY\n"); }
TABLE                   { printf("TABLE\n"); }

"ON COMMIT"             { printf("ON_COMMIT\n"); }
DELETE|PRESERVE         { printf("DELETE_PRESERVE\n"); }
ROWS                    { printf("ROWS\n"); }
REFERENCES              { printf("REFERENCES\n"); }
"FOREIGN KEY"           { printf("FOREIGN_KEY\n"); }
"ON UPDATE"             { printf("ON_UPDATE\n"); }
"ON DELETE"             { printf("ON_DELETE\n"); }
"NOT NULL"              { printf("NOT_NULL\n"); }
UNIQUE                  { printf("UNIQUE\n"); }
"PRIMARY KEY"           { printf("PRIMARY_KEY\n"); }
CASCADE|"SET NULL"|"SET DEFAULT"|"NO ACTION" { printf("TRIGGER_ACTION\n"); }

DATE                    { printf("DATE\n"); }
TIME                    { printf("TIME\n"); }
NUMERIC                 { printf("NUMERIC\n"); }   
INTEGER                 { printf("INTEGER\n"); }
FLOAT                   { printf("FLOAT\n"); }
REAL                    { printf("REAL\n"); }
CHAR                    { printf("CHAR\n"); }
VARCHAR                 { printf("VARCHAR\n"); }

SELECT                  { printf("SELECT\n"); }
FROM                    { printf("FROM\n"); }
WHERE                   { printf("WHERE\n"); }
"*"                     { printf("STAR\n"); }
"<"                     { printf("LESSTHAN\n"); }

{identifier}            { printf("IDENTIFIER: %s\n", yytext); }
{number}                { printf("NUMBER: %s\n", yytext); }

","                     { printf("COMMA\n"); }
\n                      { printf("NEWLINE\n"); }
[ \t]+                  ; /* Ignore whitespace */
"("                     { printf("LB\n"); }
")"                     { printf("RB\n"); }
";"                     { printf("SEMICOLON\n"); }
.                       { printf("OTHER: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter your SQL query:\n");

    char input[1000];
    fgets(input, sizeof(input), stdin);  // Read the query from the user

    yy_scan_string(input);  // Send it to lexer
    yylex();                // Start lexical analysis

    return 0;
}