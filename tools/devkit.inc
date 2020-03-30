os_main equ 0000h

%DEFINE KEY_UP  72
%DEFINE KEY_DOWN    80
%DEFINE KEY_LEFT    75
%DEFINE KEY_RIGHT   77

%DEFINE KEY_ESC 27
%DEFINE KEY_ENTER

os_clear_screen		equ	0009h
os_print_string		equ	0003h
os_print_newline	equ	000Fh
os_file_selector	equ	005Ah
os_print_space		equ	006Ch
os_dump_string		equ	006Fh
os_print_digit		equ	0072h
os_print_1hex		equ	0075h
os_print_2hex		equ	0078h
os_print_4hex		equ	007Bh
os_wait_for_key		equ	0012h
os_check_for_key	equ	0015h
os_get_file_list	equ	0042h
os_load_file		equ	0021h
os_write_file		equ	0096h
os_file_exists		equ	0099h
os_create_file		equ	009Ch
os_remove_file		equ	009Fh
os_rename_file		equ	00A2h
os_get_file_size	equ	00A5h
os_speaker_tone		equ	001Bh
os_speaker_off		equ	001Eh
os_input_string		equ	0036h
os_string_tokenize	equ	00CFh
os_string_chomp		equ	0048h
os_string_length	equ	002Dh
os_string_uppercase	equ	0030h
os_string_copy		equ	0039h
os_string_compare	equ	0045h
os_string_parse		equ	00C3h
os_run_basic		equ	00C6h
os_pause		equ	0024h
os_fatal_error		equ	0027h