.model small
.stack 100h
.data
    snake_pos dw 960 dup (?) ; higher byte = x coord | lower byte = y coord    ; dosbox screen is 27hx18h adjusted for 8x8 sprites  
    snake_length dw 0
    key_pressed db 'd'
    prev_key db ?
    time_now db 00h
    food_pos dw ?
    food_seed dw 0401h  ; used so that rotten_pos and food_pos are different when generating random numbers
    eat_streak db 0
    rotten_pos dw ?
    rotten_seed dw 1F52h
    temp_pos dw ?
    border_pos dw 28h+28h+18h+18h dup (?)
    paused db 0

    difficulty db ?  ; change difficulty here | 0 = easy, 1 = med, 2 = hard

    med_pos0 dw 30,0806h,0807h,0811h,0812h,0906h,0907h,0911h,0912h,0a06h,0a07h,0a11h,0a12h,100ah,100eh,130ah,130eh,160ah,160eh,1c06h,1c07h,1c11h,1c12h,1d06h,1d07h,1d11h,1d12h,1e06h,1e07h,1e11h,1e12h
    med_pos1 dw 30,080ch,0b0ch,0c0ch,1204h,1205h,1206h,1207h,1211h,1212h,1213h,1214h,1304h,1305h,1306h,1307h,1311h,1312h,1313h,1314h,1404h,1405h,1406h,1407h,1411h,1412h,1413h,1414h,1a0ch,1b0ch,1e0ch
   
    hard_pos0 dw 60,0302h,0303h,0304h,0305h,0306h,0307h,0402h,0403h,0404h,0405h,0406h,0407h,050fh,060eh,0313h,0314h,0413h,0414h,0e0eh,0e0fh,0e10h,0e11h,0f0eh,0f0fh,0f10h,0f11h,1010h,1011h,1110h,1111h,1507h,1508h,1607h,1608h,1707h,1708h,1709h,170ah,1807h,1808h,1809h,180ah,200ah,2109h,2204h,2205h,2304h,2305h,2211h,2212h,2213h,2214h,2215h,2216h,2311h,2312h,2313h,2314h,2315h,2316h
    hard_pos1 dw 60,0311h,0312h,0411h,0412h,050bh,050ch,050dh,0513h,0514h,060bh,060ch,060dh,0610h,0611h,0613h,0614h,0710h,0711h,0d0bh,0d0ch,0d0dh,100bh,100ch,100dh,1206h,1207h,1211h,1212h,1306h,1307h,1311h,1312h,1406h,1407h,1411h,1412h,160bh,160ch,160dh,190bh,190ch,190dh,1f07h,1f08h,2004h,2005h,2007h,2008h,200bh,200ch,200dh,2104h,2105h,210bh,210ch,210dh,2206h,2207h,2306h,2307h

    active_wall_pos dw 61 dup (?)

    strScore db 'SCORE:'
    strScore_l equ $-strScore

    strSnek db "SNEK"
    strSnek_l equ $-strSnek

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

    strExit db "[ESC] EXIT"
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

    strPaused db "Paused"
    strPaused_l equ $-strPaused
    
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

    strSave db "[S] SAVE",13,10
    strSave_l equ $-strSave

    strMenu db "[M] MAIN MENU",13,10
    strMenu_l equ $ - strMenu 

    ;mechanics
    strMechTitleLbl db "MECHANICS",13,10
    strMechTitleLbl_l equ $ - strMechTitleLbl

    strMechGoBack db "[B] GO BACK",13,10
    strMechGoBack_l equ $ - strMechGoBack

    ;[1]-mechanics     HOW TO MOVE?
    strMechNavi1 db "   1 OF 7  >",13,10
    strMechNavi1_l equ $ - strMechNavi1

    strMechTitle1 db "HOW TO MOVE?",13,10
    strMechTitle1_l equ $ - strMechTitle1

    strMechInstructions1 db "USE W,A,S,D TO MOVE",13,10
    strMechInstructions1_l equ $ - strMechInstructions1

    ;[2]-mechanics     HOW TO STAY ALIVE?
    strMechNavi2 db "<  2 OF 7  >",13,10
    strMechNavi2_l equ $ - strMechNavi2

    strMechTitle2 db "HOW TO STAY ALIVE?",13,10
    strMechTitle2_l equ $ - strMechTitle2

    strMechInstructions2_1 db "DO NOT HIT WALLS &",13,10
    strMechInstructions2_1_l equ $ - strMechInstructions2_1

    strMechInstructions2_2 db "DO NOT EAT YOURSELF",13,10
    strMechInstructions2_2_l equ $ - strMechInstructions2_2


    ;[3]-mechanics     WHAT'S THE GOAL?
    strMechNavi3 db "<  3 OF 7  >",13,10
    strMechNavi3_l equ $ - strMechNavi3

    strMechTitle3 db "WHAT'S THE GOAL?",13,10
    strMechTitle3_l equ $ - strMechTitle3

    strMechInstructions3_1 db "COLLECT MANY HEALTHY APPLES",13,10
    strMechInstructions3_1_l equ $ - strMechInstructions3_1

    strMechInstructions3_2 db "TO MAKE YOUR SNEK LONGER",13,10
    strMechInstructions3_2_l equ $ - strMechInstructions3_2

    strMechInstructions3_3 db "AND GET MORE POINTS!",13,10
    strMechInstructions3_3_l equ $ - strMechInstructions3_3

    ;[4]-mechanics     BEWARE!!!
    strMechNavi4 db "<  4 OF 7  >",13,10
    strMechNavi4_l equ $ - strMechNavi4

    strMechTitle4 db "BEWARE!!!",13,10
    strMechTitle4_l equ $ - strMechTitle4

    strMechInstructions4_1 db "DO NOT EAT ROTTEN APPLES",13,10
    strMechInstructions4_1_l equ $ - strMechInstructions4_1

    strMechInstructions4_2 db "THEY MAKE YOUR SNEK SMALLER",13,10
    strMechInstructions4_2_l equ $ - strMechInstructions4_2

    strMechInstructions4_3 db "AND DEDUCT POINTS!",13,10
    strMechInstructions4_3_l equ $ - strMechInstructions4_3

    ;[5]-mechanics     A SURPRISE!
    strMechNavi5 db "<  5 OF 7  >",13,10
    strMechNavi5_l equ $ - strMechNavi5

    strMechTitle5 db "A SURPRISE!",13,10
    strMechTitle5_l equ $ - strMechTitle5

    strMechInstructions5_1 db "KEEP EATING HEALTHY APPLES &",13,10
    strMechInstructions5_1_l equ $ - strMechInstructions5_1

    strMechInstructions5_2 db "A SUPER APPLE WILL APPEAR!",13,10
    strMechInstructions5_2_l equ $ - strMechInstructions5_2

    strMechInstructions5_3 db "THEY ADD 3 BLOCKS TO YOUR SNEK!",13,10
    strMechInstructions5_3_l equ $ - strMechInstructions5_3

    ;[6]-mechanics     CHOOSE DIFFICULTY
    strMechNavi6 db "<  6 OF 7  >",13,10
    strMechNavi6_l equ $ - strMechNavi6

    strMechTitle6 db "CHOOSE DIFFICULTY!",13,10
    strMechTitle6_l equ $ - strMechTitle6

    strMechInstructions6_1 db "SPEED AND ENVIRONMENT CHANGE",13,10
    strMechInstructions6_1_l equ $ - strMechInstructions6_1

    strMechInstructions6_2 db "BASED ON THE DIFFICULTY",13,10
    strMechInstructions6_2_l equ $ - strMechInstructions6_2

    strMechDiffLabels db "EASY     MEDIUM  HARD",13,10
    strMechDiffLabels_l equ $ - strMechDiffLabels

    strMechDiffTimeDelays db "0.125 SEC  0.1 SEC 0.075 SEC ",13,10
    strMechDiffTimeDelays_l equ $ - strMechDiffTimeDelays

    ;[7]-mechanics     VIEW LEADERBOARDS
    strMechNavi7 db "<  7 OF 7   ",13,10
    strMechNavi7_l equ $ - strMechNavi7

    strMechTitle7 db " VIEW LEADERBOARDS",13,10
    strMechTitle7_l equ $ - strMechTitle7

    strMechInstructions7_1 db "SAVE YOUR SCORE &",13,10
    strMechInstructions7_1_l equ $ - strMechInstructions7_1

    strMechInstructions7_2 db "SEE IF YOU REACHED TOP 5!",13,10
    strMechInstructions7_2_l equ $ - strMechInstructions7_2

    strMechLeaderboardsTitle db "LEADERBOARDS",13,10
    strMechLeaderboardsTitle_l equ $ - strMechLeaderboardsTitle

    strMechLeaderboardsPlyr1 db "RAF 099",13,10
    strMechLeaderboardsPlyr1_l equ $ - strMechLeaderboardsPlyr1

    strMechLeaderboardsPlyr2 db "HAR 098",13,10
    strMechLeaderboardsPlyr2_l equ $ - strMechLeaderboardsPlyr2

    strMechLeaderboardsPlyr3 db "ALX 097",13,10
    strMechLeaderboardsPlyr3_l equ $ - strMechLeaderboardsPlyr3

    strMechLeaderboardsPlyr4 db "PAO 096",13,10
    strMechLeaderboardsPlyr4_l equ $ - strMechLeaderboardsPlyr4

    strMechLeaderboardsPlyr5 db "MCH 095",13,10
    strMechLeaderboardsPlyr5_l equ $ - strMechLeaderboardsPlyr5

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
    mov ax, 0013h
    int 10h
    mov ax, @data
    mov ds, ax 
    mov ax, 0001h
    lea di, border_pos

    top_bot_border:
        cmp ah, 28h
        je vertical_border
        mov word ptr [di], ax 
        push ax 
        add al, 30h
        mov word ptr [di+2], ax
        pop ax
        inc ah
        add di, 4
        jmp top_bot_border
    
    vertical_border:
        mov ax, 0002h
    left_right_border:
        cmp al, 18h
        je menu_page
        mov word ptr [di], ax 
        push ax 
        add ah, 27h
        mov word ptr [di+2], ax 
        pop ax
        inc al 
        add di, 4
        jmp left_right_border
          
    menu_page:
        call cls

        ;draw logo
        mov dh, 13
        mov dl, 3
        call calculate_pos
        lea si, snek_title
        mov bh, 108
        mov bl, 33 
        call draw_img

        call menu_bg_draw

        mov ax, @data
        mov es, ax

        ;write title
        mov dh, 19 ;row
        mov dl, 12 ;column
        mov bl, 0Ch ;color
        mov cx, strTitle_l
        lea bp, strTitle
        call str_out

        ;write year
       mov dh, 20
       mov dl, 13
       mov bl, 0Fh
       mov cx, strYear_l
       lea bp, strYear
       call str_out

        ;write menu choices
        mov dh, 10
        mov dl, 13
        mov bl, 0Eh 
        ;start 
        mov cx, strStart_l
        lea bp, strStart
        call str_out
        ;leaderboard    
        mov dh, 12
        mov cx, strLeaderboard_l
        lea bp, strLeaderboard
        call str_out
        ;mechanics
        mov dh, 14
        mov cx, strMech_l
        lea bp, strMech
        call str_out
        ;exit
        mov dh, 16
        mov dl, 13
        mov bl, 0Eh
        mov cx, strExit_l
        lea bp, strExit
        call str_out
        ;get resp
        menu_page_start:

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
            jmp menu_page_start
        
            mm_diff: jmp diff_page
            mm_lead: jmp lead_page
            mm_mech: jmp mech_page

        exit:
            call cls
            mov ah, 4ch
            int 21h 

        diff_page:
            call cls
            call menu_bg_draw

            mov ax, @data
            mov ds, ax
            mov es, ax

            ;write diff prompt
            mov dh, 7 ;row
            mov dl, 10 ;column
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

            diff_page_start:
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
                call load_walls
                call main_loop
            hard:
            cmp al, '3'
                jnz mm 
                mov difficulty, 2
                call load_walls
                call main_loop
            mm:
            cmp al, 'b'
                je df_menu
                jmp diff_page_start
                df_menu: jmp menu_page
        
    load_walls proc
        ;get random bit (0 or 1) using systime for map choice
        mov ax, @data
        mov ds, ax
        mov ah, 00h
        int 1ah
        mov ax, dx
        xor dx, dx
        mov cx, 10
        div cx
        xor dx, 01h ;get the least significant bit
        ;0 or 1 is now stored in dl
        cmp difficulty, 1
        jnz load_hard
            cmp dl, 1
            jnz medzero
                lea si, med_pos1
                jmp load_active
            medzero:
                lea si, med_pos0
                jmp load_active
        load_hard:
            cmp dl, 1
            jnz hardzero
                lea si, hard_pos1
                jmp load_active
            hardzero:
                lea si, hard_pos0
                jmp load_active
        load_active:
            lea di, active_wall_pos
            mov cx, word ptr [si]
            mov word ptr [di], cx
            add si, 2
            add di, 2
            ldwall:
                mov dx, word ptr [si]
                mov word ptr [di], dx
                add si, 2
                add di, 2
                loop ldwall
        ret
    load_walls endp

    game_over_page proc
        mov ax, @data
        mov es, ax
        call cls
        
        ;write game over prompt
        mov dh, 7 ;row
        mov dl, 14 ;column
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

        mov dh, 14
        mov cx, strSave_l
        lea bp, strSave
        call str_out

        call draw_logs 

        call resp
        cmp al, 'r'
            jz retry
        cmp al, 'm'
            je go_menu
        cmp al, 's'
            je go_save

        cmp al, 27
            je go_exit
            call game_over_page

            retry: jmp diff_page
            go_menu: jmp menu_page
            go_exit: jmp exit
        ret

        go_save:
        call cls
        call menu_bg_draw

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
        jmp menu_page
    game_over_page endp

lead_page:
    mov ax, @data
    mov es, ax
    call cls

    ;write leaderboard prompt
    mov dh, 6 ;row
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

        back_to_menu:
        mov dl, 14
        mov bl, 0Eh ; yellow
        mov dh, 19
        mov cx, strBack_l
        lea bp, strBack
        call str_out

        call menu_bg_draw

        wait_resp:
        call resp
        cmp al, 'b'
            je lead_back
            jmp wait_resp

            lead_back:
                jmp menu_page    
        ret

    menu_bg_draw PROC
        ;draw left_1
        mov dh, 0
        mov dl, 7
        call calculate_pos
        lea si, menu_bg_left_1
        mov bh, 56
        mov bl, 144
        call draw_img

        ;draw left_2
        add dh, 7
        mov dl, 16
        call calculate_pos
        lea si, menu_bg_left_2
        mov bh, 48
        mov bl, 72
        call draw_img

        ;draw mid
        add dh, 6
        mov dl, 22
        call calculate_pos
        lea si, menu_bg_mid
        mov bh, 104
        mov bl, 24
        call draw_img

        ;draw right
        add dh, 13
        mov dl, 16
        call calculate_pos
        lea si, menu_bg_right_2
        mov bh, 72
        mov bl, 72
        call draw_img
        
        add dh, 9
        mov dl, 11
        call calculate_pos
        lea si, menu_bg_right_1
        mov bh, 40
        mov bl, 112
        call draw_img

        ret
    menu_bg_draw ENDP

    mech_page:
        ; ch = page tracker
        mov ch, 1  ; set ch to 1 when first calling mech_page
        call navigate_mech_page

    navigate_mech_page proc
        ; switch case to keep track of what page to display
        cmp ch, 1
            je goto_mech_page_1
        cmp ch, 2
            je goto_mech_page_2
        cmp ch, 3
            je goto_mech_page_3
        cmp ch, 4
            je goto_mech_page_4
        cmp ch, 5
            je goto_mech_page_5
        cmp ch, 6
            je goto_mech_page_6
        cmp ch, 7
            je goto_mech_page_7

        goto_mech_page_1:
            call mech_page_1
            jmp skip1

        goto_mech_page_2:
            call mech_page_2
            jmp skip1

        goto_mech_page_3:
            call mech_page_3
            jmp skip1

        goto_mech_page_4:
            call mech_page_4
            jmp skip1

        goto_mech_page_5:
            call mech_page_5
            jmp skip1

        goto_mech_page_6:
            call mech_page_6
            jmp skip1
        
        goto_mech_page_7:
            call mech_page_7

        skip1: ret
    navigate_mech_page endp

    draw_logs proc ; draws both left and right logs simultaneously
        mov cx, 4
        mov dx, 0   ; coord (top left)
        log:      
            push cx 
            call calculate_pos 
            lea si, log_border_left
            mov bh, 30
            mov bl, 50
            push dx
            call draw_img
            add dh, 24h
            call calculate_pos
            lea si, log_border_right
            mov bh, 30
            mov bl, 50
            call draw_img
            pop dx 
            add dx, 6
            pop cx
            loop log
        ret
    draw_logs endp

    ; writes default texts per mech_page
    mech_print_page_defaults proc
        call draw_logs
        
        mov ax, @data
        mov es, ax 
        ; write "MECHANICS" Title 
        mov dh, 2 ;row
        mov dl, 16 ;column
        mov bl, 0Eh ;color
        mov cx, strMechTitleLbl_l
        lea bp, strMechTitleLbl
        call str_out

        ; write "[B] BACK"
        mov dh, 22 ;row
        mov dl, 16 ;column
        mov bl, 08h ;color
        mov cx, strBack_l
        lea bp, strBack
        call str_out

        ret
    mech_print_page_defaults endp

    mech_page_1 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "1 - HOW TO MOVE?"
        mov dh, 4 ;row
        mov dl, 14 ;column
        mov bl, 0Bh ;color
        mov cx, strMechTitle1_l
        lea bp, strMechTitle1
        call str_out

        ; write "USE W,A,S,D TO MOVE"
        mov dh, 18 ;row
        mov dl, 11 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions1_l
        lea bp, strMechInstructions1
        call str_out

        ; write "1 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi1_l
        lea bp, strMechNavi1
        call str_out

        ; draw w
        mov dx, 1308h
        lea si, w_key
        call draw_key
        
        ; draw a
        mov dx, 100Bh
        lea si, a_key
        call draw_key

        ; draw s
        mov dx, 130Bh
        lea si, s_key 
        call draw_key

        ; draw d 
        mov dx, 160Bh
        lea si, d_key
        call draw_key 

        mov ch, 1
        call mech_get_resp
        ret
    mech_page_1 endp

    draw_key proc 
        call calculate_pos 
        mov bh, 23
        mov bl, 23
        call draw_img 
        ret
    draw_key endp

    mech_page_2 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "2 - HOW TO STAY ALIVE?"
        mov dh, 4 ;row
        mov dl, 11 ;column
        mov bl, 0Bh ;color
        mov cx, strMechTitle2_l
        lea bp, strMechTitle2
        call str_out

        ; write "DO NOT HIT WALLS &"
        mov dh, 17 ;row
        mov dl, 11 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions2_1_l
        lea bp, strMechInstructions2_1
        call str_out

        ; write "DO NOT EAT YOURSELF"
        mov dh, 18 ;row
        mov dl, 11 ;column
        mov bl, 0Bh ;color
        mov cx, strMechInstructions2_2_l
        lea bp, strMechInstructions2_2
        call str_out

        ; write "2 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi2_l
        lea bp, strMechNavi2
        call str_out

        ; draw snake (left side) 
        mov dx, 0c0Ch
        mov cx, 7
        call draw_snake_demo
        
        mov dx, 0B07h
        mov cx, 8
        draw_sample_wall:
            push cx
            push dx 
            call calculate_pos
            pop dx 
            inc dl
            mov bh, 8
            mov bl, 8
            lea si, wall
            call draw_img 
            pop cx
            loop draw_sample_wall

        ; draw snake (right side)
        mov dx, 160Ch
        mov cx, 8
        call draw_snake_demo

        mov dx, 1507h
        mov cx, 8
        draw_body_wall:
            push cx
            push dx 
            call calculate_pos
            pop dx 
            inc dl
            mov bh, 8
            mov bl, 8
            lea si, snake_body
            call draw_img 
            pop cx
            loop draw_body_wall
        
        mov dx, 1607h
        mov cx, 8
        draw_horizontal_body:
            push cx
            push dx 
            call calculate_pos
            pop dx 
            inc dh
            mov bh, 8
            mov bl, 8
            lea si, snake_body
            call draw_img 
            pop cx
            loop draw_horizontal_body
        
        mov dx, 1D08h
        mov cx, 4
        draw_vertical_body:
          push cx
            push dx 
            call calculate_pos
            pop dx 
            inc dl
            mov bh, 8
            mov bl, 8
            lea si, snake_body
            call draw_img 
            pop cx
            loop draw_vertical_body

        mov ch, 2
        call mech_get_resp
        ret
    mech_page_2 endp

    mech_page_3 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "3 - WHAT'S THE GOAL?"
        mov dh, 4 ;row
        mov dl, 12 ;column
        mov bl, 0Bh ;color
        mov cx, strMechTitle3_l
        lea bp, strMechTitle3
        call str_out

        ; write "COLLECT MANY HEALTHY APPLES"
        mov dh, 16 ;row
        mov dl, 7 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions3_1_l
        lea bp, strMechInstructions3_1
        call str_out

        ; write "TO MAKE YOUR SNEK LONGER"
        mov dh, 17 ;row
        mov dl, 8 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions3_2_l
        lea bp, strMechInstructions3_2
        call str_out

        ; write "AND GET MORE POINTS!"
        mov dh, 18 ;row
        mov dl, 10 ;column
        mov bl, 0Eh ;color
        mov cx, strMechInstructions3_3_l
        lea bp, strMechInstructions3_3
        call str_out

        ; write "3 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi3_l
        lea bp, strMechNavi3
        call str_out

        ; draw fruit
        mov dx, 0F09h
        call calculate_pos 
        lea si, food_map
        mov bh, 8
        mov bl, 8
        call draw_img

        ; draw top snake
        mov dx, 1009h
        mov cx, 10
        call draw_snake_demo 

        ; draw bottom snake
        mov dx, 0F0Bh
        mov cx, 11
        call draw_snake_demo

        mov ch, 3
        call mech_get_resp
        ret
    mech_page_3 endp

    draw_snake_demo proc    ; args: dx = snake head pos, cx = snake length 
        push cx 
        call calculate_pos 
        
        lea si, snake_head_left
        mov bh, 8
        mov bl, 8
        call draw_img 
        
        inc dh
        pop cx 
        dec cx
        
        draw_top_snake_body:
            call calculate_pos
            push dx 
            push cx
            lea si, snake_body
            mov bh, 8
            mov bl, 8
            call draw_img 
            pop cx
            pop dx 
            inc dh
            loop draw_top_snake_body
        ret
    draw_snake_demo endp

    mech_page_4 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "4 - BEWARE!!!"
        mov dh, 4 ;row
        mov dl, 16 ;column
        mov bl, 04h ;color
        mov cx, strMechTitle4_l
        lea bp, strMechTitle4
        call str_out

        ; write "DO NOT EAT ROTTEN APPLES"
        mov dh, 16 ;row
        mov dl, 8 ;column
        mov bl, 04h ;color
        mov cx, strMechInstructions4_1_l
        lea bp, strMechInstructions4_1
        call str_out

        ; write "THEY MAKE YOUR SNEK SMALLER"
        mov dh, 17 ;row
        mov dl, 7 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions4_2_l
        lea bp, strMechInstructions4_2
        call str_out

        ; write "AND DEDUCT POINTS!"
        mov dh, 18 ;row
        mov dl, 10 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions4_3_l
        lea bp, strMechInstructions4_3
        call str_out

        ; write "4 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi4_l
        lea bp, strMechNavi4
        call str_out

        ; draw fruit
        mov dx, 0F09h
        call calculate_pos 
        lea si, rotten_apple
        mov bh, 8
        mov bl, 8
        call draw_img

        ; draw top snake
        mov dx, 1009h
        mov cx, 10
        call draw_snake_demo 

        ; draw bottom snake
        mov dx, 0F0Bh
        mov cx, 9
        call draw_snake_demo

        mov ch, 4
        call mech_get_resp
        ret
    mech_page_4 endp

    mech_page_5 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "5 - A SURPRISE!"
        mov dh, 4 ;row
        mov dl, 15 ;column
        mov bl, 0Dh ;color
        mov cx, strMechTitle5_l
        lea bp, strMechTitle5
        call str_out

        ; write "KEEP EATING HEALTHY APPLES &"
        mov dh, 16 ;row
        mov dl, 6 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions5_1_l
        lea bp, strMechInstructions5_1
        call str_out

        ; write "A SUPER APPLE WILL APPEAR!"
        mov dh, 17 ;row
        mov dl, 7 ;column
        mov bl, 0Dh ;color
        mov cx, strMechInstructions5_2_l
        lea bp, strMechInstructions5_2
        call str_out

        ; write "EAT THIS AND ADD 3 BLOCKS TO YOUR SNEK!"
        mov dh, 18 ;row
        mov dl, 4 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions5_3_l
        lea bp, strMechInstructions5_3
        call str_out

        ; write "5 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi5_l
        lea bp, strMechNavi5
        call str_out

        ; draw fruit
        mov dx, 0F09h
        call calculate_pos 
        lea si, super_apple
        mov bh, 8
        mov bl, 8
        call draw_img

        ; draw top snake
        mov dx, 1009h
        mov cx, 10
        call draw_snake_demo 

        ; draw bottom snake
        mov dx, 0F0Bh
        mov cx, 13
        call draw_snake_demo

        mov ch, 5   
        call mech_get_resp
        ret
    mech_page_5 endp
    
    mech_page_6 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "6 - CHOOSE DIFFICULTY"
        mov dh, 4 ;row
        mov dl, 11 ;column
        mov bl, 0Bh ;color
        mov cx, strMechTitle6_l
        lea bp, strMechTitle6
        call str_out

        ; write "SPEED AND ENVIRONMENT CHANGE"
        mov dh, 17 ;row
        mov dl, 6 ;column
        mov bl, 0Fh ;color
        mov cx, strMechInstructions6_1_l
        lea bp, strMechInstructions6_1
        call str_out

        ; write "BASED ON THE DIFFICULTY"
        mov dh, 18 ;row
        mov dl, 8 ;column
        mov bl, 0Bh ;color
        mov cx, strMechInstructions6_2_l
        lea bp, strMechInstructions6_2
        call str_out

        ; write "6 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi6_l
        lea bp, strMechNavi6
        call str_out

        ; write "EASY MEDIUM HARD"
        mov dh, 6
        mov dl, 9
        mov bl, 0Fh ;color
        mov cx, strMechDiffLabels_l
        lea bp, strMechDiffLabels
        call str_out

        ; write time delays
        mov dh, 15
        mov dl, 6
        mov bl, 0Bh ;color
        mov cx, strMechDiffTimeDelays_l
        lea bp, strMechDiffTimeDelays
        call str_out

        ; easy
        mov dx, 090Ah
        call calculate_pos 

        lea si, easy_map
        mov bh, 39
        mov bl, 23
        call draw_img

        ; med1
        mov dx, 1208h
        call calculate_pos        

        lea si, medium_map_1
        mov bh, 39
        mov bl, 23
        call draw_img

        ; med2
        mov dx, 120Bh
        call calculate_pos        

        lea si, medium_map_2
        mov bh, 39
        mov bl, 23
        call draw_img
        
        ; hard1
        mov dx, 1A08h
        call calculate_pos        

        lea si, hard_map_1
        mov bh, 39
        mov bl, 23
        call draw_img

        ; hard2
        mov dx, 1A0Bh
        call calculate_pos        

        lea si, hard_map_2
        mov bh, 39
        mov bl, 23
        call draw_img

        mov ch, 6
        call mech_get_resp
        ret
    mech_page_6 endp

    mech_page_7 proc
        mov ax, @data
        mov es, ax
        call cls
        call mech_print_page_defaults

        ; write "7 - VIEW LEADERBOARDS"
        mov dh, 4 ;row
        mov dl, 11 ;column
        mov bl, 0Bh ;color
        mov cx, strMechTitle7_l
        lea bp, strMechTitle7
        call str_out

        ; write "LEADERBOARDS"
        mov dh, 7 ;row
        mov dl, 14 ;column
        mov bl, 0Ah ;color
        mov cx, strMechLeaderboardsTitle_l
        lea bp, strMechLeaderboardsTitle
        call str_out

        ; write "RAF 099"
        mov dh, 9 ;row
        mov dl, 16 ;column
        mov bl, 0Fh ;color
        mov cx, strMechLeaderboardsPlyr1_l
        lea bp, strMechLeaderboardsPlyr1
        call str_out

        ; write "HAR 098"
        mov dh, 10 ;row
        mov dl, 16 ;column
        mov bl, 0Fh ;color
        mov cx, strMechLeaderboardsPlyr2_l
        lea bp, strMechLeaderboardsPlyr2
        call str_out

        ; write "ALX 097"
        mov dh, 11 ;row
        mov dl, 16 ;column
        mov bl, 0Fh ;color
        mov cx, strMechLeaderboardsPlyr3_l
        lea bp, strMechLeaderboardsPlyr3
        call str_out

        ; write "PAO 096"
        mov dh, 12 ;row
        mov dl, 16 ;column
        mov bl, 0Fh ;color
        mov cx, strMechLeaderboardsPlyr4_l
        lea bp, strMechLeaderboardsPlyr4
        call str_out

        ; write "MCH 095"
        mov dh, 13 ;row
        mov dl, 16 ;column
        mov bl, 0Fh ;color
        mov cx, strMechLeaderboardsPlyr5_l
        lea bp, strMechLeaderboardsPlyr5
        call str_out

        ; write "SAVE YOUR SCORE &"
        mov dh, 17 ;row
        mov dl, 11 ;column
        mov bl, 0Bh ;color
        mov cx, strMechInstructions7_1_l
        lea bp, strMechInstructions7_1
        call str_out

        ; write "SEE IF YOU REACHED TOP 5!"
        mov dh, 18 ;row
        mov dl, 8 ;column
        mov bl, 0Eh ;color
        mov cx, strMechInstructions7_2_l
        lea bp, strMechInstructions7_2
        call str_out

        ; write "7 OF 7"
        mov dh, 20 ;row
        mov dl, 14 ;column
        mov bl, 0Eh ;color
        mov cx, strMechNavi7_l
        lea bp, strMechNavi7
        call str_out

        mov ch, 7
        call mech_get_resp
        ret
    mech_page_7 endp

    ; gets response per page display
    mech_get_resp proc
        call resp
        cmp al, 'a'
            je mech_move_left
        cmp al, 'd'
            je mech_move_right
        cmp al, 'b'
            je goto_lead_back
            jmp skip2 
            goto_lead_back: call lead_back

        ; do not decrement if ch = 1
        mech_move_left:
            cmp ch, 1
                jne mech_move_left_dec
                je skip2
        
        ; do not increment if ch = 7
        mech_move_right:
            cmp ch, 7
                jne mech_move_right_inc
                je skip2
               
        mech_move_left_dec:
            dec ch 
            jmp skip2

        mech_move_right_inc: inc ch
        
        skip2: call navigate_mech_page
        ret
    mech_get_resp endp

    main_loop proc
        lea di, food_pos
        mov bp, food_seed
        call rng
        lea di, rotten_pos
        mov bp, rotten_seed
        call rng

        mov eat_streak, 0

        lea si, snake_pos
        mov word ptr [si], 0A0Ah ; snake's initial position 
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
        
        start: mov snake_length, 0 ; reset score for next game loop
        game_loop:
            call header
            call input
            cmp paused, 1
            jz do_paused
            call draw
            call move
            call cls
            jmp game_loop
            do_paused:
                mov dh, 12
                mov dl, 16
                mov bl, 0Eh
                lea bp, strPaused 
                mov cx, strPaused_l
                call str_out
            jmp game_loop
        ; should never reach this
            mov ah, 4ch
            int 21h
    main_loop endp

    printsp proc    ; print space
        space: 
            mov ah, 02h
            mov dl, 20h
            int 21h 
        loop space
        ret
    printsp endp

    printnl proc    ; print newline
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

    header proc
        mov ax, @data
        mov es, ax 

        mov ax, 1300h ; interrupt for write string
        mov bx, 000Fh ; set page number and color of string
        mov dh, 0 ; row
        mov dl, 0 ; col
        mov cx, strScore_l ; size of string
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

        mov bp, strScore_l
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

            mov ax, strScore_l
            mov bx, bp
            sub bx, ax
            cmp bx, 2
            jle print   

        mov ax, 1300h ; interrupt for write string
        mov bx, 000Fh ; set page number and color of string
        mov dx, 40
        sub dx, strSnek_l ; col
        mov cx, strSnek_l ; size of string
        lea bp, strSnek ; string in es:bp 
        int 10h
        ret
    header endp 

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

        update:
            cmp paused, 1
            jz back
            mov ah, key_pressed
            mov prev_key, ah
            mov key_pressed, al           
    back: ret 
    input endp

    draw proc
        mov ax, @data
        mov ds, ax 
        lea si, snake_pos
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
            mov bh, 8
            mov bl, 8
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
                mov bh, 8
                mov bl, 8
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

            mov ax, @data
            mov ds, ax
            mov bl, eat_streak

            mov ax, @code
            mov ds, ax
            cmp bl, 5
            je load_super
            lea si, food_map
            jmp draw_apple
            load_super: 
                lea si, super_apple
            draw_apple:
            mov bh, 8
            mov bl, 8
            call draw_img

            mov ax, @data 
            mov ds,  ax 
            mov dx, rotten_pos
            call calculate_pos
            
            mov ax, @code
            mov ds, ax
            lea si, rotten_apple
            mov bh, 8
            mov bl, 8
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
                mov bh, 8
                mov bl, 8
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

        lea si, active_wall_pos
        mov bp, word ptr [si]
        draw_wall: 
            add si, 2
            mov dx, word ptr [si]
            push si
            call calculate_pos 
            mov ax, @code 
            mov ds, ax
            lea si, wall
            mov bh, 8
            mov bl, 8
            call draw_img 
            pop si 
            mov ax, @data
            mov ds, ax 
            dec bp 
            cmp bp, 0
            jne draw_wall
        draw_easy:  
            ret
    draw endp

    calculate_pos proc ; args: dx = coordinate | ret: di = coord in vram
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
    calculate_pos endp

    draw_img proc   ; args: si = bitmap addr | bx = sprite dimensions (bh=height, hl=width) ; NOTE: calculate the position of the sprite first
        mov ax, 0A000h  ; vram segment
        mov es, ax   
        mov cl, bl  
        y_axis:
            push di
                mov ch, bh
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
        dec cl 
        jnz y_axis
        ret
    draw_img endp 

    rng proc       ; args : di = addr of variable  |  bp = seed
        mov ax, @data
        mov ds, ax
    randstart:
        mov ah, 00h
        int 1ah 
        xor dx, bp

        mov ax, dx 
        xor dx, dx 
        mov cx, 15h ; make sure y coord does not go out of bounds
        div cx 

        inc dl 
        mov bl, dl ; y coord
        
        mov ah, 00h
        int 1ah
        xor dx, bp 

        mov ax, dx 
        xor dx, dx 
        mov cx, 25h ; make sure x coord does not go out of bounds
        div cx 
        
        inc dl
        mov bh, dl  ; x coord

        mov word ptr [di], bx   ; update coordinates of the variable in the given address (either rotten_pos or food_pos)

        lea si, border_pos
        mov bp, 0
        find_border:
            cmp bp, 28h+28h+18h+18h
            jg cont
            mov ax, word ptr [si]
            mov bx, word ptr [di]
            cmp ax, bx 
            je randstart    ; generate another coord if already occupied by a wall
            inc bp 
            add si, 2
            jmp find_border

        cont:
            cmp difficulty, 0
            je snake_col

           lea si, active_wall_pos
        init_wall:
        mov bp, word ptr [si]
        find_wall:
            cmp bp, 0
            je snake_col
            add si, 2
            dec bp 
            mov ax, word ptr [si]
            mov bx, word ptr [di]
            cmp ax, bx 
            je randstart    ; generate another coord if food_pos is already occupied by a wall
            jmp find_wall
        snake_col:
            lea si, snake_pos 
            mov bp, snake_length 
            snake_loop:
                cmp bp, 0
                je rngdone
                dec bp
                mov ax, word ptr [si]
                mov bx, word ptr [di] 
                cmp ax, bx 
                je genagain ; generate another coord if food_pos is already occupied by snake
                add si, 2
                jmp snake_loop
        genagain: 
            mov bx, di
            call rng
        rngdone:
            ret
    rng endp 

    move proc
        mov ax, @data
        mov ds, ax
        
        cmp difficulty, 0 
        je easydelay
        cmp difficulty, 1
        je meddelay
        cmp difficulty, 2
        je harddelay 
        
        easydelay: ; 125000 microsec (1e848h)
            mov cx, 1
            mov dx, 0e848h
            jmp calldelay
        meddelay:  ; 100000 microsec (186a0h)
            mov cx, 1
            mov dx, 86a0h
            jmp calldelay
        harddelay: ; 85000 microsec (14c08h)
            mov cx, 1
            mov dx, 4c08h
        calldelay:
            call delay

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
            ;200,000 microseconds
            mov cx, 0fh
            mov dx, 4240h 
            call delay 
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

            food_collision:
                lea si, snake_pos
                lea di, food_pos
                mov ax, word ptr [si]
                mov bx, word ptr [di]

                inc ah
                cmp ah, bh 
                jng rotten_collision 
                dec ah 

                inc bh
                cmp ah, bh
                jnl rotten_collision

                inc al
                cmp al, bl 
                jng rotten_collision 
                dec al

                inc bl
                cmp al, bl
                jnl rotten_collision 

                cmp eat_streak, 5
                je superapl
                inc snake_length
                inc eat_streak
                jmp rand
                superapl:
                    add snake_length, 3
                    mov eat_streak, 0                    
                rand: 
                    lea di, food_pos
                    mov bp, food_seed
                    call rng

            rotten_collision:
                lea si, snake_pos
                lea di, rotten_pos
                mov ax, word ptr [si]
                mov bx, word ptr [di]

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

                cmp snake_length, 0
                jne decrlife
                jmp stop

                decrlife:
                    ; reset coords of the snake's tail 
                    ; (fixes issue wherein old tail is drawn on the coordinate where snake last ate a rotten apple)
                    mov bx, snake_length
                    shl bx, 1   ; basically bx *= 2
                    mov word ptr [si+bx], 0

                    dec snake_length                    
                    lea di, rotten_pos
                    mov bp, rotten_seed
                    call rng 
                
            wall_collision:
                mov ax, @data
                mov ds, ax 
                lea di, snake_pos 

                cmp difficulty, 0
                je return 

                lea si, active_wall_pos
                mov bp, word ptr [si] ; get length of active wall array
                check_wall_col:
                    dec bp
                    cmp bp, 0
                    jl return
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
    return: 
        ret
    move endp

    ;DELAY args: cx dx = time in micro sec
    delay proc   
        mov ah, 86h    ;WAIT.
        int 15h
        ret
    delay endp   

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
    rotten_apple:
        DB 00h,00h,00h,06h,06h,00h,00h,00h  
        DB 00h,00h,0Ah,00h,00h,02h,00h,00h  
        DB 00h,02h,0Fh,02h,0Ah,02h,02h,00h  
        DB 00h,0Fh,06h,06h,02h,06h,02h,00h  
        DB 00h,06h,06h,02h,06h,06h,06h,00h  
        DB 00h,06h,06h,06h,06h,07h,07h,00h  
        DB 00h,00h,06h,06h,07h,07h,00h,00h  
        DB 00h,00h,00h,00h,00h,00h,00h,00h  
    super_apple:
        DB 00h,00h,00h,0Ch,0Ch,00h,00h,00h  
        DB 00h,00h,0Eh,00h,00h,0Eh,00h,00h  
        DB 00h,0Eh,0Fh,0Eh,0Eh,0Eh,0Eh,00h  
        DB 00h,0Fh,0Dh,0Dh,0Eh,0Dh,0Eh,00h  
        DB 00h,0Dh,0Dh,0Eh,0Dh,0Dh,0Dh,00h  
        DB 00h,0Dh,0Dh,0Dh,0Dh,05h,05h,00h  
        DB 00h,00h,0Dh,0Dh,05h,05h,00h,00h  
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
    
    log_border_left:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30
        DB 00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,0Ah,02h,02h,02h,02h,02h,02h,0Ah,00h ; 1
        DB 00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,0Eh,02h,02h,02h,02h,02h,02h,02h,0Ah,00h ; 2
        DB 00h,06h,06h,0Dh,0Dh,06h,06h,06h,06h,02h,02h,06h,06h,06h,06h,06h,06h,00h,0Eh,0Eh,02h,02h,02h,00h,02h,02h,02h,02h,02h,00h ; 3
        DB 00h,06h,06h,05h,05h,02h,06h,06h,06h,00h,02h,02h,06h,06h,06h,06h,00h,0Ah,0Ah,02h,02h,02h,00h,00h,02h,02h,02h,02h,02h,00h ; 4
        DB 00h,06h,06h,06h,00h,02h,06h,06h,06h,00h,06h,06h,06h,06h,06h,0Eh,0Ah,0Ah,02h,02h,02h,00h,00h,02h,02h,02h,02h,02h,0Ah,00h ; 5
        DB 00h,06h,06h,06h,00h,02h,06h,06h,06h,00h,06h,06h,0Eh,0Eh,0Eh,0Eh,02h,02h,02h,02h,00h,00h,02h,02h,02h,02h,02h,0Ah,00h,00h ; 6
        DB 00h,06h,06h,06h,00h,02h,06h,06h,06h,06h,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h ; 7
        DB 00h,06h,06h,06h,00h,02h,06h,06h,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h ; 8
        DB 00h,06h,06h,06h,06h,06h,06h,0Ah,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h ; 9
        DB 00h,06h,06h,06h,06h,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h ; 10
        DB 00h,06h,06h,06h,0Ah,0Ah,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h ; 11
        DB 00h,06h,0Ah,0Ah,0Ah,02h,00h,00h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h ; 12
        DB 00h,0Ah,0Ah,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,00h,00h,00h,00h ; 13
        DB 0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,06h,00h,00h,00h,00h,00h ; 14
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h ; 15
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h ; 16
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h ; 17
        DB 02h,02h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h ; 18
        DB 02h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,00h,06h,0Eh,0Eh,00h,00h ; 19
        DB 02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,0Eh,06h,06h,0Eh,00h,00h ; 20
        DB 02h,02h,02h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,02h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h ; 21
        DB 00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,0Dh,0Dh,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,00h,00h,06h,00h,00h ; 22
        DB 00h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,05h,05h,06h,06h,06h,06h,00h,00h,06h,06h,00h,06h,00h,00h,06h,00h,00h ; 23
        DB 00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,06h,06h,06h,00h,06h,06h,00h,06h,00h,0Eh,00h,00h,00h ; 24
        DB 00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,02h,00h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,00h,06h,00h,00h,00h ; 25
        DB 00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,02h,02h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,00h,06h,00h,00h,00h ; 26
        DB 00h,06h,06h,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,00h,06h,00h,00h,00h ; 27
        DB 00h,06h,06h,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,00h,06h,00h,00h,00h ; 28
        DB 0Ah,0Ah,06h,06h,06h,00h,06h,06h,00h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,00h,00h,06h,00h,00h ; 29
        DB 02h,0Ah,0Ah,0Ah,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,00h,06h,00h,06h,06h,00h,00h ; 30
        DB 02h,02h,02h,0Ah,0Ah,0Ah,06h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h ; 31
        DB 02h,02h,02h,02h,0Ah,0Ah,0Ah,06h,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,00h,00h,06h,0Eh,00h,00h,00h ; 32
        DB 02h,02h,02h,02h,02h,02h,0Ah,0Ah,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h ; 33
        DB 02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Dh,0Dh,06h,06h,06h,00h,00h,00h,00h,00h ; 34
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,02h,06h,06h,06h,06h,06h,06h,06h,06h,06h,05h,05h,06h,06h,06h,00h,00h,00h,00h,00h ; 35
        DB 02h,02h,02h,00h,00h,02h,02h,02h,02h,02h,02h,0Ah,0Eh,00h,06h,06h,06h,06h,06h,06h,00h,02h,06h,06h,06h,00h,00h,00h,00h,00h ; 36
        DB 00h,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,00h,00h,00h,06h,06h,06h,06h,02h,06h,06h,06h,00h,00h,00h,00h,00h ; 37
        DB 00h,00h,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,06h,06h,0Eh,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h ; 38
        DB 00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,0Eh,0Eh,0Eh,0Eh,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h ; 39
        DB 00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,02h,02h,02h,02h,0Ah,06h,06h,06h,06h,06h,00h,00h,00h,00h ; 40
        DB 00h,06h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,06h,06h,06h,00h,00h,00h,00h ; 41
        DB 00h,06h,06h,06h,06h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h ; 42
        DB 00h,06h,06h,06h,06h,06h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah,00h,00h,00h,00h ; 43
        DB 00h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,00h,00h,00h ; 44
        DB 00h,06h,06h,06h,00h,06h,06h,06h,02h,00h,00h,00h,00h,00h,00h,02h,02h,02h,00h,00h,02h,02h,02h,00h,02h,02h,0Ah,00h,00h,00h ; 45
        DB 00h,06h,06h,06h,00h,0Dh,0Dh,06h,06h,06h,06h,06h,06h,06h,00h,00h,02h,02h,00h,00h,02h,02h,02h,00h,00h,02h,02h,0Ah,00h,00h ; 46
        DB 00h,06h,06h,06h,00h,05h,05h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,02h,0Ah,00h,00h ; 47
        DB 00h,06h,06h,06h,00h,02h,02h,06h,06h,00h,00h,06h,06h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,00h ; 48
        DB 00h,06h,06h,06h,06h,06h,06h,06h,02h,06h,00h,00h,06h,06h,06h,06h,00h,00h,00h,00h,0Eh,02h,02h,02h,02h,02h,02h,02h,0Ah,00h ; 49
        DB 00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,0Ah,02h,02h,02h,02h,02h,02h,0Ah,00h ; 50

    log_border_right:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30
        DB 00h,0Ah,02h,02h,02h,02h,02h,02h,0Ah,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h ; 1
        DB 00h,0Ah,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h ; 2
        DB 00h,02h,02h,02h,02h,02h,00h,02h,02h,02h,0Eh,0Eh,00h,06h,06h,06h,06h,06h,06h,02h,02h,06h,06h,06h,06h,0Dh,0Dh,06h,06h,00h ; 3
        DB 00h,02h,02h,02h,02h,02h,00h,00h,02h,02h,02h,0Ah,0Ah,00h,06h,06h,06h,06h,02h,02h,00h,06h,06h,06h,02h,05h,05h,06h,06h,00h ; 4
        DB 00h,0Ah,02h,02h,02h,02h,02h,00h,00h,02h,02h,02h,0Ah,0Ah,0Eh,06h,06h,06h,06h,06h,00h,06h,06h,06h,02h,00h,06h,06h,06h,00h ; 5
        DB 00h,00h,0Ah,02h,02h,02h,02h,02h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,06h,06h,00h,06h,06h,06h,02h,00h,06h,06h,06h,00h ; 6
        DB 00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,06h,06h,06h,06h,02h,00h,06h,06h,06h,00h ; 7
        DB 00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,06h,06h,02h,00h,06h,06h,06h,00h ; 8
        DB 00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Ah,06h,06h,06h,06h,06h,06h,00h ; 9
        DB 00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,06h,06h,06h,06h,00h ; 10
        DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,0Ah,0Ah,06h,06h,06h,00h ; 11
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,00h,00h,02h,0Ah,0Ah,0Ah,06h,00h ; 12
        DB 00h,00h,00h,00h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,0Ah,0Ah,00h ; 13
        DB 00h,00h,00h,00h,00h,06h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah ; 14
        DB 00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h ; 15
        DB 00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h ; 16
        DB 00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h ; 17
        DB 00h,00h,00h,00h,0Eh,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,02h,02h ; 18
        DB 00h,00h,0Eh,0Eh,06h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,02h ; 19
        DB 00h,00h,0Eh,06h,06h,0Eh,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h ; 20
        DB 00h,00h,0Eh,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,02h,02h,02h ; 21
        DB 00h,00h,06h,00h,00h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,0Dh,0Dh,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h ; 22
        DB 00h,00h,06h,00h,00h,06h,00h,06h,06h,00h,00h,06h,06h,06h,06h,05h,05h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,06h,00h ; 23
        DB 00h,00h,00h,0Eh,00h,06h,00h,06h,06h,00h,06h,06h,06h,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h ; 24
        DB 00h,00h,00h,06h,00h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,00h,02h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h ; 25
        DB 00h,00h,00h,06h,00h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h ; 26
        DB 00h,00h,00h,06h,00h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,06h,06h,00h ; 27
        DB 00h,00h,00h,06h,00h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,06h,06h,00h ; 28
        DB 00h,00h,06h,00h,00h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,00h,06h,06h,00h,06h,06h,06h,0Ah,0Ah ; 29
        DB 00h,00h,06h,06h,00h,06h,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,0Ah,0Ah,0Ah,02h ; 30
        DB 00h,00h,0Eh,06h,06h,06h,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,0Ah,0Ah,0Ah,02h,02h,02h ; 31
        DB 00h,00h,00h,0Eh,06h,00h,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,06h,0Ah,0Ah,0Ah,02h,02h,02h,02h ; 32
        DB 00h,00h,00h,00h,0Eh,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,00h,06h,06h,0Ah,0Ah,02h,02h,02h,02h,02h,02h ; 33
        DB 00h,00h,00h,00h,00h,06h,06h,06h,0Dh,0Dh,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h ; 34
        DB 00h,00h,00h,00h,00h,06h,06h,06h,05h,05h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h ; 35
        DB 00h,00h,00h,00h,00h,06h,06h,06h,02h,00h,06h,06h,06h,06h,06h,06h,00h,0Eh,0Ah,02h,02h,02h,02h,02h,02h,00h,00h,02h,02h,02h ; 36
        DB 00h,00h,00h,00h,00h,06h,06h,06h,02h,06h,06h,06h,06h,00h,00h,00h,0Eh,0Eh,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,00h ; 37
        DB 00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,0Eh,06h,06h,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,00h,00h ; 38
        DB 00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h ; 39
        DB 00h,00h,00h,00h,06h,06h,06h,06h,06h,0Ah,02h,02h,02h,02h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h ; 40
        DB 00h,00h,00h,00h,06h,06h,06h,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,06h,00h ; 41
        DB 00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,06h,06h,06h,06h,00h ; 42
        DB 00h,00h,00h,00h,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,06h,06h,06h,06h,06h,00h ; 43
        DB 00h,00h,00h,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,00h ; 44
        DB 00h,00h,00h,0Ah,02h,02h,00h,02h,02h,02h,00h,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,02h,06h,06h,06h,00h,06h,06h,06h,00h ; 45
        DB 00h,00h,0Ah,02h,02h,00h,00h,02h,02h,02h,00h,00h,02h,02h,00h,00h,06h,06h,06h,06h,06h,06h,06h,0Dh,0Dh,00h,06h,06h,06h,00h ; 46
        DB 00h,00h,0Ah,02h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,05h,05h,00h,06h,06h,06h,00h ; 47
        DB 00h,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,06h,06h,06h,06h,00h,00h,06h,06h,02h,02h,00h,06h,06h,06h,00h ; 48
        DB 00h,0Ah,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,06h,06h,06h,06h,00h,00h,06h,02h,06h,06h,06h,06h,06h,06h,06h,00h ; 49
        DB 00h,0Ah,02h,02h,02h,02h,02h,02h,0Ah,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h ; 50
    
    easy_map:
    	;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  
        DB 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh  ; 1
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 2
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 3
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 4
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 5
    	DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 6 
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 7
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 8
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 9 
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 10
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 11
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 12
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 13
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 14
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 15
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 16
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 17
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 18
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 19
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 20
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 21
        DB 0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Fh	; 22
        DB 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh  ; 23

    medium_map_1:
    	;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh  ; 1
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 2
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 3
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 4
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 5
    	DB 0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh	; 6 
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh	; 7
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 8
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,00h,00h,0Eh,00h,00h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 9 
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 10
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 11
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 12
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,00h,00h,0Eh,00h,00h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 13
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 14
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 15
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 16
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh	; 17
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh	; 18
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 19
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 20
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 21
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh  ; 23

    medium_map_2:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh  ; 1
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 2
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 3
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 4
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 5
    	DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 6 
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 7
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 8
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 9 
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 10
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 11
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh	; 12
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 13
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 14
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 15
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 16
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 17
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 18
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 19
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 20
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 21
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh	; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh  ; 23

    hard_map_1:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch ; 1
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 2
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 3
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 4
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 5
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 6
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 7
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 8
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,00h,0Ch ; 9
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch ; 10
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 11
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 12
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 13
        DB 0Ch,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 14
        DB 0Ch,00h,00h,00h,00h,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 15
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 16
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 17
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 18
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 19
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 20
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 21
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 22
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch ; 23

    hard_map_2:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch ; 1
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 2
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 3
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,0Ch ; 4
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,0Ch ; 5
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,0Ch ; 6
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,0Ch,0Ch,00h,00h,0Ch ; 7
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,0Ch ; 8
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 9
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 10
        DB 0Ch,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,0Ch,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,0Ch ; 11
        DB 0Ch,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,0Ch,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,0Ch ; 12
        DB 0Ch,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,0Ch,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,0Ch ; 13
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 14
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 15
        DB 0Ch,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 16
        DB 0Ch,00h,00h,0Ch,0Ch,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 17
        DB 0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 18
        DB 0Ch,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 19
        DB 0Ch,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 20
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 21
        DB 0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch ; 22
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch ; 23

    w_key:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23 
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 1
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 2
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 3
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 4
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 5
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 6
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 7
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 8
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 9
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 10
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 11
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 12
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 13
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 14
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 15
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 16
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 17
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Eh ; 18
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 19
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 20
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 21
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 23

    a_key:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23 
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 1
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 2
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 3
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 4
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 5
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 6
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 7 
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 8
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 9
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 10
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 11
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 12
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 13
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 14
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 15
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 16
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 17
        DB 0Eh,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 18
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 19
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 20
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 21
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 23

    s_key:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23 
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 1
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 2
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 3
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 4
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 5
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Eh ; 6
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Eh ; 7 
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 8
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 9
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 10
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 11
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 12
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 13
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Eh ; 14
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Eh ; 15
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,00h,00h,00h,00h,00h,00h,0Eh ; 16
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 17
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 18
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 19
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 20
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 21
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 23

    d_key:
        ;   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23 
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 1
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 2
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 3
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 4
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 5
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 6
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 7 
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 8
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 9
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 10
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 11
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 12
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 13
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 14
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 15
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,0Eh ; 16
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 17
        DB 0Eh,00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 18
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 19
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 20
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 21
        DB 0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh ; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh ; 23

    snek_title:
        DB 00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        DB 00h,02h,02h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,02h,02h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,00h
        DB 02h,02h,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,02h,02h,00h,00h,00h,00h,02h,02h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,02h,02h,00h,00h,00h,00h,02h,02h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,02h,02h,00h,00h,00h,00h,02h,02h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,02h,02h,00h,00h,00h,02h,02h,0Fh,0Fh,0Fh,0Fh,02h,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,02h,00h,00h,00h,00h,02h,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,02h,00h,00h,00h,00h,02h,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,02h,00h,00h,00h,02h,0Fh,0Ah,0Ah,0Ah,0Ah,0Fh,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,0Ah,0Ah,0Ah,00h,00h,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,0Ah,0Ah,0Ah,00h,00h,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,0Ah,0Ah,0Ah,00h,00h,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,02h,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,02h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,02h,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,0Eh,0Eh,02h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,0Eh,0Eh,00h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h
        DB 02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,00h,00h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h
        DB 02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,02h
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,0Eh,0Eh,0Eh,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,00h,00h,00h,00h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h
        DB 02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,00h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,00h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,00h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,00h,00h,00h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h
        DB 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h

    menu_bg_left_1: ;56x144
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,06h,0Eh,06h,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,0Ch,00h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,0Ch,00h,00h,00h,00h,0Eh,06h,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,0Ch,0Ch,0Ch,0Ch,00h,0Eh,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,00h,0Eh,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,00h,0Eh,0Eh,0Eh,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,00h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,0Eh,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,0Eh,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,0Eh,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,00h,0Eh,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
    DB 06h,06h,06h,06h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,06h,00h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h
    DB 06h,06h,06h,00h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h
    DB 06h,06h,00h,06h,06h,06h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,0Eh
    DB 06h,06h,00h,06h,06h,06h,00h,06h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,0Eh,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,02h
    DB 06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,00h,00h,00h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,02h
    DB 06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,06h,06h,00h,00h,00h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,02h
    DB 00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,06h,00h,00h,00h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h
    DB 0Eh,0Eh,0Eh,00h,06h,06h,00h,06h,06h,06h,06h,06h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,00h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,0Eh,0Eh,0Eh
    DB 0Ah,0Ah,0Ah,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,06h
    DB 0Ah,0Ah,0Ah,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,06h
    DB 02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h
    DB 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh
    DB 06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,06h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,06h,06h,06h,06h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,06h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,06h,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 06h,00h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 0Eh,0Eh,0Eh,0Eh,00h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,00h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,00h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah

    menu_bg_left_2: ;48x72
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,06h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,0Eh,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,0Eh,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,0Eh,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah

    menu_bg_mid: ;104x24
    DB 00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h
    DB 00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h
    DB 00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h
    DB 00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
    DB 00h,00h,00h,00h,0Ah,0Eh,0Eh,0Eh,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h
    DB 00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h
    DB 00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h
    DB 00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,00h
    DB 0Eh,0Eh,0Eh,00h,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,02h,02h,00h,0Eh
    DB 02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,00h,0Ah
    DB 02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,00h,0Ah
    DB 00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Eh
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah

    menu_bg_right_2: ;72x72
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,02h,00h,00h,00h,00h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,00h,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Eh,0Eh,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,02h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Eh,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,02h,00h,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,00h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,0Eh,0Eh,0Eh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,0Eh,0Eh,0Eh,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,02h,02h,02h,02h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,0Eh,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h,02h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Eh,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Eh,0Eh,0Eh,0Eh,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,00h,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h
    DB 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h
    DB 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h
    DB 0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah

    menu_bg_right_1: ;40x112
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,00h,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,0Eh,06h,0Eh,06h,06h,06h,00h,0Ch,00h,0Ch,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,00h,00h,00h,00h,0Ch,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,00h,00h,00h,0Eh,00h,0Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,0Eh,0Eh,0Eh,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,06h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,0Eh,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,06h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 0Eh,0Eh,0Eh,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,0Eh,0Eh,0Eh,0Eh,00h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,02h,02h,02h,02h,00h,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,02h,02h,02h,02h,0Eh,00h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 02h,02h,02h,02h,02h,02h,02h,02h,0Eh,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,00h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,00h,06h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,02h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,0Eh,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,00h,0Eh,0Eh,0Eh,0Eh,06h,06h,06h,06h,06h,06h,06h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,02h,02h,02h,06h,06h,06h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,0Eh,0Eh,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,02h,02h,02h,06h,06h,06h,06h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,0Eh,02h,02h,02h,06h,06h,06h,06h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,0Eh,06h,06h,06h,06h,00h,00h,06h,06h,06h,06h,06h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,06h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,0Eh,0Eh,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,02h,02h,06h,06h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,02h,02h,0Eh,0Eh,0Eh,0Eh,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 00h,00h,00h,00h,02h,02h,02h,06h,06h,06h,06h,0Eh,0Eh,0Eh,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Eh,0Eh,0Eh,0Eh,00h,02h,02h,06h,06h,06h,06h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,06h,06h,06h,06h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,06h,06h,06h,06h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,06h,06h,06h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h
    DB 0Ah,0Ah,0Ah,0Ah,00h,00h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h,02h,02h,02h
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h
    DB 02h,02h,02h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h
    DB 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,00h,00h
    DB 02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,02h,02h,02h,02h,02h,02h,02h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
    DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah

end