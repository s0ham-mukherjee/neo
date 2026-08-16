.intel_syntax noprefix
.text
.globl fib
fib:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setle al
    movzx rax, al
    test rax, rax
    jz .L_else_0
    mov rax, [rbp-8]
    jmp .L_fib_end
    jmp .L_endif_1
.L_else_0:
.L_endif_1:
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    push rax
    pop rbx
    pop rax
    sub rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call fib
    add rsp, 32
    push rax
    mov rax, [rbp-8]
    push rax
    mov rax, 2
    push rax
    pop rbx
    pop rax
    sub rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call fib
    add rsp, 32
    push rax
    pop rbx
    pop rax
    add rax, rbx
    jmp .L_fib_end
.L_fib_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.globl main
main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    lea rax, [rip + .L_str_2]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    xor eax, eax
    mov [rbp-8], rax
.L_for_3:
    mov rax, [rbp-8]
    push rax
    mov rax, 10
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setle al
    movzx rax, al
    test rax, rax
    jz .L_fend_4
    lea rax, [rip + .L_str_5]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call print_int
    add rsp, 32
    lea rax, [rip + .L_str_6]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call fib
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    push rax
    pop rbx
    pop rax
    add rax, rbx
    mov [rbp-8], rax
    jmp .L_for_3
.L_fend_4:
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
.L_str_2:
    .asciz "--- Fibonacci Calculator in Neo ---"
.L_str_5:
    .asciz "fib("
.L_str_6:
    .asciz ") = "
