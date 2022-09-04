# Writing an x86 bootloader

## Getting Started
`apt-get install nasm qemu qemu-kvm`

## Build
`nasm -f bin boot.asm -o boot.bin`

## Run
`qemu-system-x86_64 -fds boot.bin`

## Useful links
* [Writing a Tiny x86 Bootloader](https://www.joe-bergeron.com/posts/Writing%20a%20Tiny%20x86%20Bootloader/)

* [Writing a Bootloader Part 2](http://3zanders.co.uk/2017/10/16/writing-a-bootloader2/)

* [OS Dev - Writing a simple operating system from scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)
