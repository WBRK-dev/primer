#![no_std]
#![no_main]

use crate::driver::vga::VGA;
use crate::sync::spinlock::Spinlock;

mod boot;
mod sync;
mod stdio;
mod driver;
mod panic_handler;

static WRITER: Spinlock<VGA> = Spinlock::new(VGA::new());

#[unsafe(no_mangle)]
pub extern "C" fn kmain() -> ! {
    {
        let vga = WRITER.lock();
        vga.clear_screen();
    }

    println!("[   OK   ] Started kernel");
    println!("[   OK   ] Started stdio");
    println!("[   OK   ] Started serial");

    loop {}
}
