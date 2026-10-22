use core::arch::global_asm;

global_asm!("
.pushsection .text.boot, \"ax\"

.global _start

_start:
    mov esp, 0x20000

    mov ecx, __bss_start
.Lset_bss_zero:
    cmp ecx, __bss_end
    je .Lcontinue

    mov byte ptr [ecx], 0
    inc ecx

    jmp .Lset_bss_zero

.Lcontinue:
    cld
    call kmain

.Lhalt:
    hlt
    jmp .Lhalt

.popsection
");
