#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

//自定义宏
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASIBLE -1
#define OVERFLOW -2
//Status是函数的类型,其值是函数结果状态代码
typedef int Status;
//将ElemType定义为char型
typedef char ElemType;

//栈存储空间默认初始分配量
#define STACK_INIT_SIZE 100

//栈存储空间一次的分配增量
#define STACKINCREMENT 10

//定义顺序存储栈数据结构
typedef struct
{
    ElemType * base;   //在栈构造之前和销毁之后，base的值为NULL
    ElemType * top;    //栈顶指针
    int stacksize;      //当前分配存储总容量(以sizeof(ElemType)为单位)
} Stack;

/**
 * 构造一个空栈S
 * @param  S 栈地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status InitStack (Stack * S);

/**
 * 销毁栈S
 * 初始条件:栈S已存在
 * @param  S 栈地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status DestroyStack (Stack * S);

/**
 * 将S重置为空栈
 * 初始条件:栈已存在
 * @param  S 栈地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status ClearStack (Stack * S);

/**
 * 查询S是否为空栈
 * 初始条件:栈S已存在
 * @param  S 栈S
 * @return   若S为空栈,则返回TRUE,否则返回FALSE
 */
Status StackEmpty (Stack S);

/**
 * 查询S的当前长度
 * 初始条件:栈S已存在
 * @param  S 栈S
 * @return   S中数据元素的个数
 */
int StackLength (Stack S);

/**
 * 查询S栈顶元素
 * 初始条件：栈已存在且非空栈
 * @param  S 栈S
 * @param  e 用于存放栈顶元素的值
 * @return   操作结果状态Status OK/ERROR
 */
Status GetTop (Stack S, ElemType * e);

/**
 * 插入元素e为新的栈顶元素
 * 初始条件:栈S已存在
 * @param  S 栈地址值
 * @param  e 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status Push (Stack * S, ElemType e);

/**
 * 删除栈S的栈顶元素，并送入e
 * 初始条件：栈S已存且非空
 * @param  S 栈地址值
 * @param  e 用于保留删除数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status Pop (Stack * S, ElemType * e);

/**
 * 从栈底到栈顶依次对栈S中的元素使用函数visit进行访问
 * 初始条件:栈S已存在
 * @param  S 栈S
 * @param  visit 对栈S中每一元素所作访问操作
 * @return   操作结果状态Status OK/ERROR
 */
Status StackTraverse (Stack S, Status (*visitor) (ElemType * Elem));

/**
 * 打印数据元素Elem的值
 * @param  Elem 栈S中的某一元素
 * @return   操作结果状态Status OK/ERROR
 */
Status visit (ElemType * Elem);

/**
 * 从output.txt读取数据
 * @param  S 待读取数据的栈
 * @return   操作结果状态Status OK/ERROR
 */
Status LoadData (Stack * S);

/**
 * 保存数据元素Elem的值至output.txt
 * @param  S 当前栈
 * @return   操作结果状态Status OK/ERROR
 */
Status SaveData (Stack S);


/****************************************
 * 以下所有定义用于实现表达式求值
 ****************************************/

//定义操作数类型为int类型
typedef int OperandType;

//定义运算符优先级表
static char PriorTable[7][7] =
{ 
 /*         '+' '-' '*' '/' '(' ')' '#' */
 /*'+'*/    {'>','>','<','<','<','>','>'}, 
 /*'-'*/    {'>','>','<','<','<','>','>'},
 /*'*'*/    {'>','>','>','>','<','>','>'},
 /*'/'*/    {'>','>','>','>','<','>','>'},
 /*'('*/    {'<','<','<','<','<','=',' '},
 /*')'*/    {'>','>','>','>',' ','>','>'},
 /*'#'*/    {'<','<','<','<','<',' ','='}
};

//定义运算符常量表
enum {PLUS, REDUCE, RIDE, SUB, LEFTPARE, RIGHTPARE, SHARP};

/************************************
 * 以下定义用于建立Operand类型的栈及其操作
 ************************************/

//定义顺序存储栈数据结构
typedef struct
{
    OperandType * base;   //在栈构造之前和销毁之后，base的值为NULL
    OperandType * top;    //栈顶指针
    int stacksize;        //当前分配存储总容量(以sizeof(ElemType)为单位)
} OPND;

/**
 * 构造一个空栈S
 * @param  S 栈地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status InitOPND (OPND * S);

/**
 * 插入元素e为新的栈顶元素
 * 初始条件:栈S已存在
 * @param  S 栈地址值
 * @param  e 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status PushOPND (OPND * S, OperandType e);

/**
 * 删除栈S的栈顶元素，并送入e
 * 初始条件：栈S已存且非空
 * @param  S 栈地址值
 * @param  e 用于保留删除数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status PopOPND (OPND * S, OperandType * e);

/************************************
 * 以下定义用于实现表达式求值
 ************************************/

/**
 * 根据运算符计算结果
 * @param  a     操作数a
 * @param  theta 运算符
 * @param  b     操作数b
 * @return       运算结果
 */
OperandType Operate(OperandType a, char theta, OperandType b);

/**
 * 计算两个运算符的优先级
 * @param  stackOperator 退栈运算符
 * @param  otherOperator 用户输入运算符
 * @return               运算符优先级'>','=','<'
 */
char Precede(char stackOperator, char otherOperator);

/** 计算表达式的值 */
OperandType EvaluateExpression(void);

Status InitStack (Stack * S)
{
    //构造栈底
    S->base = (ElemType *)malloc(STACK_INIT_SIZE * sizeof(ElemType));
    if (! S->base ) exit(OVERFLOW);
    //构造栈顶
    S->top = S->base;
    //初始化栈长
    S->stacksize = 0;
    return OK;
}

Status DestroyStack (Stack * S)
{
    //栈S不存在，函数错误执行
    if (! S->base) return ERROR;

    //销毁栈底指针所指内存单元
    free(S->base);
    //栈底指针重置为NULL,栈顶指针重置为栈底指针，栈长重置为0
    S->base = NULL;
    S->top = S->base;
    S->stacksize = 0;
    return OK;
}

Status ClearStack (Stack * S)
{
    //栈S不存在，函数错误执行
    if (! S->base) return ERROR;

    //栈顶指针重置为栈底指针，栈长重置为0
    S->top = S->base;
    S->stacksize = 0;
    return OK;
}


Status StackEmpty (Stack S)
{
    //栈S不存在，函数错误执行
    if (! S.base) return ERROR;

    return S.base == S.top ? TRUE : FALSE;
}

int StackLength (Stack S)
{
    //栈S不存在，函数错误执行
    if (! S.base) return ERROR;

    return S.top - S.base;
}

Status GetTop (Stack S, ElemType * e)
{
    //栈为空，函数错误执行
    if (S.top == S.base) return ERROR;

    //利用e返回栈顶元素值
    (*e) = *(S.top - 1);
    return OK;
}

Status Push (Stack * S, ElemType e)
{
    //栈S不存在，函数错误执行
    if (! S->base) return ERROR;

    //插入元素e为新的栈顶元素
    if (S->top - S->base >= S->stacksize)
    {   //满栈，追加空间
        S->base = (ElemType *) realloc(S->base, (S->stacksize + STACKINCREMENT) * sizeof(ElemType));
        if (! S->base) exit(OVERFLOW);
        S->top = S->base + S->stacksize;
        S->stacksize += STACKINCREMENT;
    }

    *(S->top)++ = e;
    return OK;
}

Status Pop (Stack * S, ElemType * e)
{
    //栈为空，函数错误执行
    if (S->top == S->base) return ERROR;

    *e = *(--S->top);
    return OK;
}

Status StackTraverse (Stack S, Status (*visitor) (ElemType * Elem))
{
    //循环变量
    ElemType *ptr;
    //栈为空，函数错误执行
    if (S.base == S.top) return ERROR;
    //遍历输出栈中元素
    ptr = S.base;
    while (S.top != ptr)
    {
        visitor(ptr++);
    }
    return OK;
}

Status visit (ElemType * Elem)
{
    printf("%c\n", *Elem);
    return OK;
}

Status LoadData (Stack * S)
{
    FILE *fp;    //文件指针
    if ((fp = fopen("output.txt","r")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //读取数据
    while(fread(S->top, sizeof(ElemType), 1, fp))
    {
        (S->top)++;
    }

    fclose(fp);
    return OK;
}

Status SaveData (Stack S)
{
    FILE *fp;    //文件指针
    if ((fp = fopen("output.txt","w")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //保存数据
    fwrite(S.base, sizeof(ElemType), StackLength(S), fp);
    fclose(fp);
    return OK;
}

/****************************************
 ****************************************/

Status InitOPND (OPND * S)
{
    //构造栈底
    S->base = (OperandType *)malloc(STACK_INIT_SIZE * sizeof(OperandType));
    if (! S->base ) exit(OVERFLOW);
    //构造栈顶
    S->top = S->base;
    //初始化栈长
    S->stacksize = 0;
    return OK;
}

Status PushOPND (OPND * S, OperandType e)
{
    //栈S不存在，函数错误执行
    if (! S->base) return ERROR;

    //插入元素e为新的栈顶元素
    if (S->top - S->base >= S->stacksize)
    {   //满栈，追加空间
        S->base = (OperandType *) realloc(S->base, (S->stacksize + STACKINCREMENT) * sizeof(OperandType));
        if (! S->base) exit(OVERFLOW);
        S->top = S->base + S->stacksize;
        S->stacksize += STACKINCREMENT;
    }

    *(S->top)++ = e;
    return OK;
}

Status PopOPND (OPND * S, OperandType * e)
{
    //栈为空，函数错误执行
    if (S->top == S->base) return ERROR;

    *e = *(--S->top);
    return OK;
}



/****************************************
 ****************************************/

char Precede(char stackOperator, char otherOperator)
{
    int row, col;    //运算符优先级表的行列号
    //根据第一个运算符确定行号
    switch(stackOperator)
    {
        case '+':
            row = PLUS;
            break;
        case '-':
            row = REDUCE;
            break;
        case '*':
            row = RIDE;
            break;
        case '/':
            row = SUB;
            break;
        case '(':
            row = LEFTPARE;
            break;
        case ')':
            row = RIGHTPARE;
            break;
        case '#':
            row = SHARP;
            break;
        default:
            //返回$符号，表示函数执行错误
            return '$';
    }
    //根据第二个运算符确定列号
    switch(otherOperator)
    {
        case '+':
            col = PLUS;
            break;
        case '-':
            col = REDUCE;
            break;
        case '*':
            col = RIDE;
            break;
        case '/':
            col = SUB;
            break;
        case '(':
            col = LEFTPARE;
            break;
        case ')':
            col = RIGHTPARE;
            break;
        case '#':
            col = SHARP;
            break;
        default:
            //返回$符号，表示函数执行错误
            return '$';
    }

    //根据行列号返回目标运算符优先级
    return PriorTable[row][col];
}

OperandType Operate(OperandType a, char theta, OperandType b)
{
    //根据运算符返回计算结果
    switch(theta)
    {
        case '+': 
            return a + b;

        case '-': 
            return a - b;
        case '*': 
            return a * b;

        case '/': 
            return a / b;

        default : 
            return 0;
    }
 } 


OperandType EvaluateExpression(void)
{
    Stack OPTR;            //OPTR:运算符栈
    OPND OPND;             //OPND:操作数栈
    char input;            //用户输入表达式字符
    char theta;            //退栈运算符
    OperandType a, b;      //Operand型退栈操作数
    OperandType f;         //Operand型计算结果
    //初始化两个栈，并将'#'压入运算符栈
    InitStack(&OPTR);
    Push(&OPTR, '#');
    InitOPND(&OPND);
    //读入表达式
    input = getchar();
    while (input != '#' || (GetTop(OPTR, &theta), theta != '#') )
    {   //不是运算符则进栈
        if(input >= '0' && input <= '9')
        {
            f = (int) (input - '0');
            PushOPND(&OPND, f);
            input = getchar();
        }
        else if (input == ' ' || input == '\n')
        {   //过滤控制字符和空格符
            input = getchar();
        }
        else
        {
            GetTop(OPTR, &theta);
            switch (Precede(theta, input))
            {
                case '<': //栈顶元素优先级低
                Push(&OPTR, input);
                input = getchar();
                break;

                case '=': //脱括号并接收下一字符
                    Pop(&OPTR, &input);
                    input = getchar();
                    break;

                case '>': //退栈并将运算结果入栈
                    //将待计算的操作数和运算符退栈取出
                    Pop(&OPTR, &theta);
                    PopOPND(&OPND, &b);
                    PopOPND(&OPND, &a);
                    //将计算结果压入操作数栈
                    f = Operate(a, theta, b);
                    PushOPND(&OPND, f);
                    break;

                case '$':    //读入不明字符，计算失败
                    scanf("%*[^\n]");    //清空输入流
                    return INT_MAX;
                    break;
            }
        }
    }

    //返回运算结果
    PopOPND(&OPND, &f);
    return f;
}

int main (void)
{
    Stack stack;       //栈结构
    int choice;        //用户所选功能编号
    ElemType container;//用于存放各个功能函数反馈的数据元素值
    Status (*test_visit)(ElemType *) = visit;
    //初始化栈
    InitStack(&stack);
    //读取文本数据
    LoadData(&stack);
    //打印系统菜单界面
    printf ("\t\tWelcome to Stack System\n\n");

    while (TRUE)
    {
        //打印系统菜单界面
        printf ("1:Clear Stack\n");
        printf ("2:Require whether Empty or not\n");
        printf ("3:Require Stack Length\n");
        printf ("4:Require Top Element\n");
        printf ("5:Push Element\n");
        printf ("6:Pop Element\n");
        printf ("7:Traverse Stack\n");
        printf ("8:Evaluate Expression\n");
        printf ("9:Exit\n\n");
        //提示用户选择功能
        printf ("Please input function number:");
        //用户选择事件
        scanf ("%d", &choice);

        //处理用户选择事件
        switch (choice)
        {

        case 1:
            ClearStack (&stack);
            printf ("Clear Success\n");
            break;

        case 2:
            if (StackEmpty (stack) == TRUE)
            {
                printf ("Stack is Empty\n");
            }
            else
            {
                printf ("Stack is not Empty\n");
            }

            break;

        case 3:
            container = StackLength (stack);
            printf ("Stack Length:%d\n", container);
            break;

        case 4:
            if (GetTop (stack, &container) == ERROR)
            {
                printf ("Require Failed\n");
            }
            else
            {
                printf ("Top Element:%c\n", container);
            }

            break;

        case 5:
            printf ("Please input the value of Element what to be pushed:");
            scanf ("%1s", &container);

            if (Push (&stack, container) == ERROR)
            {
                printf ("Push Failed\n");
            }
            else
            {
                printf ("Push %c Success\n", container);
            }

            break;

        case 6:
            if (Pop (&stack, &container) == ERROR)
            {
                printf ("Pop Failed\n");
            }
            else
            {
                printf ("Pop %c Success\n", container);
            }

            break;

        case 7:
            if(StackTraverse (stack, test_visit) == ERROR)
            {
                printf("Traverse Failed\n");
            }
            break;

        case 8:
            printf("Please input espression end with '#':\n");
            container =  EvaluateExpression();
            //根据运算结果反馈用户
            if (container == INT_MAX)
            {   //计算失败
                printf("*** Evaluate Failed.Please check your expression ***\n");
            }
            else if (container == INFEASIBLE)
            {   //未以'#'结尾
                printf("*** Evalueate Failed.Please end with '#'***\n");
            }
            else
            {   //计算成功
                printf(": = %d", container);
            }
            break;
    
        case 9:
            //保存数据
            SaveData(stack);
            //销毁栈
            DestroyStack (&stack);
            exit (OK);
            break;

        default:
            printf ("No Such Function");
            break;
        }

        printf ("\n****************************************\n");
    }

    return OK;
}
