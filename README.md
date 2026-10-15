# Primer

My first attempt at creating a simple bootloader and kernel.

Without AI

## Roadmap
- [x] First stage
  - [x] Load second stage into memory
- [x] Second stage
  - [x] Load kernel into memory
  - [x] Enable A20
  - [x] GDT
  - [x] Set up segment registers and stack
  - [x] Switch to 32 bit mode
- [ ] Kernel
  - [x] Bare-metal Rust-project (`no_std`, `no_main`, eigen 32-bit target)
  - [x] Linker script: kernel op 0x20000, `_start` als eerste code, platte binary
  - [x] Bootloader laadt de kernel met meerdere sectoren (grootte niet meer hardcoded)
  - [ ] `_start` die in een halt-lus eindigt (bewijs dat Rust-code draait)
  - [ ] Panic handler
  - [ ] VGA-tekstdriver (karakter, kleur, nieuwe regel, scrollen)
  - [ ] `print!` / `println!` via `core::fmt::Write`
  - [ ] Seriële uitvoer (COM1) voor debuggen
  - [ ] IDT en exception handlers (geen triple fault bij een fout)
  - [ ] PIC herprogrammeren en timer-interrupt
  - [ ] Toetsenbord (PS/2) via interrupts
  - [ ] Geheugenkaart ophalen (E820, vanuit de bootloader)
  - [ ] Fysieke frame-allocator
  - [ ] Paging
  - [ ] Kernel heap (`alloc`)
