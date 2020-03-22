#!/bin/sh

# This script assembles the MikeOS bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on Linux)

# Only the root user can mount the floppy disk image as a virtual
# drive (loopback mounting), in order to copy across the files

# (If you need to blank the floppy image: 'mkdosfs disk_images/mikeos.flp')


if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi

mkdir disk_images/

if [ ! -e disk_images/RedstoneDOS.flp ]
then
	echo ">>> Creating new RedstoneDOS floppy image..."
	mkdosfs -C disk_images/RedstoneDOS.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o bootloader.bin ../src/kernel/bootloader/bootloader.asm || exit


echo ">>> Assembling RedstoneDOS kernel..."

nasm -O0 -w+orphan-labels -f bin -o RDOS.bin ../src/kernel/kernel.asm || exit



echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=bootloader.bin of=disk_images/RedstoneDOS.flp || exit


echo ">>> Copying RedstoneDOS kernel and programs..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat disk_images/RedstoneDOS.flp tmp-loop && cp RDOS.bin tmp-loop/

sleep 0.2

echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop


echo ">>> Creating CD-ROM ISO image..."

rm -f disk_images/RedstoneDOS.iso
mkisofs -quiet -V 'REDSTONEDOS' -input-charset iso8859-1 -o disk_images/RedstoneDOS.iso -b RedstoneDOS.flp disk_images/ || exit

echo '>>> Done!'