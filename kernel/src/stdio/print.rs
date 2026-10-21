use core::fmt::{Arguments, Write};

use crate::WRITER;

#[doc(hidden)]
pub fn _print(args: Arguments) {
    let mut writer = WRITER.lock();
    write!(writer, "{}", args);
}

#[doc(hidden)]
pub fn _println(args: Arguments) {
    let mut writer = WRITER.lock();
    writeln!(writer, "{}", args);
}

