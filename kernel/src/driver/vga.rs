use core::{fmt, ptr::{read_volatile, write_volatile}};

#[derive(Clone, Copy)]
pub enum Color {
    White = 0xF,
    Yellow = 0xE,
    LightMagenta = 0xD,
    LightRed = 0xC,
    LightCyan = 0xB,
    LightGreen = 0xA,
    LightBlue = 0x9,
    DarkGray = 0x8,
    LightGray = 0x7,
    Brown = 0x6,
    Magenta = 0x5,
    Red = 0x4,
    Cyan = 0x3,
    Green = 0x2,
    Blue = 0x1,
    Black = 0x0,
}

const X_MAX: u8 = 80;
const Y_MAX: u8 = 25;

pub struct VGA {
    pub foreground: Color,
    pub background: Color,
    x: u8,
    y: u8,
}

impl VGA {
    pub fn new() -> Self {
        Self {
            foreground: Color::LightGray,
            background: Color::Black,
            x: 0,
            y: 0,
        }
    }

    pub fn write_newline(&mut self) {
        for x in self.x..X_MAX {
            self.write_cell(&b' ', x, self.y);
        }

        self.x = 0;
        self.y += 1;

        self.check_y_pos();
    }

    pub fn write_string(&mut self, s: &str) {
        for c in s.as_bytes().iter() {
            if *c == b'\n' as u8 {
                self.write_newline();
                continue;
            }

            self.write_cell(c, self.x, self.y);

            self.x += 1;

            if self.x >= X_MAX {
                self.x = 0;
                self.y += 1;
                self.check_y_pos();
            }
        }
    }

    pub fn clear_screen(&self) {
        for y in 0..Y_MAX {
            for x in 0..X_MAX {
                self.write_cell(&b' ', x, y);
            }
        }
    }

    fn write_cell(&self, c: &u8, x: u8, y: u8) {
        if x >= X_MAX || y >= Y_MAX {
            return;
        }

        let vga_value: u16 = ((self.background as u16) << 12) | ((self.foreground as u16) << 8) | *c as u16;
        let address = Self::cell_ptr(x, y);
        unsafe {
            write_volatile(address, vga_value);
        }
    }

    fn shift_up(&mut self, amount: Option<u8>) {
        let amount = amount.unwrap_or(1);

        if amount >= Y_MAX || amount < 1 {
            return;
        }

        for y in amount..Y_MAX {
            for x in 0..X_MAX {
                let address_from = Self::cell_ptr(x, y);
                let address_to = Self::cell_ptr(x, y - amount);
                unsafe {
                    write_volatile(address_to, read_volatile(address_from));
                }
            }
        }

        for y in (Y_MAX - amount)..Y_MAX {
            for x in 0..X_MAX {
                self.write_cell(&b' ', x, y);
            }
        }
    }

    fn check_y_pos(&mut self) {
        if self.y >= Y_MAX {
            self.shift_up(Some(self.y + 1 - Y_MAX));
            self.y = Y_MAX - 1;
        }
    }

    // SAFETY: Always returns 0xB8000 - 0xBFFFF
    fn cell_ptr(x: u8, y: u8) -> *mut u16 {
        if x >= X_MAX || y >= Y_MAX {
            return 0xB8000 as *mut u16;
        }

        return (0xB8000 + x as u32 * 2 + y as u32 * 2 * X_MAX as u32) as *mut u16
    }
}

impl fmt::Write for VGA {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        self.write_string(s);
        Ok(())
    }
}
