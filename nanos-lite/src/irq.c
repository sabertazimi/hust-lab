#include "common.h"

extern _RegSet* do_syscall(_RegSet *r);
extern _RegSet* schedule(_RegSet *prev);

static _RegSet* do_event(_Event e, _RegSet* r) {
  _RegSet* ret = NULL;

  switch (e.event) {
    case _EVENT_SYSCALL:
      ret = do_syscall(r);
      break;
    case _EVENT_TRAP:
    case _EVENT_IRQ_TIME:
      ret = schedule(r);
      break;
    default: panic("Unhandled event ID = %d", e.event);
  }

  return ret;
}

void init_irq(void) {
  _asye_init(do_event);
}
