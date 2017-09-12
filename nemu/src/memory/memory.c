#include "nemu.h"
#include "device/mmio.h"

#define PMEM_SIZE (128 * 1024 * 1024)
#define PGSIZE    4096    // Bytes mapped by a page
#define PGMASK          (PGSIZE - 1)    // Mask for bit ops
#define PGROUNDUP(sz)   (((sz)+PGSIZE-1) & ~PGMASK)
#define PGROUNDDOWN(a)  (((a)) & ~PGMASK)

// Control Register flags
#define CR0_PE    0x00000001  // Protection Enable
#define CR0_PG    0x80000000  // Paging

// Page directory and page table constants
#define NR_PDE    1024    // # directory entries per page directory
#define NR_PTE    1024    // # PTEs per page table
#define PGSHFT    12      // log2(PGSIZE)
#define PTXSHFT   12      // Offset of PTX in a linear address
#define PDXSHFT   22      // Offset of PDX in a linear address

// Page table/directory entry flags
#define PTE_P     0x001     // Present
#define PTE_W     0x002     // Writeable
#define PTE_U     0x004     // User
#define PTE_PWT   0x008     // Write-Through
#define PTE_PCD   0x010     // Cache-Disable
#define PTE_A     0x020     // Accessed
#define PTE_D     0x040     // Dirty

typedef uint32_t PTE;
typedef uint32_t PDE;
#define PDX(va)     (((uint32_t)(va) >> PDXSHFT) & 0x3ff)
#define PTX(va)     (((uint32_t)(va) >> PTXSHFT) & 0x3ff)
#define OFF(va)     ((uint32_t)(va) & 0xfff)

// construct virtual address from indexes and offset
#define PGADDR(d, t, o) ((uint32_t)((d) << PDXSHFT | (t) << PTXSHFT | (o)))

// Address in page table or page directory entry
#define PTE_ADDR(pte)   ((uint32_t)(pte) & ~0xfff)

#define pmem_rw(addr, type) *(type *)({\
    Assert(addr < PMEM_SIZE, "physical address(0x%08x) is out of bound, EIP = 0x%08x", addr, cpu.eip); \
    guest_to_host(addr); \
    })

uint8_t pmem[PMEM_SIZE];

static paddr_t page_translate(vaddr_t va) {
  if (cpu.cr0.val & CR0_PG) {
    uint32_t pde_base = cpu.cr3.val;
    uint32_t pdx = PDX(va);
    Log("pde_base = 0x%08x", pde_base);
    PDE pde = *((uint32_t *)(pde_base + pdx * sizeof(char)));
    Log("pde_base = 0x%08x", pde_base);
    Assert(pde & PTE_P, "Can't find %d th page directory entry", pdx);

    uint32_t pte_base = PTE_ADDR(pde);
    uint32_t ptx = PTX(va);
    PTE pte = *((uint32_t *)(pte_base + ptx * sizeof(char)));
    Assert(pte & PTE_P, "Can't find %d th page directory entry", ptx);

    uint32_t pa_base = PTE_ADDR(pte);
    uint32_t pa_offset = PTE_ADDR(va);
    return pa_base + pa_offset;
  } else {
    return va;
  }
}

/* Memory accessing interfaces */

uint32_t paddr_read(paddr_t addr, int len) {
  int map_NO = is_mmio(addr);

  if (map_NO == -1) {
    return pmem_rw(addr, uint32_t) & (~0u >> ((4 - len) << 3));
  } else {
    return mmio_read(addr, len, map_NO);
  }
}

void paddr_write(paddr_t addr, int len, uint32_t data) {
  int map_NO = is_mmio(addr);

  if (map_NO == -1) {
    memcpy(guest_to_host(addr), &data, len);
  } else {
    mmio_write(addr, len, data, map_NO);
  }
}

uint32_t vaddr_read(vaddr_t addr, int len) {
  if (PTX(addr) != PTX(addr + len - 1)) {
    // cross the page boundary
    vaddr_t page_bound = PGROUNDUP(addr);

    int nr_inpage = page_bound - addr;
    int nr_outpage = len - nr_inpage;

    paddr_t paddr_inpage = page_translate(addr);
    paddr_t paddr_outpage = page_translate(page_bound);

    uint32_t data_inpage = paddr_read(paddr_inpage, nr_inpage);
    uint32_t data_outpage = paddr_read(paddr_outpage, nr_outpage);
    uint32_t data = (data_outpage << (nr_inpage << 3)) | data_inpage;

    return data;
  } else {
    paddr_t paddr = page_translate(addr);
    return paddr_read(paddr, len);
  }
}

void vaddr_write(vaddr_t addr, int len, uint32_t data) {
  if (PTX(addr) != PTX(addr + len - 1)) {
    // cross the page boundary
    vaddr_t page_bound = PGROUNDUP(addr);

    int nr_inpage = page_bound - addr;
    int nr_outpage = len - nr_inpage;

    paddr_t paddr_inpage = page_translate(addr);
    paddr_t paddr_outpage = page_translate(page_bound);

    uint32_t data_inpage = data & (~0u >> ((4 - nr_inpage) << 3));
    uint32_t data_outpage = (data >> (nr_inpage << 3)) & (~0u >> ((4 - nr_outpage) << 3));

    paddr_write(paddr_inpage, nr_inpage, data_inpage);
    paddr_write(paddr_outpage, nr_outpage, data_outpage);
  } else {
    paddr_t paddr = page_translate(addr);
    paddr_write(paddr, len, data);
  }
}

