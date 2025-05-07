#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct {
    char operation[8];
    char operand1[16];
    char operand2[16];
    char result[16];
} QuadInstruction;
 int isNumber(char *str) {
    if (!str || !*str) return 0;
    
    int dots = 0;
    int i = 0;
    
    if (str[0] == '-') i = 1;
    
    for (; str[i]; i++) {
        if (str[i] == '.') {
            dots++;
            if (dots > 1) return 0;
        }
        else if (!isdigit(str[i])) {
            return 0;
        }
    }  
    return 1;
}
 float performOp(char *op, char *val1, char *val2) {
    float v1 = atof(val1);
    float v2 = atof(val2);
    
    if (strcmp(op, "+") == 0) return v1 + v2;
    if (strcmp(op, "-") == 0) return v1 - v2;
    if (strcmp(op, "*") == 0) return v1 * v2;
    if (strcmp(op, "/") == 0) {
        if (v2 == 0.0) {
            printf("ERROR: Division by zero!\n");
            exit(1);
        }
        return v1 / v2;
    }
    printf("ERROR: Unknown operator %s\n", op);
    exit(1);
}
int main() {
    QuadInstruction *quads;
    int quadCount = 0;
    int maxQuads = 100;
    char line[128];  
    quads = (QuadInstruction*)malloc(maxQuads * sizeof(QuadInstruction));
    printf("Enter quadruples (op arg1 arg2 result), empty line to end:\n");   
    while (1) {
        if (!fgets(line, sizeof(line), stdin) || line[0] == '\n') {
            break;
        }     
        sscanf(line, "%s %s %s %s", 
               quads[quadCount].operation,
               quads[quadCount].operand1,
               quads[quadCount].operand2, 
               quads[quadCount].result);
        
        quadCount++;
    }

    printf("\n--- Original Quadruples ---\n");
    for (int i = 0; i < quadCount; i++) {
        printf("%d: %s %s %s %s\n", i, 
               quads[i].operation, 
               quads[i].operand1,
               quads[i].operand2, 
               quads[i].result);
    }

    int changed = 0;
    for (int i = 0; i < quadCount; i++) {
        if (isNumber(quads[i].operand1) && isNumber(quads[i].operand2)) {
            float result = performOp(quads[i].operation, quads[i].operand1, quads[i].operand2);
            strcpy(quads[i].operation, "=");
            sprintf(quads[i].operand1, "%.2f", result);
            strcpy(quads[i].operand2, "");
            changed = 1;
         }
    }
    
    printf("\n--- Optimized Quadruples (Constant Folding) ---\n");
    for (int i = 0; i < quadCount; i++) {
        printf("%d: %s %s %s %s\n", i, 
               quads[i].operation, 
               quads[i].operand1,
               quads[i].operand2, 
               quads[i].result);
    }
    
    if (!changed) {
        printf("No constant folding optimizations were performed.\n");
    }
    
    free(quads);
    return 0;
}