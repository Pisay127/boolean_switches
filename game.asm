.model small
.code
.386
.stack 128

include libgfx.asm

org 100h

; first_input refers to the first input for the switch
first_input_x  dw ?
first_input_y  dw ?
first_input_x1 dw ?
first_input_y1 dw ?

; second_input refers to the first input for the switch
second_input_x  dw ?
second_input_y  dw ?
second_input_x1 dw ?
second_input_y1 dw ?
xd dw ?
yd dw ?
cd db ?
ccd db ?

start:
	gx_set_video_mode_gx

	; Initialize program
	mov first_input_x, 25	; CENTER AT 150
	mov first_input_y, 25	; CENTER AR 90
    mov first_input_x1, 75
    mov first_input_y1, 75
    mov second_input_x, 25
    mov second_input_y, 100
    mov second_input_x1, 75
    mov second_input_y1, 150
	mov xd, 1 ; Initial X direction is negative
	mov yd, 0 ; Initial Y direction is positive
	mov gx_color, 18

mainloop:
	; Check if ESCAPE key is pressed
	call check_keypress
	jz draw 	; No keypress available
	cmp al, 27 	; Check if ASCII code of key is 27 (ESC)
	je exit		; If so exit the program

draw:
	; Clear the previous Square (Totally different effect without it :D)
	;mov dh, gx_color ; Tempoary storing the original color
	;push dx
	;mov gx_color, 16
    ; Draw the first input
    movv gx_x1, first_input_x
    movv gx_y1, first_input_y
    movv gx_x2, first_input_x1
    movv gx_y2, first_input_y1
    call gx_rect

    ; Draw the second input
    movv gx_x1, second_input_x
    movv gx_y1, second_input_y
    movv gx_x2, second_input_x1
    movv gx_y2, second_input_y1
    call gx_rect

    jmp mainloop

exit:
	gx_set_video_mode_txt
	return 0

end start
