bits 16
org 0


    mov ax, 0x1000
    mov ds, ax
    mov es, ax

    ; Second stage code here

    mov si, booted_string
    call print_string


halt:
    hlt
    jmp halt


booted_string db "Loaded second stage...", 0

%include "boot/lib/print.asm"

times 512 - ($ - $$) db 0
