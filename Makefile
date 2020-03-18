.PHONY: kernel bootloader

main:
	@echo "Please, Select a target: Bootloader or kernel"

bootloader:
	nasm -O0 -f bin -o bootloader.bin src/kernel/bootloader/bootloader.asm

kernel:
	nasm -O0 -f bin -o RDOS.bin src/kernel/kernel.asm