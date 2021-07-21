#ifndef INCLUDE_HEAP_H_
#define INCLUDE_HEAP_H_

#include <defs.h>

// 堆起始地址
#define HEAP_START 0xE0000000

// 内存块管理结构
typedef
struct header {
	struct header *prev; 	// 前后内存块管理结构指针
	struct header *next;
	uint32_t allocated : 1;	// 该内存块是否已经被申请
	uint32_t length : 31; 	// 当前内存块的长度
} header_t;

void heap_init(void);
void *kmalloc(uint32_t len);
void kfree(void *p);
void heap_checkpoint(void);

#endif 	// INCLUDE_HEAP_H_
