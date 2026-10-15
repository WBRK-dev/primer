bits 16
org 0x8000

    mov ax, 0x0000
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
    mov al, KERNEL_SECTORS
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

    lgdt [gdt_descriptor]            ; Load entries into GDT

to_kernel:
    cli

    mov eax, cr0
    or al, 0b00000001
    mov cr0, eax

    jmp 0x0008:protected_mode        ; Far jump to kernel

failed:
    push ax
    call print_nl
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

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

gdt_start:
    db 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
    db 0b11111111, 0b11111111, 0b00000000, 0b00000000, 0b00000000, 0b10011010, 0b11001111, 0b00000000
    db 0b11111111, 0b11111111, 0b00000000, 0b00000000, 0b00000000, 0b10010010, 0b11001111, 0b00000000
gdt_end:

%include "boot/lib/print.asm"
%include "boot/lib/a20.asm"

bits 32
protected_mode:
    mov ax, 0x0010
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x7C00
    mov fs, ax
    mov gs, ax

    jmp 0x20000

times 512 - ($ - $$) db 0
