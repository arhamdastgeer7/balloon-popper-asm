[org 100h]

segment .text

start:
    mov ah, 0
    mov al, 03h+
    int 10h

    call draw_border
    call show_title  
    call show_balloons
    call show_help
    call show_start_msg
    
    mov ah, 00h
    int 16h

    mov ax, 4C00h
    int 21h

draw_border:
    mov ax, 0600h
    mov bh, 17h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 1
    int 10h
    mov cx, 78
    mov al, '-'
    mov ah, 0Eh
top_line:
    int 10h
    loop top_line
    
    mov ah, 02h
    mov bh, 0
    mov dh, 23
    mov dl, 1
    int 10h
    mov cx, 78
    mov al, '-'
    mov ah, 0Eh
bottom_line:
    int 10h
    loop bottom_line
    ret

show_title:
    mov ah, 02h
    mov bh, 0
    mov dh, 3
    mov dl, 25
    int 10h
    mov dx, game_name
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 4
    mov dl, 29
    int 10h
    mov dx, game_type
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 6
    mov dl, 30
    int 10h
    mov cx, 20
    mov al, '='
    mov ah, 0Eh
title_line:
    int 10h
    loop title_line
    ret

show_balloons:
    mov ah, 02h
    mov bh, 0
    mov dh, 9
    mov dl, 20
    int 10h
    mov dx, balloon1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 11
    mov dl, 35
    int 10h
    mov dx, balloon2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 13
    mov dl, 50
    int 10h
    mov dx, balloon3
    mov ah, 09h
    int 21h
    ret

show_help:
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 25
    int 10h
    mov dx, help1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 17
    mov dl, 25
    int 10h
    mov dx, help2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 18
    mov dl, 25
    int 10h
    mov dx, help3
    mov ah, 09h
    int 21h
    ret

show_start_msg:
    mov ah, 02h
    mov bh, 0
    mov dh, 21
    mov dl, 28
    int 10h
    mov dx, start_msg
    mov ah, 09h
    int 21h
    ret

segment .data
game_name   db 'BALLOON POP GAME$'
game_type   db 'TYPING CHALLENGE$'
balloon1    db '(O)',13,10,' A $'
balloon2    db '(O)',13,10,' M $'
balloon3    db '(O)',13,10,' X $'
help1       db '-> TYPE LETTERS TO POP BALLOONS$'
help2       db '-> BE FAST FOR MORE POINTS$'
help3       db '-> DON"T LET THEM ESCAPE!$'
start_msg   db 'PRESS ANY KEY TO BEGIN$'