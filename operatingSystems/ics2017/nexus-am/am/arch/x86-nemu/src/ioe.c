#include <am.h>
#include <x86.h>

#define RTC_PORT 0x48   // Note that this is not standard
static unsigned long boot_time;

// for keyboard
#define I8042_DATA_PORT 0x60
#define I8042_STATUS_PORT 0x64
#define I8042_STATUS_HASKEY_MASK 0x1

void _ioe_init() {
  boot_time = inl(RTC_PORT);
}

unsigned long _uptime() {
  return inl(RTC_PORT) - boot_time;
}

uint32_t* const fb = (uint32_t *)0x40000;

_Screen _screen = {
  .width  = 400,
  .height = 300,
};

extern void* memcpy(void *, const void *, int);

#define SCREEN_INDEX(x, y) ((y) * _screen.width + (x))

void _draw_rect(const uint32_t *pixels, int x, int y, int w, int h) {
  int pixel_start = 0;

  for (int j = y; j < y + h; ++j, pixel_start += w) {
    memcpy(fb + SCREEN_INDEX(x, j), pixels + pixel_start, sizeof(uint32_t) * w);
  }
}

void _draw_sync() {
}

int _read_key() {
  return ((inb(I8042_STATUS_PORT) & I8042_STATUS_HASKEY_MASK)
      ? inl(I8042_DATA_PORT)
      : _KEY_NONE);
}
