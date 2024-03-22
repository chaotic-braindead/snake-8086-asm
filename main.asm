.model small
.stack 100h

.data
snake_s dw 04h
snake_x dw 0Ah
snake_y dw 0Ah
; or head_pos dw 0A0Ah (x coord on higher byte)
; snake_velocity dw 0000h (x velo on higher byte)

game db "Snake"
game_s equ $-game

play db "[1] Play"
play_s equ $-play

exit db "[2] Exit"
exit_s equ $-exit

time_now db 0

key_pressed db 0


.code 

main: 
    mov ax, @data
    mov es,ax
    mov ah, 00h
    mov al, 13h
    int 10h
    mov ah, 0Bh
    mov bh, 00h
    mov bl, 00h
    int 10h

    ;call draw_snake

    mov ah, 4ch
    int 21h

    ;game_loop:
        ; call input
        ; call draw_snake
        ;jmp game_loop

 draw_snake:
 
    mov cx, snake_x
    mov dx, snake_y
    draw_x:
        mov ah, 0ch
        mov al, 0fh
        mov bh, 00h
        int 10h
        inc cx 
        mov ax, cx
        sub ax, snake_x 
        cmp ax, snake_s 
        jng draw_x
        mov cx, snake_x
        inc dx
        mov ax, dx 
        sub ax, snake_y 
        cmp ax, snake_s 
        jng draw_x
    ret

;game_screen:
  ;  mov ax, 1300h ; interrupt for write string
  ;  mov bx, 000Fh ; set page number and color of string
   

    ;  snake title
    ;mov dh, 02 ; row
    ;mov dl, 22 ; col
    ;sub dl, game_s ; offset 
    ;mov cx, game_s ; size of string
    ;mov bp, offset game ; string in es:bp 
    ;int 10h
    
    ; options
    ;mov dh, 12 ; row 
    ;mov cx, play_s ; size of string
    ;mov bp, offset play ; string in es:bp 
    ;int 10h
    
    ;mov dh, 13 ; row
    ;mov cx, exit_s ; size of string
    ;mov bp, offset exit ; string in es:bp 
    ;int 10h

    ;ret

;input:
    ;mov ah, 01h ; get user input
    ;int 16h
    
    ;jz return

    ;mov ah, 00h
    ;int 16h
    ;cmp al, 'w'
    ;je move_up  (set snake_x_velo to 0 and snake_y_velo to -1)
    ;cmp al, 'a' 
    ;je move_left (set snake_x_velo to -1 and snake_y_velo to 0)
    ;cmp al, 's'
    ;je move_down (set snake_x_velo to 0 and snake_y_velo to 1)
    ;cmp al, 'd'
    ;je move_right (set snake_x_velo to 1 and snake_y_velo to 0)

    ;cmp al, '2' ; check if escape key
    ;jne update ; update key_pressed if not 2 
    
    ; else, exit 

    ;mov ah, 4ch
    ;int 21h

    ;update:
        ;mov key_pressed, al
        ;mov ah, 0Ah
        ;mov cx, 1
        ;int 10h
    ;return:
        ;ret 
end 

;timer:
    ;mov ah, 2ch ; get system time
    ;int 21h
    ;cmp dh, time_now
    ;je timer 
    ;mov time_now, dh
    ;* do actions here *
    ;* ex.
    ; mov ax, snake_velocity 
    ; add snake_x, ah
    ; add snake_y, al