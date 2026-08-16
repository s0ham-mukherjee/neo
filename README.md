# The Neo Programming Language (`.neo`)

> **Google-Level Production Compiler & Optimization Engine**  
> A high-performance, C++-style compiled programming language (**Neo**) featuring a Control Flow Graph (CFG) basic block engine, Common Subexpression Elimination (CSE), x86-64 Assembly Peephole Optimizer, Graphviz DOT Exporter (`--dump-cfg`), Microbenchmark Runner (`neo bench`), and native machine code generator (`neo.exe`).

---

## 🏛 Google-Tier Architecture & Pipeline Design

```
Source (.neo) → Lexer → Parser → Type Checker → TAC IR → CFG Basic Block Engine → Optimizer (-O1/-O2) → Peephole Assembly Opt → Native Executable
```

| Phase | Description |
|-------|-------------|
| **Preprocessor** | Integrated C preprocessor pass for `#include` header inclusion and `#define` macro expansion. |
| **Lexer** | Scans Neo keywords, identifiers, string/char/float literals, multiline comments (`/* ... */`), and operators with position tracking. |
| **Diagnostics Engine** | Colorized diagnostic formatting displaying source line context snippets and precise column caret markers (`^~~~`). |
| **Parser** | Hand-crafted precedence-climbing recursive descent parser building an Abstract Syntax Tree (AST). |
| **AST Visualizer** | Indented ASCII visual tree printer (`--dump-ast`). |
| **Type Checker** | Scoped symbol tables, static type checking, struct/class layout computation, and method mangling. |
| **Runtime Engine** | Built-in standard library runtime (`println_int`, `println_str`, `print_int`, `print_str`, `clock_ms`). |
| **Intermediate Representation** | Decoupled Three-Address Code (TAC) linear IR engine (`--emit-ir`). |
| **CFG Basic Block Engine** | Deconstructs IR into a **Control Flow Graph (CFG)** with basic blocks and predecessor/successor edges (`--dump-cfg`). |
| **Advanced IR Optimizer** | **Constant Folding**: Compile-time constant evaluation.<br>**Dead Code Elimination (DCE)**: Prunes dead blocks & unreachable jumps.<br>**Common Subexpression Elimination (CSE)**: Reuses redundant subexpression evaluations. |
| **Peephole Assembly Optimizer** | Scans generated assembly to collapse redundant loads/stores, convert `mov rax, 0` into `xor eax, eax`, and eliminate redundant `push rax / pop rax`. |
| **Code Generator** | Emits Win64 / System V AMD64 ABI compliant x86-64 Intel assembly syntax with 16-byte stack frame alignment. |
| **Linker** | Integrates with GNU assembler (`as`) & linker driver (`g++`) to produce native executables. |

---

## 🚀 Key Features & Language Support Matrix

| Category | Features Supported |
|----------|-------------------|
| **Data Types** | `int`, `bool`, `char`, `float`, `double`, `void`, Pointers (`T*`), Arrays (`T[N]`), `struct`, `class`, References (`T&`), Strings (`str` / `"..."`). |
| **Built-in Standard Runtime** | `println_int(val)`, `println_str("...")`, `print_int(val)`, `print_str("...")`, `clock_ms()`. |
| **Control Flow** | `if` / `else`, `while`, `for`, `do-while`, `switch` / `case` / `default`, `break`, `continue`, `return`. |
| **Operators** | Arithmetic (`+`, `-`, `*`, `/`, `%`), Comparisons (`==`, `!=`, `<`, `>`, `<=`, `>=`), Logical (`&&`, `||`, `!`), Bitwise (`&`, `|`, `^`, `~`, `<<`, `>>`), Ternary (`? :`), Increment/Decrement (`++`, `--`), Compound Assignments (`+=`, `-=`, `*=`, `/=`, `%=`), Member Access (`.`, `->`), Array Indexing (`[]`). |
| **Object-Oriented Programming** | Classes, Structs, Member fields, Member methods (`this` pointer passing in `RCX`), Access labels (`public:`, `private:`), Method name mangling (`Class_method`). |
| **Google-Tier Optimizations** | **Constant Folding**: Compile-time constant evaluation.<br>**Dead Code Elimination**: Prunes dead code after return.<br>**Common Subexpression Elimination (CSE)**: Eliminates redundant mathematical expressions.<br>**Peephole Assembly Optimization**: Replaces zero assignment with `xor eax, eax` and removes redundant push/pops. |

---

## 🛠 Build Instructions

Requires a **C++17 compiler** (GCC, Clang, or MSVC) and optionally **CMake 3.16+**.

### Building Neo Compiler with MSYS2 GCC
```powershell
C:\msys64\ucrt64\bin\g++.exe -std=c++17 -Iinclude -O2 src/main.cpp src/token.cpp src/lexer.cpp src/type.cpp src/ast.cpp src/parser.cpp src/semantic.cpp src/ir.cpp src/optimizer.cpp src/codegen.cpp -o neo.exe
```

### Building with CMake
```bash
cmake -B build
cmake --build build
```

---

## 💻 Usage & Subcommands

```bash
# 1. Run a Neo program immediately
.\neo.exe run examples\hello.neo

# 2. Build native binary executable
.\neo.exe build examples\benchmark.neo -o bench.exe -O2
.\bench.exe

# 3. High-Performance Execution Microbenchmarking
.\neo.exe bench examples\benchmark.neo -O2

# 4. Dump visual Control Flow Graph (CFG) in Graphviz DOT format
.\neo.exe --dump-cfg examples\class_demo.neo

# 5. Dump visual Abstract Syntax Tree (AST)
.\neo.exe --dump-ast examples\class_demo.neo

# 6. Emit optimized Three-Address Code (TAC) IR
.\neo.exe --emit-ir examples\fibonacci.neo -O2

# 7. Emit optimized x86-64 assembly (.s)
.\neo.exe examples\hello.neo --emit-asm
```

### Command Flags

| Command / Flag | Description |
|----------------|-------------|
| `run <file.neo>` | Compile and run Neo program in one step |
| `build <file.neo>` | Compile and link Neo program into native executable binary |
| `bench <file.neo>` | Profile execution time in microseconds |
| `--dump-cfg` | Render Control Flow Graph (CFG) in Graphviz DOT format and exit |
| `--dump-ast` | Render visual AST tree hierarchy and exit |
| `--dump-tokens` | Print lexer token stream table and exit |
| `-o <file>` | Output executable binary path (default: `a.exe` / `a.out`) |
| `-O0`, `-O1`, `-O2` | Set optimization level (0: disabled, 1: standard, 2: aggressive) |
| `--emit-asm`, `-S` | Emit x86-64 assembly file (`.s`) and skip linking |
| `--emit-ir` | Emit Three-Address Code (TAC) IR stream and exit |
| `-v`, `--verbose` | Print detailed timing and pipeline execution stages |
| `--version` | Display Neo version banner |
| `-h`, `--help` | Display usage manual |

---

## 🎓 Evaluation & Defense Presentation Guide

When presenting Neo to your capstone evaluation panel or professors, follow this 5-step demonstration:

1. **Project Pitch**:
   > *"The Neo Programming Language: A Production-Grade C++ Compiler Engine with Control Flow Graph (CFG) Analysis, Common Subexpression Elimination (CSE), Peephole Assembly Optimization, and Native x86-64 Machine Code Generation"*

2. **Step 1 — Control Flow Graph Visualizer (`--dump-cfg`)**:
   Run `.\neo.exe --dump-cfg examples\class_demo.neo` to show basic block graph decomposition with predecessor and successor edges in Graphviz DOT format:
   ```dot
   digraph ControlFlowGraph {
       "withdraw_entry" -> "else_0";
       "withdraw_b1" -> "endif_1";
   }
   ```

3. **Step 2 — Visual AST Tree (`--dump-ast`)**:
   Run `.\neo.exe --dump-ast examples\class_demo.neo` to demonstrate AST parsing of classes, methods, and fields.

4. **Step 3 — Optimization Pipeline (`--emit-ir` `-O2`)**:
   Run `.\neo.exe --emit-ir examples\benchmark.neo -O2` to showcase Common Subexpression Elimination (CSE), Constant Folding, and DCE.

5. **Step 4 — Execution Benchmarking (`neo bench`)**:
   Run `.\neo.exe build examples\benchmark.neo -o bench.exe -O2` and execute `.\bench.exe` to demonstrate high-performance execution of 100,000 loop iterations in native machine code.

---

## 📄 License

MIT License
