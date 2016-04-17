#include <stdio.h>
#include <stdlib.h>

#define ONE 49
#define TWO 50
#define THREE 51
#define FOUR 52
#define FIVE 53
#define MAX_NUM 1000

typedef struct stu {
	char name[10];	// student's name
	int ch;			// student's chinese grade
	int ma;			// student's math grade
	int en;			// student's english grade
	int avg;		// student's average grade
} stu;

int main(void) {
	stu table[MAX_NUM];
	int num = 0;	// total number of students
	char input[2];	// input selection
	int i;			// loop variable
	do {
		printf("Please input selection: \n");
		printf("1: Input\n");
		printf("2: Calculate\n");
		printf("3: Sort\n");
		printf("4: Print\n");
		printf("5: Exit\n");
		scanf("%1s", input);
		switch (input[0]) {
		case ONE:	// input new student info
			printf("Please input name: ");
			scanf("%9s", table[num].name);
			printf("Please input chinese: ");
			scanf("%d", &(table[num].ch));
			printf("Please input math: ");
			scanf("%d", &(table[num].ma));
			printf("Please input english: ");
			scanf("%d", &(table[num].en));
			num++;
			break;
		case TWO:	// calculate students' grade
			// for (i = 0;i < num;i++) {
			//  	table[i].avg = (table[i].ch*4 + table[i].ma*2 + table[i].en) / 7;
			//  }
			__asm {
				push    eax
				push    ebx
				push    ecx
				push    edx
				push    esi
				xor		ebx, ebx
				xor		ecx, ecx
		cal_loop:
				cmp     ecx, num
				jge      cal_finish
				mov     eax, table[ebx].ch      ; chinese
				mov     edx, table[ebx].ma		; math
				lea     eax, [edx + eax * 2]    ; (eax) = chinese * 2 + math
				mov     edx, table[ebx].en		; english
				lea     esi, [edx + eax *2]     ; (esi) = (chinese * 2 + math) * 2 + english
				mov     eax, 92492493h          ; (esi) / 7
				imul    esi
				add     edx, esi
				sar     edx, 2
				mov     eax, edx
				shr     eax, 1fh
				add     edx, eax
				and		edx, 0xff
				mov     table[ebx].avg, edx     ; avg = sum / 3.5
				add		ebx, 28
				inc     ecx
				jmp		cal_loop
		cal_finish:
				pop     esi   
				pop     edx
				pop     ecx
				pop     ebx
				pop     eax
			}
			break;
		case THREE:	// sort students' info, by average grade
			__asm {
				push    eax
				push    ebx
				push    ecx
				push    edx
				push    esi
				push    edi
				xor     ebx, ebx
				xor     ecx, ecx
				xor     edx, edx
				xor     eax, eax
			sort_outer:
				cmp     eax, num
				jge     sort_finish
				imul    esi, eax, 28
				mov     ebx, table[esi].avg		; avg[i]
				lea     ecx, [eax + 1]
			sort_inner:
				cmp     ecx, num
				jge     sort_outer_next
				imul    edi, ecx, 28
				cmp		table[edi].avg, ebx
				jl      sort_inner_next
				; ½»»»
				push    ecx
				push    edx
				push	esi
				push	edi
				xor     ecx, ecx
			exchange_loop:
				mov     dl, table[esi]
				xchg    dl, table[edi]
				mov     table[esi], dl
				inc     ecx
				inc		esi
				inc		edi
				cmp     ecx, 1ch
				jne     exchange_loop
				pop		edi
				pop		esi
				pop		edx
				pop     ecx
				; ½»»»
			sort_inner_next:
				inc		ecx
				jmp     sort_inner
			sort_outer_next:
				inc     eax
				jmp     sort_outer
			sort_finish:
				pop     edi
				pop     esi
				pop     edx
				pop     ecx
				pop     ebx
				pop     eax
			}
			break;
		case FOUR:	// print students' info	
			for (i = 0;i < num;i++) {
				printf("%s: %d %d %d %d\n", table[i].name, table[i].ch, table[i].ma, table[i].en, table[i].avg);
			}
			break;
		default:	// error handle
			break;
		}
	} while(input[0] != FIVE);

	return 0;
}