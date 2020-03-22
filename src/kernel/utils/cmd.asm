%include "utils/screen.asm"
%include "utils/string.asm"
%include "utils/basic.asm"
%include "utils/keyboard.asm"
%include "utils/fs.asm"

%ifndef CMD_ASM
    %define CMD_ASM

command_line:
    call clear_screen

    mov si, welcome_text
    call print_str

    mov si, help
    call print_str

    call cmd_main

cmd_main:
    mov di, input
    mov al, 0
    mov cx, 256
    rep stosb

    mov di, command
    mov cx, 32
    rep stosb

    mov si, program
    call print_str

    call print_ln

    mov ax, input
    call input_string

    call print_ln

    mov ax, input
    
    mov ax, input
    call string_chomp

    mov si, input
    cmp byte [si], 0
    je cmd_main

    mov si, input
    mov alm, ' '
    call string_tokenize

    mov word [param_list], di

    mov si, input
    mov di, command
    call string_copy

    mov ax, input
    call string_uppercase

    mov si, input

    mov di, exit_str
    call str_compare
    jc near exit

    mov di, help_str
    call str_compare
    jc near print_help

    mov di, cls_str
    call str_compare
    jc near clear_screen

    mov di, dir_str
    call str_compare
    jc near dir_list

    mov di, ver_str
    call str_compare
    jc near print_ver

    mov di, rm_str
    call str_compare
    jc near rm_file

    mov di, exit_str
    call str_compare
    jc near exit

    ;mov di, cd_str
    ;call str_compare
    ;jc near

bin_file:
    mov ax, command
    mov bx, 0
    mov cx, 32768
    call os_load_file
    jc total_fail

excecute_bin:
    mov si, command
    mov di, kern_file_string
    mov cx, 6
    call str_compare
    jc no_kernel_allowed_msg
    call print_str

    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    mov word si, [param_list]
    mov di, 0
    
    call 32768

    jmp cmd_main

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

not_extension:
    mov ax, command
    call strlen

    mov si, command
    add si, ax

    mov byte [si], '.'
    mov byte [si+1], 'b'
    mov byte [si+2], 'i'
    mov byte [si+3], 'n'
    mov byte [si+4], 0

    mov ax, command
    mov bx, 0
    mov cx, 32768
    call os_load_file
    jc try_basic_exit

    jmp excecute_bin

try_basic_exit:
    mov ax, command
    call strlen

    mov si, command
    add si, ax
    sub si, 4

    mov byte [si], '.'
    mov byte [si+1], 'b'
    mov byte [si+2], 'a'
    mov byte [si+3], 's'
    mov byte [si+4], 0

    jmp basic_file


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

; -------------------------------
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
rm_file:
    mov word si, [param_list]
    call string_parse
    cmp ax, 0
    jne .filename_provided

    mov si, nofilename_msg
    call print_str
    jmp cmd_main

.filename_provided:
    call os_remove_file
    jc .failure

    mov si, success_msg
    call print_str
    mov si, ax
    call print_str
    call print_ln
    jmp cmd_main

.failure:
    mov si, .failure_msg
    call print_str
    jmp cmd_main

    .failure_msg db 'The file could not be deleted, possibly it does not exist or its writing is protected.'
; -------------------------------

exit:
    ret

welcome_text db 'Welcome to RedstoneDOS!, VER: 1.0'
help_text db 'Commands: dir, cd, help, exit, rm, ver'
invalid_msg db 'No such command or program.'
ver_msg db 'RedstoneDOS, VER: 1.0'

input times 256 db 0
command times 32 db 0
dirlist times 1024 db 0

param_list dw 0

bas_ext db '.bas', 

; Tokens
exit_str db 'exit', 0
help_str db 'help', 0
ver_str db 'ver', 0
dir_str db 'dir', 0
cd_str db 'cd', 0
rm_str db 'rm', 0
cls_str db 'cls', 0

nofilename_msg db 'You have not entered a file name! Example: rm hello.txt', 13, 10, 0
success_msg db 'File successfully deleted!'

no_kernel_allowed_msg db 'The kernel cannot run this .bin file, possibly it is corrupt.'

kern_file_string db 'RDOS', 0

%endif