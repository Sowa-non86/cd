#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct quadruple {
    char *op;
    char *arg1;
    char *arg2;
    char *res;
} *quad;
int n;
void readQuads() {
    int i;
    printf("Enter number of quadruples: ");
    scanf("%d", &n); 
    quad = (struct quadruple*)malloc(n * sizeof(struct quadruple));  
    printf("Enter quadruples (op arg1 arg2 res):\n");
    for(i = 0; i < n; i++) {
        quad[i].op = (char*)malloc(10);
        quad[i].arg1 = (char*)malloc(10);
        quad[i].arg2 = (char*)malloc(10);
        quad[i].res = (char*)malloc(10);
        
        scanf("%s %s %s %s", quad[i].op, quad[i].arg1, quad[i].arg2, quad[i].res);
    }
}
void printQuads() {
    int i;
    printf("\nOptimized Quadruples:\n");
    for(i = 0; i < n; i++) {
        if(quad[i].op[0] != '\0') // Skip deleted quadruples
            printf("%s\t%s\t%s\t%s\n", quad[i].op, quad[i].arg1, quad[i].arg2, quad[i].res);
    }
}
int main() {
    readQuads();
    printQuads();
    return 0;
}
