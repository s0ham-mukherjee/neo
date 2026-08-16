#include "codegen.hpp"
#include "ir.hpp"
#include "lexer.hpp"
#include "optimizer.hpp"
#include "parser.hpp"
#include "semantic.hpp"

#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

namespace {

void printVersion() {
    std::cout << "The Neo Programming Language Compiler (neo) v1.0.0\n";
    std::cout << "Target: x86_64-pc-windows-msvc/mingw (Native x86-64 Machine Code)\n";
}

void printUsage(const char* program) {
    std::cout << "Usage: " << program << " [command] <input.neo> [options]\n";
    std::cout << "\nCommands:\n";
    std::cout << "  run <file.neo>    Compile and execute the Neo program immediately\n";
    std::cout << "  build <file.neo>  Compile and link into a native executable binary\n";
    std::cout << "  bench <file.neo>  Profile execution time in microseconds\n";
    std::cout << "\nOptions:\n";
    std::cout << "  -o <file>           Output binary path (default: a.exe / a.out)\n";
    std::cout << "  -O<level>           Optimization level (0, 1, 2; default: 1)\n";
    std::cout << "  --emit-asm          Emit x86-64 assembly file (.s) and skip linking\n";
    std::cout << "  --emit-ir           Emit Three-Address Code (TAC) IR and exit\n";
    std::cout << "  --dump-cfg          Print formatted Control Flow Graph (CFG) in Graphviz DOT format and exit\n";
    std::cout << "  --dump-ast          Print formatted visual AST tree and exit\n";
    std::cout << "  --dump-tokens       Print lexer token stream and exit\n";
    std::cout << "  -v, --verbose       Enable verbose compilation logging\n";
    std::cout << "  --version           Display Neo version banner\n";
    std::cout << "  -h, --help          Display this help message\n";
}

std::string readFile(const std::string& path) {
    std::ifstream in(path);
    if (!in) {
        throw std::runtime_error("Could not open file: " + path);
    }
    std::ostringstream buffer;
    buffer << in.rdbuf();
    return buffer.str();
}

int runCommand(const std::string& command) {
    return std::system(command.c_str());
}

std::string preprocess(const std::string& inputPath) {
    std::string source = readFile(inputPath);
    if (source.find("#include") != std::string::npos || source.find("#define") != std::string::npos) {
        std::string prepOut = inputPath + ".i";
        std::string cmd = "g++ -E \"" + inputPath + "\" -o \"" + prepOut + "\"";
        if (runCommand(cmd) == 0) {
            std::string preprocessedSource = readFile(prepOut);
            std::remove(prepOut.c_str());
            return preprocessedSource;
        }
    }
    return source;
}

void printDiagnostic(const std::string& source, int line, int column, const std::string& msg) {
    std::cerr << "\033[1;31merror:\033[0m " << msg << "\n";
    std::istringstream stream(source);
    std::string lineContent;
    int currentLine = 1;
    while (std::getline(stream, lineContent)) {
        if (currentLine == line) {
            std::cerr << "  " << line << " | " << lineContent << "\n";
            std::cerr << "    | ";
            for (int i = 1; i < column; ++i) {
                std::cerr << " ";
            }
            std::cerr << "\033[1;32m^~~~~~\033[0m\n";
            break;
        }
        currentLine++;
    }
}

}  // namespace

int main(int argc, char** argv) {
    if (argc < 2) {
        printUsage(argv[0]);
        return 1;
    }

    std::string inputPath;
    std::string outputPath;
    bool isRunMode = false;
    bool isBenchMode = false;
    bool emitAsmOnly = false;
    bool emitIR = false;
    bool dumpAST = false;
    bool dumpCFG = false;
    bool dumpTokens = false;
    bool verbose = false;
    int optLevel = 1;

    int argStart = 1;
    std::string firstArg = argv[1];
    if (firstArg == "run") {
        isRunMode = true;
        argStart = 2;
    } else if (firstArg == "build") {
        argStart = 2;
    } else if (firstArg == "bench") {
        isBenchMode = true;
        argStart = 2;
    }

    for (int i = argStart; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "-o" && i + 1 < argc) {
            outputPath = argv[++i];
        } else if (arg == "-O0") {
            optLevel = 0;
        } else if (arg == "-O1") {
            optLevel = 1;
        } else if (arg == "-O2") {
            optLevel = 2;
        } else if (arg == "--emit-asm" || arg == "-S") {
            emitAsmOnly = true;
        } else if (arg == "--emit-ir") {
            emitIR = true;
        } else if (arg == "--dump-ast") {
            dumpAST = true;
        } else if (arg == "--dump-cfg") {
            dumpCFG = true;
        } else if (arg == "--dump-tokens") {
            dumpTokens = true;
        } else if (arg == "-v" || arg == "--verbose") {
            verbose = true;
        } else if (arg == "--version") {
            printVersion();
            return 0;
        } else if (arg == "--help" || arg == "-h") {
            printUsage(argv[0]);
            return 0;
        } else if (arg[0] == '-') {
            std::cerr << "Unknown option: " << arg << "\n";
            printUsage(argv[0]);
            return 1;
        } else {
            inputPath = arg;
        }
    }

    if (inputPath.empty()) {
        std::cerr << "Error: no input file specified\n";
        printUsage(argv[0]);
        return 1;
    }

    if (outputPath.empty()) {
#ifdef _WIN32
        outputPath = (isRunMode || isBenchMode) ? "temp_neo.exe" : "a.exe";
#else
        outputPath = (isRunMode || isBenchMode) ? "temp_neo.out" : "a.out";
#endif
    }

    std::string source;
    try {
        source = preprocess(inputPath);

        if (verbose) std::cout << "[1/6] Lexical Analysis...\n";
        Lexer lexer(source);
        std::vector<Token> tokens = lexer.tokenize();

        for (const Token& token : tokens) {
            if (token.kind == TokenKind::Invalid) {
                printDiagnostic(source, token.line, token.column, token.lexeme);
                return 1;
            }
        }

        if (dumpTokens) {
            std::cout << "--- Neo Token Stream ---\n";
            for (const Token& token : tokens) {
                std::cout << tokenKindName(token.kind);
                if (!token.lexeme.empty()) {
                    std::cout << "('" << token.lexeme << "')";
                }
                std::cout << " @ " << token.line << ":" << token.column << "\n";
            }
            return 0;
        }

        if (verbose) std::cout << "[2/6] Parsing Abstract Syntax Tree...\n";
        Parser parser(tokens);
        Program program = parser.parseProgram();

        if (dumpAST) {
            std::cout << "--- Neo Abstract Syntax Tree ---\n";
            ASTPrinter::print(program, std::cout);
            return 0;
        }

        if (verbose) std::cout << "[3/6] Semantic Analysis & Type Checking...\n";
        SemanticAnalyzer semantic;
        semantic.analyze(program);

        if (verbose) std::cout << "[4/6] Intermediate Representation (TAC) Generation...\n";
        ir::IRGenerator irGen;
        ir::IRProgram irProg = irGen.generate(program);

        if (optLevel > 0) {
            if (verbose) std::cout << "[5/6] Running Optimization Passes (-O" << optLevel << ")...\n";
            ir::Optimizer optimizer(optLevel);
            optimizer.optimize(irProg);
        }

        if (dumpCFG) {
            ir::CFGProgram cfg = ir::buildCFG(irProg);
            cfg.printDot(std::cout);
            return 0;
        }

        if (emitIR) {
            irProg.print(std::cout);
            return 0;
        }

        if (verbose) std::cout << "[6/6] Generating x86-64 Assembly & Linking Runtime...\n";
        std::string asmPath = outputPath + ".s";
        {
            std::ofstream asmOut(asmPath);
            if (!asmOut) {
                throw std::runtime_error("Could not write assembly file: " + asmPath);
            }
            CodeGenerator codegen;
            codegen.emit(program, asmOut);
        }

        if (emitAsmOnly) {
            std::cout << "Assembly successfully emitted to " << asmPath << "\n";
            return 0;
        }

        std::string linkCommand =
#ifdef _WIN32
            "g++ -o \"" + outputPath + "\" \"" + asmPath + "\" \"src/runtime.o\"";
#else
            "g++ -no-pie -o \"" + outputPath + "\" \"" + asmPath + "\" \"src/runtime.o\"";
#endif

        int linkResult = runCommand(linkCommand);
        if (linkResult != 0) {
            std::cerr << "Linking failed. Assembly saved at " << asmPath << "\n";
            return linkResult;
        }

        if (isRunMode) {
            std::cout << "--- Running " << inputPath << " ---\n";
            std::string execCmd = ".\\" + outputPath;
            int code = runCommand(execCmd);
            (void)code;
            return 0;
        }

        if (isBenchMode) {
            std::cout << "--- Neo High-Performance Benchmark Runner ---\n";
            std::cout << "Target Program: " << inputPath << "\n";
            std::cout << "Optimization Level: -O" << optLevel << "\n\n";
            auto start = std::chrono::high_resolution_clock::now();
            std::string execCmd = ".\\" + outputPath;
            int code = runCommand(execCmd);
            auto end = std::chrono::high_resolution_clock::now();
            auto durationUs = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
            std::cout << "\n-----------------------------------\n";
            std::cout << "Status: " << (code == 0 ? "SUCCESS" : "FAILED") << " (Exit Code: " << code << ")\n";
            std::cout << "Execution Time: " << durationUs << " us (" << (durationUs / 1000.0) << " ms)\n";
            return 0;
        }

        std::cout << "Compiled successfully -> " << outputPath << "\n";
        return 0;
    } catch (const ParseError& ex) {
        std::cerr << "\033[1;31m[Parse Error]\033[0m " << ex.what() << "\n";
        return 1;
    } catch (const SemanticError& ex) {
        std::cerr << "\033[1;31m[Type Error]\033[0m " << ex.what() << "\n";
        return 1;
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << "\n";
        return 1;
    }
}
