; ISSUE: food collision does not work on randomly generated food_pos, possibly due to overflow
;        however, it works on static coordinates
; TODO: fix rng  

.model small
.stack 100h
.data
    snake_pos dw 960 dup (?) ; higher byte = x coord | lower byte = y coord    ; dosbox screen is 27hx18h adjusted for 8x8 sprites  
    snake_length dw 0
    key_pressed db 'd'
    prev_key db ?
    time_now db 00h
    food_pos dw 0A0Ah
    temp_pos dw ?
    border_pos dw 28h+28h+18h+18h dup (?)
    random_table1 db 0Ah,9Fh,0F0h,1Bh,69h,3Dh,0E8h,52h,0C6h,41h,0B7h,74h,23h,0ACh,8Eh,0D5h
    random_table2 db 9Ch,0EEh,0B5h,0CAh,0AFh,0F0h,0DBh,69h,3Dh,58h,22h,06h,41h,17h,74h,83h
    
    random_seed dw 0

    difficulty db 2 ; change difficulty here | 0 = easy, 1 = med, 2 = hard

    med_pos dw 0802h,0803h,0804h,0805h,0806h,0807h,2016h,2015h,2014h,2013h,2012h,2011h                  
    hard_pos dw 0802h,0803h,0804h,0805h,0806h,0807h,2016h,2015h,2014h,2013h,2012h,2011h,0110h,0210h,0310h,0410h,0510h,0610h,260Ah,250Ah,240Ah,230Ah,220Ah,210Ah

    strScore db 'Score:'
    strScore_s equ $-strScore
  
.code
    mov ax, @data
    mov ds, ax 
    mov ax, 0001h
    lea di, border_pos

    gen_border_top:
        cmp ah, 28h
        je bottom_border
        mov word ptr [di], ax 
        inc ah
        add di, 2
        jmp gen_border_top
    
    bottom_border:
        mov ax, 0031h
    gen_border_bottom:
        cmp ah, 28h
        je left_border 
        mov word ptr [di], ax 
        inc ah 
        add di, 2
        jmp gen_border_bottom

    left_border:
        mov ax, 0002h
    gen_border_left:
        cmp al, 18h
        je right_border
        mov word ptr [di], ax 
        inc al 
        add di, 2
        jmp gen_border_left
    
    right_border:
        mov ax, 2702h
    gen_border_right:
        cmp al, 18h
        je main
        mov word ptr [di], ax 
        inc al 
        add di, 2
        jmp gen_border_right
    
    main:
        mov ax, 0013h
        int 10h
        mov ah, 0Bh
        mov bx, 0000h
        int 10h
        lea si, snake_pos ;;
        mov word ptr [si], 0A0Ah ;;   
    ;    mov word ptr [si+2], 090Ah ;;   
    ;    mov word ptr [si+4], 080Ah ;;   

        ;call random
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

        ; if invalid key is pressed, draw same head as the key pressed before
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
        
        draw_border:
            mov ax, @data
            mov ds, ax
            lea si, border_pos
            mov bp, 0
            do:
                mov dx, word ptr [si]
                add si, 2
                push si
                call calculate_pos 
                mov ax, @code 
                mov ds, ax
                lea si, wall
                call draw_img 
                pop si 
                mov ax, @data
                mov ds, ax 
                inc bp
                cmp bp, 28h+28h+18h+18h
                jl do
        
        mov ax, @data
        mov ds, ax 

        cmp difficulty, 0
        je draw_easy
        cmp difficulty, 1
        je draw_med
        cmp difficulty, 2
        je draw_hard

        draw_easy: 
            ret
        draw_med:
            lea si, med_pos
            mov bp, 12
            jmp draw_wall 
        draw_hard:
            lea si, hard_pos
            mov bp, 24

        draw_wall: 
            mov dx, word ptr [si]
            add si, 2
            push si
            call calculate_pos 
            mov ax, @code 
            mov ds, ax
            lea si, wall
            call draw_img 
            pop si 
            mov ax, @data
            mov ds, ax 
            dec bp 
            cmp bp, 0
            jne draw_wall
        ret

    calculate_pos:  ; args: dx = coordinate | ret: di = coord in vram
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

    draw_img:   ; args: si = bitmap addr
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

    random:
        push ds
            mov ax, @data
            mov ds, ax
            mov bh,16
            mov bl,160-16
            call dorangedrandom	
            mov dh, al
            mov bh,16
            mov bl,200-16
            call dorangedrandom	
            mov dl, al
            mov food_pos, dx 
            
        pop ds
        ret		
        
    DoRandomByte1:
        mov al,cl			;Get 1st seed
    DoRandomByte1b:
        ror al,1			;Rotate Right
        ror al,1
        xor al,cl			;Xor 1st Seed
        ror al,1
        ror al,1			;Rotate Right
        xor al,ch			;Xor 2nd Seed
        ror al,1			;Rotate Right
        xor al,10011101b	;Xor Constant
        xor al,cl			;Xor 1st seed
        ret

    DoRandomByte2:
        lea bx, random_table1
        mov ah,0
        mov al,ch		
        xor al,00001011b
        and al,00001111b	;Convert 2nd seed low nibble to Lookup
        
        mov si,ax
        mov dh,[es:bx+si]		;Get Byte from LUT 1
        
        call DoRandomByte1	
        and al,00001111b		;Convert random number from 1st 
        
        lea bx, random_table2	;geneerator to Lookup
        mov si,ax
        mov al,[es:bx+si]		;Get Byte from LUT2
        
        xor al,dh				;Xor 1st lookup
        ret
        
        
    DoRandom:			;RND outputs to A (no input)
        push bx
        push cx
        push dx
            mov cx, random_seed    ;Get and update
            inc cx							  	  ;Random Seed
            mov random_seed,cx
            call DoRandomWord
            mov al,dl
            xor al,dh
        pop dx
        pop cx
        pop bx
        ret
        
    DoRandomWord:		;Return Random pair in HL from Seed BC
        call DoRandomByte1		;Get 1st byte
        mov dh,al
        push dx
        push cx
        push bx
            call DoRandomByte2	;Get 2nd byte
        pop bx
        pop cx
        pop dx
        mov dl,al
        inc cx
        ret	
        
        
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    DoRangedRandom: 		;Return a value between B and C
        call DoRandom
        cmp AL,BH
        jc DoRangedRandom
        cmp AL,BL
        jnc DoRangedRandom
        ret
	
    rng:       
        mov ax, @data
        mov ds, ax
        mov ax, 1839h
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
            cmp dl, 2   ; check if at the topmost side of the screen
            jz stop
            dec dl 
            mov word ptr [si], dx
            jmp collision
        move_down: 
            cmp prev_key, 'w'
            je ignore
            cmp dl, 22   ; check if at the bottommost side of the screen
            jz stop
            inc dl 
            mov word ptr [si], dx
            jmp collision 
        move_left: 
            cmp prev_key, 'd'
            je ignore
            cmp dh, 1   ; check if at the leftmost side of the screen
            jz stop
            dec dh 
            mov word ptr [si], dx
            jmp collision 
        move_right: 
            cmp prev_key, 'a'
            je ignore
            cmp dh, 38  ; check if at the rightmost side of the screen
            jz stop
            inc dh
            mov word ptr [si], dx
            jmp collision
        ignore: 
            mov ah, prev_key
            mov key_pressed, ah
            jmp check_key
        stop:
            mov ah, 4ch
            int 21h
        collision:
            mov ax, @data
            mov ds, ax 
            ; self collision
            lea si, snake_pos
            lea di, snake_pos
            mov bp, snake_length
            add di, 6
            body_collision:
                cmp bp, 3
                jle food_collision
                dec bp
                add di, 2
                mov ax, word ptr [si]
                mov bx, word ptr [di]

                inc ah 
                cmp ah, bh 
                jng body_collision
                dec ah 
                
                inc bh
                cmp ah, bh
                jnl body_collision
                dec bh 
                
                inc al
                cmp al, bl 
                jng body_collision
                dec al

                inc bl
                cmp al, bl
                jnl body_collision
                dec bl 
                jmp stop

                food_collision:
                    lea si, snake_pos
                    mov ax, word ptr [si]
                    mov bx, food_pos

                    inc ah
                    cmp ah, bh 
                    jng wall_collision 
                    dec ah 

                    inc bh
                    cmp ah, bh
                    jnl wall_collision

                    inc al
                    cmp al, bl 
                    jng wall_collision 
                    dec al

                    inc bl
                    cmp al, bl
                    jnl wall_collision 

                    inc snake_length
                    
                    mov ax, 120Ch 
                    mov food_pos, ax
                    ;call random
                    ;call rng ; for some reason, collision cannot be detected when a new random coord is given. only works on non-overflowed values
            wall_collision:
                mov ax, @data
                mov ds, ax 
                lea di, snake_pos 

                cmp difficulty, 0
                je collision_easy 
                cmp difficulty, 1
                je collision_med
                cmp difficulty, 2
                je collision_hard 

                collision_easy:
                    ret
                collision_med:
                    lea si, med_pos
                    mov bp, 12
                    jmp init
                collision_hard: 
                    lea si, hard_pos 
                    mov bp, 24
                
                init:
                    sub si, 2
                check_wall_col:
                    cmp bp, 0
                    jl return
                    dec bp
                    add si, 2
                    mov ax, word ptr [di]
                    mov bx, word ptr [si]
                    inc ah
                    cmp ah, bh 
                    jng check_wall_col 
                    dec ah 

                    inc bh
                    cmp ah, bh
                    jnl check_wall_col 

                    inc al
                    cmp al, bl 
                    jng check_wall_col 
                    dec al

                    inc bl
                    cmp al, bl
                    jnl check_wall_col
                     
                    mov ah, 4ch
                    int 21h     
    return: 
        ret
        
    

    snake_head_up: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     
    snake_head_down: 
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h    
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     
        DB 00h,0Ah,00h,0Ah,0Ah,00h,0Ah,00h     
        DB 00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h     
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h     
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
    snake_head_left: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
        DB 00h,00h,00h,0Ah,0Ah,02h,00h,0Ah     
        DB 00h,00h,0Ah,00h,0Ah,0Ah,0Ah,02h     
        DB 00h,0Ch,0Ah,0Ah,0Ah,02h,0Ah,0Ah     
        DB 00h,0Ch,0Ah,0Ah,0Ah,02h,0Ah,0Ah     
        DB 00h,00h,0Ah,00h,0Ah,0Ah,0Ah,02h     
        DB 00h,00h,00h,0Ah,0Ah,02h,00h,0Ah     
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
    snake_head_right: 
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
        DB 0Ah,00h,02h,0Ah,0Ah,0Ah,00h,00h     
        DB 02h,0Ah,0Ah,0Ah,00h,0Ah,00h,00h     
        DB 0Ah,0Ah,02h,0Ah,0Ah,0Ah,0Ch,00h     
        DB 0Ah,0Ah,02h,0Ah,0Ah,0Ah,0Ch,00h     
        DB 02h,0Ah,0Ah,0Ah,00h,0Ah,00h,00h     
        DB 0Ah,00h,02h,0Ah,0Ah,0Ah,00h,00h     
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
    snake_body:
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     
        DB 00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h     
        DB 00h,0Ah,02h,0Ah,0Ah,02h,0Ah,00h     
        DB 00h,02h,0Ah,0Ah,0Ah,0Ah,02h,00h     
        DB 00h,00h,00h,00h,00h,00h,00h,00h     
    food_map:
        DB 00h,00h,00h,0Ah,02h,00h,00h,00h  
        DB 00h,00h,0Ch,00h,00h,0Ch,00h,00h  
        DB 00h,0Ch,0Fh,0Ch,0Ch,0Ch,0Ch,00h  
        DB 00h,0Fh,0Ch,0Ch,0Ch,0Ch,0Ch,00h  
        DB 00h,0Fh,0Ch,0Ch,0Ch,0Ch,0Ch,00h  
        DB 00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h  
        DB 00h,00h,0Ch,0Ch,0Ch,0Ch,00h,00h  
        DB 00h,00h,00h,00h,00h,00h,00h,00h  
    wall:
        DB 06h,04h,06h,06h,06h,06h,04h,06h
        DB 04h,04h,06h,06h,06h,06h,04h,04h
        DB 06h,04h,0Eh,0Eh,0Eh,0Eh,04h,06h
        DB 06h,04h,0Eh,06h,06h,0Eh,04h,06h
        DB 06h,04h,0Eh,06h,06h,0Eh,04h,06h
        DB 06h,04h,0Eh,0Eh,0Eh,0Eh,04h,06h
        DB 04h,04h,06h,06h,06h,06h,04h,04h
        DB 06h,04h,06h,06h,06h,06h,04h,06h
end