org 100h

jmp start

;  DATA SECTION 
game_state db 0
score dw 0
timer dw 0
ticks db 0
level db 1
level_score_target dw 50

balloon1 db 1, 20, 12, 'A', 0Ch
balloon2 db 1, 20, 26, 'S', 0Eh  
balloon3 db 1, 20, 40, 'D', 0Bh
balloon4 db 1, 20, 54, 'F', 0Dh
balloon5 db 1, 20, 66, 'G', 0Ah
balloon6 db 0, 20, 18, 'H', 09h
balloon7 db 0, 20, 48, 'J', 0Fh

rand_seed dw 0

; BALLOON text - PERFECTLY CLEAN VERSION
balloon_line1 db ' ####   ##   #      #      ####   ####  #   # ', 0
balloon_line2 db ' #   # #  #  #      #     #    # #    # ##  # ', 0
balloon_line3 db ' ####  ####  #      #     #    # #    # # # # ', 0
balloon_line4 db ' #   # #  #  #      #     #    # #    # #  ## ', 0
balloon_line5 db ' ####  #  #  #####  #####  ####   ####  #   # ', 0

subtitle1 db '        -= TYPING MASTER CHALLENGE =-', 0
start_prompt db '       >>> PRESS SPACE TO START <<<       $'

; Level selection screen
level_title db 'SELECT YOUR LEVEL', 0
level1_txt db '[1] BEGINNER  - 5 Balloons, Slow Speed', 0
level2_txt db '[2] MEDIUM    - 6 Balloons, Medium Speed', 0
level3_txt db '[3] ADVANCED  - 7 Balloons, Fast Speed!', 0
select_prompt db 'Press 1, 2, or 3 to select level', 0

game_title db 'BALLOON POPPER', 0
score_txt db 'SCORE:', 0
time_txt db 'TIME:', 0
level_txt db 'LVL:', 0
ceiling_line db '================================================', 0

b_top db '  .-""-.  ', 0
b_up db ' /      \ ', 0
b_mid db '|   X   |', 0
b_low db ' \      / ', 0
b_bot db '  `-,,-`  ', 0
b_str1 db '    ||    ', 0
b_str2 db '    ||    ', 0

pop3 db '  - * -  ', 0

; GAME OVER text - PERFECTLY CLEAN VERSION
game_over1 db '  ####  # #   #   #  ####      ####  #   # ####  #### ', 0
game_over2 db ' #     #   #  ## ##  #        #    # #   # #     #  #', 0
game_over3 db ' # ### #####  # # #  ###      #    # #   # ####  #### ', 0
game_over4 db ' #   # #   #  #   #  #        #    #  # #  #     #  # ', 0
game_over5 db '  #### #   #  #   #  #####     ####    #   ####  #   #', 0

final_score_txt db 'YOUR FINAL SCORE:', 0
restart_txt db 'PRESS [SPACE] TO PLAY AGAIN', 0

congrats_msg db 'AMAZING REFLEXES!', 0
good_msg db 'WELL DONE!', 0
try_msg db 'NICE TRY!', 0

beginner_msg db 'BEGINNER MODE', 0
medium_msg db 'MEDIUM MODE', 0
advanced_msg db 'ADVANCED MODE', 0

;     MAIN PROGRAM 
start:
    call init_random
    
main_loop:
    cmp byte [game_state], 0
    jne check_playing
    call draw_level_select
    call wait_for_level_select
    mov byte [game_state], 1
    call init_game
    jmp main_loop

check_playing:
    cmp byte [game_state], 1
    jne show_end
    call game_loop
    jmp main_loop

show_end:
    call draw_end_screen
    call wait_for_key_end
    jmp main_loop

;  LEVEL SELECTION 
draw_level_select:
    call clear_screen_blue
    
    ; Draw BALLOON text
    mov dh, 2
    mov dl, 15
    call set_cursor
    mov si, balloon_line1
    mov bl, 8Ch
    call print_string_color
    
    mov dh, 3
    mov dl, 15
    call set_cursor
    mov si, balloon_line2
    mov bl, 8Eh
    call print_string_color
    
    mov dh, 4
    mov dl, 15
    call set_cursor
    mov si, balloon_line3
    mov bl, 8Ah
    call print_string_color
    
    mov dh, 5
    mov dl, 15
    call set_cursor
    mov si, balloon_line4
    mov bl, 8Bh
    call print_string_color
    
    mov dh, 6
    mov dl, 15
    call set_cursor
    mov si, balloon_line5
    mov bl, 8Dh
    call print_string_color
    
    ; Level selection
    mov dh, 10
    mov dl, 25
    call set_cursor
    mov si, level_title
    mov bl, 0Fh
    call print_string_color
    
    mov dh, 13
    mov dl, 18
    call set_cursor
    mov si, level1_txt
    mov bl, 0Ah
    call print_string_color
    
    mov dh, 15
    mov dl, 18
    call set_cursor
    mov si, level2_txt
    mov bl, 0Eh
    call print_string_color
    
    mov dh, 17
    mov dl, 18
    call set_cursor
    mov si, level3_txt
    mov bl, 0Ch
    call print_string_color
    
    mov dh, 20
    mov dl, 21
    call set_cursor
    mov si, select_prompt
    mov bl, 0Bh
    call print_string_color
    ret

wait_for_level_select:
    mov ah, 0
    int 16h
    cmp al, '1'
    je level_1_selected
    cmp al, '2'
    je level_2_selected
    cmp al, '3'
    je level_3_selected
    jmp wait_for_level_select

level_1_selected:
    mov byte [level], 1
    ret

level_2_selected:
    mov byte [level], 2
    ret

level_3_selected:
    mov byte [level], 3
    ret

;  INITIALIZATION 
init_random:
    mov ah, 0
    int 1Ah
    mov [rand_seed], dx
    ret

init_game:
    mov word [score], 0
    mov word [timer], 0
    mov byte [ticks], 0
    
    ; Initialize balloons based on level
    mov byte [balloon1], 1
    mov byte [balloon1+1], 20
    mov byte [balloon1+2], 12
    mov byte [balloon2], 1
    mov byte [balloon2+1], 20
    mov byte [balloon2+2], 26
    mov byte [balloon3], 1
    mov byte [balloon3+1], 20
    mov byte [balloon3+2], 40
    mov byte [balloon4], 1
    mov byte [balloon4+1], 20
    mov byte [balloon4+2], 54
    mov byte [balloon5], 1
    mov byte [balloon5+1], 20
    mov byte [balloon5+2], 66
    
    ; Activate balloon 6 for medium and advanced
    cmp byte [level], 1
    je skip_balloon6
    mov byte [balloon6], 1
    mov byte [balloon6+1], 20
    mov byte [balloon6+2], 18
skip_balloon6:
    
    ; Activate balloon 7 only for advanced
    cmp byte [level], 3
    jne skip_balloon7
    mov byte [balloon7], 1
    mov byte [balloon7+1], 20
    mov byte [balloon7+2], 48
skip_balloon7:
    
    call generate_random_letters
    ret

generate_random_letters:
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok1
    sub al, 6
gen_ok1:
    mov [balloon1+3], al
    
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok2
    sub al, 6
gen_ok2:
    mov [balloon2+3], al
    
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok3
    sub al, 6
gen_ok3:
    mov [balloon3+3], al
    
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok4
    sub al, 6
gen_ok4:
    mov [balloon4+3], al
    
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok5
    sub al, 6
gen_ok5:
    mov [balloon5+3], al
    
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok6
    sub al, 6
gen_ok6:
    mov [balloon6+3], al
    
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna gen_ok7
    sub al, 6
gen_ok7:
    mov [balloon7+3], al
    ret

get_random:
    push dx
    mov ax, [rand_seed]
    mov dx, 8405h
    mul dx
    inc ax
    mov [rand_seed], ax
    pop dx
    ret

;   GAME SCREEN 
draw_game_screen:
    call clear_screen_blue
    
    mov dh, 0
    mov dl, 0
    call set_cursor
    mov ah, 09h
    mov al, ' '
    mov bl, 70h
    mov cx, 80
    int 10h
    
    mov dh, 0
    mov dl, 28
    call set_cursor
    mov si, game_title
    mov bl, 70h
    call print_string_color
    
    mov dh, 0
    mov dl, 2
    call set_cursor
    mov si, score_txt
    mov bl, 70h
    call print_string_color
    mov dl, 9
    call set_cursor
    mov ax, [score]
    mov bl, 70h
    call print_number_color
    
    mov dh, 0
    mov dl, 60
    call set_cursor
    mov si, level_txt
    mov bl, 70h
    call print_string_color
    mov dl, 65
    call set_cursor
    mov al, [level]
    add al, '0'
    mov ah, 09h
    mov cx, 1
    int 10h
    
    mov dh, 0
    mov dl, 70
    call set_cursor
    mov si, time_txt
    mov bl, 70h
    call print_string_color
    mov dl, 76
    call set_cursor
    mov ax, [timer]
    mov bl, 70h
    call print_number_color
    
    mov dh, 3
    mov dl, 15
    call set_cursor
    mov si, ceiling_line
    mov bl, 0Ch
    call print_string_color
    
    mov dh, 4
    mov dl, 15
    call set_cursor
    mov si, ceiling_line
    mov bl, 0Ch
    call print_string_color
    
    mov si, balloon1
    call draw_full_balloon
    mov si, balloon2
    call draw_full_balloon
    mov si, balloon3
    call draw_full_balloon
    mov si, balloon4
    call draw_full_balloon
    mov si, balloon5
    call draw_full_balloon
    mov si, balloon6
    call draw_full_balloon
    mov si, balloon7
    call draw_full_balloon
    ret

draw_full_balloon:
    cmp byte [si], 0
    jne dfb_active
    ret
    
dfb_active:
    mov dh, [si+1]
    mov dl, [si+2]
    mov bl, [si+4]
    
    push dx
    push si
    call set_cursor
    mov si, b_top
    call print_string_color
    pop si
    pop dx
    
    inc dh
    push dx
    push si
    call set_cursor
    mov si, b_up
    call print_string_color
    pop si
    pop dx
    
    inc dh
    push dx
    call set_cursor
    mov ah, 0Eh
    mov al, '|'
    int 10h
    mov al, ' '
    int 10h
    mov al, ' '
    int 10h
    mov al, [si+3]
    int 10h
    mov al, ' '
    int 10h
    mov al, ' '
    int 10h
    mov al, ' '
    int 10h
    mov al, '|'
    int 10h
    pop dx
    
    inc dh
    push dx
    push si
    call set_cursor
    mov si, b_low
    call print_string_color
    pop si
    pop dx
    
    inc dh
    push dx
    push si
    call set_cursor
    mov si, b_bot
    call print_string_color
    pop si
    pop dx
    
    inc dh
    push dx
    push si
    call set_cursor
    mov si, b_str1
    call print_string_color
    pop si
    pop dx
    
    inc dh
    push dx
    push si
    call set_cursor
    mov si, b_str2
    call print_string_color
    pop si
    pop dx
    ret

;    GAME LOGIC 
game_loop:
game_loop_start:
    call draw_game_screen
    
    mov ah, 01h
    int 16h
    jz game_no_key
    
    mov ah, 0
    int 16h
    
    cmp al, 27
    je game_exit
    
    cmp al, 'a'
    jb game_check
    cmp al, 'z'
    ja game_check
    sub al, 32
    
game_check:
    call check_balloon_match
    
game_no_key:
    call update_balloons
    
    call check_ceiling_collision
    cmp al, 1
    je game_over_now
    
    ; Speed based on level
    cmp byte [level], 1
    je delay_beginner
    cmp byte [level], 2
    je delay_medium
    jmp delay_advanced

delay_beginner:
    mov cx, 0xFFFF
delay_beg1:
    nop
    nop
    nop
    nop
    loop delay_beg1
    
    mov cx, 0xFFFF
delay_beg2:
    nop
    nop
    loop delay_beg2
    
    mov cx, 0xFFFF
delay_beg3:
    nop
    loop delay_beg3
    jmp delay_done

delay_medium:
    mov cx, 0xEFFF
delay_med1:
    nop
    nop
    nop
    loop delay_med1
    
    mov cx, 0xAFFF
delay_med2:
    nop
    nop
    loop delay_med2
    jmp delay_done

delay_advanced:
    mov cx, 0x9FFF
delay_adv1:
    nop
    nop
    loop delay_adv1
    
    mov cx, 0x4FFF
delay_adv2:
    nop
    loop delay_adv2

delay_done:
    inc byte [ticks]
    cmp byte [ticks], 45
    jb game_skip_timer
    mov byte [ticks], 0
    inc word [timer]
    
game_skip_timer:
    jmp game_loop_start
    
game_over_now:
    mov byte [game_state], 2
    ret
    
game_exit:
    mov ax, 4C00h
    int 21h

check_balloon_match:
    mov si, balloon1
    call match_letter
    mov si, balloon2
    call match_letter
    mov si, balloon3
    call match_letter
    mov si, balloon4
    call match_letter
    mov si, balloon5
    call match_letter
    mov si, balloon6
    call match_letter
    mov si, balloon7
    call match_letter
    ret

match_letter:
    cmp byte [si], 0
    jne match_active
    ret
    
match_active:
    cmp al, [si+3]
    je match_found
    ret
    
match_found:
    push si
    mov dh, [si+1]
    mov dl, [si+2]
    call show_pop_effect
    pop si
    
    mov byte [si], 0
    add word [score], 10
    
    call beep
    
    call spawn_new_balloon
    ret

show_pop_effect:
    push dx
    call set_cursor
    mov si, pop3
    mov bl, 0Eh
    call print_string_color
    pop dx
    ret

spawn_new_balloon:
    mov si, balloon1
    cmp byte [si], 0
    je spawn_found
    mov si, balloon2
    cmp byte [si], 0
    je spawn_found
    mov si, balloon3
    cmp byte [si], 0
    je spawn_found
    mov si, balloon4
    cmp byte [si], 0
    je spawn_found
    mov si, balloon5
    cmp byte [si], 0
    je spawn_found
    
    ; Check level for balloon 6
    cmp byte [level], 1
    je spawn_return
    mov si, balloon6
    cmp byte [si], 0
    je spawn_found
    
    ; Check level for balloon 7
    cmp byte [level], 3
    jne spawn_return
    mov si, balloon7
    cmp byte [si], 0
    je spawn_found

spawn_return:
    ret
    
spawn_found:
    mov byte [si], 1
    mov byte [si+1], 22
    
    cmp si, balloon1
    je spawn_pos1
    cmp si, balloon2
    je spawn_pos2
    cmp si, balloon3
    je spawn_pos3
    cmp si, balloon4
    je spawn_pos4
    cmp si, balloon5
    je spawn_pos5
    cmp si, balloon6
    je spawn_pos6
    cmp si, balloon7
    je spawn_pos7
    ret
    
spawn_pos1:
    mov byte [si+2], 12
    jmp spawn_letter
spawn_pos2:
    mov byte [si+2], 26
    jmp spawn_letter
spawn_pos3:
    mov byte [si+2], 40
    jmp spawn_letter
spawn_pos4:
    mov byte [si+2], 54
    jmp spawn_letter
spawn_pos5:
    mov byte [si+2], 66
    jmp spawn_letter
spawn_pos6:
    mov byte [si+2], 18
    jmp spawn_letter
spawn_pos7:
    mov byte [si+2], 48
    
spawn_letter:
    call get_random
    and al, 19h
    add al, 'A'
    cmp al, 'Z'
    jna spawn_let_ok
    sub al, 6
spawn_let_ok:
    mov [si+3], al
    ret

update_balloons:
    mov si, balloon1
    call move_up
    mov si, balloon2
    call move_up
    mov si, balloon3
    call move_up
    mov si, balloon4
    call move_up
    mov si, balloon5
    call move_up
    mov si, balloon6
    call move_up
    mov si, balloon7
    call move_up
    ret

move_up:
    cmp byte [si], 0
    jne move_active
    ret
move_active:
    dec byte [si+1]
    ret

check_ceiling_collision:
    mov al, 0
    mov si, balloon1
    cmp byte [si], 0
    je check_b2
    cmp byte [si+1], 7
    ja check_b2
    mov al, 1
    ret
check_b2:
    mov si, balloon2
    cmp byte [si], 0
    je check_b3
    cmp byte [si+1], 7
    ja check_b3
    mov al, 1
    ret
check_b3:
    mov si, balloon3
    cmp byte [si], 0
    je check_b4
    cmp byte [si+1], 7
    ja check_b4
    mov al, 1
    ret
check_b4:
    mov si, balloon4
    cmp byte [si], 0
    je check_b5
    cmp byte [si+1], 7
    ja check_b5
    mov al, 1
    ret
check_b5:
    mov si, balloon5
    cmp byte [si], 0
    je check_b6
    cmp byte [si+1], 7
    ja check_b6
    mov al, 1
    ret
check_b6:
    mov si, balloon6
    cmp byte [si], 0
    je check_b7
    cmp byte [si+1], 7
    ja check_b7
    mov al, 1
    ret
check_b7:
    mov si, balloon7
    cmp byte [si], 0
    je check_done
    cmp byte [si+1], 7
    ja check_done
    mov al, 1
check_done:
    ret

;     END SCREEN 
draw_end_screen:
    call clear_screen_blue
    
    ; Draw GAME OVER
    mov dh, 5
    mov dl, 10
    call set_cursor
    mov si, game_over1
    mov bl, 8Ch
    call print_string_color
    
    mov dh, 6
    mov dl, 10
    call set_cursor
    mov si, game_over2
    mov bl, 8Eh
    call print_string_color
    
    mov dh, 7
    mov dl, 10
    call set_cursor
    mov si, game_over3
    mov bl, 8Ah
    call print_string_color
    
    mov dh, 8
    mov dl, 10
    call set_cursor
    mov si, game_over4
    mov bl, 8Bh
    call print_string_color
    
    mov dh, 9
    mov dl, 10
    call set_cursor
    mov si, game_over5
    mov bl, 8Dh
    call print_string_color
    
    ; Show level completed
    mov dh, 11
    mov dl, 32
    call set_cursor
    cmp byte [level], 1
    je show_beginner
    cmp byte [level], 2
    je show_medium
    mov si, advanced_msg
    mov bl, 0Ch
    jmp show_level_msg
show_beginner:
    mov si, beginner_msg
    mov bl, 0Ah
    jmp show_level_msg
show_medium:
    mov si, medium_msg
    mov bl, 0Eh
show_level_msg:
    call print_string_color
    
    mov dh, 13
    mov dl, 30
    call set_cursor
    mov ax, [score]
    cmp ax, 100
    jae end_amazing
    cmp ax, 50
    jae end_good
    mov si, try_msg
    mov bl, 0Bh
    jmp end_show_msg
end_good:
    mov si, good_msg
    mov bl, 0Ah
    jmp end_show_msg
end_amazing:
    mov si, congrats_msg
    mov bl, 0Eh
end_show_msg:
    call print_string_color
    
    mov dh, 16
    mov dl, 28
    call set_cursor
    mov si, final_score_txt
    mov bl, 0Fh
    call print_string_color
    mov dl, 47
    call set_cursor
    mov ax, [score]
    mov bl, 0Eh
    call print_number_color
    
    mov dh, 20
    mov dl, 24
    call set_cursor
    mov si, restart_txt
    mov bl, 0Ah
    call print_string_color
    ret

;    UTILITY FUNCTIONS 
clear_screen_blue:
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h
    ret

set_cursor:
    mov ah, 02h
    mov bh, 0
    int 10h
    ret

print_string_color:
    push ax
    push bx
    push cx
psc_loop:
    lodsb
    test al, al
    jnz psc_continue
    pop cx
    pop bx
    pop ax
    ret
psc_continue:
    mov ah, 09h
    mov cx, 1
    int 10h
    
    push ax
    mov ah, 03h
    mov bh, 0
    int 10h
    inc dl
    mov ah, 02h
    int 10h
    pop ax
    
    jmp psc_loop

print_number_color:
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0
    mov bx, 10
pnc_div:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jz pnc_done_div
    jmp pnc_div
    
pnc_done_div:
pnc_print:
    pop ax
    add al, '0'
    
    push cx
    mov ah, 09h
    mov cx, 1
    int 10h
    
    push ax
    mov ah, 03h
    mov bh, 0
    int 10h
    inc dl
    mov ah, 02h
    int 10h
    pop ax
    pop cx
    
    loop pnc_print
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

wait_for_key_end:
    mov ah, 0
    int 16h
    cmp al, ' '
    je wfke_restart
    cmp al, 27
    je wfke_exit
    jmp wait_for_key_end
wfke_restart:
    mov byte [game_state], 0
    ret
wfke_exit:
    mov ax, 4C00h
    int 21h

beep:
    push ax
    push cx
    in al, 61h
    or al, 03h
    out 61h, al
    mov cx, 0x1FF
beep_loop:
    nop
    loop beep_loop
    in al, 61h
    and al, 0FCh
    out 61h, al
    pop cx
    pop ax
    ret
