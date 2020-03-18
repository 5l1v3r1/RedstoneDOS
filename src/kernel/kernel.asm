bits 16

%define DOS_VER '1.0'

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

kernel_done:
    jmp $