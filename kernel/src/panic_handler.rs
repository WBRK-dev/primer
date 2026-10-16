use core::panic::PanicInfo;

use crate::driver::vga::{Color, VGA};

const PANIC_HEADER: &'static str = "Kernal panic:";

#[panic_handler]
fn panic_handler(info: &PanicInfo) -> ! {
    let mut vga = VGA::new();
    vga.clear_screen();
    vga.background = Color::Red;
    vga.foreground = Color::White;

    vga.write_string(PANIC_HEADER);
    vga.write_newline();
    vga.write_string(info.message().as_str().unwrap());
    vga.write_newline();

    loop {}
}
