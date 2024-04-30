.model small
.stack 100h
.data
    snake_pos dw 255 dup (?) ; higher byte = x coord | lower byte = y coord
    snake_length dw 2
    key_pressed db 'd'
    prev_key db ?
    time_now db 00h
    food_pos dw 0A0Ah
    temp_pos dw ?

   
    strScore db 'Score:'
    strScore_s equ $-strScore
  
.code
    mov ax, @data
    mov ds, ax 
    main:
        mov ax, 0013h
        int 10h
        mov ah, 0Bh
        mov bx, 0000h
        int 10h
        lea si, snake_pos ;;
        mov word ptr [si], 0A0Ah ;;   
        mov word ptr [si+2], 090Ah ;;   
        mov word ptr [si+4], 080Ah ;;   


        ;call rng
        game_loop:
            call write_score
            call input
            call draw
            call move
            call cls
            jmp game_loop

            ; should never reach this
            mov ah, 4ch
            int 21h

    cls: ; clears the screen
        mov ah, 07h          ; scroll down function
        mov al, 0            ; number of lines to scroll
        mov cx, 0
        mov dx, 9090
        mov bh, 00h          ; clear entire screen
        int 10h
        ret

    write_score:
        mov ax, @data
        mov es, ax 
        mov ax, 1300h ; interrupt for write string
        mov bx, 000Fh ; set page number and color of string
   
        mov dh, 0 ; row
        mov dl, 0 ; col
        mov cx, strScore_s ; size of string
        lea bp, strScore ; string in es:bp 
        int 10h

        mov ax, snake_length
        mov cx, 03h
        divide:         ; convert to decimal
            xor dx, dx
            mov bx, 0ah
            div bx
            push dx
            loop divide

        mov bp, strScore_s
        print:
            inc bp
            mov ah, 02h         ; place cursor after strScore
            mov dx, bp 
            int 10h

            pop dx
            mov ah, 09h
            mov bx, 000Fh
            mov cx, 1
            mov al, dl
            add al, '0'
            int 10h         ; print ascii

            mov ax, strScore_s
            mov bx, bp
            sub bx, ax
            cmp bx, 2
            jle print        
        ret

    input:
        mov ah, 02h
        mov bx, 0
        mov dx, 0502h
        int 10h 

        mov ah, 09h
        mov al, key_pressed
        mov bx, 000Fh
        mov cx, 1
        int 10h

        mov ah, 01h ; get user input
        int 16h

        jz back

        mov ah, 00h
        int 16h
        
        
        cmp al, 27 ; check if escape key
        jne update ; update key_pressed if not esc
        mov ah, 4ch
        int 21h

        update:
            mov ah, key_pressed
            mov prev_key, ah
            mov key_pressed, al           
    back: ret 

    draw:
        mov ax, @data
        mov ds, ax 
        lea si, snake_pos;;
        mov dx, word ptr [si]
        call calculate_pos

        mov ax, @data
        mov ds, ax
        mov bl, key_pressed
        mov bh, prev_key

        mov ax, @code
        mov ds, ax

        cmp bl, 'w'
        je head_up
        cmp bl, 's'
        je head_down
        cmp bl, 'a'
        je head_left
        cmp bl, 'd'
        je head_right 
        
        cmp bh, 'w'
        je head_up
        cmp bh, 's'
        je head_down
        cmp bh, 'a'
        je head_left
        cmp bh, 'd'
        je head_right         

        head_up:
            lea si, snake_head_up
            jmp draw_head
        head_down:
            lea si, snake_head_down
            jmp draw_head
        head_left:
            lea si, snake_head_left
            jmp draw_head
        head_right:
            lea si, snake_head_right
        

        draw_head:
            call draw_img
        
        draw_body:      
            push ax 
            push bx 
            push cx 
            push dx 
            push ds
            push di
            push si
            push bp
            
            mov ax, @data
            mov ds, ax  
            mov bp, snake_length
            lea si, snake_pos
            add si, 2
            try:
                cmp bp, 0
                jle draw_food
                mov dx, word ptr [si]
                add si, 2
                push si
                call calculate_pos
                lea si, snake_body
                call draw_img
                pop si
                mov ax, @data
                mov ds, ax  
                dec bp
                jmp try
        
        draw_food:
            pop bp
            pop si
            pop di
            pop ds
            pop dx 
            pop cx 
            pop bx 
            pop ax 

            mov ax, @data
            mov ds, ax
            mov dx, food_pos
            call calculate_pos

            mov ax, @code
            mov ds, ax
            lea si, food_map
            call draw_img
        ret

    calculate_pos:
        mov ax, @code
        mov ds, ax
        push dx
            mov ax, 8
            mul dh
            mov di, ax
            mov ax, 8*320
            mov bx, 0
            add bl, dl
            mul bx 
            add di, ax
        pop dx 
        ret

    draw_img:
        mov ax, 0A000h ;; 
        mov es, ax     ;;
        mov cl, 8
        y_axis:
            push di
                mov ch, 8
        x_axis:
            mov al, byte ptr [ds:si]
            xor al, byte ptr [es:di]
            mov byte ptr [es:di], al
            inc si
            inc di
            dec ch
            jnz x_axis
        pop di
        add di, 320
        inc bl
        dec cl 
        jnz y_axis
        ret

    rng:       
        mov ax, 25173
        mul food_pos
        add ax, 13849
        mov food_pos, ax
        ret
    
    move:
        mov ax, @data
        mov ds, ax
        mov ah, 2ch ; get system time
        int 21h
        cmp dl, time_now
        je move     ; keep checking until we have a different time
        mov time_now, dl
        
       lea si, snake_pos
       mov dx, word ptr [si]
       mov temp_pos, dx
       mov bp, snake_length
       body_move: 
          cmp bp, 0
          je skip
          add si, 2                       ; get next x and y coords
          mov dx, word ptr [si]  
          mov cx, temp_pos
          mov word ptr [si], cx 
          mov temp_pos, dx
          dec bp 
          jmp body_move

       skip:
            mov ax, @data
            mov ds, ax
            lea si, snake_pos
        check_key:
            mov dx, word ptr [si]
            cmp key_pressed, 'w'
            je move_up 
            cmp key_pressed, 'a' 
            je move_left
            cmp key_pressed, 's'
            je move_down 
            cmp key_pressed, 'd'
            je move_right
            jmp ignore
        move_up:
            cmp prev_key, 's'       ; if the previous key is the opposite direction, do nothing
            je ignore
            dec dl 
            mov word ptr [si], dx
            jmp collision
        move_down: 
            cmp prev_key, 'w'
            je ignore
            inc dl 
            mov word ptr [si], dx
            jmp collision 
        move_left: 
            cmp prev_key, 'd'
            je ignore
            dec dh 
            mov word ptr [si], dx
            jmp collision 
        move_right: 
            cmp prev_key, 'a'
            je ignore
            inc dh
            mov word ptr [si], dx
            jmp collision
        ignore: 
            mov ah, prev_key
            mov key_pressed, ah
            jmp check_key
        
        collision:
            mov ax, @data
            mov ds, ax 
            lea si, snake_pos
            mov ax, word ptr [si]
            mov bx, food_pos

            inc ah
            cmp ah, bh 
            jng return 
            dec ah 

            inc bh
            cmp ah, bh
            jnl return

            inc al
            cmp al, bl 
            jng return 
            dec al

            inc bl
            cmp al, bl
            jnl return 
 
            inc snake_length
         
            call rng 
       
    return: 
        ret

    snake_head_up: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     ;  1
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     ;  2
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     ;  3
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  5
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     ;  7
    snake_head_down: 
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     ;  7
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  5
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     ;  3
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     ;  2
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
    snake_head_left: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,0Ah,0Ah,02h,00h,0Ah     ;  7
        DB 00h,00h,0Ah,00h,0Ah,0Ah,0Ah,02h     ;  1
        DB 00h,0Ch,0Ah,0Ah,0Ah,02h,0Ah,0Ah     ;  3
        DB 00h,0Ch,0Ah,0Ah,0Ah,02h,0Ah,0Ah     ;  2
        DB 00h,00h,0Ah,00h,0Ah,0Ah,0Ah,02h     ;  6
        DB 00h,00h,00h,0Ah,0Ah,02h,00h,0Ah     ;  4
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  5
    snake_head_right: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  4
        DB 0Ah,00h,02h,0Ah,0Ah,0Ah,00h,00h     ;  1
        DB 02h,0Ah,0Ah,0Ah,00h,0Ah,00h,00h     ;  0
        DB 0Ah,0Ah,02h,0Ah,0Ah,0Ah,0Ch,00h     ;  2
        DB 0Ah,0Ah,02h,0Ah,0Ah,0Ah,0Ch,00h     ;  3
        DB 02h,0Ah,0Ah,0Ah,00h,0Ah,00h,00h     ;  7
        DB 0Ah,00h,02h,0Ah,0Ah,0Ah,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  5
    snake_body:
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  1
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     ;  2
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  3
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     ;  5
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  7
    food_map:
        DB 00h,00h,00h,0Ah,02h,00h,00h,00h     ;  0
        DB 00h,00h,0Ch,00h,00h,0Ch,00h,00h     ;  1
        DB 00h,0Ch,0Fh,0Ch,0Ch,0Ch,0Ch,00h     ;  2
        DB 00h,0Fh,0Ch,0Ch,0Ch,0Ch,0Ch,00h     ;  3
        DB 00h,0Fh,0Ch,0Ch,0Ch,0Ch,0Ch,00h     ;  4
        DB 00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h     ;  5
        DB 00h,00h,0Ch,0Ch,0Ch,0Ch,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  7
    
end