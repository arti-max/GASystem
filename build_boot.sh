nasm -f bin boot/boot.asm -o boot.bin
qemu-system-i386 -fda boot.bin