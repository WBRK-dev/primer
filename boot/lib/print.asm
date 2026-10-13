print_char:             ; AL = char        (changes AH, BH)
    mov ah, 0x0E
    xor bh, bh
    int 0x10
    ret

print_string:           ; SI = pointing to string
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp print_string
.done:
    ret

print_nl:
    mov al, 13
    call print_char
    mov al, 10
    call print_char
    ret

print_hex:              ; AX = getal, print 4 hexcijfers   (bewaart alles)
    pusha
    mov cx, 4
.lus:
    rol ax, 4
    push ax
    and al, 0x0F
    cmp al, 10
    jb .cijfer
    add al, 'A' - 10 - '0'
.cijfer:
    add al, '0'
    call print_char
    pop ax
    dec cx
    jnz .lus
    popa
    ret

