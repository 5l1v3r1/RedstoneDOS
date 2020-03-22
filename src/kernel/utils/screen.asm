%ifndef SCREEN_ASM
    %define SCREEN_ASM

clear_screen:
    pusha

    mov ah, 6
    mov al, 0
    mov bh, 7
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 10h

    popa
    ret

print_ln:
    pusha

    mov ah, 0Eh

    mov al, 13
    int 10h

    mov al, 10
    int 10h

    popa
    ret


print_int:
    pusha

    cmp ax, 9
    jle .digit_format

    add ax, 'A'-'9'-1

.digit_format:
    add ax, '0'

    mov ah, 0Eh
    int 10h

    popa
    ret

%endif