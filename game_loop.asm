org 100h

; Set video mode 80x25
mov ax, 0003h
int 10h

; Initialize game variables
mov word [score], 0
mov word [time_left], 60  ; 60 seconds game time
mov word [balloon_count], 6
mov word [timer_counter], 0
mov byte [balloon1_burst], 0
mov byte [balloon2_burst], 0
mov byte [balloon3_burst], 0
mov byte [balloon4_burst], 0
mov byte [balloon5_burst], 0
mov byte [balloon6_burst], 0

; Game loop
game_loop:
    ; Clear screen with LIGHT NAVY BLUE background
    mov ax, 0600h
    mov bh, 17h
    mov cx, 0
    mov dx, 184Fh
    int 10h

    ; Display game header
    call display_header
    
    ; Display all balloons
    call display_balloons
    
    ; Check if time is up
    cmp word [time_left], 0
    jle game_finished
    
    ; Check if all balloons are burst
    cmp word [balloon_count], 0
    jle game_finished
    
    ; Get keyboard input
    call get_input
    
    ; Update timer
    call update_timer
    
    ; Small delay
    mov cx, 2
    mov dx, 0
    mov ah, 86h
    int 15h
    
    jmp game_loop

game_finished:
    ; Pass score to end screen
    mov ax, [score]
    mov [final_score], ax
    ret

;SUBROUTINES

display_header:
    ; Print header
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 30
    int 10h
    mov dx, header
    mov ah, 09h
    int 21h

    ; Print score label
    mov ah, 02h
    mov bh, 0
    mov dh, 3
    mov dl, 5
    int 10h
    mov dx, score_label
    mov ah, 09h
    int 21h
    
    ; Convert score to string and display
    mov ax, [score]
    call number_to_string
    mov ah, 02h
    mov bh, 0
    mov dh, 3
    mov dl, 12
    int 10h
    mov dx, number_buffer
    mov ah, 09h
    int 21h

    ; Print time label
    mov ah, 02h
    mov bh, 0
    mov dh, 3
    mov dl, 40
    int 10h
    mov dx, time_label
    mov ah, 09h
    int 21h
    
    ; Convert time to string and display
    mov ax, [time_left]
    call number_to_string
    mov ah, 02h
    mov bh, 0
    mov dh, 3
    mov dl, 46
    int 10h
    mov dx, number_buffer
    mov ah, 09h
    int 21h
    ret

display_balloons:
    ; Balloon 1 - A
    cmp byte [balloon1_burst], 1
    je .skip_balloon1
    mov ah, 02h
    mov bh, 0
    mov dh, 7
    mov dl, 15
    int 10h
    mov dx, balloon_top1
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 8
    mov dl, 15
    int 10h
    mov dx, balloon_mid1
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 9
    mov dl, 15
    int 10h
    mov dx, balloon_bottom1
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 15
    int 10h
    mov dx, balloon_string1
    mov ah, 09h
    int 21h
.skip_balloon1:

    ; Balloon 2 - S
    cmp byte [balloon2_burst], 1
    je .skip_balloon2
    mov ah, 02h
    mov bh, 0
    mov dh, 7
    mov dl, 35
    int 10h
    mov dx, balloon_top2
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 8
    mov dl, 35
    int 10h
    mov dx, balloon_mid2
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 9
    mov dl, 35
    int 10h
    mov dx, balloon_bottom2
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 35
    int 10h
    mov dx, balloon_string2
    mov ah, 09h
    int 21h
.skip_balloon2:

    ; Balloon 3 - D
    cmp byte [balloon3_burst], 1
    je .skip_balloon3
    mov ah, 02h
    mov bh, 0
    mov dh, 7
    mov dl, 55
    int 10h
    mov dx, balloon_top3
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 8
    mov dl, 55
    int 10h
    mov dx, balloon_mid3
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 9
    mov dl, 55
    int 10h
    mov dx, balloon_bottom3
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 55
    int 10h
    mov dx, balloon_string3
    mov ah, 09h
    int 21h
.skip_balloon3:

    ; Balloon 4 - F
    cmp byte [balloon4_burst], 1
    je .skip_balloon4
    mov ah, 02h
    mov bh, 0
    mov dh, 14
    mov dl, 15
    int 10h
    mov dx, balloon_top4
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 15
    mov dl, 15
    int 10h
    mov dx, balloon_mid4
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 15
    int 10h
    mov dx, balloon_bottom4
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 17
    mov dl, 15
    int 10h
    mov dx, balloon_string4
    mov ah, 09h
    int 21h
.skip_balloon4:

    ; Balloon 5 - G
    cmp byte [balloon5_burst], 1
    je .skip_balloon5
    mov ah, 02h
    mov bh, 0
    mov dh, 14
    mov dl, 35
    int 10h
    mov dx, balloon_top5
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 15
    mov dl, 35
    int 10h
    mov dx, balloon_mid5
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 35
    int 10h
    mov dx, balloon_bottom5
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 17
    mov dl, 35
    int 10h
    mov dx, balloon_string5
    mov ah, 09h
    int 21h
.skip_balloon5:

    ; Balloon 6 - H
    cmp byte [balloon6_burst], 1
    je .skip_balloon6
    mov ah, 02h
    mov bh, 0
    mov dh, 14
    mov dl, 55
    int 10h
    mov dx, balloon_top6
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 15
    mov dl, 55
    int 10h
    mov dx, balloon_mid6
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 55
    int 10h
    mov dx, balloon_bottom6
    mov ah, 09h
    int 21h
    mov ah, 02h
    mov bh, 0
    mov dh, 17
    mov dl, 55
    int 10h
    mov dx, balloon_string6
    mov ah, 09h
    int 21h
.skip_balloon6:
    ret

get_input:
    mov ah, 01h        ; Check if key pressed
    int 16h
    jz .no_input       ; No key pressed
    
    mov ah, 00h        ; Get key pressed
    int 16h
    
    ; Convert to uppercase
    cmp al, 'a'
    jb .check_key
    cmp al, 'z'
    ja .check_key
    sub al, 32         ; Convert to uppercase
    
.check_key:
    ; Check balloon keys
    cmp al, 'A'
    je .burst_balloon1
    cmp al, 'S'
    je .burst_balloon2
    cmp al, 'D'
    je .burst_balloon3
    cmp al, 'F'
    je .burst_balloon4
    cmp al, 'G'
    je .burst_balloon5
    cmp al, 'H'
    je .burst_balloon6
    jmp .no_input

.burst_balloon1:
    cmp byte [balloon1_burst], 1
    je .no_input
    mov byte [balloon1_burst], 1
    jmp .increase_score

.burst_balloon2:
    cmp byte [balloon2_burst], 1
    je .no_input
    mov byte [balloon2_burst], 1
    jmp .increase_score

.burst_balloon3:
    cmp byte [balloon3_burst], 1
    je .no_input
    mov byte [balloon3_burst], 1
    jmp .increase_score

.burst_balloon4:
    cmp byte [balloon4_burst], 1
    je .no_input
    mov byte [balloon4_burst], 1
    jmp .increase_score

.burst_balloon5:
    cmp byte [balloon5_burst], 1
    je .no_input
    mov byte [balloon5_burst], 1
    jmp .increase_score

.burst_balloon6:
    cmp byte [balloon6_burst], 1
    je .no_input
    mov byte [balloon6_burst], 1

.increase_score:
    add word [score], 10    ; Increase score by 10
    dec word [balloon_count] ; Decrease balloon count
    
.no_input:
    ret

update_timer:
    ; Simple timer - decrement every few iterations
    mov ax, [timer_counter]
    inc ax
    mov [timer_counter], ax
    cmp ax, 18         ; Adjust this value for game speed
    jb .done
    
    mov word [timer_counter], 0
    dec word [time_left]
.done:
    ret

; Convert number in AX to string
number_to_string:
    mov di, number_buffer
    mov bx, 10
    mov cx, 3          ; We want 3 digits
    
.convert_loop:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    inc di
    loop .convert_loop
    
    mov byte [di], '$' ; Null terminator
    ret

;         DATA SECTION 
header      db 'BURSTING BALLOONS$'
score_label db 'SCORE: $'
time_label  db 'TIME: $'

; Balloon ASCII art
balloon_top1    db '  ___  $'
balloon_mid1    db ' /   \ $'
balloon_bottom1 db ' \ A / $'
balloon_string1 db '  \|/  $'

balloon_top2    db '  ___  $'
balloon_mid2    db ' /   \ $'
balloon_bottom2 db ' \ S / $'
balloon_string2 db '  \|/  $'

balloon_top3    db '  ___  $'
balloon_mid3    db ' /   \ $'
balloon_bottom3 db ' \ D / $'
balloon_string3 db '  \|/  $'

balloon_top4    db '  ___  $'
balloon_mid4    db ' /   \ $'
balloon_bottom4 db ' \ F / $'
balloon_string4 db '  \|/  $'

balloon_top5    db '  ___  $'
balloon_mid5    db ' /   \ $'
balloon_bottom5 db ' \ G / $'
balloon_string5 db '  \|/  $'

balloon_top6    db '  ___  $'
balloon_mid6    db ' /   \ $'
balloon_bottom6 db ' \ H / $'
balloon_string6 db '  \|/  $'

; Game variables
score dw 0
time_left dw 0
balloon_count dw 0
timer_counter dw 0
balloon1_burst db 0
balloon2_burst db 0
balloon3_burst db 0
balloon4_burst db 0
balloon5_burst db 0
balloon6_burst db 0
number_buffer db '000$'
final_score dw 0
