[bits 32]
; Define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

CR equ 0x0d    ; Carriage return
LF equ 0x0a    ; Line feed

; Function: set_cursor
;           set the hardware cursor position based on the
;           current column (cur_col) and current row (cur_row) coordinates
; See:      https://wiki.osdev.org/Text_Mode_Cursor#Moving_the_Cursor_2
;
; Inputs:   None
; Clobbers: EAX, ECX, EDX

set_cursor_pm:
  mov ecx, [cur_row]  ; EAX = cur_row
  imul ecx, [screen_width]  ; ECX = cur_row * screen_width
  add ecx, [cur_col]  ; ECX = cur_row * screen_width + cur_col

  ; Send low byte of cursor position to video card
  mov edx, 0x3d4
  mov al, 0x0f
  out dx, al                  ; Output 0x0f to 0x3d4
  inc edx
  mov al, cl
  out dx, al                  ; Output lower byte of cursor pos to 0x3d5

  ; Send high byte of cursor position to video card
  dec edx
  mov al, 0x0e
  out dx, al                  ; Output 0x0e to 0x3d4
  inc edx
  mov al, ch
  out dx, al                  ; Output higher byte of cursor pos to 0x3d5

  ret
