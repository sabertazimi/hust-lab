#include <x86.h>

#define PG_ALIGN __attribute((aligned(PGSIZE)))

static PDE kpdirs[NR_PDE] PG_ALIGN;
static PTE kptabs[PMEM_SIZE / PGSIZE] PG_ALIGN;
static void* (*palloc_f)();
static void (*pfree_f)(void*);

_Area segments[] = {      // Kernel memory mappings
  {.start = (void*)0,          .end = (void*)PMEM_SIZE}
};

#define NR_KSEG_MAP (sizeof(segments) / sizeof(segments[0]))

void _pte_init(void* (*palloc)(), void (*pfree)(void*)) {
  palloc_f = palloc;
  pfree_f = pfree;

  int i;

  // make all PDEs invalid
  for (i = 0; i < NR_PDE; i ++) {
    kpdirs[i] = 0;
  }

  PTE *ptab = kptabs;
  for (i = 0; i < NR_KSEG_MAP; i ++) {
    uint32_t pdir_idx = (uintptr_t)segments[i].start / (PGSIZE * NR_PTE);
    uint32_t pdir_idx_end = (uintptr_t)segments[i].end / (PGSIZE * NR_PTE);
    for (; pdir_idx < pdir_idx_end; pdir_idx ++) {
      // fill PDE
      kpdirs[pdir_idx] = (uintptr_t)ptab | PTE_P;

      // fill PTE
      PTE pte = PGADDR(pdir_idx, 0, 0) | PTE_P;
      PTE pte_end = PGADDR(pdir_idx + 1, 0, 0) | PTE_P;
      for (; pte < pte_end; pte += PGSIZE) {
        *ptab = pte;
        ptab ++;
      }
    }
  }

  set_cr3(kpdirs);
  set_cr0(get_cr0() | CR0_PG);
}

void _protect(_Protect *p) {
  PDE *updir = (PDE*)(palloc_f());
  p->ptr = updir;
  // map kernel space
  for (int i = 0; i < NR_PDE; i ++) {
    updir[i] = kpdirs[i];
  }

  p->area.start = (void*)0x8000000;
  p->area.end = (void*)0xc0000000;
}

void _release(_Protect *p) {
}

void _switch(_Protect *p) {
  set_cr3(p->ptr);
}

int _map(_Protect *p, void *va, void *pa) {
  uint32_t *vaddr = (uint32_t *)va;
  uint32_t *paddr = (uint32_t *)pa;
  int success = 0;

  PDE *pde_base = p->ptr;
  uint32_t pdx = PDX(vaddr);

  if (!(pde_base[pdx] & PTE_P)) {
    // alloc a new page table
    PTE *ptab = (PTE *)(palloc_f());
    pde_base[pdx] = (uintptr_t)ptab | PTE_P;
  }

  PDE pde = pde_base[pdx];
  PTE *pte_base = (PTE *)PTE_ADDR(pde);
  uint32_t ptx = PTX(vaddr);

  if (!(pte_base[ptx] & PTE_P)) {
    pte_base[ptx] = (uintptr_t)PTE_ADDR(paddr) | PTE_P;
    success = 1;
  }

  return success;
}

void _unmap(_Protect *p, void *va) {
}

_RegSet *_umake(_Protect *p, _Area ustack, _Area kstack, void *entry, char *const argv[], char *const envp[]) {
  _RegSet *start_tf = (_RegSet *)(((char *)ustack.end) - (sizeof(_RegSet)));
  start_tf->edi = 0;
  start_tf->esi = 0;
  start_tf->ebp = 0;
  start_tf->esp = 0;
  start_tf->ebx = 0;
  start_tf->edx = 0;
  start_tf->ecx = 0;
  start_tf->eax = 0;
  start_tf->irq = 0;
  start_tf->error_code = 0;
  start_tf->eip = 0;
  start_tf->cs = 0;
  start_tf->eflags = 0;

  _RegSet *utf = (start_tf - 1);
  utf->edi = 0;
  utf->esi = 0;
  utf->ebp = (uintptr_t)start_tf;
  utf->esp = (uintptr_t)start_tf;
  utf->ebx = 0;
  utf->edx = 0;
  utf->ecx = 0;
  utf->eax = 0;
  utf->irq = 0x81;
  utf->error_code = 0;
  utf->eip = (uintptr_t)entry;
  utf->cs = 0x8;
  utf->eflags = 0x2;
  return utf;
}
