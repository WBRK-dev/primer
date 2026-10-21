use core::fmt::Write;
use core::panic::PanicInfo;

use crate::{WRITER, driver::vga::{Color, VGA}, println};

#[panic_handler]
fn panic_handler(info: &PanicInfo) -> ! {
    if let Some(mut vga) = WRITER.try_lock() {
        vga.background = Color::Red;
        vga.foreground = Color::White;
        let _ = write!(vga, "{}\n", info);
        loop {}
    }

    let mut vga = VGA::new();
    vga.background = Color::Red;
    vga.foreground = Color::White;
    let _ = write!(vga, "{}\n", info);

    loop {}
}
