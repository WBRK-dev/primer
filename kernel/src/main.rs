#![no_std]
#![no_main]

use core::fmt::Write;

use crate::driver::vga::VGA;

mod boot;
mod driver;
mod panic_handler;

const PRINT_MESSAGE: &'static str = "Hello from Rust!";

#[unsafe(no_mangle)]
pub extern "C" fn kmain() -> ! {
    let mut vga = VGA::new();

    for i in 0..28 {
        let _ = write!(vga, "{} {}\n", PRINT_MESSAGE, i);
    }
    vga.write_string("> \nTest");

    loop {}
}
