; Graphics library by Itay Gruden
; https://github.com/itay-grudev/assembly-dos-gx

include libutil.asm

gx_x      dw ?
gx_y      dw ?
gx_x1     dw ?
gx_y1     dw ?
gx_x2     dw ?
gx_y2     dw ?
gx_dx     dw ?
gx_dy     dw ?
gx_m      dw ?
gx_color  db ?

; Sets the MS-DOS BIOS Video Mode
gx_set_video_mode macro mode
  mov al, mode
  mov ah, 0
  int 10h
endm

; Start Address of Video memory
GX_START_ADDR dw 0a000h

; Explicitly sets the MS-DOS BIOS Video Mode
; to 320x200 256 color graphics (MCGA,VGA)
; { Uses ES }
gx_set_video_mode_gx macro
  gx_set_video_mode 13h
  mov es, GX_START_ADDR
endm

; Explicitly sets the MS-DOS BIOS Video Mode
; to 80x25 Monochrome text (MDA,HERC,EGA,VGA)
gx_set_video_mode_txt macro
  gx_set_video_mode 03h
endm

; Sets a pixel using the BIOS int10h API { Uses AX, CX, DX }
gx_pixel_bios macro x, y, color
  mov ah, 0CH     ; set graphics pixel DOS function
  mov al, color   ; al stores the color
  mov cx, x       ; cx stores the x coordinate
  mov dx, y       ; dx stores the y coordinare
  int 10h         ; interrupt
endm

; Sets a pixel using Video Memory { Uses AX, BX, DI, Video Memory }
gx_pixel macro x, y, color
  mov ax, y
  mov bx, 320
  mul bx
  mov di, ax
  add di, x
  mov al, color
  mov es:[di], al
endm

; Draws a rectangle between (gx_x1;gx_y1) and (gx_x2;gx_y2) { Uses AX, BX, DI, Video Memory }
gx_rect:
  movv gx_y, gx_y1
gx_rect_v:
  movv gx_x, gx_x1
gx_rect_h:
  gx_pixel gx_x, gx_y, gx_color
  inc gx_x
  cmpv gx_x, gx_x2, ax
  jl gx_rect_h
  inc gx_y
  cmpv gx_y, gx_y2, ax
  jl gx_rect_v
  ret

; Okay, our own code starts here.
draw_rect macro top_left_x, top_left_y, bottom_right_x, bottom_right_y
    movv gx_x1, top_left_x
    movv gx_y1, top_left_y
    movv gx_x2, bottom_right_x
    movv gx_y2, bottom_right_y
    call gx_rect
endm
