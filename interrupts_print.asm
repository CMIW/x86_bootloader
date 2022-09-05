; By storing 0x07 in the AH register and sending interrupt code 0x10 to the
; Basic Input/Output System (BIOS), we can scroll the window down by a number of
; rows. We need to set AH to 0x07 and AL to 0x00. The value of register BH
; refers to the Basic Input/Output System (BIOS) color attribute. In this case
; the color attribute will be black background (0x0) behind light-gray (0x7)
; text, so we must set BH to 0x07. Registers CX and DX refer to the subsection
; of the screen that we want to clear. The standard number of character
; rows/cols here is 25/80, so we set CH and CL to 0x00 to set (0,0) as the top
; left of the screen to clear, and DH as 0x18 = 24, DL as 0x4f = 79.
clearscreen:
  ; standard calling convention between caller and callee
  push bp ; we save the caller's base pointer (4 bytes)
  mov bp, sp ; update the base pointer with the new stack pointer
  pusha ; push all general registers on the stack

  mov ah, 0x07  ; tells the (BIOS) to scroll down window
  mov al, 0x00  ; clear the entire window
  mov bh, 0x07  ; white on black
  mov cx, 0x00  ; specifies top left of screen as (0,0)
  mov dh, 0x18  ; 18h = 24 rows of chars
  mov dl, 0x4f  ; 4fh = 79 cols of chars
  int 0x10  ; calls video interrupt

  ; standard calling convention between caller and callee
  popa ; pop all general registers off the stack
  mov sp, bp  ; update the stack pointer with the base pointer
  pop bp  ; load the caller's base pointer (4 bytes)
  ret

; We must set register DX to a two byte value, the first representing the
; desired row, and second the desired column. AH gotta be 0x02. BH represents
; the page number we want to move the cursor to. The Basic Input/Output System
; (BIOS) allows you to draw to off-screen pages, in order to facilitate smoother
; visual transitions by rendering off-screen content before it is shown to the
; user. This is called double buffering. We'll just use the default page of 0.
movecursor:
  ; standard calling convention between caller and callee
  push bp ; we save the caller's base pointer (4 bytes)
  mov bp, sp ; update the base pointer with the new stack pointer
  pusha ; push all general registers on the stack

  ; This moves the argument we passed into the DX register. The reason we offset
  ; by 4 is that the contents of bp takes up 2 bytes on the stack, and the
  ; argument takes up 2 bytes, so we have to offset a total of 4 bytes from the
  ; actual address of bp.
  mov dx, [bp+4]  ; get the argument from the stack. |bp| = 2, |arg| = 2
  mov ah, 0x02  ; set cursor position
  mov bh, 0x00  ; page 0 because we're not using double-buffering
  int 0x10

  ; standard calling convention between caller and callee
  popa ; pop all general registers off the stack
  mov sp, bp  ; update the stack pointer with the base pointer
  pop bp  ; load the caller's base pointer (4 bytes)
  ret

print:
  ; standard calling convention between caller and callee
  push bp ; we save the caller's base pointer (4 bytes)
  mov bp, sp ; update the base pointer with the new stack pointer
  pusha ; push all general registers on the stack

  mov si, [bp+4] ; grab the pointer to the data
  mov bh, 0x00  ; page 0 because we're not using double-buffering
  mov bl, 0x00  ; foreground color, irrelevant - in text mode
  mov ah, 0x0E  ; print character to teletypewriter (TTY)

.char:
  mov al, [si]  ; get the current char from our pointer position
  add si, 1 ; keep incrementing si until we see a null char
  or al, 0
  je .return  ; end if the string is done
  int 0x10  ; print the character if we're not done
  jmp .char   ; keep looping

.return:
  ; standard calling convention between caller and callee
  popa ; pop all general registers off the stack
  mov sp, bp  ; update the stack pointer with the base pointer
  pop bp  ; load the caller's base pointer (4 bytes)
  ret
