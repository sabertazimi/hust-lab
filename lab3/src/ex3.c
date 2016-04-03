#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <time.h>

/**
N	EQU  1000
BUF	DB  'zhangsan', 0, 0, 100, 85, 80, ?
	DB  'lisi', 6 DUP(0), 80, 100,70, ?
	DB  N-4 DUP( 'TempValue',0,80,90,95,?)
	DB  'wangwu', 4 dup(0), 70, 60, 80, 0
	DB  'xuxiaohua', 0, 40, 55, 61, 0
**/

#define  LEN  14			/** 每个学生成绩表的长度 **/
#define  N	  1000			/** 学生人数 **/

unsigned char buf[N*LEN];	/** 学生成绩缓冲区 **/
unsigned char *POIN;		/** 用于保存查找到的学生的成绩表起始地址 **/

#define  COUNT   1000       /** 重复计算的次数 **/

short int Average();
short int Search(char *name);

int main(int argc, char *argv[])
{
	char name[10] = "wangwu";	/** 需要查找学生的姓名 **/
	unsigned long c, addr;
	int  f;
	clock_t start, end;
	/**/
	strcpy((char *)(buf+0*LEN),"zhangsan");	    /** 第1个学生 **/
	buf[0*LEN+10] = 100;
	buf[0*LEN+11] = 85;
	buf[0*LEN+12] = 80;
	/**/
	strcpy((char *)(buf+(N-2)*LEN),"wangwu");	/** 倒数第2个学生 **/
	buf[(N-2)*LEN+10] = 70;
	buf[(N-2)*LEN+11] = 60;
	buf[(N-2)*LEN+12] = 80;
	/**/
	/** 用于反汇编定位函数Average(),显示的值即为Average()的入口 **/
	addr = (unsigned long)(&Average);
	printf("Average() address = %x \n",addr);
	/**/
	start = clock();
	for(c = 0; c < COUNT; c++)
	{
		Average();
		f = Search(name);
	}
	end = clock();
	printf("The time was: %dms\n", (end - start) * 55);
	/**/
	return( 0 );
}


/**
	功能: 计算所有学生的平均成绩((2*语文A+数学B+英语C/2)/3.5)
	参数: buf,N --- 学生成绩缓冲区和学生人数（2个都是全局变量）
	返回: 无
**/
short int Average()
{
	int k;
	unsigned short A,B,C,M;
	for(k = 0; k < N; k++)
	{
		A = buf[k*LEN+10];
		B = buf[k*LEN+11];
		C = buf[k*LEN+12];
		M = (A * 4 + B * 2 + C) / 7;
		buf[k*LEN+13] = (unsigned char)M;
	}
    return( 0 );
}


/**
	功能: 在学生成绩表中查找某个学生的平均成绩
	参数: buf,N --- 学生成绩缓冲区和学生人数（2个都是全局变量）
		  name ---- 需要查找的学生姓名
	返回: 若找到,则返回1并且将该学生成绩表的起始地址保存到POIN中
		  否则,返回0
**/
short int Search(char *name)
{
	int i,k;
	unsigned char *p;
	int result = 0;
	/**/
	for(k = 0; k < N; k++)
	{
		p = buf + k * LEN;
		for(i = 0; p[i] == name[i] && name[i] != 0 && i < 10; i++);
		if( p[i] == name[i] && name[i] == 0 )
		{
			POIN = p;
			result = 1;
			break;
		}
	}
	/**/
	return( result );
}
