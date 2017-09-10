#include "cpu/exec.h"
#include "memory/mmu.h"

void raise_intr(uint8_t NO, vaddr_t ret_addr) {
  /* TODO: Trigger an interrupt/exception with ``NO''.
   * That is, use ``NO'' to index the IDT.
   */

  // push eflags, cs, eip
  rtl_push(&cpu.eflags.val);
  cpu.eflags.IF = 0;
  rtl_push((rtlreg_t *)(&cpu.cs));
  rtl_push(&ret_addr);

  // load idt descriptor
  Log("cpu.idtr.base = 0x%08x, No = %d", cpu.idtr.base, NO);
  uint32_t gate_low = vaddr_read(cpu.idtr.base + NO * 8, 4);
  uint32_t gate_high = vaddr_read(cpu.idtr.base + NO * 8 + 4, 4);

  // seek gate descriptor, get handler address
  uint32_t handler_address = (gate_high & 0xffff0000) | (gate_low & 0x0000ffff);
  decoding.jmp_eip = handler_address;
  decoding.is_jmp = 1;
}

void dev_raise_intr() {
}
