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
    je .load_kernel_setup

    mov si, a20_failed_string
    call print_string
    jmp halt

.load_kernel_setup:
    mov cx, KERNEL_LOAD_LOOPS

    ; Loading the kernel into memory

load_kernel:
    mov ax, cx
    call print_hex
    dec cx

    cmp cx, 0
    jne .continue

    mov word [DAP_SECTORS], LAST_KERNEL_LOAD_LOOP_SECTORS

.continue:
    mov si, DAP
    mov dl, [BOOT_DRIVE]
    mov ah, 0x42

    int 0x13                         ; Load kernel into memory

    jc failed

    mov eax, [DAP_SECTORS]
    add dword [DAP_LBA], eax
    adc dword [DAP_LBA + 4], 0
    add word [DAP_SEGMENT], 0x400

    push cx
    mov si, loaded_kernel_string
    call print_nl
    call print_string
    pop cx
    push cx
    mov ax, cx
    call print_hex
    pop cx

    cmp cx, 0
    jne load_kernel

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

DAP         dw 0x0010
DAP_SECTORS dw 0x0020
DAP_OFFSET  dw 0x0000
DAP_SEGMENT dw 0x2000
DAP_LBA     dq 2

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
