#include "common.h"

#define NAME(key) \
  [_KEY_##key] = #key,

static const char *keyname[256] __attribute__((used)) = {
  [_KEY_NONE] = "NONE",
  _KEYS(NAME)
};

size_t events_read(void *buf, size_t len) {
  return 0;
}

static char dispinfo[128] __attribute__((used));

size_t strlen_dispinfo(void) {
  return strlen(dispinfo);
}

void dispinfo_read(void *buf, off_t offset, size_t len) {
  if (buf == NULL) {
    return;
  }

  char *_buf = buf;
  strncpy(_buf, dispinfo + offset, len);
  _buf[len] = '\0';
}

typedef struct _point {
  int x;
  int y;
} _point;

static _point get_pixel_pos(off_t offset) {
  int x = 0;
  int y = 0;
  int is_valid_pixel = false;

  for (int byte_off = offset / sizeof(uint32_t); y < _screen.height; ++y) {
    x = byte_off - y * _screen.width;

    if (x < _screen.width) {
      is_valid_pixel = true;
      break;
    }
  }

  _point pt = {-1, -1};

  if (is_valid_pixel == true) {
    pt.x = x;
    pt.y = y;
  }

  return pt;
}

void fb_write(const void *buf, off_t offset, size_t len) {
  if (buf == NULL) {
    return ;
  }

  _point start_pt = get_pixel_pos(offset);
  _point end_pt = get_pixel_pos(offset + len);

  for (int i = start_pt.x, j = start_pt.y; j <= end_pt.y; i = 0, ++j) {
    _draw_rect(buf, i, j, _screen.width - i, 1);
  }
}

void init_device() {
  _ioe_init();

  // TODO: print the string to array `dispinfo` with the format
  // described in the Navy-apps convention

  sprintf(dispinfo, "WIDTH:%d\nHEIGHT:%d", _screen.width, _screen.height);
}
