.set MAGIC,    0x1BADB002

.set FLAGS,    0

.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot

.long MAGIC
.long FLAGS
.long CHECKSUM

stackBottom:

.skip 1024


# set the stack top which grows from higher to lower
stackTop:

.section .text
.global _start
.type _start, @function

.extern net_main
.type net_main, @function


_start:

	mov $stackTop, %esp

	call net_main

	cli


hltLoop:

	hlt
	jmp hltLoop

.size _start, . - _start