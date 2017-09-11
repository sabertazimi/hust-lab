#include "common.h"
#include "syscall.h"

#define _STDOUT 1
#define _STDERR 2
#define SYSCALL_RET SYSCALL_ARG1(r)

_RegSet* do_syscall_none(uintptr_t *args, _RegSet *r) {
  SYSCALL_RET = 1;
  return r;
}

_RegSet* do_syscall_write(uintptr_t *args, _RegSet *r) {
  int fd = args[1];
  char* buf = (char *)args[2];
  int nr_buf = args[3];
  int nr_out = -1;

  if (fd == _STDOUT || fd == _STDERR) {
    nr_out = 0;

    while (nr_buf > 0) {
      _putc(buf[nr_out]);
      --nr_buf;
      ++nr_out;
    }
  }

  SYSCALL_RET = nr_out;

  return r;
}

_RegSet* do_syscall_exit(uintptr_t *args, _RegSet *r) {
  _halt(args[1]);
  return r;
}

_RegSet* do_syscall_brk(uintptr_t *args, _RegSet *r) {
  SYSCALL_RET = 0;
  return r;
}

_RegSet* do_syscall(_RegSet *r) {
  uintptr_t a[4];
  a[0] = SYSCALL_ARG1(r);
  a[1] = SYSCALL_ARG2(r);
  a[2] = SYSCALL_ARG3(r);
  a[3] = SYSCALL_ARG4(r);

  switch (a[0]) {
    case SYS_none:
      return do_syscall_none(a, r);
    case SYS_open:
      TODO();
      break;
    case SYS_read:
      TODO();
      break;
    case SYS_write:
      return do_syscall_write(a, r);
    case SYS_exit:
      return do_syscall_exit(a, r);
    case SYS_kill:
      TODO();
      break;
    case SYS_getpid:
      TODO();
      break;
    case SYS_close:
      TODO();
      break;
    case SYS_lseek:
      TODO();
      break;
    case SYS_brk:
      return do_syscall_brk(a, r);
    case SYS_fstat:
      TODO();
      break;
    case SYS_time:
      TODO();
      break;
    case SYS_signal:
      TODO();
      break;
    case SYS_execve:
      TODO();
      break;
    case SYS_fork:
      TODO();
      break;
    case SYS_link:
      TODO();
      break;
    case SYS_unlink:
      TODO();
      break;
    case SYS_wait:
      TODO();
      break;
    case SYS_times:
      TODO();
      break;
    case SYS_gettimeofday:
      TODO();
      break;
    default: panic("Unhandled syscall ID = %d", a[0]);
  }

  return NULL;
}
