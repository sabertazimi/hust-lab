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

#define LIST_INIT_SIZE 100

//定义链式存储的线性表数据结构
typedef struct LNode
{
    ElemType data;
    struct LNode * next;
} LNode, *LinkList;

/**
 * 构造一个空的线性表
 * @param  L 线性表地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status InitList (LNode  * L);

/**
 * 销毁线性表L
 * 初始条件:线性表L已存在
 * @param  L 线性表地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status DestroyList (LNode * L);

/**
 * 将L重置为空表
 * 初始条件:线性表已存在
 * @param  L 线性表地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status ClearList (LNode * L);

/**
 * 查询L是否为空表
 * 初始条件:线性表L已存在
 * @param  L 线性表L
 * @return   若L为空表,则返回TRUE,否则返回FALSE
 */
Status ListEmpty (LNode * L);

/**
 * 查询L的当前长度
 * 初始条件:线性表L已存在
 * @param  L 线性表L
 * @return   L中数据元素的个数
 */
int ListLength (LNode * L);

/**
 * 查询L中第i个数据元素的值
 * 初始条件：线性表已存在，1 ≤ i ≤ ListLength(L)
 * @param  L 线性表L
 * @param  i 数据元素的位序
 * @param  e 用于存放数据元素的值
 * @return   操作结果状态Status OK/ERROR
 */
Status GetElem (LNode * L, int i, ElemType * e);

/**
 * 查询满足比较规则的线性表数据元素的位序
 * 初始条件：线性表已存在
 * @param  L 线性表L
 * @param  e 目标数据元素值
 * @param  compare 自定义数据元素比较规则
 * @return   L中第1个与e满足关系compare()关系的数据元素的位序(不存在为0)
 */
int LocateElem (LNode * L, ElemType e, Status (*cmp) (ElemType Elem, LNode * AnotherElem));

/**
 * 定义L中元素的比较规则
 * @param  Elem        L中某个元素
 * @param  AnotherElem L中另一元素
 * @return             比较结果 TRUE/FALSE
 */
Status compare (ElemType Elem, LNode * AnotherElem);

/**
 * 查询目标元素的前驱元素的值
 * 初始条件:线性表已存在
 * @param  L 线性表L
 * @param  cur_e 目标数据元素值
 * @param  pre_e 用于存放前驱元素的值
 * @return       若cur_e是L的数据元素，且不是第一个，则用pre_e返回它的前驱，
 *               否则操作失败，pre_e无定义
 */
Status PriorElem (LNode * L, ElemType cur_e, ElemType * pre_e);

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
Status NextElem (LNode * L, ElemType cur_e, ElemType * next_e);

/**
 * 在L的第i个位置之前插入新的数据元素e，L的长度加1
 * 初始条件:线性表L已存在且非空，1 ≤ i ≤ ListLength(L)+1
 * 调用函数:LocateElem
 * @param  L 线性表地址值
 * @param  i 目标插入位序
 * @param  e 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status ListInsert (LNode * L, int i, ElemType e);

/**
 * 删除L的第i个数据元素，用e返回其值，L的长度减1
 * 初始条件：线性表L已存在，1 ≤ i ≤ ListLength(L)
 * @param  L 线性表地址值
 * @param  i 目标删除位序
 * @param  e 用于保留删除数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status ListDelete (LNode * L, int i, ElemType * e);

/**
 * 遍历线性表L,并对每一元素都执行visit操作
 * 初始条件:线性表L已存在
 * @param  L 线性表L
 * @param  visit 对线性表L中每一元素所作操作
 * @return   操作结果状态Status OK/ERROR
 */
Status ListTraverse (LNode * L, Status (*visitor) (LNode  * Elem));

/**
 * 打印数据元素Elem的值
 * @param  Elem 线性表L中的某一元素
 * @return   操作结果状态Status OK/ERROR
 */
Status visit (LNode * Elem);

Status InitList (LNode * L)
{
    //构造一个空的线性表L
    L->next = NULL;
    return OK;
}

Status DestroyList (LNode * L)
{
    //遍历指针
    LNode * prior, *current;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    prior = L->next;
    //空表
    if (!prior)
    {
        current = NULL;
    }
    //遍历释放各个结点所占内存单元
    else
    {
        for (current = prior->next;prior->next != NULL;
                prior = current, current = current->next)
        {
            free (prior);
        }
    }

    return OK;
}

Status ClearList (LNode * L)
{
    //遍历指针
    LNode * prior, * current;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    prior = L->next;
    //空表
    if (!prior)
    {
        current = NULL;
    }
    //遍历释放各个结点所占内存单元
    else
    {
        for (current = prior->next; prior->next != NULL;
                prior = current, current = current->next)
        {
            free (prior);
        }
    }

    //线性表存在,函数执行正确
    L->next = NULL;
    return OK;

}

Status ListEmpty (LNode * L)
{
    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    //线性表存在,函数执行正确
    return L->next == NULL;
}

int ListLength (LNode * L)
{
    //链表长度
    int length;
    //链表遍历指针
    LNode * ptr;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    //线性表存在,函数执行正确
    //遍历链表,查找链表长度
    for (ptr = L, length = 0; ptr->next != NULL; ptr = ptr->next, length++)
    {
        ;
    }

    return length;
}

Status GetElem (LNode * L, int i, ElemType * e)
{
    //循环变量
    int j;
    //链表遍历指针
    LNode * ptr;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    if (i < 1 || i > ListLength (L))
    {
        return ERROR;
    }

    //函数执行正确
    //遍历链表,查找目标元素
    for (ptr = L, j = 0; j < i; ptr = ptr->next, j++)
    {
        ;
    }

    (*e) = ptr->data;//将目标元素值存入e指向内存单元
    return OK;
}

int LocateElem (LNode * L, ElemType e,
                Status (*cmp) (ElemType Elem, LNode * AnotherElem))
{
    //循环变量
    int i;
    //链表遍历指针
    LNode * ptr;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    //初始化i为1
    //遍历线性表,直至表尾或找到目标元素
    for (ptr = L->next, i = 1; i <= ListLength (L) && cmp (e, ptr) == FALSE; ptr = ptr->next, i++)
    {
        ;
    }

    //当i>L.length时，说明表中无目标元素，返回0
    //当i<L.length时，说明成功找到目标元素，返回其位序
    return (i <= ListLength (L) ? i : 0);
}

Status compare (ElemType Elem, LNode * AnotherElem)
{
    return Elem == AnotherElem->data ? TRUE : FALSE;
}

Status PriorElem (LNode * L, ElemType cur_e, ElemType * pre_e)
{
    {
        //循环变量
        int i;
        //链表遍历指针
        LNode * ptr;
        int cur_pos = 0;    //当前数据元素位序

        if (! L)
        {
            return ERROR;    //线性表不存在,函数执行失败
        }

        //为调用LocateElem函数，定义函数指针compare
        Status (*cmp) (ElemType Elem, LNode * AnotherElem) = compare;
        //利用LocateElem函数定位数据元素cur_e;
        cur_pos = LocateElem (L, cur_e, cmp);

        //目标元素不存在或为首元素，执行失败
        //否则将前驱元素值存入e所指内存单元
        if (cur_pos == 0 || cur_pos == 1)
        {
            return ERROR;
        }

        //遍历线性表,直至找到目标元素
        for (ptr = L, i = 0; i < cur_pos - 1; ptr = ptr->next, i++);

        (*pre_e) = ptr->data;
        return OK;
    }
}

Status NextElem (LNode * L, ElemType cur_e, ElemType * next_e)
{
    //循环变量
    int i;
    //链表遍历指针
    LNode * ptr;
    int cur_pos = 0;
    //当前数据元素位序

    if (! L)
    {
        return ERROR;    //线性表不存在,函数执行失败
    }

    //为调用LocateElem函数，定义函数指针compare
    Status (*cmp) (ElemType Elem, LNode * AnotherElem) = compare;
    //利用LocateElem函数定位数据元素cur_e;
    cur_pos = LocateElem (L, cur_e, cmp);

    //目标元素不存在或为尾元素，执行失败
    //否则将前驱元素值存入e所指内存单元
    if (cur_pos == 0 || cur_pos == ListLength (L))
    {
        return ERROR;
    }

    //遍历线性表,直至找到目标元素
    for (ptr = L, i = 0; i < cur_pos + 1; ptr = ptr->next, i++);

    (*next_e) = ptr->data;
    return OK;
}

Status ListInsert (LNode * L, int i, ElemType e)
{
    int j;    //循环变量
    //链表遍历指针
    LNode * ptr;
    //插入结点
    LNode * insNode;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    //i超出范围,函数执行失败
    if (i < 1 || i > ListLength (L) + 1)
    {
        return ERROR;
    }

    //构造插入结点
    insNode = (LNode *) malloc (sizeof (LNode));
    insNode->data = e;

    //插入操作
    //寻找前驱结点
    for (ptr = L, j = 0; j < i - 1; ptr = ptr->next, j++)
    {
        ;
    }


    //插入新结点
    insNode->next = ptr->next;
    ptr->next = insNode;

    return OK;
}

Status ListDelete (LNode * L, int i, ElemType * e)
{
    int j;    //循环变量
    //链表遍历指针
    LNode * ptr;
    //保存被删除结点
    LNode * delNode;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }


    //i超出范围,函数执行失败
    if (i < 1 || i > ListLength (L))
    {
        return ERROR;
    }


    //删除操作
    //寻找前驱结点
    for (ptr = L, j = 0; j < i - 1; ptr = ptr->next, j++)
    {
        ;
    }

    //保存删除结点值
    (*e) = ptr->next->data;
    //删除目标结点
    delNode = ptr->next;
    ptr->next = delNode->next;
    free (delNode);
    return OK;
}

Status ListTraverse (LNode * L, Status (*visitor) (LNode * Elem))
{
    //遍历指针
    LNode * ptr;

    //线性表不存在,函数执行失败
    if (! L)
    {
        return ERROR;
    }

    //空表
    if (!L->next)
    {
        return ERROR;
    }
    //遍历线性表
    for (ptr = L->next; ptr != NULL ; ptr = ptr->next)
    {
        visitor (ptr);
    }

    return OK;
}

Status visit (LNode * Elem)
{
    printf ("%d\n", Elem->data);
    return OK;
}

int main (void)
{
    //为LIST_INIT_SIZE个链表首结点分配合适内存单元
    LNode * multi_list = (LNode *)malloc(LIST_INIT_SIZE * sizeof(LNode));
    if (! multi_list) exit(OVERFLOW);       //内存空间不足，退出系统
    int list_id = 1;                        //链表ID号,初始化为1，表示默认操作第一个链表
    int max_list_id = LIST_INIT_SIZE;       //最大ID号
    ElemType input;                         //用户输入变量
    ElemType container;                     //用于存放各个功能函数反馈的数据元素值
    Status (*test_compare) (ElemType, LNode *) = compare;
    Status (*test_visit) (LNode *) = visit;
    //初始化所有链表
    for (list_id = 1;list_id <= LIST_INIT_SIZE;list_id++)
    {
        InitList(multi_list + list_id - 1);
    }
    
    //当前操作链表重置为第一个链表
    list_id = 1;
    //打印系统菜单界面
    printf ("\t\tWelcome to MultiList System\n\n");

    while (TRUE)
    {
        //打印系统菜单界面
        printf ("1:Clear List\n");
        printf ("2:Require List Empty or Not\n");
        printf ("3:Require List Length\n");
        printf ("4:Require List Element by Inputing Position\n");
        printf ("5:Require List Element by Inputing Value\n");
        printf ("6:Require Prior Element\n");
        printf ("7:Require Next Element\n");
        printf ("8:Insert Element\n");
        printf ("9:Delete Element\n");
        printf ("10:Traverse List\n");
        printf ("11:Change List to be Manipulated(ID:1-%d)\n", max_list_id);
        printf ("12:Exit System\n\n");
        //提示用户选择功能
        printf ("Please Choose Function:");
        //用户选择事件
        scanf ("%d", &input);

        //处理用户选择事件
        switch (input)
        {

        case 1:
            ClearList (multi_list + list_id - 1);
            printf ("Clear Success\n");
            break;

        case 2:
            if (ListEmpty (multi_list + list_id - 1) == TRUE)
            {
                printf ("No.%d List is Empty\n", list_id);
            }
            else
            {
                printf ("No.%d List is not Empty\n", list_id);
            }

            break;

        case 3:
            container = ListLength (multi_list + list_id - 1);
            printf ("No.%d List Length:%d\n", list_id, container);
            break;

        case 4:
            printf ("Please input target position:");
            scanf ("%d", &input);

            if (GetElem (multi_list + list_id - 1, input, &container) == ERROR)
            {
                printf ("Require Failed\n");
            }
            else
            {
                printf ("No.%d Element Value:%d\n", input, container);
            }

            break;

        case 5:
            printf ("Please input target value:");
            scanf ("%d", &input);

            if ( (container = LocateElem (multi_list + list_id - 1, input, test_compare)) == 0)
            {
                printf ("Locate Failed\n");
            }
            else
            {
                printf ("The position of %d :%d\n", input, container);
            }

            break;

        case 6:
            printf ("Please input target value:");
            scanf ("%d", &input);

            if (PriorElem (multi_list + list_id - 1, input, &container) == ERROR)
            {
                printf ("No Prior Element\n");
            }
            else
            {
                printf ("Prior Element:%d\n", container);
            }

            break;

        case 7:
            printf ("Please input target value:");
            scanf ("%d", &input);

            if (NextElem (multi_list + list_id - 1, input, &container) == ERROR)
            {
                printf ("No Next Element\n");
            }
            else
            {
                printf ("Next Element:%d\n", container);
            }

            break;

        case 8:
            printf ("Please input position to be inserted:");
            scanf ("%d", &input);
            printf ("Please input value to be inserted:");
            scanf ("%d", &container);

            if (ListInsert (multi_list + list_id - 1, input, container) == ERROR)
            {
                printf ("Insert Failed\n");
            }
            else
            {
                printf ("Insert %d Success\n", container);
            }

            break;

        case 9:
            printf ("Please input the position of element to be deleted:");
            scanf ("%d", &input);

            if (ListDelete (multi_list + list_id - 1, input, &container) == ERROR)
            {
                printf ("Delete Failed\n");
            }
            else
            {
                printf ("Delete %d Success\n", container);
            }

            break;

        case 10:
            if (ListTraverse (multi_list + list_id - 1, test_visit) == ERROR)
            {
                printf("Traverse Failed\n");
            }
            break;

        case 11:
            //此循环用于限定用户输入
            do
            {
                printf("Please input target ID:");
                //用户键入目标链表ID
                scanf("%d", &list_id);
            }
            while(list_id < 1 || list_id > LIST_INIT_SIZE);
            break;

        case 12:
            //将线性表存入文件
            //将标准输出重定向至输出文件output
            freopen("output.txt", "w", stdout);
            //调用ListTraverse函数,将链表打印至output
            for(list_id = 1;list_id <= LIST_INIT_SIZE;list_id++)
            {
                 ListTraverse(multi_list + list_id - 1, test_visit);
            }
            //销毁多线性表
            for(list_id = 1;list_id <= LIST_INIT_SIZE;list_id++)
            {
                DestroyList(multi_list + list_id - 1);
            }
            //销毁所有首结点
            free(multi_list);
            exit (OK);
            break;

        default:
            printf ("No Such Function");
            break;
        }

        printf ("\n********************\n");
    }

}