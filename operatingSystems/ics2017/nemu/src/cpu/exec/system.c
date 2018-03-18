#include "cpu/exec.h"

void diff_test_skip_qemu();
void diff_test_skip_nemu();

make_EHelper(lidt) {
  cpu.idtr.limit = vaddr_read(id_dest->addr, 2);
  cpu.idtr.base = vaddr_read(id_dest->addr + 2, 4);

  print_asm_template1(lidt);
}

make_EHelper(mov_r2cr) {
  switch (id_dest->reg) {
    case 0:
      cpu.cr0.val = id_src->val;
      break;
    case 2:
      TODO();
      break;
    case 3:
      cpu.cr3.val = id_src->val;
      break;
    default:
      panic("Can't find CR%d", id_dest->reg);
      break;
  }

  print_asm("movl %%%s,%%cr%d", reg_name(id_src->reg, 4), id_dest->reg);
}

make_EHelper(mov_cr2r) {
  switch (id_src->reg) {
    case 0:
      operand_write(id_dest, &cpu.cr0.val);
      break;
    case 2:
      TODO();
      break;
    case 3:
      operand_write(id_dest, &cpu.cr3.val);
      break;
    default:
      panic("Can't find CR%d", id_dest->reg);
      break;
  }

  print_asm("movl %%cr%d,%%%s", id_src->reg, reg_name(id_dest->reg, 4));

#ifdef DIFF_TEST
  diff_test_skip_qemu();
#endif
}

extern void raise_intr(uint8_t NO, vaddr_t ret_addr);

make_EHelper(int) {
  raise_intr(id_dest->val, *eip);

  print_asm("int %s", id_dest->str);

#ifdef DIFF_TEST
  diff_test_skip_nemu();
#endif
}

make_EHelper(iret) {
  rtl_pop(&t0);
  decoding.jmp_eip = t0;
  decoding.is_jmp = 1;
  rtl_pop((rtlreg_t *)(&cpu.cs));
  rtl_pop(&cpu.eflags.val);

  print_asm("iret");
}

uint32_t pio_read(ioaddr_t, int);
void pio_write(ioaddr_t, int, uint32_t);

make_EHelper(in) {
  id_dest->val = pio_read(id_src->val, id_dest->width);
  operand_write(id_dest, &id_dest->val);

  print_asm_template2(in);

#ifdef DIFF_TEST
  diff_test_skip_qemu();
#endif
}

make_EHelper(out) {
  pio_write(id_dest->val, id_src->width, id_src->val);

  print_asm_template2(out);

#ifdef DIFF_TEST
  diff_test_skip_qemu();
#endif
}
