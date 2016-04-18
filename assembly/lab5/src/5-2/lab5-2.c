#include <stdio.h>
#include <stdlib.h>

#define ONE 49
#define TWO 50
#define THREE 51
#define FOUR 52
#define FIVE 53
#define SIX	54
#define MAX_NUM 1000

typedef struct stu {
	char name[12];	// student's name
	int ch;			// student's chinese grade
	int ma;			// student's math grade
	int en;			// student's english grade
	int avg;		// student's average grade
} stu;

extern void  cal(stu *, int);
extern void  sort(stu *, int);
extern void  search(stu *, int, char *);

int main(void) {
	stu table[MAX_NUM];
	int num = 0;	// total number of students
	char str[12];   // search aid string
	char input[2];	// input selection
	int i;			// loop variable
	do {
		printf("\nPlease input selection: \n");
		printf("1: Input\n");
		printf("2: Calculate\n");
		printf("3: Sort\n");
		printf("4: Search\n");
		printf("5: Print\n");
		printf("6: Exit\n");
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
			cal(&table[0], num);
			break;
		case THREE:	// sort students' info, by average grade
			sort(&table[0], num);
			break;
		case FOUR:  // search target student
			printf("Please input name: ");
			scanf("%9s", str);
			search(&table[0], num, &str[0]);

			__asm {
				mov i, eax
			}

			if (i > -1 && i < num) {
				printf("Found: %s: %d %d %d %d\n", table[i].name, table[i].ch, table[i].ma, table[i].en, table[i].avg);
			} else {
				printf("Not Found!\n");
			}
			break;
		case FIVE:	// print students' info	
			for (i = 0;i < num;i++) {
				printf("%s: %d %d %d %d\n", table[i].name, table[i].ch, table[i].ma, table[i].en, table[i].avg);
			}
			break;
		default:	// error handle
			break;
		}
	} while(input[0] != SIX);

	return 0;
}