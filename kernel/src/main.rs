#![no_std]
#![no_main]

mod boot;
mod panic_handler;

#[unsafe(no_mangle)]
pub extern "C" fn kmain() -> ! {
    loop {}
}
