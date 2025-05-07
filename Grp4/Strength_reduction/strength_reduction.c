#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Quad {
    char op[5], src1[20], src2[20], dst[20];
} quads[100];

int n = 0;

int is_power_of_two(char *s, int *p) {
    int val = atoi(s);
    if (val <= 0) return 0;
    for (int i = 0; i < 31; i++) {
        if ((1 << i) == val) {
            *p = i;
            return 1;
        }
    }
    return 0;
}

void read_input() {
    char line[100];
    printf("Enter quadruples (op src1 src2 dst), empty line to stop:\n");
    while (fgets(line, sizeof(line), stdin)) {
        if (line[0] == '\n') break;
        if (sscanf(line, "%s %s %s %s", quads[n].op, quads[n].src1, quads[n].src2, quads[n].dst) == 4)
            n++;
        else
            printf("Invalid input, try again.\n");
    }
}

void optimize() {
    int p;
    for (int i = 0; i < n; i++) {
        if (strcmp(quads[i].op, "*") == 0 && is_power_of_two(quads[i].src2, &p)) {
            strcpy(quads[i].op, "<<");
            sprintf(quads[i].src2, "%d", p);
        } else if (strcmp(quads[i].op, "/") == 0 && is_power_of_two(quads[i].src2, &p)) {
            strcpy(quads[i].op, ">>");
            sprintf(quads[i].src2, "%d", p);
        }
    }
}

void print_quads(char *msg) {
    printf("\n%s\n", msg);
    for (int i = 0; i < n; i++)
        printf("%s %s %s %s\n", quads[i].op, quads[i].src1, quads[i].src2, quads[i].dst);
}

int main() {
    read_input();
    print_quads("Original:");
    optimize();
    print_quads("Optimized:");
    return 0;
}