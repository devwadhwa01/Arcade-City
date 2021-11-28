;Microprocessor Project

;Dev Wadhwa 19BCE0444
;Grihit Budhiraja 19BCE2141
;Anusha Mandal 19BCE2211
;B. Ashwin Janardhan 19BCE2443
;Shashwat Ashar 19BCE0808

data segment           
    arcade_city_start db "Arcade City", 13, 10, "$"
    menu_1 db "1. Tic Tac Toe", 13, 10, "$"
    menu_2 db "2. Snake", 13, 10, "$"
    menu_3 db "3. Hangman", 13, 10, "$"
    exit db "4. Exit", 13, 10, "$"
    enter DB "Enter your choice:", 13, 10, "$"
    new_line db 13, 10, "$"
    game_draw db "_|_|_", 13, 10
              db "_|_|_", 13, 10
              db "_|_|_", 13, 10, "$"                  
    game_pointer db 9 DUP(?)  
    win_flag db 0 
    player db "0$"     
    tic_tac_toe_over db "Game Over!", 13, 10, "$"    
    tic_tac_toe_start db "Tic-Tac-Toe", 13, 10, "$"
    player_message db "Player $"   
    win_message db " wins!$"   
    type_message db "Enter position: $"  
    star_line db "**************", 13, 10, "$"
    
    s_size  equ     7

; the snake coordinates
; (from head to tail)
; low byte is left, high byte
; is top - [top, left]
snake dw s_size dup(0)

tail    dw      ?

; directions vios keys for left,right,up and down...
left    equ     4bh
right   equ     4dh
up      equ     48h
down    equ     50h

;current snake direction is right
cur_dir db      right

wait_time dw    0

;welcome messege and rules of the game
msg1 	db "=========== Snake Game ===========", 0dh,0ah
	db "                                  ", 0dh,0ah
	db "=================Rules================", 0dh,0ah

	db "Eat EveryThing in the Screen and Clear the Screen.", 0dh,0ah, 0ah
	
	db "Press UP ARROW to Go UPWORD", 0dh,0ah
	db "Press DOWN ARROW to Go DOWNWORD", 0dh,0ah, 0ah
	
	db "Press LEFT ARROW to Go LEFT", 0dh,0ah	
	db "Press RIGHT ARROW to Go RIGHT", 0dh,0ah, 0ah
	
	db "======================================", 0dh,0ah, 0ah
	db "Press ESC to EXIT the Game", 0dh,0ah
	db "======================================", 0dh,0ah, 0ah
	db "Press ANY KEY to START the Game...$"
	
msg2 db ""
	
	 db " the goal is to eat the screen and clear the screen ", 0dh,0ah
	 db "   ......  .......  ........   ...................", 0dh,0ah
	 db "   ......  .......  ........   ...................", 0dh,0ah
	 db "   ..      ..   ..     ..      ...................", 0dh,0ah	
	 db "   ......  .......     ..      ...................", 0dh,0ah
	 db "   ......  .......     ..      ...................", 0dh,0ah
	 db "   ..      ..   ..     ..      ...................", 0dh,0ah
	 db "   ......  ..   ..     ..      ...................", 0dh,0ah
	 db "   ......  ..   ..     ..      ...................", 0dh,0ah
	 db "                                                 $"	

    
    
ends


stack segment
    dw   128  dup(?)
ends         


code segment    
start:
    mov ax, data
    mov ds, ax
    
    lea dx, arcade_city_start 
    call print
    
    lea dx, menu_1 
    call print
    
    lea dx, menu_2 
    call print
    
    lea dx, menu_3
    call print
    
    lea dx, exit
    call print
    
    lea dx, enter
    call print
    
    mov ax, 00H
    mov ah, 01H
    int 21H
    
    sub al, 30H
    
    cmp al, 01H
    je tic_tac_toe
    
    cmp al, 02H
    je snake_game
    
    cmp al, 04H
    je finish
    
    
tic_tac_toe:
    ; set segment registers
    mov ax, data
    mov ds, ax
    ; game start   
    call set_game_pointer             


main_loop:  
    call clrscr      
    lea dx, tic_tac_toe_start 
    call print    
    lea dx, new_line
    call print                      
    lea dx, player_message
    call print
    lea dx, player
    call print  
    lea dx, new_line
    call print    
    lea dx, game_draw
    call print        
    lea dx, new_line
    call print       
    lea dx, type_message    
    call print                               
    ; read draw position                   
    call    read_keyboard                     
    ; calculate draw position                   
    sub al, 49               
    mov bh, 0
    mov bl, al                                                                    
    call update_draw                                                                                           
    call check                         
    ; check if game ends                   
    cmp win_flag, 1  
    je game_over      
    call change_player             
    jmp main_loop   


change_player:   
    lea si, player    
    xor ds:[si], 1  
    ret      

 
update_draw:
    mov bl, game_pointer[bx]
    mov bh, 0    
    lea si, player    
    cmp ds:[si], "0"
    
    je draw_x                       
    cmp ds:[si], "1"
    
    je draw_o                            
    
    draw_x:
    mov cl, "x"
    
    jmp update
    draw_o:          
    mov cl, "o"  
    jmp update    
          
    update:         
    mov ds:[bx], cl  
    ret    
       

check:
    call check_row
    ret     
       
       
check_row:
    mov cx, 0
    check_row_loop:     
    cmp cx, 0
    je first_row
    
    cmp cx, 1
    je second_row
    
    cmp cx, 2
    je third_row  
    
    call check_column
    ret    
        
    first_row:    
    mov si, 0   
    jmp do_check_row   

    second_row:    
    mov si, 3
    jmp do_check_row
    
    third_row:    
    mov si, 6
    jmp do_check_row        

    do_check_row:
    inc cx
    mov bh, 0
    mov bl, game_pointer[si]
    mov al, ds:[bx]
    cmp al, "_"
    je check_row_loop
    inc si
    mov bl, game_pointer[si]    
    cmp al, ds:[bx]
    jne check_row_loop   
    inc si
    mov bl, game_pointer[si]  
    cmp al, ds:[bx]
    jne check_row_loop                                 
    mov win_flag, 1
    ret                
       
       
check_column:
    mov cx, 0
    check_column_loop:     
    cmp cx, 0
    je first_column
  
    cmp cx, 1
    je second_column
    
    cmp cx, 2
    je third_column  
    call check_diagonal
    ret    
        
    first_column:    
    mov si, 0   
    jmp do_check_column   

    second_column:    
    mov si, 1
    jmp do_check_column
    
    third_column:    
    mov si, 2
    jmp do_check_column        

    do_check_column:
    inc cx
    mov bh, 0
    mov bl, game_pointer[si]
    mov al, ds:[bx]
    cmp al, "_"
    je check_column_loop 
    add si, 3
    mov bl, game_pointer[si]    
    cmp al, ds:[bx]
    jne check_column_loop 
    add si, 3
    mov bl, game_pointer[si]  
    cmp al, ds:[bx]
    jne check_column_loop                                     
    mov win_flag, 1
    ret        


check_diagonal:
    mov cx, 0
    check_diagonal_loop:     
    cmp cx, 0
    je first_diagonal
    cmp cx, 1
    je second_diagonal                         
    ret    
        
    first_diagonal:    
    mov si, 0                
    mov dx, 4 
    jmp do_check_diagonal   

    second_diagonal:    
    mov si, 2
    mov dx, 2
    jmp do_check_diagonal       

    do_check_diagonal:
    inc cx  
    mov bh, 0
    mov bl, game_pointer[si]
    mov al, ds:[bx]
    cmp al, "_"
    je check_diagonal_loop    
    add si, dx
    mov bl, game_pointer[si]    
    cmp al, ds:[bx]
    jne check_diagonal_loop       
    add si, dx
    mov bl, game_pointer[si]  
    cmp al, ds:[bx]
    jne check_diagonal_loop                                          
    mov win_flag, 1
    ret  
           

game_over:        
    call clrscr   
    lea dx, tic_tac_toe_start 
    call print    
    lea dx, new_line
    call print                              
    lea dx, game_draw
    call print        
    lea dx, new_line
    call print
    lea dx, tic_tac_toe_over
    call print      
    lea dx, new_line
    call print     
    lea dx, star_line
    call print 
    lea dx, player_message
    call print    
    lea dx, player
    call print    
    lea dx, win_message
    call print
    lea dx, new_line
    call print     
    lea dx, star_line
    call print
    lea dx, new_line
    call print 
    jmp start    
  
     
set_game_pointer:
    lea si, game_draw
    lea bx, game_pointer                        
    mov cx, 9   
    
    loop_1:
    cmp cx, 6
    je add_1                    
    cmp cx, 3
    je add_1    
    jmp add_2 
    
    add_1:
    add si, 1
    jmp add_2     
      
    add_2:                                
    mov ds:[bx], si 
    add si, 2
                        
    inc bx               
    loop loop_1  
    ret
    
snake_game:

    call clrscr
    ; Printing the welcome msg
    mov dx, offset msg1 
    mov bl,2
    mov ah,9
    int 10h
    int 21h 


    ; waiting for any key to start.... 
    mov ah, 00h
    int 16h   


    ;to clear the sceen
	mov ax, 03H
	int 10H

    ;printing the game background which the user have to clean.
    mov dx, offset msg2
    mov ah, 9 
    int 21h 	
	

    ;hiding the cursor blinking text cursor....
    mov     ah, 1
    mov     ch,2bh
    mov     cl,0bh
    int     10h           


game_loop:


    ;showing the new head of the snake...
    mov     dx, snake[0]


    mov     ah, 02h
    int     10h

    ;printing * at the location we set the cursor...
    mov     al, '*' 
    mov     ah, 09h

    mov     bl, 0ch 
    mov     cx, 1  
    int     10h

    ;saving the tail
    mov     ax, snake[s_size * 2 - 2]
    mov     tail, ax

    call    move_snake


    ;========hiding old tail==========
    mov     dx, tail

    mov     ah, 02h
    int     10h

    mov     al, ' '
    mov     ah, 09h
    mov     bl, 0eh 
    mov     cx, 1   
    int     10h



check_for_key:

    ;=======checking if any command user gives

    mov     ah, 01h
    int     16h
    jz      no_key 

    mov     ah, 00h
    int     16h

    cmp     al, 1bh     
    je      stop_game  

    mov     cur_dir, ah

no_key:



; this interrupt is about getting the system time

mov     ah, 00h
int     1ah

cmp     dx, wait_time
jb      check_for_key
add     dx, 4
mov     wait_time, dx



;GAME LOOP
jmp     game_loop


stop_game:
mov     ah, 1
mov     ch, 0bh
mov     cl, 0bh
int     10h

ret

move_snake proc near

    
mov     ax, 40h
mov     es, ax

  ; Identifing the snake tail position
  mov   di, s_size * 2 - 2
  
  ; moving the whole snake
  mov   cx, s_size-1
move_array:       
  mov   ax, snake[di-2]
  mov   snake[di], ax
  sub   di, 2
  loop  move_array

   
   ; Jump according to the given instruction   
cmp     cur_dir, left
  je    move_left
cmp     cur_dir, right
  je    move_right
cmp     cur_dir, up
  je    move_up
cmp     cur_dir, down
  je    move_down

jmp     stop_move       

 ; Operation if user Press LEFT ARROW
move_left:
  mov   al, b.snake[0]
  dec   al
  mov   b.snake[0], al
  cmp   al, -1
  jne   stop_move       
  mov   al, es:[4ah]    ; col number.
  dec   al
  mov   b.snake[0], al  ; return to right.
  jmp   stop_move

  ; Operation if user Press RIGHT ARROW
move_right:
  mov   al, b.snake[0]
  inc   al
  mov   b.snake[0], al
  cmp   al, es:[4ah]    ; col number.   
  jb    stop_move
  mov   b.snake[0], 0   ; return to left.
  jmp   stop_move

  ; Operation if user Press UPWORD ARROW
move_up:
  mov   al, b.snake[1]
  dec   al
  mov   b.snake[1], al
  cmp   al, -1
  jne   stop_move
  mov   al, es:[84h]    ; row number -1.
  mov   b.snake[1], al  ; return to bottom.
  jmp   stop_move

  ; Operation if user Press DOWNWORD ARROW
move_down:
  mov   al, b.snake[1]
  inc   al
  mov   b.snake[1], al
  cmp   al, es:[84h]    ; row number -1.
  jbe   stop_move
  mov   b.snake[1], 0   ; return to top.
  jmp   stop_move

stop_move:
  ret
move_snake endp        
       
print: ;print content that is present in dx  
    mov ah, 9
    int 21h       
    ret 
    

clrscr: ;clear screen
    mov ah, 0fh
    int 10h       
    mov ah, 0
    int 10h    
    ret
       
    
read_keyboard: 
    mov ah, 1       
    int 21h      
    ret      
      
      
finish:
    end start
    code ends         
       
