%include "screen.asm"
%include "string.asm"

command_line:
    call clear_screen

    mov si, welcome_text
    call print_str

    mov si, help
    call print_str

welcome_text db 'Welcome to RedstoneDOS!, VER: 1.0'
help_text db 'Commands: dir, cd, help, exit, rm, ver'