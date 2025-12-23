default rel

extern CreateFileA
extern ReadFile
extern CloseHandle
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

%define GENERIC_READ     0x80000000
%define OPEN_EXISTING    3
%define FILE_ATTRIBUTE_NORMAL 0x80
%define STD_OUTPUT_HANDLE -11
%define INVALID_HANDLE_VALUE -1

section .data
    filename db "test.txt", 0
    buffer   times 1024 db 0
    bytesRead dq 0

section .text
global main

main:
    sub rsp, 72              ; ✅ shadow space + arguments

    ; === Ouvrir le fichier ===
    lea rcx, [filename]
    mov rdx, GENERIC_READ
    xor r8, r8
    xor r9, r9
    mov qword [rsp+32], OPEN_EXISTING
    mov qword [rsp+40], FILE_ATTRIBUTE_NORMAL
    mov qword [rsp+48], 0
    call CreateFileA

    cmp rax, INVALID_HANDLE_VALUE
    je exit

    mov r12, rax             ; handle fichier

    ; === Lire le fichier ===
    mov rcx, r12
    lea rdx, [buffer]
    mov r8d, 1024
    lea r9, [bytesRead]
    mov qword [rsp+32], 0
    call ReadFile

    ; === Obtenir stdout ===
    mov ecx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov r13, rax

    ; === Afficher ===
    mov rcx, r13
    lea rdx, [buffer]
    mov r8, [bytesRead]
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteConsoleA

    ; === Fermer ===
    mov rcx, r12
    call CloseHandle

exit:
    xor ecx, ecx
    call ExitProcess
