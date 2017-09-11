#include "common.h"
#include "fs.h"

#define DEFAULT_ENTRY ((void *)0x4000000)

uintptr_t loader(_Protect *as, const char *filename) {
  int fd = fs_open(filename, 0, 0);
  assert(fd != -1);
  size_t file_size = fs_filesz(fd);
  size_t buf_size = file_size + 3;
  char buf[buf_size + 3];

  int ret = 0;
  ret = fs_read(fd, buf, file_size);
  assert(ret != -1);
  memcpy(DEFAULT_ENTRY, buf, file_size);
  ret = fs_close(fd);
  assert(ret != -1);

  return (uintptr_t)DEFAULT_ENTRY;
}
