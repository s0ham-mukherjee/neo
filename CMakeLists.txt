cmake_minimum_required(VERSION 3.16)
project(neo CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)

add_executable(neo
    src/main.cpp
    src/token.cpp
    src/lexer.cpp
    src/type.cpp
    src/ast.cpp
    src/parser.cpp
    src/semantic.cpp
    src/ir.cpp
    src/optimizer.cpp
    src/codegen.cpp
)
