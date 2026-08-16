.intel_syntax noprefix
.text
.globl main
main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    lea rax, [rip + .L_str_0]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    lea rax, [rip + .L_str_1]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    mov rax, 40
    mov [rbp-8], rax
    mov rax, 2
    mov [rbp-16], rax
    lea rax, [rip + .L_str_2]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, [rbp-16]
    push rax
    pop rbx
    pop rax
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
    xor eax, eax
    jmp .L_main_end
    xor eax, eax
.L_main_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.section .rdata,"dr"
.L_str_0:
    .asciz "Hello from Neo Programming Language!"
.L_str_1:
    .asciz "-----------------------------------"
.L_str_2:
    .asciz "Computing 40 + 2 in Neo:"
