/********************
 *说明:2015年夏 C语言课程设计:模拟器和汇编程序设计之模拟器
********************/

#include <stdio.h>
#include <stdlib.h>
#include <io.h>
#include <string.h>

/*定义宏来模拟指令的解码*/
#define REG0 ((IR>>24)&0x0F)
#define REG1 ((IR>>20)&0x0F)
#define REG2 ((IR>>16)&0x0F)
#define IMMEDIATE (IR&0xFFFF)
#define ADDRESS (IR&0xFFFFFF)
#define PORT (IR&0xFF)
#define OPCODE ((IR>>28)&0x0F)

typedef struct PROG_STATE_WORD
{
    unsigned short overflow_flg: 1;
    unsigned short compare_flg: 1;
    unsigned short reserve: 14;
} PROG_STATE_WORD;

unsigned char * MEM;        /*用动态存储区模拟内存，大小由命令行参数确定*/
unsigned long * PC;         /*指令计数器，用来存放下条指令的内存地址*/
short GR[8];                /*通用寄存器的模拟*/
PROG_STATE_WORD PSW;
unsigned long IR;

/*用16个函数实现16条指令的相应功能*/
int HLT (void);
int JMP (void);
int CJMP (void);
int OJMP (void);
int LOAD (void);
int STORE (void);
int LOADI (void);
int NOP (void);
int ADD (void);
int SUB (void);
int IN (void);
int OUT (void);
int EQU (void);
int LT (void);
int LTE (void);
int NOT (void);

int main (int argc, char ** argv)
{
    unsigned long instruction;
    unsigned long mem_size;
    /*函数指针数组，用于指令对应函数的调用*/
    int (*ops[]) (void) = {HLT,JMP,CJMP,OJMP,LOAD,STORE,LOADI,
                           NOP,ADD,SUB,IN,OUT,EQU,LT,LTE,NOT
                          };
    FILE * pfIn;
    int ret = 1;
    int n;

    if (argc < 3)
    {
        printf ("ERROR:no enough command line arguments!\n");
        exit (-1);
    }

    /*从参数中取模拟内存大小*/
    n = sscanf(argv[1], "%li", &mem_size);
    if (n < 1)
    {
        printf ("ERROR:argument %s is an invalid number!\n", argv[1]);
        exit (-1);
    }

    /*向系统申请动态存储区，模拟内存*/
    if ( (MEM = (unsigned char *) malloc (mem_size)) == NULL)
    {
        printf ("ERROR:fail to allocate memory!\n");
        exit (-1);
    }

    /*使指令计数器指向模拟内存的顶端*/
    PC = (unsigned long *) MEM;

    if ( (pfIn = fopen (argv[2], "r")) == NULL)
    {
        printf ("ERROR:cannot open file %s for reading!\n", argv[2]);
        exit (-1);
    }

    /*从文件中取出目标代码，加载到模拟内存*/
    while (!feof (pfIn))
    {
        fscanf (pfIn, "%li", &instruction);
        memcpy (PC, &instruction, sizeof (instruction));
        PC++;
    }

    fclose (pfIn);
    /*使PC指向模拟内存顶端的第一条指令*/
    PC = (unsigned long *) MEM;

    /*模拟处理器执行指令*/
    while (ret)
    {
        /*取指：将PC指示的指令加载到指令寄存器IR*/
        IR = *PC;
        /*PC指向下一条执行指令*/
        PC++;
        /*解码并执行指令*/
        ret = (*ops[OPCODE])();
    }

    free (MEM);
    return 1;
}

int HLT (void)
{
    return 0;
}

int JMP (void)
{
    PC = (unsigned long *) (MEM + ADDRESS);
    return 1;
}

int CJMP (void)
{
    if (PSW.compare_flg)
    {
        PC = (unsigned long *) (MEM + ADDRESS);
    }

    return 1;
}

int OJMP (void)
{
    if (PSW.overflow_flg)
    {
        PC = (unsigned long *) (MEM + ADDRESS);
    }

    return 1;
}

int LOAD (void)
{
    GR[REG0] = (short) (* (unsigned long *) (MEM + ADDRESS));
    return 1;
}

int STORE (void)
{
    * (short *) (MEM + ADDRESS) = GR[REG0];
    return 1;
}

int LOADI (void)
{
    GR[REG0] = (short) (IMMEDIATE);
    return 1;
}

int NOP (void)
{
    return 1;
}

int ADD (void)
{
    GR[REG0] = GR[REG1] + GR[REG2];

    if (GR[REG2] > 0)
    {
        if (GR[REG0] < GR[REG1])
        {
            PSW.overflow_flg = 1;
        }
        else
        {
            PSW.overflow_flg = 0;
        }
    }
    else
        if (GR[REG2] < 0)
        {
            if (GR[REG0] > GR[REG1])
            {
                PSW.overflow_flg = 1;
            }
            else
            {
                PSW.overflow_flg = 0;
            }
        }
        else
        {
            PSW.overflow_flg = 0;
        }

    return 1;
}

int SUB (void)
{
    GR[REG0] = GR[REG1] - GR[REG2];

    if (GR[REG2] > 0)
    {
        if (GR[REG0] > GR[REG1])
        {
            PSW.overflow_flg = 1;
        }
        else
        {
            PSW.overflow_flg = 0;
        }
    }
    else
        if (GR[REG2] < 0)
        {
            if (GR[REG0] < GR[REG1])
            {
                PSW.overflow_flg = 1;
            }
            else
            {
                PSW.overflow_flg = 0;
            }
        }
        else
        {
            PSW.overflow_flg = 0;
        }

    return 1;
}

int IN (void)
{
    read (0, (char *) (GR + REG0), 1);
    return 1;
}

int OUT (void)
{
    write (1, (char *) (GR + REG0), 1);
    return 1;
}

int EQU (void)
{
    PSW.compare_flg = (GR[REG0] == GR[REG1]);
    return 1;
}

int LT (void)
{
    PSW.compare_flg = (GR[REG0] < GR[REG1]);
    return 1;
}

int LTE (void)
{
    PSW.compare_flg = (GR[REG0] <= GR[REG1]);
    return 1;
}

int NOT (void)
{
    PSW.compare_flg = !PSW.compare_flg;
    return 1;
}
