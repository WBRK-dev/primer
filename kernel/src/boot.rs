use core::arch::global_asm;

global_asm!("
.pushsection .text.boot, \"ax\"

.global _start

_start:
    mov esp, 0x20000
    cld
    call kmain

.Lhalt:
    hlt
    jmp .Lhalt

.popsection
");
