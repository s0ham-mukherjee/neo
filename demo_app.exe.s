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
    lea rax, [rip + .L_str_2]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    mov qword ptr [rbp-8], 0
    lea rax, [rbp-8]
    push rax
    mov rax, 101
    push rax
    mov rax, 45
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call SmartDevice_initialize
    add rsp, 32
    lea rax, [rip + .L_str_3]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    lea rax, [rbp-8]
    push rax
    mov rax, 30
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call SmartDevice_charge
    add rsp, 32
    lea rax, [rip + .L_str_4]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    xor eax, eax
    mov [rbp-16], rax
    mov rax, 1
    mov [rbp-24], rax
.L_for_5:
    mov rax, [rbp-24]
    push rax
    mov rax, 5
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setle al
    movzx rax, al
    test rax, rax
    jz .L_fend_6
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-24]
    push rax
    pop rbx
    pop rax
    imul rax, rbx
    mov [rbp-32], rax
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-32]
    push rax
    pop rbx
    pop rax
    add rax, rbx
    mov [rbp-16], rax
    lea rax, [rip + .L_str_7]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-24]
    push rax
    pop rcx
    sub rsp, 32
    call print_int
    add rsp, 32
    lea rax, [rip + .L_str_8]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-32]
    push rax
    pop rcx
    sub rsp, 32
    call println_int
    add rsp, 32
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    push rax
    pop rbx
    pop rax
    add rax, rbx
    mov [rbp-24], rax
    jmp .L_for_5
.L_fend_6:
    lea rax, [rip + .L_str_9]
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
    lea rax, [rip + .L_str_10]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    lea rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call SmartDevice_getBattery
    add rsp, 32
    push rax
    mov rax, 50
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setge al
    movzx rax, al
    test rax, rax
    jz .L_tern_else_11
    mov rax, 1
    push rax
    jmp .L_tern_end_12
.L_tern_else_11:
    xor eax, eax
    push rax
.L_tern_end_12:
    pop rax
    mov [rbp-40], rax
    mov rax, [rbp-40]
    push rax
    mov rax, 1
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    sete al
    movzx rax, al
    test rax, rax
    jz .L_else_13
    lea rax, [rip + .L_str_15]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    jmp .L_endif_14
.L_else_13:
    lea rax, [rip + .L_str_16]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
.L_endif_14:
    lea rax, [rip + .L_str_17]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    lea rax, [rip + .L_str_18]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
    lea rax, [rip + .L_str_19]
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
.globl SmartDevice_initialize
SmartDevice_initialize:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov rax, [rbp-16]
    mov rbx, [rbp-8]
    mov [rbx], rax
    mov rax, [rbp-24]
    mov rbx, [rbp-8]
    mov [rbx], rax
.L_SmartDevice_initialize_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.globl SmartDevice_charge
SmartDevice_charge:
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
    mov rax, [rbp-8]
    mov rax, [rax]
    push rax
    mov rax, 100
    push rax
    pop rbx
    pop rax
    cmp rax, rbx
    setg al
    movzx rax, al
    test rax, rax
    jz .L_else_20
    mov rax, 100
    mov rbx, [rbp-8]
    mov [rbx], rax
    jmp .L_endif_21
.L_else_20:
.L_endif_21:
    lea rax, [rip + .L_str_22]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-8]
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
    call print_int
    add rsp, 32
    lea rax, [rip + .L_str_23]
    push rax
    pop rcx
    sub rsp, 32
    call print_str
    add rsp, 32
    mov rax, [rbp-8]
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
    call print_int
    add rsp, 32
    lea rax, [rip + .L_str_24]
    push rax
    pop rcx
    sub rsp, 32
    call println_str
    add rsp, 32
.L_SmartDevice_charge_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.globl SmartDevice_getBattery
SmartDevice_getBattery:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 136
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    mov rax, [rax]
    jmp .L_SmartDevice_getBattery_end
.L_SmartDevice_getBattery_end:
    add rsp, 136
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
.section .rdata,"dr"
.L_str_0:
    .asciz "==============================================="
.L_str_1:
    .asciz "   Welcome to The Neo Programming Language!"
.L_str_2:
    .asciz "==============================================="
.L_str_3:
    .asciz "\n[1] OOP SmartDevice Status:"
.L_str_4:
    .asciz "\n[2] Computing Sum of Squares (1 to 5):"
.L_str_7:
    .asciz "  i = "
.L_str_8:
    .asciz " -> square = "
.L_str_9:
    .asciz "Total Sum of Squares: "
.L_str_10:
    .asciz "\n[3] System Diagnostic Check:"
.L_str_15:
    .asciz "System Status: OPTIMAL [Battery Healthy]"
.L_str_16:
    .asciz "System Status: WARNING [Low Battery]"
.L_str_17:
    .asciz "\n==============================================="
.L_str_18:
    .asciz "   Neo Execution Completed Successfully!"
.L_str_19:
    .asciz "==============================================="
.L_str_22:
    .asciz "Device #"
.L_str_23:
    .asciz " charged! Current battery: "
.L_str_24:
    .asciz "%"
