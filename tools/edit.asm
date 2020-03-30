bits 16
%include "devkit.inc"
ORG 32768

_start:
    call setup_screen

    cmp si, 0
    je .no_param_passed

    call os_string_tokenize

    mov di, filename
    call os_string_copy

    mov ax, si
    mov cx, 36864
    call os_load_file
    jnc file_load_success

    mov ax, file_load_fail_str
    mov bx, 0
    mov cx, 0
    mov dx, 0
    
    call os_clear_screen
    ret

.no_param_passed:
    call os_file_selector
    jnc near file_chosen

    call os_clear_screen

    ret

file_chosen:
    mov si, ax
	mov di, filename
	call os_string_copy


	mov di, ax
	call os_string_length
	add di, ax

	dec di
	dec di
	dec di

	mov si, txt_extension
	mov cx, 3
	rep cmpsb
	je valid_extension

	dec di

	mov si, bas_extension
	mov cx, 3
	rep cmpsb
	je valid_extension

	mov dx, 0
	mov ax, wrong_ext_msg
	mov bx, 0
	mov cx, 0
	call os_dialog_box

	mov si, 0
	jmp start