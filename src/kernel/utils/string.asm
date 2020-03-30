%include "utils/keyboard.asm"

%ifndef STRING_ASM
    %define STRING_ASM

; ------------------------------------------
print_str:
    pusha

    mov ah, 0Eh

.repeat:
    lodsb
    cmp al, 0
    je .done

    int 10h
    jmp .repeat

.done:
    popa

    ret

; ------------------------------------------
input_string:
    pusha

    mov di, ax
    mov cx, 0

.more:
    call wait_for_key

    cmp al, 13
    je .done

    cmp al, 8
    je .backspace

    cmp al, '  '
    jb .more

    cmp al, '~'
    ja .more

    jmp .nobackspace

.backspace:
    cmp cx, 0
    je .more

    pusha
    mov ah, 0Eh
    mov al, 8
    int 10h
    mov al, 32
    int 10h
    mov al, 8
    int 10h
    popa

    dec di
    dec cx

    jmp .more

.nobackspace:
    pusha
    mov ah, 0Eh
    int 10h

    popa
    
    stosb
    inc cx
    cmp cx, 254
    jae near .done

    jmp near .more

.done:
    mov ax, 0
    stosb

    popa
    ret
; ------------------------------------------
string_tokenize:
    push si

.next_char:
    cmp byte [si], al
    je .return_token
    cmp byte [si], 0
    jz .no_more
    inc si
    jmp .next_char

.return_token:
    mov byte [si], 0
    inc si
    mov di, si
    pop si
    ret

.no_more:
    mov di, 0
    pop si
    ret

; ------------------------------------------
string_chomp:
    pusha

    mov dx, ax

    mov di, ax
    mov cx, 0

.keepcounting:
    cmp byte [di], ' '
    jne .counted
    inc cx
    inc di
    jmp .keepcounting

.counted:
    cmp cx, 0
    je .finished_copy

    mov si, di
    mov di, dx

.keep_copying:
    mov al, [si]
    mov [di], al
    cmp al, 0
    je .finished_copy
    inc si
    inc di
    jmp .keep_copying

.finished_copy:
    mov ax, dx

    call strlen
    cmp ax, 0
    je .done

    mov si, dx
    add si, ax

.more:
    dec si
    cmp byte [si], ' '
    jne .done
    mov byte [si], 0
    jmp .more

.done:
    popa
    ret
; ------------------------------------------
strlen:
    pusha

    mov bx, ax

    mov cx, 0

.more:
    cmp byte [bx], 0
    je .done
    inc bx
    inc cx
    jmp .more

.done:
    mov word[.tmp_counter], cx
    popa

    mov ax, [.tmp_counter]
    ret

    .tmp_counter dw 0
; ------------------------------------------
string_copy:
    pusha

.more:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    cmp byte al, 0
    jne .more

.done:
    popa
    ret
; ------------------------------------------
string_uppercase:
    pusha

    mov si, ax

.more:
    cmp byte [si], 0
    je .done

    cmp byte [si], 'a'
    jb .noatoz
    cmp byte [si], 'z'
    ja .noatoz

    sub byte [si], 20h

    inc si
    jmp .more

.noatoz:
    inc si
    jmp .more

.done:
    popa
    ret
; ------------------------------------------
str_compare:
    pusha

.more:
    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne .not_same

    cmp al, 0
    je .terminated

    inc si
    inc di
    jmp .more

.not_same:
    popa
    clc
    ret

.terminated:
    popa
    stc
    ret
; ------------------------------------------
string_parse:
    push si

    mov ax, si

    mov bx, 0
    mov cx, 0
    mov dx, 0

    push ax

.loop1:
	lodsb
	cmp al, 0
	je .finish
	cmp al, ' '
	jne .loop1
	dec si
	mov byte [si], 0

	inc si
	mov bx, si

.loop2:
	lodsb
	cmp al, 0
	je .finish
	cmp al, ' '
	jne .loop2
	dec si
	mov byte [si], 0

	inc si
	mov cx, si

.loop3:
	lodsb
	cmp al, 0
	je .finish
	cmp al, ' '
	jne .loop3
	dec si
	mov byte [si], 0

	inc si
	mov dx, si

.finish:
	pop ax

	pop si
	ret
; ------------------------------------------
string_length:
    pusha

    mov bx, ax

    mov cx, 0

.more:
    cmp byte [bx], 0
    je .done
    inc bx
    inc cx
    jmp .more

.done:
    mov word [.tmp_counter], cx
    popa

    mov ax, [.tmp_counter]
    ret

    .tmp_counter dw 0
; ------------------------------------------
string_compare:
    pusha

.more:
    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne .not_same

    cmp al, 0
    je .terminated

    inc si
    inc di

    jmp .more

.not_same:
    popa

    clc

    ret

.terminated:
    popa
    stc
    ret
; ------------------------------------------

%endif