enable_a20:
    call .check_a20_enabled

    cmp ax, 1
    je .ret_success

    mov ax, 1
    call .set_a20

    call .check_a20_enabled
    cmp ax, 1
    je .ret_success

    mov ax, 0
    ret

.ret_success:
    mov ax, 1
    ret

.check_a20_enabled:
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

.set_a20:                                  ; AX = 0/1
    xchg ah, al
    in al, 0x92                           ; 00000010, bit 1 is the A20 bit

    and al, 0xFD                          ; Mask the A20 bit to 0

    cmp ah, 0
    je .apply

    or al, 0x02                           ; Enable the A20 bit

.apply:
    out 0x92, al
    ret
