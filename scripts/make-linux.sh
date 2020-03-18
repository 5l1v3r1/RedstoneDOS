cd ../src/kernel/bootloader/ && nasm -O0 -w+orphan-labels -f bin bootloader.bin bootloader.asm
cd ../src/kernel/ && nasm -O0 -w+orphan-labels -f bin RDOS.bin kernel.asm