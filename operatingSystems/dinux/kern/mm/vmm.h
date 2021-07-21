#ifndef INCLUDE_VMM_H
#define INCLUDE_VMM_H

#include <defs.h>
#include <idt.h>
#include <vmm.h>

#define PAGE_OFFSET     0xC0000000  ///< 内核的偏移地址
#define PAGE_PRESENT    0x1         ///< P--位0是存在（Present）标志，用于指明表项对地址转换是否有效。P=1表示有效；P=0表示无效。
#define PAGE_WRITE      0x2         /// <R/W--位1是读/写（Read/Write）标志。如果等于1，表示页面可以被读、写或执行。
#define PAGE_USER       0x4         ///< U/S--位2是用户/超级用户（User/Supervisor）标志。
#define PAGE_SIZE       4096
#define PAGE_MASK      0xFFFFF000
#define PGD_INDEX(x) (((x) >> 22) & 0x3FF)
#define PTE_INDEX(x) (((x) >> 12) & 0x3FF)
#define OFFSET_INDEX(x) ((x) & 0xFFF)
#define PGD_SIZE (PAGE_SIZE/sizeof(pte_t))
#define PTE_SIZE (PAGE_SIZE/sizeof(uint32_t))
#define PTE_COUNT 128

typedef uint32_t pgd_t;
typedef uint32_t pte_t;

extern pgd_t pgd_kern[PGD_SIZE];    ///< kernal page

/// \brief initialization
void vmm_init(void);

/// \brief change page table
void switch_pgd(uint32_t pd);

/// \brief map virtual address to physical address with adapting page table entry
void map(pgd_t *pgd_now, uint32_t va, uint32_t pa, uint32_t flags);

/// \brief unmap virtual address with restoring page table entry
void unmap(pgd_t *pgd_now, uint32_t va);

/// \brief get pa of va
/// \param pgd_now page table
/// \param va virtaul address
/// \param pa to get mapping address
/// \return bool 1 va mapped, 0 va unmapped
uint32_t get_mapping(pgd_t *pgd_now, uint32_t va, uint32_t *pa);

/// \brief page fault handler
void page_fault(pt_regs *regs);

#endif 	// INCLUDE_VMM_H
