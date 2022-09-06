disk_load:
  ; standard calling convention between caller and callee
  push bp ; we save the caller's base pointer (4 bytes)
  mov bp, sp ; update the base pointer with the new stack pointer
  pusha ; push all general registers on the stack
  push dx

  mov ah, 0x02  ; read mode
  mov al, dh  ; read dh number of sectors
  mov cl, 0x02  ; start from sector 2 as sector 1 is our boot sector
  mov ch, 0x00  ; cylinder 0
  mov dh, 0x00  ; head 0

  int 0x13  ; Basic Input/Output System (BIOS) interrupt
  jc disk_error ; check carry bit for disk_error

  pop dx  ; get back original number of sectors to read
  ; Basic Input/Output System (BIOS) sets 'al' to the number of sectors to
  ; actually read, compare it to 'dh' and error out if they are !=
  cmp al, dh
  jne sectors_error

  ; standard calling convention between caller and callee
  popa ; pop all general registers off the stack
  mov sp, bp  ; update the stack pointer with the base pointer
  pop bp  ; load the caller's base pointer (4 bytes)
  ret

disk_error:
  ; Prepare to print the message by clearing the screen.
  call clearscreen

  ; Prepare to print the message by moving the cursor to position (0,0)
  push 0x0000
  call movecursor
  add sp, 2

  push msg_disk_error
  call print
  add sp, 2

  jmp disk_loop

sectors_error:
  ; Prepare to print the message by clearing the screen.
  call clearscreen

  ; Prepare to print the message by moving the cursor to position (0,0)
  push 0x0000
  call movecursor
  add sp, 2

  push msg_sectors_error
  call print
  add sp, 2

  jmp disk_loop

disk_loop:
  jmp $

msg_disk_error:
  db "Disk Error", 0

msg_sectors_error:
  db "Sectors Error", 0
