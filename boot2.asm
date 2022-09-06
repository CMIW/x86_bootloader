bits 16

org 0x7c00

boot:
  ; We call the A20-Gate activate function to enable A20 line to access more than
  ; 1MB of memory.
	mov ax, 0x2401
	int 0x15  ; enable A20 bit
  ; Set the VGA text mode to a known value to be safe.
	mov ax, 0x3
	int 0x10  ; set vga text mode 3
	cli
  ; Enable 32 bit instructions and access to the full bit 32 registers by
  ; entering Protected Mode. Set up a Global Descriptor Table which will define
  ; a 32 bit code segment, load it with the lgdt instruction then do a long
  ; jump to that code segment.
	lgdt [gdt_pointer] ;load the Global Descriptor Table
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:boot2 ; long jump to the code segment

gdt_start:
	dq 0x0

gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:

gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32

boot2:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

  mov esi,hello
	mov ebx,0xb8000

.loop:
	lodsb
	or al,al
	jz halt
	or eax,0x0100
	mov word [ebx], ax
	add ebx,2
	jmp .loop

halt:
	cli
	hlt

hello: db "Hello world!",0

times 510 - ($-$$) db 0
dw 0xaa55
