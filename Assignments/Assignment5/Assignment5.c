#include <stdio.h>
#include <string.h>

#define MAX_QUADRUPLES 100

typedef struct {
    char op;
    char arg1[10];
    char arg2[10];
    char result[10];
} Quadruple;

// Function to find a common subexpression in the optimized list
int find_common_subexpression(Quadruple quadruples[], int count, char op, char arg1[], char arg2[]) {
    for (int i = 0; i < count; i++) {
        if (quadruples[i].op == op &&
            strcmp(quadruples[i].arg1, arg1) == 0 &&
            strcmp(quadruples[i].arg2, arg2) == 0) {
            return i;
        }
    }
    return -1;
}

// Function to eliminate common subexpressions
void eliminate_common_subexpressions(Quadruple quadruples[], int *count) {
    Quadruple optimized[MAX_QUADRUPLES];
    int new_count = 0;

    for (int i = 0; i < *count; i++) {
        int index = -1;

        if (quadruples[i].op != '=') {
            index = find_common_subexpression(optimized, new_count,
                                              quadruples[i].op,
                                              quadruples[i].arg1,
                                              quadruples[i].arg2);
        }

        if (index != -1) {
            // Replace result with existing result
            strcpy(quadruples[i].result, optimized[index].result);
        } else {
            // Copy to optimized quadruples
            optimized[new_count++] = quadruples[i];
        }
    }

    // Copy back the optimized quadruples
    for (int i = 0; i < new_count; i++) {
        quadruples[i] = optimized[i];
    }

    *count = new_count;
}

// Function to print the quadruples
void print_quadruples(Quadruple quadruples[], int count) {
    printf("Optimized quadruples:\n");
    for (int i = 0; i < count; i++) {
        printf("(%c, %s, %s, %s)\n", quadruples[i].op, quadruples[i].arg1, quadruples[i].arg2, quadruples[i].result);
    }
}

int main() {
    Quadruple quadruples[] = {
        {'-', "a", "b", "t1"},
        {'+', "t1", "c", "t2"},
        {'=', "t2", "", "x"},
        {'-', "a", "b", "t3"},
        {'+', "t3", "c", "t4"},
        {'=', "t4", "", "y"},
        {'*', "x", "y", "t5"},
        {'=', "t5", "", "z"}
    };    

    int count = sizeof(quadruples) / sizeof(quadruples[0]);

    eliminate_common_subexpressions(quadruples, &count);
    print_quadruples(quadruples, count);

    return 0;
}
