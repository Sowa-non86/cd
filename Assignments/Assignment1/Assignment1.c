#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_TOKENS 1000
#define MAX_LEXEME_LEN 50

typedef struct {
    int line;
    char lexeme[MAX_LEXEME_LEN];
    char type[20];
    int value;
} Token;

Token tokens[MAX_TOKENS];
int token_count = 0;
int error_count = 0;
int semicolon_missing = 0;

// Dictionaries for unique values of each token type
char keywords[MAX_TOKENS][MAX_LEXEME_LEN];
char identifiers[MAX_TOKENS][MAX_LEXEME_LEN];
char numbers[MAX_TOKENS][MAX_LEXEME_LEN];
char operators[MAX_TOKENS][MAX_LEXEME_LEN];
char punctuators[MAX_TOKENS][MAX_LEXEME_LEN];
char string_literals[MAX_TOKENS][MAX_LEXEME_LEN];

int keyword_count = 0, identifier_count = 0, number_count = 0;
int operator_count = 0, punctuator_count = 0, string_literal_count = 0;

// Get index in a specific dictionary or add new entry
int get_index_or_add(char dict[MAX_TOKENS][MAX_LEXEME_LEN], int *count, const char *lexeme) {
    for (int i = 0; i < *count; i++) {
        if (strcmp(dict[i], lexeme) == 0) {
            return i + 1; // 1-based index
        }
    }
    strncpy(dict[*count], lexeme, MAX_LEXEME_LEN);
    (*count)++;
    return *count; // Return new index
}

void add_token(int line, const char *lexeme, const char *type, int value) {
    if (token_count >= MAX_TOKENS) return;
    tokens[token_count].line = line;
    strncpy(tokens[token_count].lexeme, lexeme, MAX_LEXEME_LEN);
    strncpy(tokens[token_count].type, type, 20);
    tokens[token_count].value = value;
    token_count++;
}

void add_error(int line, const char *message) {
    printf("Error on line %d: %s\n", line, message);
    error_count++;
}

void check_and_add_token(int line, const char *lexeme) {
    const char *keyword_list[] = {
        "SELECT", "FROM", "WHERE", "INSERT", "UPDATE", "DELETE", "CREATE",
        "DROP", "ALTER", "TABLE", "VALUES", "INTO", "JOIN", "ON", "ORDER",
        "GROUP", "BY", "HAVING", "AS", "AND", "OR", "NOT", "NULL", "DISTINCT",
        "LIKE", "IN", "EXISTS", "COUNT", "SUM", "AVG", "MIN", "MAX"
    };
    int num_keywords = sizeof(keyword_list) / sizeof(keyword_list[0]);

    for (int i = 0; i < num_keywords; i++) {
        if (strcasecmp(lexeme, keyword_list[i]) == 0) {
            int value = get_index_or_add(keywords, &keyword_count, lexeme);
            add_token(line, lexeme, "KEYWORD", value);
            return;
        }
    }

    if (isdigit(lexeme[0])) {
        int value = get_index_or_add(numbers, &number_count, lexeme);
        add_token(line, lexeme, "NUMBER", value);
    } else if (isalpha(lexeme[0]) || lexeme[0] == '_') {
        int value = get_index_or_add(identifiers, &identifier_count, lexeme);
        add_token(line, lexeme, "IDENTIFIER", value);
    } else if (strchr("=<>!*/%", lexeme[0])) {
        int value = get_index_or_add(operators, &operator_count, lexeme);
        add_token(line, lexeme, "OPERATOR", value);
    } else if (strchr("(),.;", lexeme[0])) {
        int value = get_index_or_add(punctuators, &punctuator_count, lexeme);
        add_token(line, lexeme, "PUNCTUATOR", value);
        if (lexeme[0] == ';') {
            semicolon_missing = 0;
        }
    } else {
        add_token(line, lexeme, "UNKNOWN", -1);
    }
}

void tokenize_line(const char *line, int line_number) {
    char buffer[MAX_LEXEME_LEN];
    int index = 0;
    semicolon_missing = 1;

    for (int i = 0; line[i] != '\0'; i++) {
        if (isspace(line[i])) {
            if (index > 0) {
                buffer[index] = '\0';
                check_and_add_token(line_number, buffer);
                index = 0;
            }
        } else if (line[i] == '\'') {
            buffer[index++] = line[i++];
            while (line[i] != '\'' && line[i] != '\0') {
                buffer[index++] = line[i++];
            }
            buffer[index++] = '\'';
            buffer[index] = '\0';
            int value = get_index_or_add(string_literals, &string_literal_count, buffer);
            add_token(line_number, buffer, "STRING_LITERAL", value);
            index = 0;
        } else if (strchr("=<>!*/%(),.;", line[i])) {
            if (index > 0) {
                buffer[index] = '\0';
                check_and_add_token(line_number, buffer);
                index = 0;
            }
            char punctuator[2] = {line[i], '\0'};
            check_and_add_token(line_number, punctuator);
        } else {
            buffer[index++] = line[i];
        }
    }

    if (index > 0) {
        buffer[index] = '\0';
        check_and_add_token(line_number, buffer);
    }

    if (semicolon_missing) {
        add_error(line_number, "Missing semicolon at end of statement");
    }
}

void print_tokens() {
    if (error_count > 0) {
        printf("%d errors detected. Processing halted.\n", error_count);
        return;
    }

    printf("%-5s %-20s %-15s %-10s\n", "Line", "Lexeme", "Token Type", "Value");
    printf("--------------------------------------------------------\n");

    for (int i = 0; i < token_count; i++) {
        printf("%-5d %-20s %-15s %-10d\n",
               tokens[i].line,
               tokens[i].lexeme,
               tokens[i].type,
               tokens[i].value);
    }
}

int main() {
    FILE *file = fopen("sql_code.txt", "r");
    if (!file) {
        perror("Error opening file. Ensure sql_code.txt exists in the correct directory.");
        return 1;
    }

    char line[1024];
    int line_number = 1;

    while (fgets(line, sizeof(line), file)) {
        tokenize_line(line, line_number);
        if (error_count > 0) {
            fclose(file);
            return 1;
        }
        line_number++;
    }

    fclose(file);
    print_tokens();
    return 0;
}
