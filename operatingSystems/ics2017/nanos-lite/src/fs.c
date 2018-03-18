#include "fs.h"

typedef struct {
  char *name;
  size_t size;
  off_t disk_offset;
  off_t open_offset;
} Finfo;

enum {FD_STDIN, FD_STDOUT, FD_STDERR, FD_FB, FD_EVENTS, FD_DISPINFO, FD_NORMAL};

extern void ramdisk_read(void *buf, off_t offset, size_t len);
extern void ramdisk_write(const void *buf, off_t offset, size_t len);
extern void dispinfo_read(void *buf, off_t offset, size_t len);
extern void fb_write(const void *buf, off_t offset, size_t len);
extern size_t events_read(void *buf, size_t len);
extern size_t strlen_dispinfo(void);

/* This is the information about all files in disk. */
static Finfo file_table[] __attribute__((used)) = {
  {"stdin (note that this is not the actual stdin)", 0, 0},
  {"stdout (note that this is not the actual stdout)", 0, 0},
  {"stderr (note that this is not the actual stderr)", 0, 0},
  [FD_FB] = {"/dev/fb", 0, 0},
  [FD_EVENTS] = {"/dev/events", 0, 0},
  [FD_DISPINFO] = {"/proc/dispinfo", 128, 0},
#include "files.h"
};

#define NR_FILES (sizeof(file_table) / sizeof(file_table[0]))

void init_fs() {
  // TODO: initialize the size of /dev/fb

  Finfo *fb_info = &file_table[FD_FB];
  size_t fb_sz = _screen.width * _screen.height * sizeof(uint32_t);
  fb_info->size = fb_sz;

  Finfo *disp_info = &file_table[FD_DISPINFO];
  disp_info->size = strlen_dispinfo();
}

int fs_open(const char *pathname, int flags, int mode) {
  int fd = -1;

  if (pathname == NULL) {
    return fd;
  }

  for (int i = 0, nr_files = NR_FILES; i < nr_files; ++i) {
    if (strcmp(file_table[i].name, pathname) == 0) {
      fd = i;
      break;
    }
  }

  if (fd != -1) {
    file_table[fd].open_offset = 0;
  }

  return fd;
}

ssize_t fs_read(int fd, void *buf, size_t len) {
  size_t nr_read = -1;

  if (fd < FD_STDIN || fd >= NR_FILES) {
    return nr_read;
  }

  switch (fd) {
    case FD_STDIN:
    case FD_STDOUT:
    case FD_STDERR:
    case FD_FB:
    {
      nr_read = 0;
      break;
    }
    case FD_EVENTS:
    {
      nr_read = events_read(buf, len);
      break;
    }
    case FD_DISPINFO:
    {
      Finfo *finfo = &file_table[fd];
      nr_read = finfo->size - finfo->open_offset;
      nr_read = (nr_read < len) ? nr_read : len;
      dispinfo_read(buf, finfo->open_offset, nr_read);
      finfo->open_offset += nr_read;
      break;
    }
    default:
    {
      assert(buf);
      Finfo *finfo = &file_table[fd];
      nr_read = finfo->size - finfo->open_offset;
      nr_read = (nr_read < len) ? nr_read : len;
      ramdisk_read(buf, finfo->disk_offset + finfo->open_offset, nr_read);
      finfo->open_offset += nr_read;
      break;
    }
  }

  return nr_read;
}

ssize_t fs_write(int fd, const void *buf, size_t len) {
  size_t nr_write = -1;
  char *_buf = (char *)buf;

  if (fd < FD_STDIN || fd >= NR_FILES) {
    return nr_write;
  }

  switch (fd) {
    case FD_STDOUT:
    case FD_STDERR:
    {

      nr_write = 0;

      while (len > 0) {
        _putc(_buf[nr_write]);
        --len;
        ++nr_write;
      }

      break;
    }
    case FD_FB:
    {
      Finfo *finfo = &file_table[fd];
      nr_write = finfo->size - finfo->open_offset;
      nr_write = (nr_write < len) ? nr_write : len;
      fb_write(buf, finfo->open_offset, nr_write);
      finfo->open_offset += nr_write;
      break;
    }
    case FD_STDIN:
    case FD_EVENTS:
    case FD_DISPINFO:
    {
      nr_write = 0;
      break;
    }
    default:
    {
      assert(buf);
      Finfo *finfo = &file_table[fd];
      nr_write = finfo->size - finfo->open_offset;
      nr_write = (nr_write < len) ? nr_write : len;
      ramdisk_write(buf, finfo->disk_offset + finfo->open_offset, nr_write);
      finfo->open_offset += nr_write;
      break;
    }
  }

  return nr_write;
}

off_t fs_lseek(int fd, off_t offset, int whence) {
  off_t result_offset = -1;

  if (fd < FD_STDIN || fd >= NR_FILES) {
    return result_offset;
  }

  if (fd > FD_STDERR && fd < NR_FILES) {
    Finfo *finfo = &file_table[fd];

    switch (whence) {
      case SEEK_SET:
        result_offset = offset;
        result_offset = (result_offset >= 0 && result_offset <= finfo->size) ? result_offset : -1;
        finfo->open_offset = (result_offset != -1) ? result_offset : finfo->open_offset;
        break;
      case SEEK_CUR:
        result_offset = finfo->open_offset + offset;
        result_offset = (result_offset >= 0 && result_offset <= finfo->size) ? result_offset : -1;
        finfo->open_offset = (result_offset != -1) ? result_offset : finfo->open_offset;
        break;
      case SEEK_END:
        result_offset = finfo->size + offset;
        result_offset = (result_offset >= 0 && result_offset <= finfo->size) ? result_offset : -1;
        finfo->open_offset = (result_offset != -1) ? result_offset : finfo->open_offset;
        break;
      default:
        break;
    }
  }

  return result_offset;
}

int fs_close(int fd) {
  if (fd < FD_STDIN || fd >= NR_FILES) {
    return -1;
  } else {
    file_table[fd].open_offset = 0;
    return 0;
  }
}

size_t fs_filesz(int fd) {
  if (fd < FD_NORMAL || fd >= NR_FILES) {
    return -1;
  } else {
    return file_table[fd].size;
  }
}
