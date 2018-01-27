; Mouse coordinates
mouse_x dw ?
mouse_y dw ?

init_mouse:
    mov ax, 00h
    int 33h

    mov ax, 01h
    int 33h

    ret

get_mouse_button_press:
    mov ax, 03h ; Mode for reading mouse motion counters
    int 33h
    mov mouse_x, cx
    mov mouse_y, dx

    ret
