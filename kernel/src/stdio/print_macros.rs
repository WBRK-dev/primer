#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => {
        $crate::stdio::print::_print(format_args!($($arg)*));
    };
}

#[macro_export]
macro_rules! println {
    ($($arg:tt)*) => {
        $crate::stdio::print::_println(format_args!($($arg)*));
    };
}
