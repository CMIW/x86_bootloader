bits 16 ; Tells the assembler that we're working in 16-bit real mode.
; x86 processors have a number of segment registers, which are used to store the
; beginning of a 64k segment of memory. In real mode, memory is addressed using
; a logical address, rather than the physical address. The logical address of a
; piece of memory consists of the 64k segment it resides in, as well as its off-
; set from the beginning of that segment. The 64k segment of a logical address
; should be divided by 16, so, given a logical address beginning at 64k segment
; A, with offset B, the reconstructed physical address would be A*0x10 + B.

; The processor has a resgister for the data segment (ds). Since our code
; resides at 0x0700, we set the data segment (ds) to that address. We have to
; load the segment into another register because we can't set it directly in the
; segment register. The [org 0x7c00] directive sets the assembler location
; counter and all the above.
[org 0x7c00]

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

; Setup Stack
; On x86 architectures, the stack pointer (sp) decreases. We must set the
; initial stack pointer (sp) to a number of bytes past the stack segment equal
; to the desired size of the stack. We will place the bottom of the stack in
; 0x9000 to make sure we are far away enough from our other boot loader related
; memory to avoid collisions.
mov bp, 0x9000
mov sp, bp

; Prepare to print the message by clearing the screen.
;call clearscreen

; When the BIOS prints characters it updates the current row and column in the
; BIOS Data Area (BDA). When in protected mode you can read the byte in memory
; location 0x450 for the column and 0x451 for the row. You can use this
; information to continue where the BIOS left off.
mov al, [0x450]             ; Byte at address 0x450 = last BIOS column position
mov [cur_col], ax          ; Copy to current column
mov al, [0x451]             ; Byte at address 0x451 = last BIOS row position
mov [cur_row], ax
call movecursor

; Print on the screen the message "16bit Real Mode"
push msg_16b
call print

call load_kernel
call switch_to_32bit

; Learn how to print on 32 bit mode


; Tell the processor not to accept interrupts and to halt processing.
cli
hlt

; All the needed instruction to print to the screen on 16bits Real Mode
; are on this file
%include "interrupts_print.asm"

%include "disk.asm"
%include "switch_to_32bit.asm"
%include "global_descriptor_table.asm"
%include "print.asm"

[bits 16]
load_kernel:
  mov bx, KERNEL_OFFSET ; bx -> destination
  mov dh, 2             ; dh -> num sectors
  mov dl, [BOOT_DRIVE]  ; dl -> disk
  call disk_load
  ret

[bits 32]
BEGIN_32BIT:
  xor eax, eax
  mov al, [0x450]             ; Byte at address 0x450 = last BIOS column position
  mov [cur_col], eax          ; Copy to current column
  mov al, [0x451]             ; Byte at address 0x451 = last BIOS row position
  mov [cur_row], eax

  mov ax, [0x44a]
  mov [screen_width], eax

  mov eax, 1
  add [cur_row], eax
  mov eax, 0
  mov [cur_col], eax

  call set_cursor

  call KERNEL_OFFSET ; give control to the kernel
  jmp $ ; loop in case kernel returns

; boot drive variable
BOOT_DRIVE db 0

cur_row:      dd 0x00
cur_col:      dd 0x00
screen_width: dd 0x00

; Define some data and store a pointer to its starting address. The 0 at the end
; terminates the string with a null character, so we'll know when the string is
; done. We can reference the address of this string with msg.
msg_16b:
db "16bit Real Mode", 0

msg_32b:
db "32bit Protected Mode", 0

; The code in a bootsector has to be exactly 512 bytes, ending in 0xAA55.
; pad the binary to a length of 510 bytes, and make sure the file ends with the
; appropriate boot signature.
times 510-($-$$) db 0
dw 0xAA55
