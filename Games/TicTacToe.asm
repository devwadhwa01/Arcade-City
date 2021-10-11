;Microprocessor Project

;Dev Wadhwa 19BCE0444
;Grihit Budhiraja 19BCE2141
;Anusha Mandal 19BCE2211
;B. Ashwin Janardhan 19BCE2443
;Shashwat Ashar 19BCE0808

data segment           
    arcade_city_start db "Arcade City", 13, 10, "$"
    menu_1 db "1. Tic Tac Toe", 13, 10, "$"
    menu_2 db "2. Hangman", 13, 10, "$"
    menu_3 db "3. Ping Pong", 13, 10, "$"
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
ends


stack segment
    dw   128  dup(?)
ends         


code segment
;arcade_city:
    ; set segment registers
    ;mov ax, data
    ;mov ds, ax
    ;lea dx, arcade_city_start 
    ;call print
    ;lea dx, menu_1 
    ;call print
    ;lea dx, menu_2 
    ;call print
    ;lea dx, menu_3  
        

start_tic_tac_toe:
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
    jmp finish    
  
     
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
       
    
read_keyboard: ;read keyboard
    mov ah, 1       
    int 21h      
    ret      
      
      
finish:
    jmp finish         
      

code ends

end start_tic_tac_toe
