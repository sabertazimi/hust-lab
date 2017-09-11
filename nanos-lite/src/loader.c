#include "common.h"
#include "fs.h"

#define DEFAULT_ENTRY ((void *)0x4000000)

uintptr_t loader(_Protect *as, const char *filename) {
  int ret = 0;

  int fd = fs_open(filename, 0, 0);
  assert(fd != -1);
  size_t file_size = fs_filesz(fd);

  ret = fs_read(fd, DEFAULT_ENTRY, file_size);
  assert(ret != -1);

  ret = fs_close(fd);
  assert(ret != -1);

  return (uintptr_t)DEFAULT_ENTRY;
}
