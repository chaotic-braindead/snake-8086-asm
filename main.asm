.model small
.stack 100h

.data
    head_x dw 0Ah
    head_y dw 0Ah 
    head_size dw 04h 
    
    time_now db 00h

.code
    mov ax, @data
    mov ds, ax 
    main:
        mov ax, 0013h
        int 10h
        
        mov ah, 0Bh
        mov bx, 0000h
        int 10h
        
        game_loop:
            call draw
            call timer
            jmp game_loop
        
        ret
        ;mov ah, 4ch
        ;int 21h
    
    draw:
        mov cx, head_x
        mov dx, head_y
        
        draw_head:
            mov ah, 0ch
            mov al, 0fh
            mov bh, 00h
            int 10h             ; draw pixel

            inc cx              
            mov ax, cx
            sub ax, head_x 
            cmp ax, head_size
            jle draw_head       ; check x axis

            mov cx, head_x
            inc dx 

            mov ax, dx
            sub ax, head_y
            cmp ax, head_size 
            jle draw_head       ; check y axis
        ret 
    
    timer:
        mov ah, 2ch ; get system time
        int 21h
        cmp dh, time_now
        je timer 
        mov ax, head_size
        add head_x, ax
        mov time_now, dh
        ret
    ;* do actions here *
    ;* ex.
    ; mov ax, snake_velocity 
    ; add snake_x, ah
    ; add snake_y, al
    
end