; ISSUE: food collision does not work on randomly generated food_pos, possibly due to overflow
;        however, it works on static coordinates
; TODO: fix rng  
;       implement harley's file/io leaderboard

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
    paused db 0
    
    random_seed dw 0

    difficulty db ?  ; change difficulty here | 0 = easy, 1 = med, 2 = hard

    med_pos dw 12,0802h,0803h,0804h,0805h,0806h,0807h,2016h,2015h,2014h,2013h,2012h,2011h                  
    hard_pos dw 24,0802h,0803h,0804h,0805h,0806h,0807h,2016h,2015h,2014h,2013h,2012h,2011h,0110h,0210h,0310h,0410h,0510h,0610h,260Ah,250Ah,240Ah,230Ah,220Ah,210Ah

    strScore db 'Score:'
    strScore_s equ $-strScore

    ;main menu
    strTitle db "BSCS 2-2, Group 1",13,10
    strTitle_l equ $-strTitle

    strYear db "[v1.0] | 2024",13,10
    strYear_l equ $ - strYear

    ;main menu choices
    strStart db "[S] START",13,10
    strStart_l equ $ - strStart

    strLeaderboard db "[L] LEADERBOARD",13,10
    strLeaderboard_l equ $ - strLeaderboard

    strMech db "[M] MECHANICS",13,10
    strMech_l equ $ - strMech

    strExit db "[ESC] EXIT",13,0
    strExit_l equ $ - strExit

    ;difficulty options
    strDiffSelec db "SELECT A DIFFICULTY",13,10
    strDiffSelec_l equ $ - strDiffSelec

    strEasy db "[1] EASY",13,10
    strEasy_l equ $ - strEasy

    strModerate db "[2] MODERATE",13,10
    strModerate_l equ $ - strModerate

    strHard db "[3] HARD",13,10
    strHard_l equ $ - strHard

    strBack db "[B] BACK",13,10
    strBack_l equ $ - strBack
    
    ;leaderboard
    strLeadPage db "LEADERBOARD",13,10
    strLeadPage_l equ $ - strLeadPage

    ;gameover choices
    strGameOver db "GAME OVER!",13,10
    strGameOver_l equ $ - strGameOver

    strScore_GO db "SCORE: ",13,10
    strScore_GO_l equ $ - strScore_GO

    intScore db '0' ;placeholder for score value

    strRetry db "[R] RETRY",13,10
    strRetry_l equ $ - strRetry

    strMenu db "[M] MAIN MENU",13,10
    strMenu_l equ $ - strMenu 

    ;mechanics
    strMechMsg db "HOW TO PLAY",13,10
    strMechMsg_l equ $ - strMechMsg

    ;invalid choice
    strInvalid db "Invalid choice!",13,10
    strInvalid_l equ $ - strInvalid

    strUname db "Enter your name:",13,10
    strUname_l equ $-strUname

    strCont db "Press any key to continue...",13,10
    strCont_l equ $-strCont

    ;player input
    charResp db ?

    filename db 'data.txt', 0
    handle dw ?
    ; scores db 05h
    ;        db 'JOE$', 000h, 010h
    ;        db 'BEN$', 000h, 00Fh
    ;        db 'GEK$', 000h, 009h
    ;        db 'KIM$', 000h, 004h
    ;        db 'JON$', 000h, 001h
    ;----expected output from scores.asm
    ; JOE 016 BEN 015 GEK 009 KIM 004 JON 001

    scores db 00h, 6*50 dup (0)
    ;inputs here
    uname db 'JOE$'
    iscore db 000h, 010h
    strbuf db 4 dup(?)
    screbuf db 00h
  
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
        
    
    
    menu_page:
        mov ax, @data
        mov es, ax
        call cls
        
        ;write title
        mov dh, 20 ;row
        mov dl, 12 ;coloumn
        mov bl, 0Ch ;color
        mov cx, strTitle_l
        lea bp, strTitle
        call str_out

        ;write year
        mov dh, 21
        mov dl, 13
        mov bl, 0Fh
        mov cx, strYear_l
        lea bp, strYear
        call str_out

        ;write menu choices
        mov dh, 11
        mov dl, 14
        mov bl, 0Eh 
            ;start 
        mov cx, strStart_l
        lea bp, strStart
        call str_out
            ;leaderboard
        mov dh, 13
        mov cx, strLeaderboard_l
        lea bp, strLeaderboard
        call str_out
            ;mechanics
        mov dh, 15
        mov cx, strMech_l
        lea bp, strMech
        call str_out
            ;exit
        mov dh, 17
        mov dl, 14
        mov bl, 0Eh
        mov cx, strExit_l
        lea bp, strExit
        call str_out
        ;get resp
        call resp 
        ;if s, start
        cmp al, 's'
            je mm_diff
        cmp al, 'l'
            je mm_lead
        cmp al, 'm'
            je mm_mech
        cmp al, 27
            je exit
            call InvalidMsg
            jmp menu_page
        
            mm_diff: jmp diff_page
            mm_lead: jmp lead_page
            mm_mech: jmp mech_page

        exit:
            mov ah, 4ch
            int 21h 

        diff_page:
            mov ax, @data
            mov es, ax
            call cls
            ;write diff prompt
            mov dh, 7 ;row
            mov dl, 10 ;coloumn
            mov bl, 0Ch ; red
            mov cx, strDiffSelec_l
            lea bp, strDiffSelec
            call str_out

            ;write diff choices
            mov dh, 10
            mov dl, 14
            mov bl, 0Eh ; yellow
                ;easy
            mov cx, strEasy_l
            lea bp, strEasy
            call str_out
                ;mod
            mov dh, 12
            mov cx, strModerate_l
            lea bp, strModerate
            call str_out
                ;hard
            mov dh, 14
            mov cx, strHard_l
            lea bp, strHard
            call str_out
                ;back
            mov dh, 17
            mov cx, strBack_l
            lea bp, strBack
            call str_out

            ;get resp
            call resp
            cmp al, '1'
                jnz med
                mov difficulty, 0
                call main_loop
            med:
            cmp al, '2'
                jnz hard 
                mov difficulty, 1
                call main_loop
            hard:
            cmp al, '3'
                jnz mm 
                mov difficulty, 2
                call main_loop
            mm:
            cmp al, 'b'
                je df_menu
                call InvalidMsg
                jmp diff_page
                df_menu: jmp menu_page
            
        
        game_over_page proc
            mov ax, @data
            mov es, ax
            call cls

            ;write game over prompt
            mov dh, 7 ;row
            mov dl, 14 ;coloumn
            mov bl, 0Ch ;color
            mov cx, strGameOver_l
            lea bp, strGameOver
            call str_out

            ;write score prompt
            mov dh, 8
            mov dl, 14
            mov bl, 0Ah
            mov cx, strScore_GO_l
            lea bp, strScore_GO
            call str_out
                ;write score int
                mov ax, snake_length
                mov cx, 03h
                divide_score:         ; convert to decimal
                    xor dx, dx
                    mov bx, 0ah
                    div bx
                    push dx
                    loop divide_score

                mov bp, strScore_GO_l

                print_score:
                    mov dh, 8
                    mov dl, 14
                    inc bp
                    mov ah, 02h         ; place cursor after strScore
                    add dx, bp
                    int 10h

                    pop dx
                    mov ah, 09h
                    mov bx, 000Ah
                    mov cx, 1
                    mov al, dl
                    add al, '0'
                    int 10h         ; print ascii

                    mov ax, strScore_GO_l
                    mov bx, bp
                    sub bx, ax
                    cmp bx, 2
                    jle print_score     

            ;write diff choices
            mov dh, 10
            mov dl, 14
            mov bl, 0Eh ; yellow
                ;easy
            mov cx, strRetry_l
            lea bp, strRetry
            call str_out
                ;mod
            mov dh, 12
            mov cx, strMenu_l
            lea bp, strMenu
            call str_out

            call resp
            cmp al, 'r'
                jz retry

            cmp al, 'm'
                je go_menu

            cmp al, 27
                je go_exit
                call InvalidMsg
                call game_over_page

                retry: jmp diff_page
                go_menu: jmp menu_page
                go_exit: jmp exit
            ret
        game_over_page endp

    lead_page:
        mov ax, @data
        mov es, ax
        call cls

        ;write leaderboard prompt
        mov dh, 7 ;row
        mov dl, 14 ;column
        mov bl, 0Ah ;color
        mov cx, strLeadPage_l
        lea bp, strLeadPage
        call str_out
        
    mov ax, @data
    mov ds, ax
    mov ax, 3d02h
    lea dx, filename
    int 21h
    mov handle, ax
    ;seek to start of file
    mov ax, 4200h
    mov bx, handle
    mov cx, 0
    mov dx, 0
    int 21h

    ;read from file
    mov ah, 3fh
    mov bx, handle
    mov cx, 1fh
    lea dx, scores
    int 21h

    lea si, scores
    mov ch, byte ptr [si]
    ;ch = number of records
    inc si
    iter_scores:
        lea di, strbuf
        mov cl, 04h
        ldbuf:
            mov dl, byte ptr [si]
            mov byte ptr [di], dl
            inc di
            inc si
            dec cl
            jnz ldbuf

        mov ah, 02h
        mov dl, 0ah
        int 21h 

        push cx
        mov cx, 16
        call printsp 
       
        pop cx
        lea dx, strbuf
        mov ah, 09h
        int 21h

        mov ah, 02h
        mov dl, 20h
        int 21h
        
        mov ah, byte ptr [si]
        inc si
        mov al, byte ptr [si]
        push cx
        mov cx, 03h
        int_score:         ; convert to decimal (thank u raffy)
            xor dx, dx
            mov bx, 0ah
            div bx
            push dx
        loop int_score
        mov cx, 03h
        printnum:
            pop dx
            add dx, '0'
            mov ah, 02 
            int 21h
        loop printnum
        inc si
        pop cx
        dec ch
        mov ah, 02h
        mov dl, 10
        int 21h
    jnz iter_scores

        ;mov ah, 4ch
        ;int 21h

        back_to_menu:
        mov dl, 14
        mov bl, 0Eh ; yellow
        mov dh, 19
        mov cx, strBack_l
        lea bp, strBack
        call str_out

        call resp
        cmp al, 'b'
            je lead_back
            call InvalidMsg
            jmp lead_page

            lead_back: jmp menu_page
            
    mech_page:
        ;write leaderboard prompt
        call cls
        mov dh, 7 ;row
        mov dl, 14 ;coloumn
        mov bl, 0Eh ;color
        mov cx, strMechMsg_l
        lea bp, strMechMsg
        call str_out

        jmp back_to_menu

    main_loop proc
        ;call random
        lea si, snake_pos
        mov word ptr [si], 0A0Ah ;;   
        mov byte ptr key_pressed, 'd'
        mov byte ptr prev_key, 's'
        mov bp, snake_length 
        clear_snake:
            cmp bp, 0
            je start
            add si, 2
            dec bp
            mov word ptr [si], 0 
            jmp clear_snake
        
        start:
        mov snake_length, 0 ; reset score for next game loop
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
    main_loop endp

    printsp proc
        space: 
            mov ah, 02h
            mov dl, 20h
            int 21h 
        loop space
        ret
    printsp endp

    printnl proc 
        nl:
            mov ah, 02h
            mov dl, 10
            int 21h 
        loop nl 
        ret
    printnl endp

    cls proc ; clears the screen
        mov ah, 07h          ; scroll down function
        mov al, 0            ; number of lines to scroll
        mov cx, 0
        mov dx, 9090
        mov bh, 00h          ; clear entire screen
        int 10h
        ret
    cls endp

    str_out proc
        mov ax, 1301h   
        mov bh, 00h   ;page
        int 10h
        ret 
    str_out endp

    resp PROC
        mov ah, 01h         ;get resp
        int 16h
        mov ah, 00h         ;read resp 
        int 16h
        ret
    resp endp

    InvalidMsg proc
        call cls
        mov dh, 13 ;row
        mov dl, 14 ;coloumn
        mov bl, 0Ah ;color
        mov cx, strInvalid_l
        lea bp, strInvalid
        call str_out

        call resp
        cmp al, 27
        je im_exit

        ret

        im_exit:
            mov ah, 4ch
            int 21h
    InvalidMsg endp

    write_score proc
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
    write_score endp 

    input proc
        mov ah, 01h ; get user input
        int 16h

        jz back

        mov ah, 00h
        int 16h
        
        cmp al, 27 ; check if escape key
        jne update ; update key_pressed if not esc
        cmp paused, 0
        je pause
        mov paused, 0
        jmp back
        pause:
            mov paused, 1
        jmp back
        ;mov ah, 4ch
        ;int 21h

        update:
            mov ah, key_pressed
            mov prev_key, ah
            mov key_pressed, al           
    back: ret 
    input endp

    draw proc
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
            jmp init_len 
        draw_hard:
            lea si, hard_pos
        init_len:
            mov bp, word ptr [si]
        draw_wall: 
            add si, 2
            mov dx, word ptr [si]
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
            mov al, byte ptr ds:[si]
            xor al, byte ptr es:[di]
            mov byte ptr es:[di], al
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
    draw endp 

    random proc
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
    random endp

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
        mov dh,es:[bx+si]		;Get Byte from LUT 1
        
        call DoRandomByte1	
        and al,00001111b		;Convert random number from 1st 
        
        lea bx, random_table2	;geneerator to Lookup
        mov si,ax
        mov al,es:[bx+si]		;Get Byte from LUT2
        
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
	
    rng proc       
        mov ax, @data
        mov ds, ax
        mov ax, 1839h
        mul food_pos
        add ax, 13849
        mov food_pos, ax
        ret
    rng endp 

    move proc
        mov ax, @data
        mov ds, ax
        cmp paused, 1
        jne time 
        ret 
        time:
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
            call cls

            mov ax, @data
            mov ds, ax
            mov es, ax 

            lea bp, strUname
            mov cx, strUname_l
            mov bl, 0Fh
            mov dh, 8
            mov dl, 12
            call str_out
            
            mov cx, 3
            mov bp, 0
            underscore:
                mov ah, 2
                mov dh, 10
                mov dl, 18
                add dx, bp 
                inc bp
                mov bh, 0
                int 10h

                mov ax, 092dh
                mov bl, 0eh
                mov bh, 0
                push cx
                mov cx, 1
                int 10h
                pop cx
            loop underscore
            
            lea si, uname 
            mov cx, 3
            mov bp, 0
            get_uname:
                mov ah, 7
                int 21h
               
                mov ah, 2
                mov dh, 10
                mov dl, 18
                add dx, bp 
                inc bp
                mov bh, 0
                int 10h

                cmp al, 8
                jne printchar

                mov ah, 2
                dec dx 
                dec bp
                dec bp
                dec si
                mov bh, 0
                int 10h

                mov ax, 0a2dh
                mov bh, 0
                mov cx, 1
                int 10h 

                jmp get_uname

                printchar:
                    mov ah, 0ah
                    mov bh, 0
                    mov bl, 0eh
                    push cx
                    mov cx, 1
                    int 10h
                    pop cx
                
                mov byte ptr [si], al
                inc si
            cmp bp, 3
            je confirm_uname
            jmp get_uname
            
            confirm_uname:
                lea bp, strCont
                mov cx, strCont_l
                mov bl, 0Fh
                mov dh, 14
                mov dl, 7
                call str_out

                mov ah, 7
                int 21h
                mov byte ptr [si], '$'
                mov ax, snake_length
                lea si, iscore 
                mov byte ptr [si+1], al
             
            ;open file  
            mov ax, 3d02h
            lea dx, filename
            int 21h
            mov handle, ax
            ;seek to start of file
            mov ax, 4200h
            mov bx, handle
            mov cx, 0
            mov dx, 0
            int 21h

            ;read from file
            mov ah, 3fh
            mov bx, handle
            mov cx, 1fh
            lea dx, scores
            int 21h
            
            ;insert
            lea di, scores
            xor ax, ax
            mov al, byte ptr [di]
            mov bl, 06h ;go to the last score record
            mul bl
            xor ah, ah
            add di, ax ;move di to the the last byte of the last record
            add di, 01h
            insrec:
                lea si, uname
                mov cx, 04h
                inpname:
                    mov dl, byte ptr [si]
                    mov byte ptr [di], dl
                    inc si
                    inc di
                    loop inpname
                lea si, iscore
                mov dh, byte ptr [si]
                mov dl, byte ptr [si+1]
                mov byte ptr [di], dh
                mov byte ptr [di+1], dl
            
            ;increment score size 
            lea si, scores
            mov ch, byte ptr [si]
            inc ch
            mov byte ptr [si], ch
            
            ;SORTING
            mov dh, ch
            ;ch = outer loop counter
            ;dh = inner loop counter
            outsort:
                lea si, scores ;reset pointers
                lea di, scores
                add si, 06h
                add di, 06h
                push cx
                mov ch, dh
                insort:
                    mov di, si
                    mov al, byte ptr [si]
                    mov ah, byte ptr [si-1]
                    mov bl, byte ptr [si+6]
                    mov bh, byte ptr [si+5]
                    cmp ax, bx
                    jge noswap
                    add di, 01h
                    sub si, 05h
                    mov dl, 06h
                    swapscore:
                        mov bh, byte ptr [di]
                        mov bl, byte ptr [si]
                        mov byte ptr [di], bl
                        mov byte ptr [si], bh
                        inc si
                        inc di
                        dec dl
                        jnz swapscore
                    noswap:
                    add si, 06h
                    dec ch 
                jnz insort
                pop cx
                dec dh
                dec ch
            jnz outsort

            ;cap score size for storage
            lea si, scores
            mov al, byte ptr [si]
            cmp al, 05h
            jle undercap
            mov al, 05h
            undercap:
            mov byte ptr[si], al
                
            ;seek to start of file
            mov ax, 4200h
            mov bx, handle
            mov cx, 0
            mov dx, 0
            int 21h
            ;write to file
            mov ah, 40h
            mov bx, handle
            lea dx, scores
            mov cx, 1fh;
            int 21h
            ;close file
            mov ah, 3eh
            mov bx, handle
            int 21h

            call game_over_page
            ret
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
                ;call game_over_page

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
                    jmp init
                collision_hard: 
                    lea si, hard_pos 
                init:
                    mov bp, word ptr [si]
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

                    jmp stop
                    ;mov ah, 4ch
                    ;int 21h     
    return: 
        ret
    move endp
    ; bitmaps
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