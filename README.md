# Writing an x86 bootloader

### Index
1. [Boot Process](#boot-process)
2. [Boot Sector](#boot-sector)
0. [Useful links](#useful-links)

### Getting Started
`apt-get install nasm qemu qemu-kvm`

### Build
`nasm -f bin boot.asm -o boot.bin`

### Run
`qemu-system-x86_64 -fda boot.bin`


## Boot Process
To boot on an x86 machine, the Basic Input/Output System (BIOS) must read specific sectors of data (usually 512 bytes in size), select a boot device, copy the first sector from the device into physical memory, at the memory address 0x7C00, then instructs the CPU to jump to the beginning of the boot loader code, memory address 0x7C00, passing control to the boot loader.

These 512 bytes contain the boot loader code, a partition table, the disk signature, and the appropriate boot signature 0xAA55 (the famous "magic number") that is checked to avoid accidentally loading something that is not supposed to be a boot sector.

## Boot Sector
The code for the boot sector is on [boot.asm](/boot.asm)

## Useful links
* [Writing a Tiny x86 Bootloader](https://www.joe-bergeron.com/posts/Writing%20a%20Tiny%20x86%20Bootloader/)

* [OS Dev - Writing a simple operating system from scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

* [Writing My Own Boot Loader](https://dev.to/frosnerd/writing-my-own-boot-loader-3mld)

* [os-tutorial](https://github.com/cfenollosa/os-tutorial)

* [Writing a Simple Operating System from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)
