; NOTES: - probably very inefficient idk
;        - works on both TASM and MASM
;        - press esc key to exit game
;        - w, a, s, d to move
; TODOs:
;       - try to fix flickering graphics which gets more noticeable as snake gets longer (a temporary fix is to set cpu cycles to max on dosbox)
;       - check for collision with self
;       - food "rng" is not really random; sometimes food spawns on on snake's body 
.model small
.stack 10h

.data
    snake_pos dw 255 dup (?) ;;
    snake_length dw 0
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
        mov word ptr [si], 0101h ;;   

        call rng 
        game_loop:
            call input
            call draw
            call write_score
            call move
            call cls
            jmp game_loop

        ; should never reach this
        mov ah, 4ch
        int 21h
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

    cls: ; clears the screen
        mov ah, 07h          ; scroll down function
        mov al, 0            ; number of lines to scroll
        mov cx, 0
        mov dx, 9090
        mov bh, 00h          ; clear entire screen
        int 10h
        ret

    draw:
        mov ax, @data
        mov ds, ax 
        lea si, snake_pos;;
        mov dx, word ptr [si]
        
        mov ax, 0A000h ;; 
        mov es, ax     ;;
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

        cmp key_pressed, 'w'
        je head_up
        cmp key_pressed, 's'
        je head_down
        cmp key_pressed, 'a'
        je head_left
        cmp key_pressed, 'd'
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
            mov cl, 8
        y_axis:
            push di
                mov ch, 8
        x_axis:
            mov al, [ds:si]
            xor al, [es:di]
            mov [es:di], al
            inc si
            inc di
            dec ch
            jnz x_axis
        pop di
        add di, 320
        inc bl
        dec cl 
        jnz y_axis

        mov bp, 0
        lea si, snake_pos;;
        push si
        
        try:
            pop si
            cmp bp, snake_length
            jge draw_food
            add si, 2
            mov ax, @data
            mov ds, ax
            mov dx, word ptr [si]
            push si

            mov ax, 0A000h ;; 
            mov es, ax     ;;
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

            lea si, snake_body 
            mov cl, 8
            
            draw_body_y:
                push di 
                mov ch, 8
            draw_body_x:
                mov al, [ds:si]
                xor al, [es:di]
                mov [es:di], al
                inc si
                inc di 
                dec ch
                jnz draw_body_x
            pop di
            add di, 320
            inc bl
            dec cl 
            jnz draw_body_y 
            inc bp
            jmp try

    draw_food: 
    mov dx, food_pos
    mov ax, 0A000h ;; 
    mov es, ax     ;;
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
    lea si, food_map
    mov cl, 8

    food_y_axis:
        push di
            mov ch, 8
    food_x_axis:
        mov al, [ds:si]
        xor al, [es:di]
        mov [es:di], al
        inc si
        inc di
        dec ch
        jnz food_x_axis
    pop di
    add di, 320
    inc bl
    dec cl 
    jnz food_y_axis
  
    break: ret 
    
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

    ; thank you stackoverflow, very cool https://stackoverflow.com/questions/40698309/8086-random-number-generator-not-just-using-the-system-time
    rng:       
        mov ax, 25173
        mul food_pos
        add ax, 13849
        mov food_pos, ax
        ret
    
    move:
        mov ah, 2ch ; get system time
        int 21h
        cmp dl, time_now
        je move     ; keep checking until we have a different time
        mov time_now, dl

        mov ax, @data
        mov ds, ax
        lea si, snake_pos
        mov bp, 0
        mov dx, word ptr [si]
        mov temp_pos, dx
        body_move: 
            add si, 2                       ; get next x and y coords
            mov dx, word ptr [si]  
            mov cx, temp_pos
            mov word ptr [si], cx 
            mov temp_pos, dx
            inc bp 
            cmp bp, snake_length
            jl body_move
        
        lea si, snake_pos
        mov ax, @data
        mov ds, ax
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
            push dx
            call collision
            pop dx
            mov word ptr [si], dx
            jmp return
        move_down: 
            cmp prev_key, 'w'
            je ignore
            inc dl 
            push dx
            call collision
            pop dx
            mov word ptr [si], dx
            ;mov word ptr [si], dx
            ;pop di
            jmp return 
        move_left: 
            cmp prev_key, 'd'
            je ignore
            dec dh 
            push dx
            call collision
            pop dx
            mov word ptr [si], dx
            jmp return 
        move_right: 
            cmp prev_key, 'a'
            je ignore
            inc dh
            push dx 
            call collision
            pop dx 
            mov word ptr [si], dx
            jmp return 
        ignore: 
            mov ah, prev_key
            mov key_pressed, ah
            jmp check_key
       
    return: 
        ret

 collision:
    mov ah, 0dh
    mov bx, 0
    mov cx, dx 
    and cx, 0FF00h
    mov cl, ch
    xor ch, ch 
    and dx, 00FFh
    int 10h
    cmp al, 0Ch
    jne wee 
    inc snake_length
    call rng     
    wee:
        ret
            
    snake_head_up: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     ;  1
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     ;  2
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     ;  3
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  5
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,00h,02h,0Ah,0Ah,02h,00h,00h     ;  7
    snake_head_down: 
        DB 00h,00h,02h,0Ah,0Ah,02h,00h,00h     ;  7
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  5
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     ;  3
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     ;  2
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
    snake_head_left: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,02h,0Ah,0Ah,02h,00h,00h     ;  7
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     ;  1
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     ;  3
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     ;  2
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  5
    snake_head_right: 
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     ;  2
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     ;  3
        DB 00h,00h,02h,0Ah,0Ah,02h,00h,00h     ;  7
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  5
    snake_body:
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  1
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     ;  2
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  3
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     ;  4
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     ;  5
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  6
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     ;  7
    food_map:
        DB 00h,00h,00h,00h,0Ah,00h,00h,00h     ;  0
        DB 00h,00h,00h,0Ah,02h,00h,00h,00h     ;  1
        DB 00h,00h,0Ch,00h,00h,0Ch,00h,00h     ;  2
        DB 00h,0Ch,0Fh,0Ch,0Ch,0Ch,0Ch,00h     ;  3
        DB 00h,0Fh,0Ch,0Ch,0Ch,0Ch,0Ch,00h     ;  4
        DB 00h,0Ch,0Ch,0Ch,0Ch,0Ch,04h,00h     ;  5
        DB 00h,00h,0Ch,0Ch,04h,04h,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  7
    
end