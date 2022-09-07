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

; Setup Stack
; On x86 architectures, the stack pointer (sp) decreases. We must set the
; initial stack pointer (sp) to a number of bytes past the stack segment equal
; to the desired size of the stack. We will place the bottom of the stack in
; 0x9000 to make sure we are far away enough from our other boot loader related
; memory to avoid collisions.
mov sp, 0x9000
mov sp, bp

; Prepare to print the message by clearing the screen.
call clearscreen

; Prepare to print the message by moving the cursor to position (0,0)
push 0x0000
call movecursor

; Print on the screen the message "16bit Real Mode"
push msg_16b
call print

; Tell the processor not to accept interrupts and to halt processing.
cli
hlt

; All the needed instruction to print to the screen on 16bits Real Mode
; are on this file
%include "interrupts_print.asm"

; Define some data and store a pointer to its starting address. The 0 at the end
; terminates the string with a null character, so we'll know when the string is
; done. We can reference the address of this string with msg.
msg_16b:
db "16bit Real Mode", 0

; The code in a bootsector has to be exactly 512 bytes, ending in 0xAA55.
; pad the binary to a length of 510 bytes, and make sure the file ends with the
; appropriate boot signature.
times 510-($-$$) db 0
dw 0xAA55
