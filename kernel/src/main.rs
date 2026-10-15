#![no_std]
#![no_main]

mod boot;
mod panic_handler;

const PRINT_MESSAGE: &'static [u8; 16] = b"Hello from Rust!";

#[unsafe(no_mangle)]
pub extern "C" fn kmain() -> ! {
    for (i, c) in PRINT_MESSAGE.iter().enumerate() {
        let vga_value: u16 = 0x0F00 | *c as u16;
        let address = (0xB8000 + i * 2) as *mut u16;
        unsafe {
            core::ptr::write_volatile(address, vga_value);
        }
    }

    loop {}
}
