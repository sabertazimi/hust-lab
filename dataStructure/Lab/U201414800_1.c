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

//线性表存储空间默认初始分配量
#define LIST_INIT_SIZE 100

//线性表存储空间一次的分配增量
#define LISTINCREMENT 10

//定义顺序存储的线性表数据结构
typedef struct
{
    ElemType * elem;   //存储空间基址
    int length;        //当前线性表长度
    int listsize;      //当前分配存储总容量(以sizeof(ElemType)为单位)
} Sqlist;


/**
 * 构造一个空的线性表
 * @param  L 线性表地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status InitList (Sqlist * L);

/**
 * 销毁线性表L
 * 初始条件:线性表L已存在
 * @param  L 线性表地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status DestroyList (Sqlist * L);

/**
 * 将L重置为空表
 * 初始条件:线性表已存在
 * @param  L 线性表地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status ClearList (Sqlist * L);

/**
 * 查询L是否为空表
 * 初始条件:线性表L已存在
 * @param  L 线性表L
 * @return   若L为空表,则返回TRUE,否则返回FALSE
 */
Status ListEmpty (Sqlist L);

/**
 * 查询L的当前长度
 * 初始条件:线性表L已存在
 * @param  L 线性表L
 * @return   L中数据元素的个数
 */
int ListLength (Sqlist L);

/**
 * 查询L中第i个数据元素的值
 * 初始条件：线性表已存在，1 ≤ i ≤ ListLength(L)
 * @param  L 线性表L
 * @param  i 数据元素的位序
 * @param  e 用于存放数据元素的值
 * @return   操作结果状态Status OK/ERROR
 */
Status GetElem (Sqlist L, int i, ElemType * e);

/**
 * 查询满足比较规则的线性表数据元素的位序
 * 初始条件：线性表已存在
 * @param  L 线性表L
 * @param  e 目标数据元素值
 * @param  compare 自定义数据元素比较规则
 * @return   L中第1个与e满足关系compare()关系的数据元素的位序(不存在为0)
 */
int LocateElem (Sqlist L, ElemType e, Status (*cmp) (ElemType Elem, ElemType AnotherElem));

/**
 * 定义L中元素的比较规则
 * @param  Elem        L中某个元素
 * @param  AnotherElem L中另一元素
 * @return             比较结果 TRUE/FALSE
 */
Status compare (ElemType Elem, ElemType AnotherElem);

/**
 * 查询目标元素的前驱元素的值
 * 初始条件:线性表已存在
 * @param  L 线性表L
 * @param  cur_e 目标数据元素值
 * @param  pre_e 用于存放前驱元素的值
 * @return       若cur_e是L的数据元素，且不是第一个，则用pre_e返回它的前驱，
 *               否则操作失败，pre_e无定义
 */
Status PriorElem (Sqlist L, ElemType cur_e, ElemType * pre_e);

/**
 * 查询目标元素的后继元素的值
 * 初始条件:线性表已存在
 * 调用函数:LocateElem
 * @param  L 线性表L
 * @param  cur_e 目标数据元素值
 * @param  next_e 用于存放后继元素的值
 * @return       若cur_e是L的数据元素，且不是最后一个，则用next_e返回它的后继，
 *               否则操作失败，next_e无定义
 */
Status NextElem (Sqlist L, ElemType cur_e, ElemType * next_e);

/**
 * 在L的第i个位置之前插入新的数据元素e，L的长度加1
 * 初始条件:线性表L已存在且非空，1 ≤ i ≤ ListLength(L)+1
 * 调用函数:LocateElem
 * @param  L 线性表地址值
 * @param  i 目标插入位序
 * @param  e 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status ListInsert (Sqlist * L, int i, ElemType e);

/**
 * 删除L的第i个数据元素，用e返回其值，L的长度减1
 * 初始条件：线性表L已存在，1 ≤ i ≤ ListLength(L)
 * @param  L 线性表地址值
 * @param  i 目标删除位序
 * @param  e 用于保留删除数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status ListDelete (Sqlist * L, int i, ElemType * e);

/**
 * 遍历线性表L,并对每一元素都执行visit操作
 * 初始条件:线性表L已存在
 * @param  L 线性表L
 * @param  visit 对线性表L中每一元素所作操作
 * @return   操作结果状态Status OK/ERROR
 */
Status ListTraverse (Sqlist L, Status (*visitor) (ElemType Elem));

/**
 * 打印数据元素Elem的值
 * @param  Elem 线性表L中的某一元素
 * @return   操作结果状态Status OK/ERROR
 */
Status visit (ElemType Elem);

/**
 * 从output.dat读取二进制数据
 * @param  L 待读取数据的线性表
 * @return   操作结果状态Status OK/ERROR
 */
Status LoadData (Sqlist *L);

/**
 * 二进制输出数据元素Elem的值至output.dat
 * @param  L 当前线性表
 * @return   操作结果状态Status OK/ERROR
 */
Status SavaData (Sqlist L);

Status InitList (Sqlist * L)
{
    //构造一个空的线性表L
    (*L).elem = (ElemType *) malloc (LIST_INIT_SIZE * sizeof (ElemType));

    if (! (*L).elem)
    {
        exit (OVERFLOW);    //存储分配失败
    }

    (*L).length = 0;                    //空表长度为0
    (*L).listsize = LIST_INIT_SIZE;     //初始存储容量
    return OK;
}

Status DestroyList (Sqlist * L)
{
    //线性表不存在,函数执行失败
    if (! (*L).elem)
    {
        return ERROR;
    }

    //线性表存在,函数执行正确
    free ( (*L).elem);
    (*L).elem = NULL;
    return OK;
}

Status ClearList (Sqlist * L)
{
    //线性表不存在,函数执行失败
    if (! (*L).elem)
    {
        return ERROR;
    }

    //线性表存在,函数执行正确
    (*L).length = 0;
    return OK;
}

Status ListEmpty (Sqlist L)
{
    //线性表不存在,函数执行失败
    if (! L.elem)
    {
        return ERROR;
    }

    //线性表存在,函数执行正确
    return L.length == 0 ? TRUE : FALSE;
}

int ListLength (Sqlist L)
{
    //线性表不存在,函数执行失败
    if (! L.elem)
    {
        return ERROR;
    }

    //线性表存在,函数执行正确
    return L.length;
}

Status GetElem (Sqlist L, int i, ElemType * e)
{
    //线性表不存在,函数执行失败
    if (! L.elem)
    {
        return ERROR;
    }

    //i超出范围,函数执行失败
    if (i < 1 || i > L.length)
    {
        return ERROR;
    }

    //函数执行正确
    (*e) = L.elem[i - 1];    //将目标元素值存入e指向内存单元
    return OK;
}

int LocateElem (Sqlist L, ElemType e,
                Status (*cmp) (ElemType Elem, ElemType AnotherElem))
{
    int i;    //循环变量

    //线性表不存在,函数执行失败
    if (! L.elem)
    {
        return ERROR;
    }

    //初始化i为1
    //遍历线性表,直至表尾或找到目标元素
    for (i = 1; i <= ListLength (L) && cmp (e, L.elem[i - 1]) == FALSE; i++);

    //当i>L.length时，说明表中无目标元素，返回0
    //当i<L.length时，说明成功找到目标元素，返回其位序
    return (i <= ListLength (L) ? i : 0);
}

Status compare (ElemType Elem, ElemType AnotherElem)
{
    return Elem == AnotherElem ? TRUE : FALSE;
}

Status PriorElem (Sqlist L, ElemType cur_e, ElemType * pre_e)
{
    int cur_pos = 0;    //当前数据元素位序

    if (! L.elem)
    {
        return ERROR;    //线性表不存在,函数执行失败
    }

    //为调用LocateElem函数，定义函数指针compare
    Status (*cmp) (ElemType Elem, ElemType AnotherElem) = compare;
    //利用LocateElem函数定位数据元素cur_e;
    cur_pos = LocateElem (L, cur_e, cmp);

    //目标元素不存在或为首元素，执行失败
    //否则将前驱元素值存入e所指内存单元
    if (cur_pos == 0 || cur_pos == 1)
    {
        return ERROR;
    }

    (*pre_e) = L.elem[cur_pos - 2];
    return OK;
}

Status NextElem (Sqlist L, ElemType cur_e, ElemType * next_e)
{
    int cur_pos = 0;    //当前数据元素位序

    if (! L.elem)
    {
        return ERROR;    //线性表不存在,函数执行失败
    }

    //为调用LocateElem函数，定义函数指针compare
    Status (*cmp) (ElemType Elem, ElemType AnotherElem) = compare;
    //利用LocateElem函数定位数据元素cur_e;
    cur_pos = LocateElem (L, cur_e, cmp);

    //目标元素不存在或为尾元素，执行失败
    //否则将前驱元素值存入e所指内存单元
    if (cur_pos == 0 || cur_pos == L.length)
    {
        return ERROR;
    }

    (*next_e) = L.elem[cur_pos];
    return OK;
}

Status ListInsert (Sqlist * L, int i, ElemType e)
{
    int j;    //循环变量
    //为扩容而分配的新基址newBase
    ElemType * newBase;

    //线性表不存在,函数执行失败
    if (! (*L).elem)
    {
        return ERROR;
    }

    //i超出范围,函数执行失败
    if (i < 1 || i > (*L).length + 1)
    {
        return ERROR;
    }

    if ( (*L).length >= (*L).listsize)     //当前存储空间已满，增加存储总容量
    {
        newBase = (ElemType *) realloc ( (*L).elem, ( (*L).listsize + LISTINCREMENT) * sizeof (ElemType));

        if (! newBase)
        {
            exit (OVERFLOW);    //存储分配失败
        }

        (*L).elem = newBase;              //新基址
        (*L).listsize += LISTINCREMENT;   //增加存储容量
    }

    //插入位置及之后的元素右移
    for (j = (*L).length; j >= i; j--)
    {
        (*L).elem[j] = (*L).elem[j - 1];
    }

    //插入e
    (*L).elem[i - 1] = e;
    //表长增1
    (*L).length++;
    return OK;
}

Status ListDelete (Sqlist * L, int i, ElemType * e)
{
    int j;
    //线性表不存在,函数执行失败
    if (! (*L).elem)
    {
        return ERROR;
    }

    //i超出范围,函数执行失败
    if (i < 1 || i > (*L).length)
    {
        return ERROR;
    }

    //被删除元素的值
    (*e) = (*L).elem[i - 1];

    //删除位置之后的元素左移
    for (j = i; j < (*L).length; j++)
    {
        (*L).elem[j - 1] = (*L).elem[j];
    }

    //表长减1
    (*L).length--;
    return OK;
}

Status ListTraverse (Sqlist L, Status (*visitor) (ElemType Elem))
{
    int i;
    //线性表不存在,函数执行失败
    if (! L.elem)
    {
        return ERROR;
    }


    //遍历线性表
    for (i = 1; i <= ListLength (L); i++)
    {
        visitor (L.elem[i - 1]);
    }

    return OK;
}

Status visit (ElemType Elem)
{
    printf ("%d\n", Elem);
    return OK;
}

Status LoadData (Sqlist *L)
{
    FILE *fp;    //文件指针
    if ((fp = fopen("output.txt","r")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //读取二进制数据
    while( fread(&(L->elem[L->length]), sizeof(ElemType), 1, fp) )
    {
        L->length++;
    }

    fclose(fp);
    return OK;
}

Status SavaData (Sqlist L)
{
    FILE *fp;    //文件指针
    if ((fp = fopen("output.txt","w")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //保存二进制数据
    fwrite(L.elem, sizeof(ElemType), L.length, fp);

    fclose(fp);

    return OK;
}

int main (void)
{
    Sqlist sqlist;     //线性表结构
    sqlist.elem = NULL;
    ElemType input;    //用户输入变量
    ElemType container;//用于存放各个功能函数反馈的数据元素值
    Status (*test_compare) (ElemType, ElemType) = compare;
    Status (*test_visit) (ElemType) = visit;
    //初始化线性表
    InitList (&sqlist);
    //读取数据
    if (LoadData(&sqlist) == ERROR )
    {
        exit(ERROR);
    }
    //打印系统菜单界面
    printf ("\t\t欢迎使用顺序线性表\n\n");

    while (TRUE)
    {
        //打印系统菜单界面
        printf ("1:重置线性表\n");
        printf ("2:查询是否为空表\n");
        printf ("3:查询表长\n");
        printf ("4:查询元素\n");
        printf ("5:定位元素\n");
        printf ("6:查询前驱元素\n");
        printf ("7:查询后继元素\n");
        printf ("8:插入元素\n");
        printf ("9:删除元素\n");
        printf ("10:遍历线性表\n");
        printf ("11:退出系统\n\n");
        //提示用户选择功能
        printf ("请输入所选功能选项:");
        //用户选择事件
        scanf ("%d", &input);

        //处理用户选择事件
        switch (input)
        {

        case 1:
            ClearList (&sqlist);
            printf ("已重置\n");
            break;

        case 2:
            if (ListEmpty (sqlist) == TRUE)
            {
                printf ("当前表为空表\n");
            }
            else
            {
                printf ("当前表不为空表\n");
            }

            break;

        case 3:
            container = ListLength (sqlist);
            printf ("当前表长为：%d\n", container);
            break;

        case 4:
            printf ("请输入目标元素位序:");
            scanf ("%d", &input);

            if (GetElem (sqlist, input, &container) == ERROR)
            {
                printf ("查询失败\n");
            }
            else
            {
                printf ("目标元素值为:%d\n", container);
            }

            break;

        case 5:
            printf ("请输入目标元素值:");
            scanf ("%d", &input);

            if ( (container = LocateElem (sqlist, input, test_compare)) == 0)
            {
                printf ("定位失败，不存在此元素\n");
            }
            else
            {
                printf ("目标元素位序为:%d\n", container);
            }

            break;

        case 6:
            printf ("请输入目标元素值:");
            scanf ("%d", &input);

            if (PriorElem (sqlist, input, &container) == ERROR)
            {
                printf ("查询失败，此元素不存在前驱元素\n");
            }
            else
            {
                printf ("目标前驱元素为:%d\n", container);
            }

            break;

        case 7:
            printf ("请输入目标元素值:");
            scanf ("%d", &input);

            if (NextElem (sqlist, input, &container) == ERROR)
            {
                printf ("查询失败，此元素不存在后继元素\n");
            }
            else
            {
                printf ("目标后继元素为:%d\n", container);
            }

            break;

        case 8:
            printf ("请输入插入元素位序:");
            scanf ("%d", &input);
            printf ("请输入插入元素值:");
            scanf ("%d", &container);

            if (ListInsert (&sqlist, input, container) == ERROR)
            {
                printf ("插入失败\n");
            }
            else
            {
                printf ("插入 %d 成功\n", container);
            }

            break;

        case 9:
            printf ("请输入删除元素位序:");
            scanf ("%d", &input);

            if (ListDelete (&sqlist, input, &container) == ERROR)
            {
                printf ("删除失败\n");
            }
            else
            {
                printf ("删除 %d 成功\n", container);
            }

            break;

        case 10:
            ListTraverse (sqlist, test_visit);
            break;

        case 11:
            //保存数据
            if (SavaData(sqlist) == ERROR)
            {
                exit(ERROR);
            }
            //销毁线性表
            DestroyList (&sqlist);
            exit (OK);
            break;

        default:
            printf ("所选功能不存在,请重新选择功能");
            break;
        }

        printf ("\n********************\n");
    }
}
