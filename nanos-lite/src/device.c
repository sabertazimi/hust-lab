#include "common.h"

#define NAME(key) \
  [_KEY_##key] = #key,

static const char *keyname[256] __attribute__((used)) = {
  [_KEY_NONE] = "NONE",
  _KEYS(NAME)
};

static char event_buf[80];

size_t events_read(void *buf, size_t len) {
  int key = _read_key();
  bool down = false;
  char *_buf = buf;

  if (key & 0x8000) {
    key ^= 0x8000;
    down = true;
  }

  if (key != _KEY_NONE) {
    sprintf(event_buf, "k%c %s\n", down ? 'd' : 'u', keyname[key]);
  } else {
    sprintf(event_buf, "t %d\n", _uptime());
  }

  int event_len = strlen(event_buf);
  event_len = (event_len < len) ? event_len : len;
  strncpy(_buf, event_buf, event_len);
  _buf[event_len] = '\0';
  return event_len;
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
  uint32_t *pixels = (uint32_t *)buf;
  uint32_t nr_pixel = 0;

  if (start_pt.y < end_pt.y) {
    // first line
    _draw_rect(pixels + nr_pixel, start_pt.x, start_pt.y, nr_pixel, 1);
    nr_pixel = _screen.width - start_pt.x;

    _draw_rect(pixels + nr_pixel, 0, start_pt.y + 1, _screen.width, end_pt.y - start_pt.y - 1);
    nr_pixel += _screen.width * (end_pt.y - start_pt.y - 1);

    // last line
    _draw_rect(pixels + nr_pixel, 0, end_pt.y, end_pt.x, 1);
  } else {
    _draw_rect(pixels, start_pt.x, start_pt.y, end_pt.x - start_pt.x, 1);
  }
}

void init_device() {
  _ioe_init();

  // TODO: print the string to array `dispinfo` with the format
  // described in the Navy-apps convention

  sprintf(dispinfo, "WIDTH:%d\nHEIGHT:%d", _screen.width, _screen.height);
}
