/* Some parameters for the placement of the runtime stack in the buffer lab */
#define STACK_SIZE 0x100000
#ifdef STACK
#define START_ADDR (void *) STACK
#else
#define START_ADDR (void *) 0x55586000
#endif
