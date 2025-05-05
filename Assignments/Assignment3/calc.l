%option noyywrap

%{
#include "y.tab.h" // Include the token definitions from Bison
#include <math.h>
#include <stdlib.h>
%}

%%

// Floating-point and integer numbers, including scientific notation
[0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)? {
    yylval.dval = atof(yytext);
    return NUMBER;
}

// Keywords / Functions
"dec" | "CONVERT"         { return CONVERT; }
"pt" | "POWTEN"           { return POWTEN; }
"pi" | "PI"               { return PI; }
"exp" | "EXP"             { return EXP; }
"log" | "LOG"             { return LOG; }
"ln" | "LN"               { return LN; }
"sin" | "SIN"             { return SIN; }
"cos" | "COS"             { return COS; }
"tan" | "TAN"             { return TAN; }
"asin" | "ASIN"           { return ASIN; }
"acos" | "ACOS"           { return ACOS; }
"atan" | "ATAN"           { return ATAN; }
"sq" | "SQUARE"           { return SQUARE; }
"cube" | "CUBE"           { return CUBE; }
"sqrt" | "SQRT"           { return SQRT; }
"cbrt" | "CBRT"           { return CBRT; }
"fact" | "FACTORIAL"      { return FACTORIAL; }
"ceil" | "CEILING"        { return CEILING; }
"floor" | "FLOOR"         { return FLOOR; }
"cel" | "CELSIUS"         { return CELSIUS; }
"fah" | "FAHRENHEIT"      { return FAHRENHEIT; }
"kel" | "KELVIN"          { return KELVIN; }
"mem"                     { return MEM; }

// Whitespace
[ \t]                     ;   // Ignore whitespace
"$"                       { return 0; }  // End of input
\n                        { return '\n'; }

// Any other single character
.                         { return yytext[0]; }

%%
