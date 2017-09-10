#include "common.h"
#include "syscall.h"

_RegSet* do_syscall_none(_RegSet *r) {
  SYSCALL_ARG1(r) = 1;
  return r;
}

_RegSet* do_syscall_exit(_RegSet *r) {
  _halt(SYSCALL_ARG2(r));
  return r;
}

_RegSet* do_syscall(_RegSet *r) {
  uintptr_t a[4];
  a[0] = SYSCALL_ARG1(r);

  switch (a[0]) {
    case SYS_none:
      return do_syscall_none(r);
    case SYS_exit:
      return do_syscall_exit(r);
    default: panic("Unhandled syscall ID = %d", a[0]);
  }

  return NULL;
}
