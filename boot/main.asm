bits 16
org 0x7C00


    mov ah, 0x00
    mov al, 0x03  ; text mode 80x25 16 colours
    int 0x10

    mov si, booted_string
    call print_string
    call print_nl

listen_for_input:
    mov ah, 0
    int 0x16
    call print_char
    jmp listen_for_input


booted_string db "Loaded first stage...", 0

    
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


times 510 - ($ - $$) db 0
dw 0xAA55
