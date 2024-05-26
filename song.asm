.model small 
.stack 0E000h           
.data

  sii dw 2415       ;B
  la  dw 2711       ;A
  sol dw 3043       ;G
  fa  dw 3416       ;F
  mi  dw 3619       ;E
  re  dw 4061       ;D
  do  dw 4560       ;C
  
  C_low dw 9121
  Csh_low dw 8609
  D_low dw 8126
  Dsh_low dw 7670
  E_low dw 7239
  F_low dw 6833
  Fsh_low dw 6449
  G_low dw 6087
  Gsh_low dw 5746
  A_low dw 5423
  Ash_low dw 5119
  B_low dw 4831
  
  C dw 4560
  Csh dw 4304
  D dw 4063
  Dsh dw 3834
  E dw 3619
  F dw 3416
  Fsh dw 3224
  G dw 3043
  Gsh dw 2873
  A dw 2711
  Ash dw 2559
  B dw 2415
    
  clock equ es:6Ch  ; clock in es 
  tone dw ?         ; declare an empty tone variable
    
.code
  
  delay proc                  ; to create a delay in the song
    push ax               
    mov ax,40h               
    mov es,ax                 
    mov ax,[clock]
    
    InitialBeat:
      cmp ax, [clock]
      mov cx, 2               
      je InitialBeat
    
    LoopDelay:
      mov ax, [clock]
      beat:
        cmp ax,[clock]
        je beat
        loop LoopDelay
        pop ax
      ret
  delay endp   

  ; to produce sound using the sound card  
  sounder proc
    push ax
    in al, 61h
    or al, 00000011b          ; access the sound card
    out 61h, al 	            ; send control word to change frequency
    mov al, 0B6h
    out 43h, al
    mov ax, [tone]            ; tone is used to fetch the note from the reference
    out 42h, al               ; send lower byte
    mov al, ah
    out 42h, al               ; send upper byte
    pop ax
    ret
  sounder endp

  ; to turn off the sound
  silence proc             
      in al,61h
      and al, 11111100b       ; close the sound card (inverse of access sound card)
      out 61h, al
      ret
  silence endp 

  press macro p1
      push bx
      mov bx,[p1]             ; insert the pressed note parameter into bx
      mov [tone],bx           ; put bx into tone to produce sound
      pop bx
      call sounder            ; call sounder to produce sound from bx insertion
  endm 

  part_1 macro
    press Fsh_low
    call delay
    call delay
    call silence

    press C
    call delay
    call silence

    press Csh
    call delay
    call silence

    press Gsh
    call delay
    call silence
    call delay

    press Csh
    call delay
    call delay
    call silence

    press Gsh_low
    call delay
    call silence
    call delay

    press C
    call delay
    call silence

    press Csh
    call delay
    call silence
    call delay
    
    press Gsh_low
    call delay
    call silence
    call delay
  endm

.startup 

  ; First part
 
  
  press E
  call delay 
  call delay 
  call delay
  call silence
  call delay
  call delay 
  call delay 
  
  press E
  call delay 
  call delay 
  call delay
  call silence
  call delay
  call delay 
  call delay 
  
  press E
  call delay 
  call delay 
  call delay
  call silence
  call delay
  call delay 
  call delay 
  
  press E
  call delay 
  call delay 
  call delay
  call silence
  call delay
  call delay 
  call delay 
  
  
  mov ah, 4ch
  int 21h
end   