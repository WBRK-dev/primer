ENTRY(_start)

SECTIONS {
    . = 0x20000;

    . = ALIGN(4);
    .text : {
        KEEP(*(.text.boot))
        *(.text .text.*)
    }

    . = ALIGN(4);
    .rodata : {
        *(.rodata .rodata.*)
    }

    . = ALIGN(4);
    .data : {
        *(.data .data.*)
    }

    . = ALIGN(4);
    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    }

    /DISCARD/ : { *(.eh_frame*) *(.comment) }
}
