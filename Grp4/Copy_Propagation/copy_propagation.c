#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_QUADS 100
#define MAX_STR 30
#define MAX_VARS 50

typedef struct {
    char op[MAX_STR];
    char arg1[MAX_STR];
    char arg2[MAX_STR];
    char res[MAX_STR];
} quad_t;

quad_t quads[MAX_QUADS];
int quad_count = 0;

typedef struct {
    char from[MAX_STR];
    char to[MAX_STR];
    int valid;
} copy_info_t;

copy_info_t copies[MAX_VARS];
int copy_count = 0;

void read_quads_from_file(char* filename) {
    FILE* fp = fopen(filename, "r");
    if (!fp) {
        fprintf(stderr, "Error: Could not open file %s\n", filename);
        exit(1);
    }
    
    while (!feof(fp) && quad_count < MAX_QUADS) {
        fscanf(fp, "%s %s %s %s", 
               quads[quad_count].op,
               quads[quad_count].arg1,
               quads[quad_count].arg2,
               quads[quad_count].res);
        quad_count++;
    }
    
    fclose(fp);
}

void print_quads() {
    printf("\n%-8s %-8s %-8s %-8s\n", "Op", "Arg1", "Arg2", "Result");
    printf("--------------------------------\n");
    
    for (int i = 0; i < quad_count; i++) {
        printf("%-8s %-8s %-8s %-8s\n",
               quads[i].op,
               quads[i].arg1,
               quads[i].arg2,
               quads[i].res);
    }
}

char* get_copy_source(char* var) {
    for (int i = 0; i < copy_count; i++) {
        if (copies[i].valid && strcmp(copies[i].to, var) == 0) {
            return copies[i].from;
        }
    }
    return NULL;
}

void invalidate_copies(char* var) {
    for (int i = 0; i < copy_count; i++) {
        if (strcmp(copies[i].from, var) == 0 || strcmp(copies[i].to, var) == 0) {
            copies[i].valid = 0;
        }
    }
}

void add_copy(char* from, char* to) {

    invalidate_copies(to);
    
    strcpy(copies[copy_count].from, from);
    strcpy(copies[copy_count].to, to);
    copies[copy_count].valid = 1;
    copy_count++;
}

void perform_copy_propagation() {

    for (int i = 0; i < quad_count; i++) {
        if (strcmp(quads[i].op, "=") == 0 && 
            quads[i].arg2[0] == '\0') {  
            
            add_copy(quads[i].arg1, quads[i].res);
        }
    }
    

    for (int i = 0; i < quad_count; i++) {

        invalidate_copies(quads[i].res);

        char* source = get_copy_source(quads[i].arg1);
        if (source) {
            strcpy(quads[i].arg1, source);
        }
        
        source = get_copy_source(quads[i].arg2);
        if (source) {
            strcpy(quads[i].arg2, source);
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    read_quads_from_file(argv[1]);
    
    printf("Before Copy Propagation:\n");
    print_quads();
    
    perform_copy_propagation();
    
    printf("\nAfter Copy Propagation:\n");
    print_quads();
    
    return 0;
}