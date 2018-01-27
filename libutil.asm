; Graphics library by Itay Gruden
; https://github.com/itay-grudev/assembly-dos-gx

; Move data from a variable into another variable
movv macro to, from
  push from
  pop to
endm

mov_byte_vars macro to, from
    save_registers

    mov dl, from
    mov to, dl

    restore_registers
endm


; Compare two memory variables
cmpv macro var1, var2, register
  mov register, var1
  cmp register, var2
endm

; Add two memory variables
addv macro to, from, register
  mov register, to
  add register, from
  mov to, register
endm

; Subtract two memory variables
subv macro to, from, register
  mov register, to
  sub register, from
  mov to, register
endm

; Return Control to DOS
return macro code
  mov ah, 4ch
  mov al, code
  int 21h
endm

; Save registers to stack
save_registers macro
  push ax
  push bx
  push cx
  push dx
endm

; Restore registers from stack
restore_registers macro
  pop dx
  pop cx
  pop bx
  pop ax
endm

; Checks for a keypress; Sets ZF if no keypress is available
; Otherwise returns it's scan code into AH and it's ASCII into al
; Removes the charecter from the Type Ahead Buffer { USING AX }
check_keypress:
  mov ah, 1     ; Checks if there is a character in the type ahead buffer
  int 16h       ; MS-DOS BIOS Keyboard Services Interrupt
  jz check_keypress_empty
  mov ah, 0
  int 16h
  ret
check_keypress_empty:
  cmp ax, ax    ; Explicitly sets the ZF
  ret
