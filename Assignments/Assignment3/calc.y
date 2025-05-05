%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double memvar = 0; /* Memory variable */

/* Define M_PI if not defined */
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

/* Function prototypes */
float pi_power(float x);
float kelvin_to_others(float k);
float fahrenheit_to_others(float f);
float celsius_to_others(float c);
void convert_base(int num, int base);
int convert_and_display(int num);
float factorial(int n);
void yyerror(char *s);
int yylex(void);
%}

%union {
    double dval;
}

%token <dval> NUMBER
%token <dval> MEM
%token POWTEN PI EXP LOG LN SIN COS TAN ASIN ACOS ATAN
%token SQUARE CUBE SQRT CBRT FACTORIAL CEILING FLOOR
%token CONVERT CELSIUS FAHRENHEIT KELVIN

%type <dval> expression

%left '-' '+'
%left '*' '/' '%'
%right '^'

%left POWTEN PI EXP LOG LN SIN COS TAN ASIN ACOS ATAN
%left SQUARE CUBE SQRT CBRT FACTORIAL CEILING FLOOR
%left CONVERT CELSIUS FAHRENHEIT KELVIN
%nonassoc UMINUS

%%

start:
    statement '\n'
    | start statement '\n'
;

statement:
    MEM '=' expression     { memvar = $3; }
    | expression           { printf("\nResult = %g\n", $1); }
;

expression:
    expression '+' expression      { $$ = $1 + $3; }
    | expression '-' expression    { $$ = $1 - $3; }
    | expression '*' expression    { $$ = $1 * $3; }
    | expression '/' expression    {
        if ($3 == 0) {
            yyerror("Error: Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | expression '%' expression    { $$ = fmod($1, $3); }
    | expression '^' expression    { $$ = pow($1, $3); }
    | '-' expression %prec UMINUS  { $$ = -$2; }
    | '(' expression ')'           { $$ = $2; }
    | '[' expression ']'           { $$ = $2; }

    | POWTEN expression        { $$ = pow(10, $2); }
    | PI expression            { $$ = pi_power($2); }
    | EXP expression           { $$ = exp($2); }
    | LOG expression           {
        if ($2 <= 0) {
            yyerror("Error: Log of non-positive number");
            $$ = 0;
        } else {
            $$ = log10($2);
        }
    }
    | LN expression            {
        if ($2 <= 0) {
            yyerror("Error: Ln of non-positive number");
            $$ = 0;
        } else {
            $$ = log($2);
        }
    }

    | SIN expression           { $$ = sin($2 * M_PI / 180); }
    | COS expression           { $$ = cos($2 * M_PI / 180); }
    | TAN expression           {
        if (fmod($2, 180) == 90 || fmod($2, 180) == -90) {
            yyerror("Error: Tangent undefined at 90/270 degrees");
            $$ = 0;
        } else {
            $$ = tan($2 * M_PI / 180);
        }
    }

    | ASIN expression {
        if ($2 < -1 || $2 > 1) {
            yyerror("Error: Asin argument must be between -1 and 1");
            $$ = 0;
        } else {
            $$ = asin($2) * 180 / M_PI;
        }
    }
    | ACOS expression {
        if ($2 < -1 || $2 > 1) {
            yyerror("Error: Acos argument must be between -1 and 1");
            $$ = 0;
        } else {
            $$ = acos($2) * 180 / M_PI;
        }
    }
    | ATAN expression          { $$ = atan($2) * 180 / M_PI; }
    | SQUARE expression        { $$ = $2 * $2; }
    | CUBE expression          { $$ = $2 * $2 * $2; }
    | SQRT expression          {
        if ($2 < 0) {
            yyerror("Error: Square root of negative number");
            $$ = 0;
        } else {
            $$ = sqrt($2);
        }
    }
    | CBRT expression          { $$ = cbrt($2); }
    | FACTORIAL expression     {
        if ($2 < 0 || $2 != floor($2) || $2 > 170) {
            yyerror("Error: Factorial only defined for non-negative integers up to 170");
            $$ = 0;
        } else {
            $$ = factorial((int)$2);
        }
    }

    | CEILING expression       { $$ = ceil($2); }
    | FLOOR expression         { $$ = floor($2); }

    | CONVERT expression       {
        if ($2 < 0 || $2 != floor($2)) {
            yyerror("Error: Can only convert non-negative integers");
            $$ = 0;
        } else {
            convert_and_display((int)$2);
            $$ = $2;
        }
    }

    | CELSIUS expression       { celsius_to_others($2); $$ = $2; }
    | FAHRENHEIT expression    { fahrenheit_to_others($2); $$ = $2; }
    | KELVIN expression        { kelvin_to_others($2); $$ = $2; }

    | NUMBER                  { $$ = $1; }
    | MEM                     { $$ = memvar; }
;

%%

/* Helper functions */
float pi_power(float x) {
    return pow(M_PI, x);
}

float kelvin_to_others(float k) {
    float celsius = k - 273.15;
    float fahrenheit = celsius * 9 / 5 + 32;
    printf("\nFahrenheit = %.2f, Celsius = %.2f\n", fahrenheit, celsius);
    return k;
}

float fahrenheit_to_others(float f) {
    float celsius = (f - 32) * 5 / 9;
    float kelvin = celsius + 273.15;
    printf("\nCelsius = %.2f, Kelvin = %.2f\n", celsius, kelvin);
    return f;
}

float celsius_to_others(float c) {
    float kelvin = c + 273.15;
    float fahrenheit = c * 9 / 5 + 32;
    printf("\nFahrenheit = %.2f, Kelvin = %.2f\n", fahrenheit, kelvin);
    return c;
}

void convert_base(int num, int base) {
    if (num == 0) return;
    int rem = num % base;
    convert_base(num / base, base);
    if (rem < 10) printf("%d", rem);
    else printf("%c", rem - 10 + 'A');
}

int convert_and_display(int num) {
    printf("\nBinary: ");
    if (num == 0) printf("0");
    else convert_base(num, 2);

    printf("\nOctal: ");
    if (num == 0) printf("0");
    else convert_base(num, 8);

    printf("\nHexadecimal: ");
    if (num == 0) printf("0");
    else convert_base(num, 16);

    printf("\n");
    return num;
}

float factorial(int n) {
    double result = 1.0;
    for (int i = 1; i <= n; i++) result *= i;
    return result;
}

int main() {
    printf("Scientific Calculator\n");
    printf("Enter expressions ($ to quit):\n");
    yyparse();
    return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
