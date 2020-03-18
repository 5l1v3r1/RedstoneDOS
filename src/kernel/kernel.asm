bits 16

%define DOS_VER '1.0'

%include "utils/string.asm"
%include "utils/keyboard.asm"
%include "utils/screen.asm"
%include "utils/cmd.asm"
%include "utils/fs.asm"

disk_buffer	equ	24576

kernel_main:
    cli
    mov ax, 0
    mov ss, ax
    mov sp, 0FFFFh
    sti

    cld

    mov ax, 2000h
    mov dx, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov si, kernel_welcome_message
    call print_str
    mov si, press_any_key_to_continue
    call print_str

    call wait_for_key
    call command_line

    jmp kernel_done

kernel_done:
    jmp $

kernel_welcome_message db 'Welcome to RedstoneOS DOS version!'
press_any_key_to_continue db 'To open the command line press any key. But don't be stupid and don't press the off key.'