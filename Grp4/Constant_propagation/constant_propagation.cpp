#include <bits/stdc++.h>
using namespace std;

class Quad {
public:
    string op;
    string src1;
    string src2;
    string dst;
    
    Quad(string _op, string _src1, string _src2, string _dst) {
        op = _op;
        src1 = _src1;
        src2 = _src2;
        dst = _dst;
    }
    
    void print() {
        cout << setw(8) << left << op << setw(8) << left << src1;
        cout << setw(8) << left << src2 << setw(8) << left << dst << endl;
    }
};

bool isConstant(const string& s) {
    if (s.empty()) return false;
    
    for (char c : s) {
        if (!isdigit(c) && c != '-' && c != '.') {
            return false;
        }
    }
    return true;
}

int main() {
    vector<Quad> quads;
    string op, src1, src2, dst;
    
    cout << "Enter quadruples (op src1 src2 dst), type 'end' to finish:\n";

    while (true) {
        cin >> op;
        if (op == "end") break;
        
        cin >> src1 >> src2 >> dst;
        quads.push_back(Quad(op, src1, src2, dst));
    }
    
    cout << "\nOriginal quadruples:\n";
    cout << setw(8) << left << "Op" << setw(8) << left << "Src1";
    cout << setw(8) << left << "Src2" << setw(8) << left << "Dst" << endl;
    cout << string(32, '-') << endl;
    
    for (auto& q : quads) {
        q.print();
    }

    map<string, string> constants;
    bool changed;
    
    do {
        changed = false;

        for (auto& q : quads) {
            if (q.op == "=" && isConstant(q.src1)) {
                constants[q.dst] = q.src1;
            }
        }

        for (auto& q : quads) {

            if (q.op == "=" && isConstant(q.src1)) continue;

            if (!isConstant(q.src1) && constants.find(q.src1) != constants.end()) {
                q.src1 = constants[q.src1];
                changed = true;
            }

            if (!q.src2.empty() && !isConstant(q.src2) && constants.find(q.src2) != constants.end()) {
                q.src2 = constants[q.src2];
                changed = true;
            }
        }
    } while (changed);
    
    cout << "\nAfter constant propagation:\n";
    cout << setw(8) << left << "Op" << setw(8) << left << "Src1";
    cout << setw(8) << left << "Src2" << setw(8) << left << "Dst" << endl;
    cout << string(32, '-') << endl;
    
    for (auto& q : quads) {
        q.print();
    }
    
    return 0;
}