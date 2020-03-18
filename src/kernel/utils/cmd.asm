%include "screen.asm"
%include "string.asm"
%include "basic.asm"

command_line:
    call clear_screen

    mov si, welcome_text
    call print_str

    mov si, help
    call print_str

cmd_main:

exit:
    ret

welcome_text db 'Welcome to RedstoneDOS!, VER: 1.0'
help_text db 'Commands: dir, cd, help, exit, rm, ver'
invalid_msg db 'No such command or program. Don't be stupid!.'

input times 256 db 0
command times 32 db 0
dirlist times 1024 db 0

bin_ext db '.bin', 0
bas_ext db '.bas', 

; Tokens
exit_str db 'exit', 0
help_str db 'help', 0
ver_str db 'ver', 0
dir_str db 'dir', 0
cd_str db 'cd', 0
rm_str db 'rm', 0