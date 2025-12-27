default rel
extern ExitProcess
extern GetStdHandle
extern WriteConsoleA

section .data
    msg db "Bonjour depuis NASM !", 13, 10
    msg_len equ $ - msg

section .text
global main

main:
    sub rsp, 40            ; alignement stack Windows x64

    mov ecx, -11           ; STD_OUTPUT_HANDLE
    call GetStdHandle

    mov rcx, rax           ; handle
    lea rdx, [msg]         ; buffer
    mov r8d, msg_len       ; taille
    xor r9d, r9d           ; chars written (NULL)
    mov qword [rsp+32], 0
    call WriteConsoleA

    xor ecx, ecx
    call ExitProcess
