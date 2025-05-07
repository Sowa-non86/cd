#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define N 200
#define V 100
#define L 31

typedef struct { char op[L], a1[L], a2[L], res[L]; bool live; } Quad;
typedef struct { char name[L]; bool used, def; } Var;

Quad q[N];
Var v[V];
int qc = 0, vc = 0;

int findVar(const char *n) {
    if (!n || !*n || n[0] == '_') return -1;
    for (int i = 0; i < vc; i++)
        if (!strcmp(v[i].name, n)) return i;
    return -1;
}

void addVar(const char *n) {
    if (!n || !*n || n[0] == '_' || findVar(n) != -1 || vc >= V) return;
    strcpy(v[vc].name, n);
    v[vc].used = v[vc].def = false;
    vc++;
}

void load(const char *f) {
    FILE *fp = fopen(f, "r");
    if (!fp) { perror(f); exit(1); }
    char l[256];
    while (fgets(l, sizeof(l), fp) && qc < N) {
        if (l[0] == '\n' || l[0] == '#') continue;
        sscanf(l, "%s %s %s %s", q[qc].op, q[qc].a1, q[qc].a2, q[qc].res);
        q[qc].live = true;
        qc++;
    }
    fclose(fp);
}

void identify() {
    for (int i = 0; i < qc; i++) {
        addVar(q[i].a1); addVar(q[i].a2); addVar(q[i].res);
        int ri = findVar(q[i].res);
        if (ri != -1) v[ri].def = true;
    }
}

void markUsed() {
    bool ch;
    for (int i = 0; i < qc; i++) {
        if (!strcmp(q[i].op, "output") || !strcmp(q[i].op, "return") ||
            !strcmp(q[i].op, "if") || !strcmp(q[i].op, "param")) {
            int a = findVar(q[i].a1);
            if (a != -1) v[a].used = true;
            a = findVar(q[i].a2);
            if (a != -1) v[a].used = true;
        }
    }

    do {
        ch = false;
        for (int i = 0; i < qc; i++) {
            int r = findVar(q[i].res);
            if (r != -1 && v[r].used) {
                int a1 = findVar(q[i].a1), a2 = findVar(q[i].a2);
                if (a1 != -1 && !v[a1].used) { v[a1].used = true; ch = true; }
                if (a2 != -1 && !v[a2].used) { v[a2].used = true; ch = true; }
            }
        }
    } while (ch);
}

void eliminate() {
    for (int i = 0; i < qc; i++) {
        int r = findVar(q[i].res);
        if (r != -1 && !v[r].used) q[i].live = false;
        if (!strcmp(q[i].op, "output") || !strcmp(q[i].op, "return") ||
            !strcmp(q[i].op, "if") || !strcmp(q[i].op, "param") ||
            !strcmp(q[i].op, "call") || !strcmp(q[i].op, "label") ||
            !strcmp(q[i].op, "goto")) q[i].live = true;
    }
}

void printQ(bool liveOnly) {
    printf("%-6s %-8s %-8s %-8s %-8s\n", "Index", "Op", "Arg1", "Arg2", "Result");
    puts("------------------------------------------");
    for (int i = 0; i < qc; i++) {
        if (!liveOnly || q[i].live)
            printf("%-6d %-8s %-8s %-8s %-8s%s\n", i, q[i].op, q[i].a1, q[i].a2, q[i].res,
                   (liveOnly && !q[i].live) ? " (DEAD)" : "");
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) { printf("Usage: %s <file>\n", argv[0]); return 1; }
    load(argv[1]);
    puts("===== Original Quadruples =====");
    printQ(false);
    identify();
    markUsed();
    eliminate();
    puts("\n===== After Dead Code Elimination =====");
    printQ(true);
    return 0;
}
