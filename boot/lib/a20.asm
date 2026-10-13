check_a20_enabled:
    push ds
    push es
    push di
    push si

    mov ax, 0xFFFF
    mov ds, ax
    mov ax, 0x0000
    mov es, ax

    mov di, 0x0500
    mov si, 0x0510

    mov al, byte [es:di]
    push ax
    mov al, byte [ds:si]
    push ax

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFA

    cmp byte [es:di], 0xFA

    pop ax
    mov byte [ds:si], al
    pop ax
    mov byte [es:di], al

    mov ax, 0
    je .finish
    mov ax, 1

.finish:
    pop si
    pop di
    pop es
    pop ds
    ret
