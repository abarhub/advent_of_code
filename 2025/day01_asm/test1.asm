; Programme NASM 64 bits pour Windows - Lecture et affichage ligne par ligne
; Compilation: nasm -f win64 readfile.asm
; Link: gcc readfile.obj -o readfile.exe (ou link.exe avec les libs appropriées)

extern GetCommandLineA
extern GetStdHandle
extern CreateFileA
extern ReadFile
extern WriteFile
extern CloseHandle
extern ExitProcess

section .data
    STD_OUTPUT_HANDLE equ -11
    STD_ERROR_HANDLE equ -12
    GENERIC_READ equ 0x80000000
    OPEN_EXISTING equ 3
    FILE_ATTRIBUTE_NORMAL equ 0x80
    INVALID_HANDLE_VALUE equ -1
    
    err_no_arg db "Erreur: Aucun fichier specifie", 13, 10, 0
    err_no_arg_len equ $ - err_no_arg
    err_open db "Erreur: Impossible d'ouvrir le fichier", 13, 10, 0
    err_open_len equ $ - err_open
    err_read db "Erreur: Erreur de lecture", 13, 10, 0
    err_read_len equ $ - err_read
    newline db 13, 10
    
    hFile dq 0
    hStdOut dq 0
    hStdErr dq 0
    bytesRead dd 0
    buffer times 4096 db 0
    filename times 260 db 0
    line_buffer times 4096 db 0

section .text
global main
default rel

main:
    ;int 3
    push rbp
    mov rbp, rsp
    sub rsp, 56
    
    ; Obtenir les handles stdout et stderr
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [hStdOut], rax
    
    mov rcx, STD_ERROR_HANDLE
    call GetStdHandle
    mov [hStdErr], rax
    
    ; Obtenir la ligne de commande
    call GetCommandLineA
    mov rsi, rax
    
    ; Extraire le nom du fichier de la ligne de commande
    call parse_cmdline
    test rax, rax
    jz no_argument
    
    ; Ouvrir le fichier
    lea rcx, [filename]
    ;lea rcx, [filename2]
    mov rdx, GENERIC_READ
    xor r8, r8                      ; pas de partage
    xor r9, r9                      ; pas de sécurité
    mov qword [rsp+32], OPEN_EXISTING
    mov qword [rsp+40], FILE_ATTRIBUTE_NORMAL
    mov qword [rsp+48], 0
    ;mov qword [rsp+32], FILE_ATTRIBUTE_NORMAL
    ;mov qword [rsp+40], 0
    ;mov dword [rsp+48], OPEN_EXISTING
    ;int 3
    call CreateFileA
    
    cmp rax, INVALID_HANDLE_VALUE
    je open_error
    
    mov [hFile], rax
    
    ; Lire et afficher le fichier ligne par ligne
read_loop:
    lea rcx, [hFile]
    mov rcx, [rcx]
    lea rdx, [buffer]
    mov r8d, 4096
    lea r9, [bytesRead]
    mov qword [rsp+32], 0
    call ReadFile
    
    test rax, rax
    jz read_error
    
    mov eax, [bytesRead]
    test eax, eax
    jz close_file
    
    ; Afficher le contenu lu ligne par ligne
    xor r12, r12                    ; position dans buffer
    xor r13, r13                    ; position dans line_buffer
    
process_char:
    cmp r12d, [bytesRead]
    jge read_loop
    
    lea rax, [buffer]
    movzx eax, byte [rax + r12]
    inc r12
    
    cmp al, 10                      ; LF
    je print_line
    
    cmp al, 13                      ; CR
    je check_crlf
    
    lea rbx, [line_buffer]
    mov [rbx + r13], al
    inc r13
    jmp process_char
    
check_crlf:
    ; Vérifier si c'est un CRLF
    cmp r12d, [bytesRead]
    jge print_line
    lea rax, [buffer]
    movzx eax, byte [rax + r12]
    cmp al, 10
    jne print_line
    inc r12                         ; sauter le LF
    
print_line:
    ; Afficher la ligne
    test r13, r13
    jz skip_print
    
    mov rcx, [hStdOut]
    lea rdx, [line_buffer]
    mov r8d, r13d
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteFile
    
skip_print:
    ; Afficher un retour à la ligne
    mov rcx, [hStdOut]
    lea rdx, [newline]
    mov r8d, 2
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteFile
    
    xor r13, r13                    ; réinitialiser line_buffer
    jmp process_char

close_file:
    mov rcx, [hFile]
    call CloseHandle
    xor ecx, ecx
    call ExitProcess

no_argument:
    mov rcx, [hStdErr]
    lea rdx, [err_no_arg]
    mov r8d, err_no_arg_len
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteFile
    mov ecx, 1
    call ExitProcess

open_error:
    mov rcx, [hStdErr]
    lea rdx, [err_open]
    mov r8d, err_open_len
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteFile
    mov ecx, 2
    call ExitProcess

read_error:
    mov rcx, [hStdErr]
    lea rdx, [err_read]
    mov r8d, err_read_len
    xor r9, r9
    mov qword [rsp+32], 0
    call WriteFile
    mov rcx, [hFile]
    call CloseHandle
    mov ecx, 3
    call ExitProcess

; Parse la ligne de commande pour extraire le nom du fichier
parse_cmdline:
    xor rcx, rcx
    
    ; Sauter le nom du programme
skip_program:
    lodsb
    test al, al
    jz no_file
    cmp al, ' '
    je found_space
    cmp al, '"'
    jne skip_program
    
skip_quoted:
    lodsb
    test al, al
    jz no_file
    cmp al, '"'
    jne skip_quoted
    
found_space:
    ; Sauter les espaces
skip_spaces:
    lodsb
    test al, al
    jz no_file
    cmp al, ' '
    je skip_spaces
    
    ; Copier le nom du fichier
    dec rsi
    lea rdi, [filename]
    
copy_filename:
    lodsb
    test al, al
    jz end_filename
    cmp al, ' '
    je end_filename
    cmp al, '"'
    je end_filename
    stosb
    jmp copy_filename
    
end_filename:
    mov byte [rdi], 0
    mov rax, 1
    ret
    
no_file:
    xor rax, rax
    ret