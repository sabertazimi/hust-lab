#include "common.h"
#include "fs.h"
#include "memory.h"

#define DEFAULT_ENTRY ((char *)0x8048000)

uintptr_t loader(_Protect *as, const char *filename) {
  int ret = 0;

  int fd = fs_open(filename, 0, 0);
  assert(fd != -1);
  size_t file_size = fs_filesz(fd);

  for (uint32_t i = 0; i < file_size; i += PGSIZE) {
    uint32_t *pa = (uint32_t *)new_page();
    uint32_t *va = (uint32_t *)(DEFAULT_ENTRY + i);
    _map(as, va, pa);
    ret = fs_read(fd, pa, PGSIZE);
    assert(ret != -1);
  }

  ret = fs_close(fd);
  assert(ret != -1);

  return (uintptr_t)DEFAULT_ENTRY;
}
