; NOTES: -probably very inefficient idk
;        - atm, only works on TASM
;        - press esc key to exit game
;        - w, a, s, d to move
; TODOs:
;       - try to fix flickering graphics which gets more noticeable as snake gets larger
;       - check for collision with self
;       - score resets to 00 if greater than 15
;       - holding the opposite key of the present direction stops the snake
.model small
.stack 10h
.data
    square_size dw 06h      ; change size of snake/fruit here
    body_x dw 50 dup (?)    ; change max length of snake here
    body_y dw 50 dup (?)    ; change max length of snake here
    snake_length dw 0
    key_pressed db 'd'
    prev_key db ?
    time_now db 00h
    food_x dw 10
    food_y dw 10
    temp_x dw ?             
    temp_y dw ?             
    
    strScore db 'Score:'
    strScore_s equ $-strScore 

.code
    mov ax, @data
    mov ds, ax 
    mov es, ax 
    main:
        mov ax, 0013h
        int 10h
        mov ah, 0Bh
        mov bx, 0000h
        int 10h
        mov si, offset body_x
        mov di, offset body_y 
        mov word ptr [ds:si], 0Ah
        mov word ptr [ds:di], 0Ah
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
        mov ax, 1300h ; interrupt for write string
        mov bx, 000Fh ; set page number and color of string
   
        mov dh, 0 ; row
        mov dl, 0 ; col
        mov cx, strScore_s ; size of string
        mov bp, offset strScore ; string in es:bp 
        int 10h

        mov ah, 02h         ; place cursor after strScore
        mov dl, 7
        int 10h
        
        mov ax, snake_length   ; convert score to decimal
        aaa                 ; ah = tenths  |  al = ones
        mov dx, ax          
        add dh, '0'         ; convert to ascii
        add dl, '0'
        push dx             

        mov ah, 09h         ; interrupt for writing char
        mov al, dh
        mov bx, 000Fh
        mov cx, 1
        int 10h             ; write tenths place

        mov ah, 02h         ; place cursor after tenths place
        mov dh, 0           
        mov dl, 8
        int 10h

        pop dx
        mov ah, 09h
        mov al, dl
        int 10h             ; write ones place 
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
        mov si, offset body_x
        mov di, offset body_y 
        mov bp, 0
        
        body:
            mov cx, [ds:si+bp] ; get snake head x coord 
            mov dx, [ds:di+bp] ; get snake head y coord

        draw_body:
            mov ax, 0c0fh
            mov bh, 00h
            int 10h             ; draw pixel

            inc cx              
            mov ax, cx
            sub ax, [ds:si+bp] 
            cmp ax, square_size
            jle draw_body       ; check x axis

            mov cx, [ds:si+bp]
            inc dx 

            mov ax, dx          
            sub ax, [ds:di+bp]
            cmp ax, square_size 
            jle draw_body       ; check y axis
            
            ; the next remaining lines are for checking if we have iterated through the entirety of the snake
            add bp, 2          
            mov ax, snake_length
            mov bx, 2
            mul bx 
            cmp bp, ax
            jle body

        mov cx, food_x
        mov dx, food_y    
        draw_food:
            mov ax, 0c04h
            mov bh, 00h
            int 10h   

            inc cx 
            mov ax, cx
            sub ax, food_x 
            cmp ax, square_size 
            jle draw_food 
            
            mov cx, food_x
            inc dx 
            mov ax, dx 
            sub ax, food_y
            cmp ax, square_size 
            jle draw_food 
        
        ret 
    
    input:
        mov ah, 01h ; get user input
        int 16h
    
        jz back

        mov ah, 00h
        int 16h
        
        cmp al, 27 ; check if escape key
        jne update ; update key_pressed if not 2 
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
        mul word ptr food_x
        add ax, 13849
        mov food_x, ax

        mov ax, 25173
        mul word ptr food_y
        add ax, 13849
        mov food_y, bx
        ret
    
    move:
        mov ah, 2ch ; get system time
        int 21h
        cmp dl, time_now
        je move     ; keep checking until we have a different time
        mov time_now, dl

        mov si, offset body_x 
        mov di, offset body_y

        mov bp, 2
        mov cx, word ptr [ds:si]
        mov temp_x, cx              ; temporarily store the value of snake head x coord
        mov cx, word ptr [ds:di]    
        mov temp_y, cx              ; temporarily store the value of snake head y coord
        
        body_move: 
            mov cx, temp_x                  ; get previous x coord   
            mov dx, word ptr [ds:si+bp]
            mov word ptr [ds:si+bp], cx
            mov temp_x, dx                  ; store current x coord value for next iteration
            
            mov cx, temp_y                  ; get previous y coord 
            mov dx, word ptr [ds:di+bp]
            mov word ptr [ds:di+bp], cx
            mov temp_y, dx                  ; store current y coord value for next iteration
            
            add bp, 2                       ; get next coordinates from x and y arrays
            
            ; next remaining lines are for checking if we have iterated through the entirety of the snake
            mov ax, snake_length           
            mov bx, 2
            mul bx
            cmp bp, ax
            jle body_move
        
        mov ax, square_size
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
            sub word ptr [ds:di], ax 
            jmp collision 
        move_down: 
            cmp prev_key, 'w'
            je ignore
            add word ptr [ds:di], ax
            jmp collision 
        move_left: 
            cmp prev_key, 'd'
            je ignore
            sub word ptr [ds:si], ax
            jmp collision 
        move_right: 
            cmp prev_key, 'a'
            je ignore
            add word ptr [ds:si], ax 
            jmp collision
        ignore:
            mov ah, prev_key
            mov key_pressed, ah
        
        collision:      ; checks for collision with fruit   ! TODO: collision with self !
            mov cx, word ptr [ds:si]
            mov dx, word ptr [ds:di]
            mov ah, 0dh
            mov bh, 00h
            int 10h 

            cmp al, 04h
            jne return 
            mov ax, snake_length
            inc ax 
            mov snake_length, ax
            call rng 
            
        return: ret
end