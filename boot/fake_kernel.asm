bits 32
org 0x20000

    ; Put print to VGA here

    mov word [0xB8000], 0x0F42

halt:
    hlt
    jmp halt

times 512 - ($ - $$) db 0
