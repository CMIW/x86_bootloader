# Writing an x86 bootloader

## Getting Started
`apt-get install nasm qemu qemu-kvm`

## Build
`nasm -f bin boot.asm -o boot.bin`

## Run
`qemu-system-x86_64 -fda boot.bin`

## Useful links
* [Writing a Tiny x86 Bootloader](https://www.joe-bergeron.com/posts/Writing%20a%20Tiny%20x86%20Bootloader/)

* [OS Dev - Writing a simple operating system from scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

* [Writing My Own Boot Loader](https://dev.to/frosnerd/writing-my-own-boot-loader-3mld)

* [os-tutorial](https://github.com/cfenollosa/os-tutorial)

* [Writing a Simple Operating System from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)
