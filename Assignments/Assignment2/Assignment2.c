#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYMBOLS 100
#define MAX_LEN 50

int line_no = 1;
char symbol_table[MAX_SYMBOLS][MAX_LEN]; // Symbol table to store identifiers
int symbol_count = 0;
FILE *yyin; // File pointer for input

// Function to add identifiers to the symbol table and return index
int add_to_symbol_table(char *identifier) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i], identifier) == 0) {
            return i + 1; // Return existing index (1-based)
        }
    }
    strcpy(symbol_table[symbol_count], identifier);
    symbol_count++;
    return symbol_count; // Return new index (1-based)
}

// Function to print the symbol table
void print_symbol_table() {
    printf("\nSymbol Table:\n");
    printf("| Index | Identifier |\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("| %-5d | %-10s |\n", i + 1, symbol_table[i]);
    }
    printf("\n");
    fflush(stdout);
}

// Function to print token information
void print_token(int line, char* lexeme, char* token_type, int token_value) {
    printf("%d\t%s\t%s\t%d\n", line, lexeme, token_type, token_value);
}

// Function to process identifiers and keywords
void process_identifier_or_keyword(char *word) {
    if (strcmp(word, "int") == 0) {
        print_token(line_no, word, "KEYWORD", 2);
    } else {
        int symbol_index = add_to_symbol_table(word);
        print_token(line_no, word, "IDENTIFIER", symbol_index);
    }
}

// Function to handle the main lexical analysis
void lexical_analysis() {
    char ch, word[MAX_LEN];
    int idx = 0;

    while ((ch = fgetc(yyin)) != EOF) {
        if (ch == '\n') {
            line_no++; // Increment line number on newline
        } else if (isspace(ch)) {
            continue; // Ignore spaces and tabs
        } else if (isalpha(ch) || ch == '_') { // Start of identifier or keyword
            word[idx++] = ch;
            while ((ch = fgetc(yyin)) != EOF && (isalnum(ch) || ch == '_')) {
                word[idx++] = ch; // Collect the identifier characters
            }
            word[idx] = '\0';
            process_identifier_or_keyword(word);

            // Put back the last non-valid character
            if (ch != EOF) {
                ungetc(ch, yyin);
            }
            idx = 0; // Reset index for the next word
        } else if (isdigit(ch)) { // Constants (numbers)
            word[idx++] = ch;
            while ((ch = fgetc(yyin)) != EOF && isdigit(ch)) {
                word[idx++] = ch; // Collect the digits
            }
            word[idx] = '\0';
            print_token(line_no, word, "CONSTANT", 9);

            // Put back the last non-valid character
            if (ch != EOF) {
                ungetc(ch, yyin);
            }
            idx = 0; // Reset index for the next word
        } else if (ch == ';' || ch == ',' || ch == '(' || ch == ')' || ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '=') {
            // Handle delimiters and operators
            char op[2] = {ch, '\0'};
            if (ch == ';') {
                print_token(line_no, op, "DELIMITER", 5);
            } else if (ch == ',') {
                print_token(line_no, op, "DELIMITER", 6);
            } else if (ch == '(') {
                print_token(line_no, op, "DELIMITER", 7);
            } else if (ch == ')') {
                print_token(line_no, op, "DELIMITER", 8);
            } else if (ch == '+') {
                print_token(line_no, op, "OPERATOR", 10);
            } else if (ch == '-') {
                print_token(line_no, op, "OPERATOR", 11);
            } else if (ch == '*') {
                print_token(line_no, op, "OPERATOR", 12);
            } else if (ch == '/') {
                print_token(line_no, op, "OPERATOR", 13);
            } else if (ch == '=') {
                print_token(line_no, op, "OPERATOR", 14);
            }
        }
    }
}

int main() {
    yyin = fopen("input.txt", "r");
    if (!yyin) {
        printf("Error: Could not open input.txt\n");
        return 1;
    }

    printf("\nLine\tLexeme\t\tToken\tValue\n\n");
    lexical_analysis(); // Perform lexical analysis
    fclose(yyin);

    print_symbol_table(); // Print the symbol table
    return 0;
}
