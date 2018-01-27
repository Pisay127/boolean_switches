.model small
.code
.386
.stack 128

include libgfx.asm
include libmouse.asm

org 100h

; Switch text flag
andor_text_flag db ?

; first_input refers to the first input for the switch
first_input_x  dw ?
first_input_y  dw ?
first_input_x1 dw ?
first_input_y1 dw ?
first_input_color db ?

; first not_input refers to the first not switch
first_not_input_x  dw ?
first_not_input_y  dw ?
first_not_input_x1 dw ?
first_not_input_y1 dw ?
first_not_input_color db ?

; second_input refers to the second input for the switch
second_not_input_x  dw ?
second_not_input_y  dw ?
second_not_input_x1 dw ?
second_not_input_y1 dw ?
second_not_input_color db ?

; second_not_input refers to the second not switch
second_input_x  dw ?
second_input_y  dw ?
second_input_x1 dw ?
second_input_y1 dw ?
second_input_color db ?

; The output block
output_x dw ?
output_y dw ?
output_x1 dw ?
output_y1 dw ?
output_color db ?

; andor refers to the main and or switch
andor_x dw ?
andor_y dw ?
andor_x1 dw ?
andor_y1 dw ?
andor_color db ?

; Screen clear coordinates
origin_x    dw ?
origin_y    dw ?
origin_x1   dw ?
origin_y1   dw ?

start:
	gx_set_video_mode_gx
    call init_mouse

	; Initialize program
    mov andor_text_flag, 0
    mov first_input_x, 24
	mov first_input_y, 24
    mov first_input_x1, 74
    mov first_input_y1, 74
    mov first_not_input_x, 86
	mov first_not_input_y, 36
    mov first_not_input_x1, 111
    mov first_not_input_y1, 61
    mov second_input_x, 24
    mov second_input_y, 99
    mov second_input_x1, 74
    mov second_input_y1, 149
    mov second_not_input_x, 86
    mov second_not_input_y, 111
    mov second_not_input_x1, 111
    mov second_not_input_y1, 136
    mov andor_x, 135
    mov andor_y, 61
    mov andor_x1, 185
    mov andor_y1, 111
    mov output_x, 210
    mov output_y, 61
    mov output_x1, 260
    mov output_y1, 111
    mov origin_x, 0
    mov origin_y, 0
    mov origin_x1, 319
    mov origin_y1, 239
	mov first_input_color, 18
    mov first_not_input_color, 1
    mov second_input_color, 18
    mov second_not_input_color, 1
    mov andor_color, 4
    mov output_color, 18

mainloop:
	; Check if ESCAPE key is pressed
    call check_keypress
	jz check_mouse_input 	; No keypress available
	cmp al, 27 	; Check if ASCII code of key is 27 (ESC)
	je exit		; If so exit the program
    jne handle_keypresses

handle_keypresses:
    cmp al, 49 ; '1'
    je handle_AND_switch
    cmp al, 50 ; '2'
    je handle_OR_switch
    cmp al, 51 ; '3'
    je handle_first_not_color_switch
    cmp al, 52 ; '4'
    je handle_second_not_color_switch
    jne check_mouse_input

    handle_AND_switch:
        mov andor_text_flag, 0
        jmp check_mouse_input

    handle_OR_switch:
        mov andor_text_flag, 1
        jmp check_mouse_input

    handle_first_not_color_switch:
        cmp first_not_input_color, 1
        je set_first_not_input_on
        jne set_first_not_input_off

        set_first_not_input_on:
            mov first_not_input_color, 14
            jmp check_mouse_input

        set_first_not_input_off:
            mov first_not_input_color, 1
            jmp check_mouse_input

    handle_second_not_color_switch:
        cmp second_not_input_color, 1
        je set_second_not_input_on
        jne set_second_not_input_off

        set_second_not_input_on:
            mov second_not_input_color, 14
            jmp check_mouse_input

        set_second_not_input_off:
            mov second_not_input_color, 1
            jmp check_mouse_input

check_mouse_input:
    call get_mouse_button_press
    test bl, 1
    jnz handle_left_click
    test bl, 2
    jnz handle_right_click

    change_input_color_return:

    jmp draw

draw:
    ; Draw "wires"
    mov gx_color, 42
    ; Draw first input "wire"
    draw_rect 24, 48, 161, 50
    ; Draw second input "wire"
    draw_rect 24, 123, 161, 125
    ; Draw "wire" through the AND/OR switch
    draw_rect 159, 48, 161, 125
    ; Draw "wire" from the AND/OR switch to the OUTPUT
    draw_rect 159, 85, 260, 87

    ; Draw the first input
    mov_byte_vars gx_color, first_input_color
    draw_rect first_input_x, first_input_y, first_input_x1, first_input_y1

    ; Draw the first not input
    mov_byte_vars gx_color, first_not_input_color
    draw_rect first_not_input_x, first_not_input_y, first_not_input_x1, first_not_input_y1

    ; Draw the second input
    mov_byte_vars gx_color, second_input_color
    draw_rect second_input_x, second_input_y, second_input_x1, second_input_y1

    ; Draw the second not input
    mov_byte_vars gx_color, second_not_input_color
    draw_rect second_not_input_x, second_not_input_y, second_not_input_x1, second_not_input_y1

    ; Draw the andor switch
    mov_byte_vars gx_color, andor_color
    draw_rect andor_x, andor_y, andor_x1, andor_y1

    mov_byte_vars gx_color, output_color
    draw_rect output_x, output_y, output_x1, output_y1

    ; Draw letter
    mov gx_color, 15
    ; Draw first vertical line
    draw_rect 147, 73, 149, 98
    ; Draw second vertical line
    draw_rect 172, 73, 174, 98
    ; Draw first horizontal line
    draw_rect 147, 73, 172, 75

    cmp andor_text_flag, 0
    je draw_A
    jne draw_B ; We can just move to b since there are only two ops (AND, OR)

    draw_A:
        ; Draw second horizontal line
        draw_rect 147, 84, 172, 86

        jmp draw_return_point
    draw_B:
        ; Draw second horizontal line
        draw_rect 147, 96, 172, 98

        jmp draw_return_point

    draw_return_point:

    jmp mainloop

clear_screen:
    ; Clear screen
    mov gx_color, 16
    draw_rect origin_x, origin_y, origin_x1, origin_y1
    ret

exit:
	gx_set_video_mode_txt
	return 0

handle_left_click:
    suck_up_left_clicks:
        call get_mouse_button_press
        or bx, bx
        jnz suck_up_left_clicks

    cmp first_input_color, 18 ; Check if it's in the original colour
    je  set_first_input_on
    jne set_first_input_off

    set_first_input_on:
        mov first_input_color, 14
        jmp change_input_color_return

    set_first_input_off:
        mov first_input_color, 18
        jmp change_input_color_return

handle_right_click:
    suck_up_right_clicks:
        call get_mouse_button_press
        or bx, bx
        jnz suck_up_right_clicks

    cmp second_input_color, 18 ; Check if it's in the original colour
    je  set_second_input_on
    jne set_second_input_off

    set_second_input_on:
        mov second_input_color, 14
        jmp change_input_color_return

    set_second_input_off:
        mov second_input_color, 18
        jmp change_input_color_return

end start
