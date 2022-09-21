; Global Descriptor Table (GDT)
gdt_start:

; null segment descriptor
gdt_null:
  dd 0x0  ; ’ dd ’ means define double word ( i.e. 4 bytes )
  dd 0x0

; code segment descriptor
; base =0 x0 , limit =0 xfffff
; 1 st flags : (present)1 (privilege)00 (descriptor type)1 -> 1001 b
; type flags : (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010 b
; 2 nd flags : (granularity)1 (32 - bit default)1 (64 - bit seg)0 (AVL)0 -> 1100 b
gdt_code:
  dw 0xffff    ; segment length, bits 0-15
  dw 0x0       ; segment base, bits 0-15
  db 0x0       ; segment base, bits 16-23
  db 10011010b ; 1st flags, type flags (8 bits)
  db 11001111b ; 2nd flags, 4 bits + segment length, bits 16-19
  db 0x0       ; segment base, bits 24-31

; data segment descriptor
; base =0 x0 , limit =0 xfffff
; 1 st flags : (present)1 (privilege)00 (descriptor type)1 -> 1001 b
; type flags : (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010 b
; 2 nd flags : (granularity)1 (32 - bit default)1 (64 - bit seg)0 (AVL)0 -> 1100 b
gdt_data:
  dw 0xffff    ; segment length, bits 0-15
  dw 0x0       ; segment base, bits 0-15
  db 0x0       ; segment base, bits 16-23
  db 10010010b ; 1st flags , type flags (8 bits)
  db 11001111b ; 2nd flags, 4 bits + segment length, bits 16-19
  db 0x0       ; segment base, bits 24-31

; The reason for putting a label at the end of the GDT is so we can have the
; assembler calculate the size of the GDT for the GDT decriptor (below)
gdt_end:

; GDT descriptor
gdt_descriptor:
  ; Size of our GDT, always one less than the true size
  dw gdt_end - gdt_start - 1 ; size (16 bit)
  dd gdt_start ; start address of our GDT (32 bit)

; Define some handy constants for the Global Descriptor Table (GDT) segment
; descriptor offsets, which are what segment registers must contain when in
; protected mode. For example, when we set Data Segment = 0x10 in Protected Mode
; the CPU knows that we mean it to use the segment described at offset 0x10 (i.e
; . 16 bytes) in our Global Descriptor Table (GDT), which in our case is the
; data segment (0x0 -> Null; 0x08 -> Code; 0x10 -> Data)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
