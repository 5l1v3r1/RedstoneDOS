@echo off

cd ../
mkdir disk_images
cd scripts/

echo RedstoneDOS Buld Script (WINDOWS)

echo Assembling bootloader...
nasm -O0 -f bin -o bootloader.bin ../src/kernel/bootloader/bootloader.asm

echo Assembling kernel...
nasm -O0 -f bin -o RDOS.bin ../src/kernel/kernel.asm

echo Adding bootsector to disk image...
imdisk -a -f disk_images\RedstoneDOS.flp -s 1440K -m b:

echo Copying kernel and applications to disk image...
copy RDOS.bin b:\

echo Dismounting disk image...
imdisk -D -m B:

echo Done!

PAUSE