#include <stdio.h>
#include <string.h>

#define MAX_QUADRUPLES 100

typedef struct {
    char op;
    int arg1;
    int arg2;
    char result[10];
} Quadruple;

void constantFolding(Quadruple quadruples[], int *count) {
    Quadruple newQuadruples[MAX_QUADRUPLES];
    int new_count = 0;

    for (int i = 0; i < *count; i++) {
        if (quadruples[i].op == '+' || quadruples[i].op == '-' ||
            quadruples[i].op == '*' || quadruples[i].op == '/') {

            int result;
            switch (quadruples[i].op) {
                case '+':
                    result = quadruples[i].arg1 + quadruples[i].arg2;
                    break;
                case '-':
                    result = quadruples[i].arg1 - quadruples[i].arg2;
                    break;
                case '*':
                    result = quadruples[i].arg1 * quadruples[i].arg2;
                    break;
                case '/':
                    result = (quadruples[i].arg2 != 0)
                             ? quadruples[i].arg1 / quadruples[i].arg2
                             : 0;
                    break;
            }

            // Replace operation with '=' and store constant result
            newQuadruples[new_count].op = '=';
            newQuadruples[new_count].arg1 = result;
            newQuadruples[new_count].arg2 = 0;
            strcpy(newQuadruples[new_count].result, quadruples[i].result);
            new_count++;

        } else {
            newQuadruples[new_count++] = quadruples[i];
        }
    }

    for (int i = 0; i < new_count; i++) {
        quadruples[i] = newQuadruples[i];
    }
    *count = new_count;
}

void printQuadruples(Quadruple quadruples[], int count) {
    printf("Optimized quadruples:\n");
    for (int i = 0; i < count; i++) {
        printf("(%c, %d, %d, %s)\n",
               quadruples[i].op,
               quadruples[i].arg1,
               quadruples[i].arg2,
               quadruples[i].result);
    }
}

int main() {
    Quadruple quadruples[] = {
        {'+', 4, 3, "t1"},
        {'*', 5, 4, "t2"},
        {'-', 10, 1, "t3"},
        {'/', 20, 5, "t4"},
        {'+', 8, 0, "t5"}  
    };

    int count = sizeof(quadruples) / sizeof(quadruples[0]);

    constantFolding(quadruples, &count);
    printQuadruples(quadruples, count);

    return 0;
}
