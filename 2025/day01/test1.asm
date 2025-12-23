default rel

extern CreateFileA
extern ReadFile
extern CloseHandle
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

extern GetCommandLineA
extern CommandLineToArgvW
extern LocalFree

extern GetLastError
extern FormatMessageA
extern GetStdHandle


%define GENERIC_READ     0x80000000
%define OPEN_EXISTING    3
%define FILE_ATTRIBUTE_NORMAL 0x80
%define STD_OUTPUT_HANDLE -11
%define INVALID_HANDLE_VALUE -1

%define RESULT_STR 0
%define RESULT_NUM 8

%define FORMAT_MESSAGE_FROM_SYSTEM 0x00001000
%define STD_ERROR_HANDLE -12

section .data
    filename db "test.txt", 0
    buffer   times 1024 db 0
    bytesRead dq 0
    argc dq 0
    errorBuffer times 1024 db 0

section .bss
    result:
        resq 1    ; pointeur vers chaîne (char*)
        resq 1    ; nombre (int64)

section .text
global main
global ma_fonction
global print_last_error

ma_fonction:
    ; stocker l'adresse de la chaîne

    call GetCommandLineA
    mov rcx, rax            ; lpCmdLine
    lea rdx, [argc]         ; &argc
    call CommandLineToArgvW

    ; RAX = argv (char**)
    mov rbx, rax            ; sauvegarde argv

    mov qword [rel result + RESULT_NUM], rbx

    cmp qword [argc], 2
    jl no_arg

    mov rcx, [rbx+8]        ; argv[1] (nom du fichier)


    ;lea rax, [rel ma_chaine]
    lea rax, [rbx+8]    
    mov [rel result + RESULT_STR], rax

    ; stocker le nombre
    mov qword [rel result + RESULT_NUM], rbx

    no_arg:

    ret

print_last_error:
    sub rsp, 72

    call GetLastError
    mov r8d, eax            ; error code

    lea rcx, [errorBuffer]
    mov rdx, 512
    mov r9d, FORMAT_MESSAGE_FROM_SYSTEM
    mov qword [rsp+32], 0   ; source
    mov qword [rsp+40], r8  ; message id
    mov qword [rsp+48], 0   ; args
    call FormatMessageA

    mov ecx, STD_ERROR_HANDLE
    call GetStdHandle

    mov rcx, rax
    lea rdx, [errorBuffer]
    mov r8d, 512
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteConsoleA

    add rsp, 72
    ret


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
