#include <stdio.h>
#include <stdlib.h>

//自定义宏
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASIBLE -1
#define OVERFLOW -2
//Status是函数的类型,其值是函数结果状态代码
typedef int Status;
//将ElemType定义为int型
typedef int ElemType;

//最大队列长度
#define MAXQSIZE 100

//定义顺序存储循环队列数据结构
typedef struct Queue
{
    ElemType * base;   //初始化的动态分配存储空间，在队列构造之前和销毁之后，base的值为NULL
    int front;         //头指针，若队列不空，指向队列首元素
    int rear;          //尾指针，若队列不空，指向队列尾元素的下一个位置
} Queue;

/**
 * 构造一个空队列Q
 * @param  Q 队列地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status InitQueue (Queue * Q);

/**
 * 销毁队列Q
 * 初始条件:队列Q已存在
 * @param  Q 队列地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status DestroyQueue (Queue * Q);

/**
 * 将Q重置为空队列
 * 初始条件:队列已存在
 * @param  Q 队列地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status ClearQueue (Queue * Q);

/**
 * 查询Q是否为空队列
 * 初始条件:队列Q已存在
 * @param  Q 队列Q
 * @return   若Q为空队列,则返回TRUE,否则返回FALSE
 */
Status QueueEmpty (Queue Q);

/**
 * 查询Q的当前长度
 * 初始条件:队列Q已存在
 * @param  Q 队列Q
 * @return   Q中数据元素的个数
 */
int QueueLength (Queue Q);

/**
 * 查询Q队列首元素
 * 初始条件：队列已存在且非空队列
 * @param  Q 队列Q
 * @param  e 用于存放队列首元素的值
 * @return   操作结果状态Status OK/ERROR
 */
Status GetHead (Queue Q, int * e);

/**
 * 插入元素e为新的队列尾元素
 * 初始条件:队列Q已存在
 * @param  Q 队列地址值
 * @param  e 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status EnQueue (Queue * Q, int e);

/**
 * 删除队列Q的队列首元素，并送入e
 * 初始条件：队列Q已存且非空
 * @param  Q 队列地址值
 * @param  e 用于保留删除数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status DeQueue (Queue * Q, int * e);

/**
 * 从队首到队尾依次对队列Q中的元素使用函数visit进行访问
 * 初始条件:队列Q已存在
 * @param  Q 队列Q
 * @param  visit 对队列Q中每一元素所作访问操作
 * @return   操作结果状态Status OK/ERROR
 */
Status QueueTraverse (Queue Q, Status (*visitor) (ElemType * Elem));

/**
 * 打印数据元素Elem的值
 * @param  Elem 队列Q中的某一元素
 * @return   操作结果状态Status OK/ERROR
 */
Status visit (ElemType * Elem);

/**
 * 从output.txt读取数据
 * @param  Q 待读取数据的队列
 * @return   操作结果状态Status OK/ERROR
 */
Status LoadData (Queue * Q);

/**
 * 保存数据元素Elem的值至output.txt
 * @param  Q 当前队列
 * @return   操作结果状态Status OK/ERROR
 */
Status SaveData (Queue Q);

Status InitQueue (Queue * Q)
{
    //分配定长字节内存单元，并进行成功性检查
    Q->base = (ElemType *)malloc(MAXQSIZE * sizeof(ElemType));
    if (! Q->base) return OVERFLOW;
    //初始化
    Q->rear = Q->front = 0;
    return OK;
}

Status DestroyQueue (Queue * Q)
{
    //队列不存在
    if (! Q->base) return ERROR;
    //队列存在，函数正确执行
    free(Q->base);
    //将base重置为null，front与rear重置为0
    Q->base = NULL;
    Q->rear = Q->front = 0;
    return OK;
}

Status ClearQueue (Queue * Q)
{
    //队列不存在
    if (! Q->base) return ERROR;
    //队列存在，函数正确执行
    //将front与rear重置为0
    Q->rear = Q->front = 0;
    return OK;
}

Status QueueEmpty (Queue Q)
{
    //队列不存在
    if (! Q.base) return ERROR;
    //队列存在，函数正确执行
    return Q.rear == Q.front ? TRUE : FALSE;
}

int QueueLength (Queue Q)
{
    //队列不存在
    if (! Q.base) return ERROR;
    //队列存在，函数正确执行
    return ( (Q.rear - Q.front + MAXQSIZE) % MAXQSIZE );
}

Status GetHead (Queue Q, ElemType * e)
{
    //队列不存在
    if (! Q.base) return ERROR;
    //队列为空
    if (QueueEmpty(Q)) return ERROR;
    //队列存在且非空
    (*e) = Q.base[Q.front];
    return OK;
}

Status EnQueue (Queue * Q, ElemType e)
{
    //队列不存在
    if (! Q->base) return ERROR;
    //队列满
    if ( (Q->rear + 1) % MAXQSIZE == Q->front ) return ERROR;
    //队列存在且未满
    Q->base[Q->rear] = e;
    //队列尾下标自增
    Q->rear = (Q->rear + 1) % MAXQSIZE;
    return OK;
}

Status DeQueue (Queue * Q, ElemType * e)
{
    //队列不存在
    if (! Q->base) return ERROR;
    //队列为空
    if (QueueEmpty(*Q)) return ERROR;
    //队列存在且非空
    (*e) = Q->base[Q->front];
    Q->front = (Q->front + 1) % MAXQSIZE;
    return OK;
}

Status QueueTraverse (Queue Q, Status (*visitor) (ElemType * Elem))
{
    int pos;      //循环变量，用于标明当前元素下标
    int count;    //循环变量，用于记录当前循环次数(此变量值应不大于队列长度),判断何时终止遍历
    //队列不存在
    if (! Q.base) return ERROR;
    //队列为空
    if (QueueEmpty(Q)) return ERROR;

    //队列存在且非空
    for (pos = Q.front, count = 0;count < QueueLength(Q);count++, pos = (pos + 1) % MAXQSIZE)
    {
        //访问目标元素
        visitor(Q.base + pos);
    }
    printf("\n");

    return OK;
}


Status visit (ElemType * Elem)
{
    printf("%d\t", *Elem);
    return OK;
}

Status LoadData (Queue * Q)
{
    FILE *fp;    //文件指针
    if ((fp = fopen("output.txt","r")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //读取数据
    //将保存的第一个数据赋给Q->front
    fread(&(Q->front), sizeof(int), 1, fp);
    //初始化队尾rear值
    Q->rear = Q->front;
    while(fread(Q->base + Q->rear, sizeof(ElemType), 1, fp))
    {
        Q->rear = (Q->rear + 1) % MAXQSIZE;
    }

    fclose(fp);
    return OK;
}

Status SaveData (Queue Q)
{
    FILE *fp;    //文件指针
    if ((fp = fopen("output.txt","w")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //保存数据
    //第一个数据用于保存Q.front值
    fwrite(&(Q.front), sizeof(int), 1, fp);
    fwrite(Q.base + Q.front, sizeof(ElemType), QueueLength(Q), fp);
    fclose(fp);
    return OK;
}

int main (void)
{
    Queue queue;       //队列结构
    queue.base = NULL;
    ElemType input;    //用户输入变量
    ElemType container;//用于存放各个功能函数反馈的数据元素                               1
    Status (*test_visit) (ElemType *) = visit;
    //初始化队列
    InitQueue (&queue);
    //读取文本数据
    LoadData(&queue);
    //打印系统菜单界面
    printf ("\t\t欢迎使用顺序队列\n\n");

    while (TRUE)
    {
        //打印系统菜单界面
        printf ("1:重置队列\n");
        printf ("2:查询是否为空队列\n");
        printf ("3:查询队列长\n");
        printf ("4:查询队列顶元素\n");
        printf ("5:插入队尾元素\n");
        printf ("6:删除队首元素\n");
        printf ("7:遍历队列\n");
        printf ("8:退出系统\n\n");
        //提示用户选择功能
        printf ("请输入所选功能选项:");
        //用户选择事件
        scanf ("%d", &input);

        //处理用户选择事件
        switch (input)
        {

        case 1:
            ClearQueue (&queue);
            printf ("已重置\n");
            break;

        case 2:
            if (QueueEmpty (queue) == TRUE)
            {
                printf ("当前队列为空队列\n");
            }
            else
            {
                printf ("当前队列不为空队列\n");
            }

            break;

        case 3:
            container = QueueLength (queue);
            printf ("当前队列长为：%d\n", container);
            break;

        case 4:
            if (GetHead (queue, &container) == ERROR)
            {
                printf ("查询失败\n");
            }
            else
            {
                printf ("队列头元素值为:%d\n", container);
            }

            break;

        case 5:
            printf ("请输入插入元素值:");
            scanf ("%d", &container);

            if (EnQueue (&queue, container) == ERROR)
            {
                printf ("插入失败\n");
            }
            else
            {
                printf ("插入 %d 成功\n", container);
            }

            break;

        case 6:
            if (DeQueue (&queue, &container) == ERROR)
            {
                printf ("删除失败\n");
            }
            else
            {
                printf ("删除 %d 成功\n", container);
            }

            break;

        case 7:
            if (QueueTraverse (queue, test_visit) == ERROR)
            {
                printf("遍历失败\n");
            }
            break;
    
        case 8:
            
            //销毁队列
            SaveData(queue);
            DestroyQueue (&queue);
            exit (INFEASIBLE);
            break;

        default:
            printf ("所选功能不存在,请重新选择功能");
            break;
        }

        printf ("\n********************\n");
    }


}
