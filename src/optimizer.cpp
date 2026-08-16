#include "optimizer.hpp"
#include <cctype>
#include <cstdlib>

namespace ir {

static bool isInteger(const std::string& s) {
    if (s.empty()) return false;
    size_t start = 0;
    if (s[0] == '-' || s[0] == '+') start = 1;
    if (start >= s.size()) return false;
    for (size_t i = start; i < s.size(); ++i) {
        if (!std::isdigit(static_cast<unsigned char>(s[i]))) return false;
    }
    return true;
}

void Optimizer::optimize(IRProgram& program) {
    if (level_ <= 0) return;
    for (auto& fn : program.functions) {
        optimizeFunction(fn);
    }
}

void Optimizer::optimizeFunction(IRFunction& fn) {
    bool changed = true;
    int passLimit = 10;
    while (changed && passLimit-- > 0) {
        changed = false;
        if (foldConstants(fn)) changed = true;
        if (algebraicSimplification(fn)) changed = true;
        if (eliminateDeadCode(fn)) changed = true;
        if (commonSubexpressionElimination(fn)) changed = true;
    }
}

bool Optimizer::foldConstants(IRFunction& fn) {
    bool changed = false;
    for (auto& inst : fn.instructions) {
        if (isInteger(inst.arg1) && isInteger(inst.arg2)) {
            int v1 = std::stoi(inst.arg1);
            int v2 = std::stoi(inst.arg2);
            int res = 0;
            bool folded = true;
            switch (inst.op) {
                case OpCode::ADD: res = v1 + v2; break;
                case OpCode::SUB: res = v1 - v2; break;
                case OpCode::MUL: res = v1 * v2; break;
                case OpCode::DIV: if (v2 != 0) res = v1 / v2; else folded = false; break;
                case OpCode::MOD: if (v2 != 0) res = v1 % v2; else folded = false; break;
                case OpCode::EQ: res = (v1 == v2); break;
                case OpCode::NEQ: res = (v1 != v2); break;
                case OpCode::LT: res = (v1 < v2); break;
                case OpCode::GT: res = (v1 > v2); break;
                case OpCode::LE: res = (v1 <= v2); break;
                case OpCode::GE: res = (v1 >= v2); break;
                default: folded = false; break;
            }
            if (folded) {
                inst.op = OpCode::ASSIGN;
                inst.arg1 = std::to_string(res);
                inst.arg2 = "";
                changed = true;
            }
        }
    }
    return changed;
}

bool Optimizer::algebraicSimplification(IRFunction& fn) {
    bool changed = false;
    for (auto& inst : fn.instructions) {
        if (inst.op == OpCode::ADD) {
            if (inst.arg2 == "0") {
                inst.op = OpCode::ASSIGN;
                inst.arg2 = "";
                changed = true;
            } else if (inst.arg1 == "0") {
                inst.op = OpCode::ASSIGN;
                inst.arg1 = inst.arg2;
                inst.arg2 = "";
                changed = true;
            }
        } else if (inst.op == OpCode::MUL) {
            if (inst.arg2 == "1") {
                inst.op = OpCode::ASSIGN;
                inst.arg2 = "";
                changed = true;
            } else if (inst.arg2 == "0") {
                inst.op = OpCode::ASSIGN;
                inst.arg1 = "0";
                inst.arg2 = "";
                changed = true;
            }
        }
    }
    return changed;
}

bool Optimizer::eliminateDeadCode(IRFunction& fn) {
    bool changed = false;
    std::vector<Instruction> newInsts;
    bool dead = false;
    for (const auto& inst : fn.instructions) {
        if (inst.op == OpCode::LABEL) {
            dead = false;
        }
        if (!dead) {
            newInsts.push_back(inst);
        } else {
            changed = true;
        }
        if (inst.op == OpCode::RETURN || inst.op == OpCode::JUMP) {
            dead = true;
        }
    }
    fn.instructions = std::move(newInsts);
    return changed;
}

bool Optimizer::commonSubexpressionElimination(IRFunction& fn) {
    bool changed = false;
    struct ExprKey {
        int op;
        std::string arg1;
        std::string arg2;
        bool operator==(const ExprKey& o) const {
            return op == o.op && arg1 == o.arg1 && arg2 == o.arg2;
        }
    };

    std::vector<std::pair<ExprKey, std::string>> seenExprs;

    for (auto& inst : fn.instructions) {
        if (inst.op == OpCode::LABEL || inst.op == OpCode::CALL || inst.op == OpCode::JUMP) {
            seenExprs.clear();
            continue;
        }

        if (inst.op == OpCode::ADD || inst.op == OpCode::SUB || inst.op == OpCode::MUL ||
            inst.op == OpCode::DIV || inst.op == OpCode::MOD || inst.op == OpCode::BIT_AND ||
            inst.op == OpCode::BIT_OR || inst.op == OpCode::BIT_XOR || inst.op == OpCode::SHL || inst.op == OpCode::SHR) {
            
            ExprKey key{static_cast<int>(inst.op), inst.arg1, inst.arg2};
            bool found = false;
            for (const auto& entry : seenExprs) {
                if (entry.first == key) {
                    inst.op = OpCode::ASSIGN;
                    inst.arg1 = entry.second;
                    inst.arg2 = "";
                    changed = true;
                    found = true;
                    break;
                }
            }
            if (!found && !inst.result.empty()) {
                seenExprs.push_back({key, inst.result});
            }
        }
    }

    return changed;
}

} // namespace ir
