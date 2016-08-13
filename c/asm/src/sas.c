/********************
 *说明:2015年夏 C语言课程设计:模拟器和汇编程序设计之编译器
********************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LEN         80
#define INSTRS_COUNT    (sizeof(g_instrs_name)/sizeof(g_instrs_name[0]))
#define INSTR_SYM       {"HLT","JMP","CJMP","OJMP","LOAD","STORE",\
                        "LOADI","NOP","ADD","SUB","IN","OUT",\
                        "EQU","LT","LTE","NOT"\
                        }

/*定义存放指令记号的数组*/
const char * g_instrs_name[] = INSTR_SYM;
/*定义存放指令格式的数组，下标对应指令码，数字字符代表7种指令格式*/
const char instr_format[17] = "1222334155667771";
/*由指令助记符得到指令代码*/
int GetInstrCode (const char * op_sym);
/*指令的译码*/
unsigned long TransToCode (char * instr_line, int instr_num);
/*由寄存器名对应到代码*/
int GetRegNum (char * instr_line, char * reg_name);

int main (int argc, char ** argv)
{
    char a_line[MAX_LEN];  /*存储每行字符*/
    char op_sym[8];        /*存储指令助记符*/
    int op_num;
    char * pcPos;          /*PC模拟指针*/
    FILE * pfIn, *pfOut;
    int n;

    /*检查命令行参数数目*/
    if (argc < 3)
    {
        printf ("ERROR:no enough command line arguments!\n");
        return 0;
    }

    /*打开源代码文件*/
    if ( (pfIn = fopen (argv[1], "r")) == NULL)
    {
        printf ("ERROR:cannot open file %s for reading!\n", argv[1]);
        return 0;
    }

    /*打开目标代码文件*/
    if ( (pfOut = fopen (argv[2], "w")) == NULL)
    {
        printf ("ERROR:cannot open file %s for writing!\n", argv[2]);
        return 0;
    }

    while (!feof (pfIn))
    {
        /*取出一条指令*/
        fgets (a_line, MAX_LEN, pfIn);

        /*处理注释*/
        if ( (pcPos = strchr (a_line, '#')) != NULL)
        {
            *pcPos = '\0';
        }

        /*从指令中取指令助记符*/
        n = sscanf (a_line, "%s", op_sym);

        /*空行和注释行*/
        if (n < 1)
        {
            continue;
        }

        /*由助记符得到指令的操作码*/
        op_num = GetInstrCode (op_sym);

        /*处理非法指令*/
        if (op_num > 15)
        {
            printf ("ERROR: %s is a invalid instruction! \n", a_line);
            exit (-1);
        }

        fprintf (pfOut, "0x%08lx\n", TransToCode (a_line, op_num));
    }

    fclose (pfIn);
    fclose (pfOut);
    return 1;
}

/*由指令助记符得到指令操作码*/
int GetInstrCode (const char * op_sym)
{
    int i;

    for (i = 0; i < INSTRS_COUNT; i++)
    {
        if (strcmp (g_instrs_name[i], op_sym) == 0)
        {
            break;
        }
    }

    return i;
}

/*将指令翻译成目标代码，instr_num为指令操作码*/
unsigned long TransToCode (char * instr_line, int instr_num)
{
    unsigned long op_code;
    unsigned long arg1, arg2, arg3;
    unsigned long instr_code = 0ul;
    char op_sym[8], reg0[8], reg1[8], reg2[8];
    unsigned long addr;
    int immed, port;
    int n;


    switch (instr_format[instr_num])
    {
    /*第一种指令格式（HLT、NOP、NOT）的译码*/
    case '1':
        op_code = instr_num;
        instr_code = op_code << 28;
        break;

    /*第二种指令格式（JMP、CJMP、OJMP）的译码*/
    case '2':
        n = sscanf (instr_line, "%s %li", op_sym, &addr);

        if (n < 2)
        {
            printf ("ERROR:bad instruction format!\n");
            exit (-1);
        }

        op_code = GetInstrCode (op_sym);
        instr_code = (op_code << 28) | (addr & 0x00ffffff);
        break;

    /*第三种格式指令（LOAD、STORE）的译码*/
    case '3':
        n = sscanf (instr_line, "%s %s", op_sym, reg0);

        if (n < 2)
        {
            printf ("ERROR:bad instruction format!\n");
            exit (-1);
        }

        op_code = GetInstrCode (op_sym);
        arg1 = GetRegNum (instr_line, reg0);
        instr_code = (op_code << 28) | (arg1 << 24) | (addr & 0x00ffffff);
        break;

    /*第四种格式指令（LOARI）的译码*/
    case '4':
        n = sscanf (instr_line, "%s %s %i", op_sym, reg0, &immed);

        if (n < 3)
        {
            printf ("ERROR:bad instruction format!\n");
            exit (-1);
        }

        op_code = GetInstrCode (op_sym);
        arg1 = GetRegNum (instr_line, reg0);
        instr_code = (op_code << 28) | (arg1 << 24) | (immed & 0x0000ffff);
        break;

    /*第五种格式指令（ADD、SUB）的译码*/
    case '5':
        n = sscanf (instr_line, "%s%s%s%s", op_sym, reg0, reg1, reg2);

        if (n < 4)
        {
            printf ("ERROR:bad instruction format!\n");
            exit (-1);
        }

        op_code = GetInstrCode (op_sym);
        arg1 = GetRegNum (instr_line, reg0);
        arg2 = GetRegNum (instr_line, reg1);
        arg3 = GetRegNum (instr_line, reg2);
        instr_code = (op_code << 28) | (arg1 << 24) | (arg2 << 20) | (arg3 << 16);
        break;

    /*第六种格式指令（IN、OUT）的译码*/
    case '6':
        n = sscanf (instr_line, "%s %s %i", op_sym, reg0, &port);

        if (n < 3)
        {
            printf ("ERROR:bad instruction format!\n");
            exit (-1);
        }

        op_code = GetInstrCode (op_sym);
        arg1 = GetRegNum (instr_line, reg0);
        instr_code = (op_code << 28) | (arg1 << 24) | (port & 0x0000ffff);
        break;

    /*第七种格式指令（EQU、LT、LTE）的译码*/
    case '7':
        n = sscanf (instr_line, "%s %s %s", op_sym, reg0, reg1);

        if (n < 3)
        {
            printf ("ERROR:bad instruction format!\n");
            exit (-1);
        }

        op_code = GetInstrCode (op_sym);
        arg1 = GetRegNum (instr_line, reg0);
        arg2 = GetRegNum (instr_line, reg1);
        instr_code = (op_code << 28) | (arg1 << 24) | (arg2 << 20);
        break;

    default:
        break;
    }

    /*返回目标代码*/
    return instr_code;
}

/*由通用寄存器名(A~G&Z)得到寄存器编号*/
int GetRegNum (char * instr_line, char * reg_name)
{
    int reg_num;

    if ( (tolower (*reg_name) >= 'a') && (tolower (*reg_name) <= 'g'))
    {
        reg_num = tolower (*reg_name) - 'a' + 1;
    }
    else
        if (tolower (*reg_name) == 'z')
        {
            reg_num = 0;
        }
        else
        {
            printf ("ERROR:bad register name in %s!\n", instr_line);
            exit (-1);
        }

    return reg_num;
}
