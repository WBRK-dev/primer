bits 32
org 0x20000

    ; Put print to VGA here

halt:
    hlt
    jmp halt

times 512 - ($ - $$) db 0
