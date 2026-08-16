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
    mov qword ptr [rbp-8], 0
    mov rax, 500
    mov [rbp-8], rax
    lea rax, [rip + .L_str_1]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    lea rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call BankAccount_getBalance
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
    lea rax, [rbp-8]
    push rax
    mov rax, 250
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call BankAccount_deposit
    add rsp, 32
    lea rax, [rbp-8]
    push rax
    mov rax, 100
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call BankAccount_withdraw
    add rsp, 32
    lea rax, [rip + .L_str_2]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    lea rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call BankAccount_getBalance
    add rsp, 32
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
.globl BankAccount_deposit
BankAccount_deposit:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, [rbp-8]
    mov rax, [rax]
    push rax
    mov rax, [rbp-16]
    push rax
    pop rbx
    pop rax
    add rax, rbx
    mov rbx, [rbp-8]
    mov [rbx], rax
    lea rax, [rip + .L_str_3]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
.L_BankAccount_deposit_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.globl BankAccount_withdraw
BankAccount_withdraw:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, [rbp-8]
    mov rax, [rax]
    push rax
    mov rax, [rbp-16]
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setge al
    movzx rax, al
    test rax, rax
    jz .L_else_4
    mov rax, [rbp-8]
    mov rax, [rax]
    push rax
    mov rax, [rbp-16]
    push rax
    pop rbx
    pop rax
    sub rax, rbx
    mov rbx, [rbp-8]
    mov [rbx], rax
    lea rax, [rip + .L_str_6]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
    jmp .L_endif_5
.L_else_4:
    lea rax, [rip + .L_str_7]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
.L_endif_5:
.L_BankAccount_withdraw_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.globl BankAccount_getBalance
BankAccount_getBalance:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    mov rax, [rax]
    jmp .L_BankAccount_getBalance_end
.L_BankAccount_getBalance_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.section .rdata,"dr"
.L_str_0:
    .asciz "--- Zeno OOP BankAccount Demo ---"
.L_str_1:
    .asciz "Initial Balance: $"
.L_str_2:
    .asciz "Final Balance: $"
.L_str_3:
    .asciz "Deposited: $"
.L_str_6:
    .asciz "Withdrew: $"
.L_str_7:
    .asciz "Insufficient funds!"
