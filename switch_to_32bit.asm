[bits 16]
switch_to_32bit:
  ; We must switch off interrupts until we have setup the protected mode
  ; interrupt vector otherwise interrupts will run riot.
  cli                     ; 1. disable interrupts

  ; Load our global descriptor table , which defines the protected mode segments
  lgdt [gdt_descriptor]   ; 2. load GDT descriptor

  ; To make the switch to protected mode, we set the first bit of CR0,
  ; a control register
  mov eax, cr0
  or eax, 0x1             ; 3. enable protected mode
  mov cr0, eax

  ; Make a far jump ( i.e. to a new segment ) to our 32 - bit code. This also
  ; forces the CPU to flush its cache of pre-fetched and real-mode decoded
  ; instructions, which can cause problems.
  jmp CODE_SEG:init_32bit ; 4. far jump

[bits 32]
; Initialise registers and the stack once in PM.
init_32bit:
  ; Now in Protected Mode, our old segments are meaningless,so we point our
  ; segment registers to the data selector we defined in our
  ; Global Descriptor Table (GDT)
  mov ax, DATA_SEG        ; 5. update segment registers
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  ; Update our stack position so it is right at the top of the free space.
  mov ebp, 0x90000        ; 6. setup stack
  mov esp, ebp

  ; Finally , call some well - known label
  call BEGIN_32BIT        ; 7. move back to mbr.asm
