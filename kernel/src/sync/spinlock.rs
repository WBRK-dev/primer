use core::{cell::UnsafeCell, ops::{Deref, DerefMut}, sync::atomic::{AtomicBool, Ordering}};

pub struct Spinlock<T> {
    value: UnsafeCell<T>,
    lock: AtomicBool,
}

impl<T: Sync + Send> Spinlock<T> {
    pub const fn new(value: T) -> Self {
        Self {
            value: UnsafeCell::new(value),
            lock: AtomicBool::new(false),
        }
    }

    pub fn lock(&self) -> SpinlockWriteGuard<'_, T> {
        while self.lock.compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed).is_err() { }
        SpinlockWriteGuard::new(self, &self.value)
    }

    pub fn try_lock(&self) -> Option<SpinlockWriteGuard<'_, T>> {
        match self.lock.compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed) {
            Ok(_) => Some(SpinlockWriteGuard::new(self, &self.value)),
            Err(_) => None,
        }
    }
}

unsafe impl<T: Send + Sync> Send for Spinlock<T> {}
unsafe impl<T: Send + Sync> Sync for Spinlock<T> {}

pub struct SpinlockWriteGuard<'a, T> {
    value: &'a UnsafeCell<T>,
    lock: &'a Spinlock<T>,
}

impl<'a, T> SpinlockWriteGuard<'a, T> {
    pub fn new(lock: &'a Spinlock<T>, value: &'a UnsafeCell<T>) -> Self {
        Self {
            value,
            lock,
        }
    }
}

impl<'a, T> Deref for SpinlockWriteGuard<'a, T> {
    type Target = T;
    fn deref(&self) -> &Self::Target {
        unsafe {
            &*self.value.get()
        }
    }
}

impl<'a, T> DerefMut for SpinlockWriteGuard<'a, T> {
    fn deref_mut(&mut self) -> &mut T {
        unsafe {
            &mut *self.value.get()
        }
    }
}

impl<'a, T> Drop for SpinlockWriteGuard<'a, T> {
    fn drop(&mut self) {
        self.lock.lock.store(false, Ordering::Release);
    }
}
