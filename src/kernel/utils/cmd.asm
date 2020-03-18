%include "screen.asm"
%include "string.asm"
%include "basic.asm"
%include "fs.asm"

command_line:
    call clear_screen

    mov si, welcome_text
    call print_str

    mov si, help
    call print_str

cmd_main:

basic_file:
    mov ax, command
    mov bx, 0
    mov cx, 32768
    call os_load_file
    jc total_fail

    mov ax, 32768
    mov word si, [param_list]
    call os_run_basic
    jmp cmd_main

total_fail:
    mov si, invalid_msg
    call print_str

    jmp cmd_main

print_help:
    mov si, help_text
    call print_str
    jmp cmd_main

cmd_clear_screen:
    call clear_screen
    jmp cmd_main

print_ver:
    mov si, ver_msg
    call print_str
    jmp cmd_main

; -----------------------------
dir_list:
    mov cx, 0

    mov ax, dirlist
    call os_get_file_list

    mov si, dirlist
    mov ah, 0Eh

.repeat:
    lodsb
    cmp al, ','
    jne .nonewline
    pusha
    call print_ln
    popa
    jmp .repeat

.nonewline:
    int 10h
    jmp .repeat

.done:
    call print_ln
    jmp cmd_main
; -------------------------------


exit:
    ret

welcome_text db 'Welcome to RedstoneDOS!, VER: 1.0'
help_text db 'Commands: dir, cd, help, exit, rm, ver'
invalid_msg db 'No such command or program. Don't be stupid!.'
ver_msg db 'RedstoneDOS, VER: 1.0'

input times 256 db 0
command times 32 db 0
dirlist times 1024 db 0

bas_ext db '.bas', 

; Tokens
exit_str db 'exit', 0
help_str db 'help', 0
ver_str db 'ver', 0
dir_str db 'dir', 0
cd_str db 'cd', 0
rm_str db 'rm', 0
cls_str db 'cls', 0