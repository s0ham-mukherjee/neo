.intel_syntax noprefix
.text
.globl computeSum
computeSum:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    xor eax, eax
    mov [rbp-16], rax
    mov rax, 1
    mov [rbp-24], rax
.L_for_0:
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-8]
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setle al
    movzx rax, al
    test rax, rax
    jz .L_fend_1
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, 2
    push rax
    pop rbx
    pop rax
    imul rax, rbx
    push rax
    xor eax, eax
    push rax
    pop rbx
    pop rax
    add rax, rbx
    push rax
    pop rbx
    pop rax
    add rax, rbx
    push rax
    mov rax, [rbp-24]
    push rax
    xor eax, eax
    push rax
    pop rbx
    pop rax
    imul rax, rbx
    push rax
    pop rbx
    pop rax
    sub rax, rbx
    mov [rbp-16], rax
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    push rax
    pop rbx
    pop rax
    add rax, rbx
    mov [rbp-24], rax
    jmp .L_for_0
.L_fend_1:
    mov rax, [rbp-16]
    jmp .L_computeSum_end
.L_computeSum_end:
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
    mov rax, 100000
    push rax
    pop rcx
    sub rsp, 32
    call computeSum
    add rsp, 32
    mov [rbp-8], rax
    lea rax, [rip + .L_str_3]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
    lea rax, [rip + .L_str_4]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
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
.L_str_2:
    .asciz "--- Zeno Intensive Benchmark Suite ---"
.L_str_3:
    .asciz "Sum (1..100000 * 2): "
.L_str_4:
    .asciz "Benchmark calculation complete!"
