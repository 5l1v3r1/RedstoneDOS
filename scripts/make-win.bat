cd ../
cd src/
dir
cd kernel
dir
nasm -O0 -f bin -o RDOS.bin kernel.asm
dir
cd bootloader
dir
nasm -O0 -f bin -o bootloader.bin bootloader.asm
cd ../../../
PAUSE