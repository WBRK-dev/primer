bits 16
org 0x7C00


    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov [BOOT_DRIVE], dl
    sti
    cld


    mov ah, 0x00
    mov al, 0x03  ; text mode 80x25 16 colours
    int 0x10

    mov si, booted_string
    call print_string
    call print_nl

    mov ax, 0x0000
    mov es, ax
    mov ah, 2h
    mov al, 1
    mov bx, 0x8000
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]
    int 0x13                    ; Load second stage into memory

    jc failed

    mov dl, [BOOT_DRIVE]
    jmp 0x0000:0x8000           ; Far jump to second stage



failed:
    push ax
    mov si, second_stage_failed_string
    call print_string
    pop ax
    call print_hex

halt:
    hlt
    jmp halt


BOOT_DRIVE db 0


booted_string db "Loaded first stage...", 0
second_stage_failed_string db "Failed to load second stage, 0x", 0


%include "boot/lib/print.asm"


times 510 - ($ - $$) db 0
dw 0xAA55
