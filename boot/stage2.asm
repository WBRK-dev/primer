bits 16
org 0

    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov [BOOT_DRIVE], dl

    ; Second stage code here

    mov si, booted_string
    call print_string

    ; Enable A20 if turned off

    call enable_a20
    cmp ax, 1
    je load_kernel

    mov si, a20_failed_string
    call print_string
    jmp halt

    ; Loading the kernel into memory

load_kernel:
    mov ax, 0x2000
    mov es, ax
    mov ah, 0x02
    mov al, 1
    mov bx, 0
    mov ch, 0
    mov cl, 3
    mov dh, 0
    mov dl, [BOOT_DRIVE]
    int 0x13                    ; Load kernel into memory

    jc failed

    mov si, loaded_kernel_string
    call print_nl
    call print_string

    mov dl, [BOOT_DRIVE]
    jmp 0x2000:0x0000           ; Far jump to kernel

failed:
    push ax
    mov si, kernel_failed_string
    call print_string
    pop ax
    call print_hex

halt:
    hlt
    jmp halt


booted_string db "Loaded second stage...", 0
loaded_kernel_string db "Loaded kernel...", 0
kernel_failed_string db "Failed to load kernel, 0x", 0
a20_failed_string db "Failed to enable A20", 0

BOOT_DRIVE db 0

%include "boot/lib/print.asm"
%include "boot/lib/a20.asm"

times 512 - ($ - $$) db 0
