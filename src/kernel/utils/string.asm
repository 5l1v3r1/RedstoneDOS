print_str:
    mov ah, 0Eh

.repeat:
    lodsb
    cmp al, 0
    je .done
    int 10h
    jmp .repeat

.done:
    ret

    times 510-($-$$) db 0
    dw 0xAA55