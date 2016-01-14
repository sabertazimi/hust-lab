#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

//系统可操作二叉树的个数
#define TREE_INIT_SIZE 100

//定义二叉树的二叉链表存储
typedef struct BiTNode
{
    ElemType data;     
    struct BiTNode * lchild, * rchild;    //左右孩子指针
} BiTNode, * BiTree;

/**
 * 构造一个空二叉树T
 * @param  T 二叉树
 * @call   BiTreeEmpty
 * @return   操作结果状态Status OK/ERROR
 */
Status InitBiTree (BiTree * T);

/**
 * 销毁二叉树T
 * 初始条件:二叉树T已存在
 * @param  T 二叉树
 * @return   操作结果状态Status OK/ERROR
 */
Status DestroyBiTree (BiTree T);

/**
 * 按前序和中序序列构造二叉树
 * @param  T           二叉树
 * @param  presequence 前序序列
 * @param  insequence  中序序列
 * @call   strlen
 * @call   myStrncpy
 * @return             操作结果状态Status OK/ERROR
 */
Status CreateBiTree(BiTree * T, char * presequence,char * insequence);

/**
 * 将T重置为空二叉树
 * 初始条件:二叉树已存在
 * @param  T 二叉树
 * @return   操作结果状态Status OK/ERROR
 */
Status ClearBiTree (BiTree T);

/**
 * 查询T是否为空二叉树
 * 初始条件:二叉树T已存在
 * @param  T 二叉树T
 * @return   若T为空二叉树,则返回TRUE,否则返回FALSE
 */
Status BiTreeEmpty (BiTree T);

/**
 * 查询T的深度
 * 初始条件:二叉树T已存在
 * @param  T 二叉树T
 * @return   T的层数
 */
int BiTreeDepth(BiTree T);

/**
 * 查找二叉树的根结点
 * 初始条件:二叉树T已存在
 * @param  T 二叉树
 * @call   BiTreeEmpty
 * @return   T的根结点
 */
BiTNode * Root(BiTree T);

/**
 * 定位结点e在树T中的位置
 * 初始条件:二叉树T已存在且不为空
 * @param  T 二叉树
 * @param  e 目标结点
 * @call   BiTreeEmpty
 * @return   e不在树中返回NULL;e在树中返回e的地址
 */
BiTNode * Locate(BiTree T, BiTNode e);

/**
 * 查询结点e的值
 * 初始条件:二叉树T已存在，e是T中结点
 * @param  T 二叉树
 * @param  e T中结点
 * @call   BiTreeEmpty
 * @call   Locate
 * @return   e的值
 */
ElemType Value(BiTree T, BiTNode e);

/**
 * 给结点e赋值value
 * 
 * @param  T     二叉树
 * @param  e     目标结点
 * @param  value 所赋值
 * @call   BiTreeEmpty
 * @call   Locate
 * @return       操作结果状态 OK/ERROR
 */
Status Assign(BiTree T, BiTNode e, ElemType value);

/**
 * 查找目标结点的双亲结点
 * 初始条件:二叉树T已存在,e是T中结点
 * @param  T 二叉树
 * @param  e 目标结点
 * @call   BiTreeEmpty
 * @return   非根结点返回双亲结点指针，否则返回NULL
 */
BiTNode * Parent(BiTree T, BiTNode e);

/**
 * 查找目标结点的左孩子结点
 * 初始条件:二叉树T已存在,e是T中结点
 * @param  T 二叉树
 * @param  e 目标结点
 * @call   BiTreeEmpty
 * @call   Locate
 * @return   返回左孩子结点指针/NULL
 */
BiTNode * LeftChild(BiTree T, BiTNode e);

/**
 * 查找目标结点的右孩子结点
 * 初始条件:二叉树T已存在,e是T中结点
 * @param  T 二叉树
 * @param  e 目标结点
 * @call   BiTreeEmpty
 * @call   Locate
 * @return   返回右孩子结点指针/NULL
 */
BiTNode * RightChild(BiTree T, BiTNode e);

/**
 * 查找目标结点的左兄弟结点
 * 初始条件:二叉树T已存在,e是T中结点
 * @param  T 二叉树
 * @param  e 目标结点
 * @call   BiTreeEmpty
 * @call   Locate
 * @call   Parent
 * @return   返回左兄弟结点指针/NULL
 */
BiTNode * LeftSibling(BiTree T, BiTNode e);

/**
 * 查找目标结点的右兄弟结点
 * 初始条件:二叉树T已存在,e是T中结点
 * @param  T 二叉树
 * @param  e 目标结点
 * @call   BiTreeEmpty
 * @call   Locate
 * @call   Parent
 * @return   返回右兄弟结点指针/NULL
 */
BiTNode * RightSibling(BiTree T, BiTNode e);

/**
 * 将c插入T中，c作为p的左子树/右子树
 * 初始条件:  二叉树T存在，p指向T中的某个结点，LR为0或1，,非空二
              叉树c与T不相交且右子树为空
 * @param  T  二叉树
 * @param  p  T中目标结点
 * @param  LR 左右子树选择符
 * @param  c  新结点(插入结点)
 * @call   BiTreeEmpty
 * @call   Locate
 * @return    操作结果状态 OK/ERROR
 */
Status InsertChild(BiTree T, BiTNode p, int LR, BiTree c);

/**
 * 删除T中的结点p
 * 初始条件:  二叉树T存在，p指向T中的某个结点，LR为0或1
 * @param  T  二叉树
 * @param  p  T中目标结点
 * @param  LR 左右子树选择符
 * @call   BiTreeEmpty
 * @call   Locate
 * @return    操作结果状态 OK/ERROR
 */
Status DeleteChild(BiTree T, BiTNode p, int LR);

/**
 * 先序遍历二叉树T
 * 初始条件:二叉树T已存在
 * @param  T     二叉树
 * @param  visit 访问操作函数
 * @call   BiTreeEmpty
 * @call   Visit
 * @return       操作结果状态 OK/ERROR
 */
Status PreOrderTraverse(BiTree T, Status (*visit)(BiTNode * e));

/**
 * 中序遍历二叉树T
 * 初始条件:二叉树T已存在
 * @param  T     二叉树
 * @param  visit 访问操作函数
 * @call   BiTreeEmpty
 * @call   Visit
 * @return       操作结果状态 OK/ERROR
 */
Status InOrderTraverse(BiTree T, Status (*visit)(BiTNode * e));

/**
 * 后序遍历二叉树T
 * 初始条件:二叉树T已存在
 * @param  T     二叉树
 * @param  visit 访问操作函数
 * @call   BiTreeEmpty
 * @call   Visit
 * @return       操作结果状态 OK/ERROR
 */
Status PostOrderTraverse(BiTree T, Status (*visit)(BiTNode * e));

/**
 * 层序遍历二叉树T
 * 初始条件:二叉树T已存在
 * @param  T     二叉树
 * @param  visit 访问操作函数
 * @call   BiTreeEmpty
 * @call   Visit
 * @call   InitQueue/DestoryQueue/EnQueue/DeQueue
 * @return       操作结果状态 OK/ERROR
 */
Status LevelOrderTraverse(BiTree T, Status (*visit)(BiTNode * e));

/**
 * 输出结点e的值
 * @param  e 二叉树T中结点
 * @return   操作结果状态Status OK/ERROR
 */
Status Visit (BiTNode * e);

/**
 * 以凹入表形式打印二叉树T
 * 根结点位于中央，右子树位于上方，左子树位于下方
 * 初始条件:二叉树T已存在且非空
 * @param  T        二叉树
 * @param  instance 凹入表间距
 * @call   BiTreeEmpty
 * @return          操作结果状态 OK/ERROR
 */
Status RTPrint(BiTree T, int instance);

/**
 * 以广义表形式打印二叉树T
 * 初始条件:二叉树T已存在且非空
 * @param  T  二叉树
 * @call   BiTreeEmpty
 * @return    操作结果状态 OK/ERROR
 */
Status GLPrint(BiTree T);

/**
 * 从output.txt读取数据
 * @param  T 多二叉树头指针
 * @call CreateBiTree
 * @return   操作结果状态Status OK/ERROR
 */
Status LoadData (BiTree * T);

/**
 * 保存数据至output.txt
 * @param  T      多二叉树头指针
 * @param  visit  访问操作函数指针(重定向标准输出流)
 * @call   BiTreeEmpty
 * @call   NodeNum
 * @call   PreOrderTraverse
 * @call   InOrderTraverse
 * @return        操作结果状态Status OK/ERROR
 */
Status SaveData (BiTree *T, Status (*visit)(BiTNode * e));

/**
 * 改进strncpy库函数，使之自动在dest为添加'\0'
 * @param  dest 目标字符串
 * @param  src  元字符串    
 * @param  n    拷贝字符个数
 * @return      拷贝成功:dest,拷贝失败:NULL
 */
char *myStrncpy(char *dest, const char *src, size_t n);

/**
 * 计算二叉树结点总数,用于存储至output.txt
 * @param  T   二叉树
 * @param  num 结点总数地址值
 * @return     操作结果状态 OK/ERROR
 */
Status NodeNum(BiTree T, int *num);


/*************************************************************************
 * 说明：利用队列,实现二叉树中部分函数(如层序遍历算法)
 ************************************************************************/

//最大队列长度
#define MAXQSIZE 100

//定义顺序存储循环队列数据结构
typedef struct Queue
{
    BiTNode * * base;   //初始化的动态分配存储空间，在队列构造之前和销毁之后，base的值为NULL
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
 * 查询Q是否为空队列
 * 初始条件:队列Q已存在
 * @param  Q 队列Q
 * @return   若Q为空队列,则返回TRUE,否则返回FALSE
 */
Status QueueEmpty (Queue Q);

/**
 * 插入元素e为新的队列尾元素
 * 初始条件:队列Q已存在
 * @param  Q 队列地址值
 * @param  e 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status EnQueue (Queue * Q, BiTNode * e);

/**
 * 删除队列Q的队列首元素，并送入e
 * 初始条件：队列Q已存且非空
 * @param  Q 队列地址值
 * @param  e 用于保留删除数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status DeQueue (Queue * Q, BiTNode * * e);

Status InitBiTree (BiTree * T)
{   //构造根结点
    (*T) = (BiTree)malloc(sizeof(BiTNode));
    //根结点data域置为空
    (*T)->data = '\0';
    //左右子树置为空
    (*T)->lchild = (*T)->rchild = NULL;
    //检查所构造树是否为空树
    if (BiTreeEmpty(*T) == TRUE) return OK;
    else return ERROR;
}

Status DestroyBiTree (BiTree T)
{   //二叉树不存在,ERROR
    if(T == NULL) return ERROR;
    //销毁二叉树
    DestroyBiTree(T->lchild);    //销毁左子树
    DestroyBiTree(T->rchild);    //销毁右子树
    free(T);                     //销毁根结点

    return OK;
}

Status CreateBiTree(BiTree * T, char * presequence,char * insequence)
{  //前/中序序列为空，构造的二叉树为空
    if(strlen(presequence) == 0 || strlen(insequence) == 0)  
    {  
        *T = NULL;  
        return ERROR; 
    }

    char rootNode = presequence[0];                                                              //根结点  
    int rootIndex = strchr(insequence, rootNode) - insequence;                                   //根在中序序列中的位置  

    //截取左/右子树的中序序列
    char * lchild_insequence = (char *)malloc(strlen(insequence) * sizeof(char));                //左子树的中序序列
    char * rchild_insequence = (char *)malloc(strlen(insequence) * sizeof(char));                //右子树的中序序列
    myStrncpy(lchild_insequence, insequence, rootIndex );                                        //左子树的中序序列
    myStrncpy(rchild_insequence, insequence + rootIndex + 1, strlen(insequence) - rootIndex - 1);//右子树的中序序列  
    
    int lchild_length = strlen(lchild_insequence);                                               //左子树的长度  
    int rchild_length = strlen(rchild_insequence);                                               //右子树的长度   

    //截取左/右子树的前序序列
    char * lchild_presequence = (char *)malloc(strlen(presequence) * sizeof(char));              //左子树的前序序列
    char * rchild_presequence = (char *)malloc(strlen(presequence) * sizeof(char));              //右子树的前序序列
    myStrncpy(lchild_presequence, presequence + 1, lchild_length);                               //左子树的前序序列                   
    myStrncpy(rchild_presequence, presequence + 1 + lchild_length, rchild_length);               //右子树的前序序列  
    
    //构造根结点
    (*T) = (BiTree)malloc(sizeof(BiTNode));
    //分配内存失败
    if (*T == NULL) return OVERFLOW; 
    //赋值根结点data域
    (*T)->data = rootNode;
    CreateBiTree(&((*T)->lchild), lchild_presequence, lchild_insequence);    //创建左子树  
    CreateBiTree(&((*T)->rchild), rchild_presequence, rchild_insequence);    //创建右子树  

    return OK;  
}

Status ClearBiTree (BiTree T)
{   //二叉树不存在，返回ERROR
    if (T == NULL) return ERROR;
    //清空左右子树，data域置为空
    T->lchild = T->rchild = NULL;
    T->data = '\0';
    return OK;
}

Status BiTreeEmpty (BiTree T)
{   //二叉树不存在，返回ERROR
    if (T == NULL) return ERROR;
    //根结点的左右子树都为空,且data域为空，二叉树为空
    return (T->lchild == NULL && T->rchild == NULL && T->data == '\0') ? TRUE : FALSE;
}

int BiTreeDepth(BiTree T)
{
    int depth = 0;    //二叉树的深度
    int ldepth;       //左子树深度
    int rdepth;       //右子树深度
    int subdepth;     //子树最大深度
    
    //二叉树不存在,ERROR
    if (T == NULL) return ERROR;

    //二叉树为空,深度为0
    if (BiTreeEmpty(T) == TRUE) depth = 0;
    //二叉树的根结点为子叶结点,深度为1
    else if(T->lchild == NULL && T->rchild == NULL) depth = 1;
    //二叉树的根结点为内点
    else if(T->lchild != NULL || T->rchild != NULL)
    {   //二叉树的深度为子树最大深度+1
        ldepth = BiTreeDepth(T->lchild);             //左子树深度
        rdepth = BiTreeDepth(T->rchild);             //右子树深度
        subdepth = ldepth > rdepth ? ldepth : rdepth;//子树最大深度
        depth = subdepth + 1; 
    }

    return depth;
}

BiTNode * Root(BiTree T)
{   //二叉树不存在,NULL
    if (T == NULL) return NULL;
    //二叉树存在,返回根结点
    return T;
}

BiTNode * Locate(BiTree T, BiTNode e)
{   
    BiTNode * dest = NULL;    //目标结点
    //二叉树不存在/空,dest为NULL
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = NULL;
    //否则，判断根结点是否为e
    else if (T->data == e.data) dest = T;
    //否则，在左子树中寻找目标结点e
    else if((dest = Locate(T->lchild, e)) != NULL) ;
    //否则，在右子树中寻找目标结点e
    else if((dest = Locate(T->rchild, e)) == NULL) dest = NULL;

    return dest;
}

ElemType Value(BiTree T, BiTNode e)
{
    ElemType dest;    //目标元素值
    BiTNode * pdest;  //目标结点
    //二叉树不存在/空,dest为ERROR
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = '\0';
    //否则，定位结点e，返回data域
    if((pdest = Locate(T, e)) != NULL) dest = pdest->data;
    else dest = '\0';

    return dest;
}

Status Assign(BiTree T, BiTNode e, ElemType value)
{
    BiTNode * dest;  //目标结点
    //二叉树不存在/空,ERROR
    if (T == NULL || BiTreeEmpty(T) == TRUE) return ERROR;
    //否则，定位结点e,并修改data域为value
    if((dest = Locate(T, e)) != NULL) dest->data = value;
    else return ERROR;

    return OK;
}

BiTNode * Parent(BiTree T, BiTNode e)
{
    BiTNode * dest = NULL;    //目标结点
    //二叉树不存在/空,dest为NULL
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = NULL;
    //否则，判断根结点是否为e的双亲
    else if (T->lchild || T->rchild )
    //以下多个if语句目的:防止Segmentation Fault
    {   //根结点有左孩子
        if (T->lchild)
        {
            if(T->lchild->data == e.data) dest = T;
        }
        //根结点有右孩子
        if (T->rchild)
        {
            if(T->rchild->data == e.data) dest = T;
        }

        //当前根结点不是目标结点的双亲,搜索左/右子树
        if (dest == NULL)
        {
            //在左子树中寻找目标结点e的双亲
            if((dest = Parent(T->lchild, e)) != NULL) ;
            //否则，在右子树中寻找目标结点e的双亲
            else if((dest = Parent(T->rchild, e)) == NULL) dest = NULL; 
        }   //end of if(dest==NULL):必须放于else if (T->lchild || T->rchild )内部
            //否则,将引起Segmentation Fault
    }

    return dest;
}

BiTNode * LeftChild(BiTree T, BiTNode e)
{
    BiTNode * dest = NULL;    //目标结点
    //二叉树不存在/空,dest为NULL
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = NULL;
    //否则，定位结点e,返回左孩子指针
    if((dest = Locate(T, e)) != NULL) dest = dest->lchild;
    else dest = NULL;

    return dest;
}

BiTNode * RightChild(BiTree T, BiTNode e)
{
    BiTNode * dest = NULL;    //目标结点
    //二叉树不存在/空,dest为NULL
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = NULL;
    //否则，定位结点e,返回右孩子指针
    if((dest = Locate(T, e)) != NULL) dest = dest->rchild;
    else dest = NULL;

    return dest;
}

BiTNode * LeftSibling(BiTree T, BiTNode e)
{
    BiTNode * dest = NULL;    //目标结点
    BiTNode * parent = NULL;  //目标结点的双亲结点
    //二叉树不存在/空,dest为NULL
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = NULL;
    //否则，定位结点e，返回左兄弟指针
    if((dest = Locate(T, e)) != NULL) 
    {
        //定位结点e的双亲结点
        parent = Parent(T, e);
        if(parent)  //具有双亲结点
        {   //结点e为左孩子，不存在左兄弟
            if(dest == parent->lchild) dest = NULL;
            //否则，返回结点e双亲的左孩子，即为e的左兄弟
            else dest = parent->lchild;
        }
    }
    else dest = NULL;

    return dest;
}

BiTNode * RightSibling(BiTree T, BiTNode e)
{
    BiTNode * dest = NULL;    //目标结点
    BiTNode * parent = NULL;  //目标结点的双亲结点
    //二叉树不存在/空,dest为NULL
    if (T == NULL || BiTreeEmpty(T) == TRUE) dest = NULL;
    //否则，定位结点e,返回右兄弟指针
    if((dest = Locate(T, e)) != NULL)
    {
        //定位结点e的双亲结点
        parent = Parent(T, e);
        if(parent)  //具有双亲结点
        {   //结点e为右孩子，不存在右兄弟
            if(dest == parent->rchild) dest = NULL;
            //否则，返回结点e双亲的右孩子，即为e的右兄弟
            else dest = parent->rchild;
        }
    }
    else dest = NULL;

    return dest;
}

Status InsertChild(BiTree T, BiTNode p, int LR, BiTree c)
{
    BiTNode * dest = NULL;    //目标结点
    //二叉树不存在/空,ERROR
    if (T == NULL || BiTreeEmpty(T) == TRUE) return ERROR;
    //二叉树c不存在/空/右子树不为空,ERROR
    if (c == NULL || BiTreeEmpty(c) == TRUE || c->rchild != NULL) return ERROR;
    //否则，定位结点p
    if((dest = Locate(T, p)) != NULL)
    {
        switch (LR)
        {   //将c插入为p的左子树
            case 0:
                //p的左子树作为c的右子树
                c->rchild = dest->lchild;
                //插入c
                dest->lchild = c;
                return OK;
            //将c插入为p的右子树
            case 1:
                //p的右子树作为c的右子树
                c->rchild = dest->rchild;
                //插入c
                dest->rchild = c;
                return OK;

            default:
                return ERROR;
        }
    }
    else return ERROR;
}

Status DeleteChild(BiTree T, BiTNode p, int LR)
{
    BiTNode * dest = NULL;    //目标结点
    //二叉树不存在/空,ERROR
    if (T == NULL || BiTreeEmpty(T) == TRUE) return ERROR;
    //否则，定位结点p
    if((dest = Locate(T, p)) != NULL)
    {
        switch (LR)
        {
            case 0:
                //删除左子树
                dest->lchild = NULL;
                return OK;

            case 1:
                //删除右子树
                dest->rchild = NULL;
                return OK;

            default:
                return ERROR;
        }
    }
    else return ERROR;
}

Status PreOrderTraverse(BiTree T, Status (*visit)(BiTNode * e))
{
    //二叉树不存在/空,遍历结束
    if (T == NULL || BiTreeEmpty(T) == TRUE) return OK;
    //遍历成功
    if (visit(T))
        if(PreOrderTraverse(T->lchild, visit))
            if(PreOrderTraverse(T->rchild, visit))
                return OK;
    //遍历失败
    return ERROR;
   
}

Status InOrderTraverse(BiTree T, Status (*visit)(BiTNode * e))
{  
    //二叉树不存在/空,遍历结束
    if (T == NULL || BiTreeEmpty(T) == TRUE) return OK;
    //遍历成功
    if(InOrderTraverse(T->lchild, visit))
        if (visit(T))
            if(InOrderTraverse(T->rchild, visit))
                return OK;
    //遍历失败
    return ERROR;
}

Status PostOrderTraverse(BiTree T, Status (*visit)(BiTNode * e))
{   
    //二叉树不存在/空,遍历结束
    if (T == NULL || BiTreeEmpty(T) == TRUE) return OK;
    //遍历成功
    if(PostOrderTraverse(T->lchild, visit))
        if(PostOrderTraverse(T->rchild, visit))
            if (visit(T))
                return OK;
    //遍历失败
    return ERROR;
}

Status LevelOrderTraverse(BiTree T, Status (*visit)(BiTNode * e))
{
    BiTNode * node;
    Queue queue;
    //二叉树不存在,ERROR
    if (T == NULL) return ERROR;
    //二叉树为空,遍历结束
    if (BiTreeEmpty(T) == TRUE) return OK;
    //初始化队列
    InitQueue(&queue);
    //根结点入列
    EnQueue(&queue,T);

    //利用队列数据结构,实现广度搜索算法
    while(!QueueEmpty(queue))
    {   //队尾结点出列
        DeQueue(&queue, &node);
        //访问队尾结点
        visit(node);
        //将队尾结点的左/右孩子入列
        if(node->lchild) EnQueue(&queue,node->lchild);
        if(node->rchild) EnQueue(&queue,node->rchild);
    }

    //销毁队列
    DestroyQueue(&queue);
    return OK;
}

Status Visit (BiTNode * e)
{   //结点不存在,ERROR
    if (e == NULL) return ERROR;
    printf("%c", e->data);
    return OK;
}

Status RTPrint(BiTree T, int instance)
{
    //二叉树不存在,ERROR
    if (T == NULL) return ERROR;
    //二叉树为空,ERROR
    if (BiTreeEmpty(T) == TRUE) return ERROR;

    //打印右子树
    RTPrint(T->rchild,instance + 5);
    //打印根结点
    for(int i = 0;i < instance;i++)
    {
        printf(" ");
    }
    printf("%5c\n",T->data);
    //打印左子树
    RTPrint(T->lchild,instance + 5);

    return OK;
}

Status GLPrint(BiTree T)
{
    //二叉树不存在,ERROR
    if (T == NULL) return ERROR;
    //二叉树为空,ERROR
    if (BiTreeEmpty(T) == TRUE) return ERROR;

    //打印根结点
    printf("%c",T->data);
    if(T->lchild || T->rchild)
    {
        printf("(");
        //打印左子树
        GLPrint(T->lchild);
        if(T->rchild)
            printf(",");
        //打印右子树
        GLPrint(T->rchild);
        printf(")");
    }

    return OK;
}

Status LoadData (BiTree * T)
{
    int bitree_id;                                //读取二叉树编号
    int * bitree_num = (int *)malloc(sizeof(int));//读取二叉树长度
    char * presequence;                           //读取的二叉树先序序列
    char * insequence;                            //读取的二叉树中序序列 
    char end[] = {'\0'};                          //串尾结束符
    FILE *fp;                                     //文件指针

    if ((fp = fopen("output.txt","r")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //读取数据
    while (TRUE) 
    {
        //将每个二叉树的第一个数据(编号)读取至bitree_id变量
        fread(&bitree_id, sizeof(int), 1, fp);
        //将每个二叉树的第二个数据(二叉树结点总数)读取至bitree_length变量
        fread(bitree_num, sizeof(int), 1, fp);
        //构造二叉树的前序序列与中序序列
        presequence = (char *)malloc( (*bitree_num + 1) * sizeof(char));
        insequence = (char *)malloc( (*bitree_num + 1) * sizeof(char));
        //从文件中读取前序序列与中序序列
        if (!fread(presequence, sizeof(char), *bitree_num, fp)) break;   //若读取完毕，退出循环
        if (!fread(insequence, sizeof(char), *bitree_num, fp)) break;    //若读取完毕，退出循环
        //添加'\0'，形成序列字符串
        strcpy(presequence + *bitree_num, end), strcpy(insequence + *bitree_num, end);
        //根据前序序列与中序序列创建二叉树
        CreateBiTree(T + bitree_id - 1, presequence, insequence);
    }

    fclose(fp);
    return OK;
}

Status SaveData (BiTree * T, Status (*visit)(BiTNode * e))
{
    int bitree_id;                                  //用于保存二叉树编号
    int * bitree_num  = (int *)malloc(sizeof(int)); //用于保存二叉树结点总数
    BiTree ptr;                                     //用于遍历所有二叉树

    //以覆盖原有数据的形式，重定向标准输出流至文件"output.txt"
    if (freopen("output.txt","w+", stdout) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //保存数据
    //遍历所有二叉树并保存其前序序列与中序序列
    for (bitree_id = 1, ptr = *T;bitree_id <= TREE_INIT_SIZE; bitree_id++, ptr = (*(T + bitree_id - 1)))
    {
        //当前二叉树存在且空，则保存当前二叉树
        if (ptr != NULL && BiTreeEmpty(ptr) == FALSE)
        {
            //每个二叉树的第一个数据用于保存二叉树ID号
            fwrite(&bitree_id, sizeof(int), 1, stdout);
            //每个二叉树的第二个数据用于保存二叉树结点总数
            *bitree_num = 0;
            NodeNum(ptr, bitree_num);
            fwrite(bitree_num, sizeof(int), 1, stdout);
            //前序遍历二叉树(标准输出流已重定向)
            PreOrderTraverse(ptr, visit);
            //中序遍历二叉树(标准输出流已重定向)
            InOrderTraverse(ptr, visit);
        }
    }

    return OK;
}

char *myStrncpy(char *dest, const char *src, size_t n)
{
    int size = sizeof(char)*(n+1);
    char *tmp = (char*)malloc(size);    // 开辟大小为n+1的临时内存tmp

    if(tmp)
    {
        memset(tmp, '\0', size);        // 将内存初始化为空字符
        memcpy(tmp, src, size-1);       // 将src的前n个字节拷贝到tmp
        memcpy(dest, tmp, size);        // 将临时空间tmp的内容拷贝到dest
        free(tmp);                      // 释放内存
        return dest;
    }
    else
    {
        return NULL;
    }
}

Status NodeNum(BiTree T, int *num)
{
    //二叉树不存在,ERROR
    if (T == NULL) return ERROR;
    //二叉树为空,ERROR
    if (BiTreeEmpty(T) == TRUE) return ERROR;
    //递归求结点总数
    (*num)++ ;
    NodeNum(T->lchild, num) ;
    NodeNum(T->rchild, num) ;
    return OK;
}

/*************************************************************************
 * 说明：利用队列,实现二叉树中部分函数(如层序遍历算法)
 ************************************************************************/

Status InitQueue (Queue * Q)
{
    //分配定长字节内存单元，并进行成功性检查
    Q->base = (BiTNode **)malloc(MAXQSIZE * sizeof(BiTNode *));
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

Status QueueEmpty (Queue Q)
{
    //队列不存在
    if (! Q.base) return ERROR;
    //队列存在，函数正确执行
    return Q.rear == Q.front ? TRUE : FALSE;
}

Status EnQueue (Queue * Q, BiTNode * e)
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

Status DeQueue (Queue * Q, BiTNode * * e)
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

int main (void)
{
    int bitree_id = 1;                  //二叉树ID号,初始化为1，表示默认操作第一个二叉树
    int max_bitree_id = TREE_INIT_SIZE; //最大ID号
    ElemType input = '\0';              //用户输入变量
    int LR;                             //插入/删除子树的方向 以及 选择功能编号
    BiTNode bitree_node;                //用于存放各个功能函数输入参数以及反馈的数据元素
    BiTNode * bitree_pnode;             //用于存放各个功能函数输入参数以及反馈的数据元素
    char presequence[TREE_INIT_SIZE];   //用于存放用户输入的前序序列
    char insequence[TREE_INIT_SIZE];    //用于存放用户输入的中序序列
    Status (*visit) (BiTNode *) = Visit;//访问操作函数指针

    //为TREE_INIT_SIZE个二叉树根结点分配合适内存单元
    BiTree * multi_bitree = (BiTree *)malloc(TREE_INIT_SIZE * sizeof(BiTree));
    if (! multi_bitree) exit(OVERFLOW);     //内存空间不足，退出系统

    //初始化所有二叉树
    for (bitree_id = 1;bitree_id <= TREE_INIT_SIZE;bitree_id++)
    {
        InitBiTree(multi_bitree + bitree_id - 1);
    }
    //读取文本数据
    LoadData(multi_bitree);
    //当前操作二叉树重置为第一个二叉树
    bitree_id = 1;
    //打印系统菜单界面
    printf ("\t\t欢迎使用多二叉树系统\n\n");

    while (TRUE)
    {
        //打印系统菜单界面
        printf("*****  当前二叉树编号: No.%d  *****\n", bitree_id);
        printf ("1:创建二叉树\t");
        printf ("2:清空二叉树\n");
        printf ("3:查询空状态\t");
        printf ("4:查询深度\n");
        printf ("5:查询根结点\t");
        printf ("6:查询结点\n");
        printf ("7:查询结点值\t");
        printf ("8:二叉树结点赋值\n");
        printf ("9:查询双亲\n");
        printf ("10:查询左孩子\t");
        printf ("11:查询右孩子\n");
        printf ("12:查询左兄弟\t");
        printf ("13:查询右兄弟\n");
        printf ("14:插入子树\n");
        printf ("15:删除子树\t");
        printf ("16:前序遍历\n");
        printf ("17:中序遍历\t");
        printf ("18:后序遍历\n");
        printf ("19:层序遍历\t");
        printf ("20:凹入表打印\n");
        printf ("21:广义表打印\t");
        printf ("22:切换二叉树(ID:1-%d)\n", max_bitree_id);
        printf ("23:退出系统\n\n");
        //提示用户选择功能
        printf ("请选择功能:");
        //用户选择事件
        scanf ("%d", &LR);

        //处理用户选择事件
        switch (LR)
        {
        case 1:     //创建二叉树
            printf("请输入前序序列:\n");
            scanf("%99s", presequence);
            printf("请输入中序序列:\n");
            scanf("%99s", insequence);
            if (CreateBiTree(multi_bitree + bitree_id - 1, presequence, insequence) == OK) 
                printf("创建 No.%d 成功\n", bitree_id);
            else printf("创建 No.%d 失败\n", bitree_id);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 2:     //清空二叉树
            if (ClearBiTree (*(multi_bitree + bitree_id - 1)) == OK) 
                printf("清空 No.%d 成功\n", bitree_id);
            else printf("清空 No.%d 失败\n", bitree_id);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 3:     //查询空状态     
            if (BiTreeEmpty (*(multi_bitree + bitree_id - 1)) == TRUE) 
                printf("No.%d 为空树\n", bitree_id);
            else printf("No.%d 不为空树\n", bitree_id);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 4:     //查询深度
            if ((input = BiTreeDepth(*(multi_bitree + bitree_id - 1))) != ERROR) 
                printf("No.%d 深度:%d\n", bitree_id, input);
            else printf("No.%d 为空树\n", bitree_id);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 5:     //查询根结点
            if ((bitree_pnode = Root(*(multi_bitree + bitree_id - 1))) != NULL) 
                printf("No.%d 根结点:%c\n", bitree_id, bitree_pnode->data);
            else printf("No.%d 不存在\n", bitree_id);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 6:     //查询结点
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((bitree_pnode = Locate(*(multi_bitree + bitree_id - 1), bitree_node)) != NULL) 
                printf("No.%d 存在结点:%c\n", bitree_id, bitree_pnode->data);
            else printf("No.%d 不存在结点:%c\n", bitree_id, bitree_node.data);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 7:     //查询结点值
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((input = Value(*(multi_bitree + bitree_id - 1), bitree_node)) != '\0') 
                printf("结点 %c 值:%c\n", bitree_node.data, input);
            else printf("不存在结点:%c\n", bitree_node.data);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 8:     //二叉树结点赋值
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            getchar();
            printf("请输入修改新值:");
            scanf("%c", &input);
            if ((Assign(*(multi_bitree + bitree_id - 1), bitree_node, input)) == OK) 
                printf("结点 %c 值:%c\n", bitree_node.data, input);
            else printf("不存在结点:%c\n", bitree_node.data);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 9:     //查询双亲
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((bitree_pnode = Parent(*(multi_bitree + bitree_id - 1), bitree_node)) != NULL) 
                printf("结点 %c 双亲:%c\n", bitree_node.data, bitree_pnode->data);
            else printf("不存在结点:%c\n", bitree_node.data);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 10:    //查询左孩子         
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((bitree_pnode = LeftChild(*(multi_bitree + bitree_id - 1), bitree_node)) != NULL) 
                printf("结点 %c 左孩子:%c\n", bitree_node.data, bitree_pnode->data);
            else printf("查询失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 11:     //查询右孩子
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((bitree_pnode = RightChild(*(multi_bitree + bitree_id - 1), bitree_node)) != NULL) 
                printf("结点 %c 右孩子:%c\n", bitree_node.data, bitree_pnode->data);
            else printf("查询失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 12:    //查询左兄弟
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((bitree_pnode = LeftSibling(*(multi_bitree + bitree_id - 1), bitree_node)) != NULL) 
                printf("结点 %c 左兄弟:%c\n", bitree_node.data, bitree_pnode->data);
            else printf("查询失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 13:    //查询右兄弟
            getchar();
            printf("请输入目标结点:");
            scanf("%c", &(bitree_node.data));
            if ((bitree_pnode = RightSibling(*(multi_bitree + bitree_id - 1), bitree_node)) != NULL) 
                printf("结点 %c 右兄弟:%c\n", bitree_node.data, bitree_pnode->data);
            else printf("查询失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 14:     //插入子树
            getchar();
            printf("请输入目标结点");
            scanf("%c", &(bitree_node.data));
            do
            {
                printf("请选择插入方向(0-左子树,1-右子树)");
                scanf("%d", &LR);
            }
            while(LR != 0 && LR != 1);
            printf("请输入新二叉树的前序序列( 无右子树 ):\n");
            scanf("%99s", presequence);
            printf("请输入新二叉树的中序序列( 无右子树 ):\n");
            scanf("%99s", insequence);
            if (CreateBiTree(&bitree_pnode, presequence, insequence) == OK) 
            {
                if ((InsertChild(*(multi_bitree + bitree_id - 1), bitree_node, LR, bitree_pnode)) == OK) 
                    printf("插入成功\n");
                else printf("插入失败\n");
            }
            else printf("插入失败\n");   
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 15:     //删除子树
            getchar();
            printf("请输入目标结点");
            scanf("%c", &(bitree_node.data));
            do
            {
                printf("请选择删除方向(0-左子树,1-右子树)");
                scanf("%d", &LR);
            }
            while(LR != 0 && LR != 1);
            if ((DeleteChild(*(multi_bitree + bitree_id - 1), bitree_node, LR)) == OK) 
                printf("删除成功\n");
            else printf("删除失败\n"); 
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 16:     //前序遍历
            if ((PreOrderTraverse(*(multi_bitree + bitree_id - 1), visit)) == OK) 
                printf("\n");
            else printf("遍历失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 17:     //中序遍历
            if ((InOrderTraverse(*(multi_bitree + bitree_id - 1), visit)) == OK) 
                printf("\n");
            else printf("遍历失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 18:     //后序遍历
            if ((PostOrderTraverse(*(multi_bitree + bitree_id - 1), visit)) == OK) 
                printf("\n");
            else printf("遍历失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 19:     //层序遍历
            if ((LevelOrderTraverse(*(multi_bitree + bitree_id - 1), visit)) == OK) 
                printf("\n");
            else printf("遍历失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 20:     //凹入表打印
            if ((RTPrint(*(multi_bitree + bitree_id - 1), 0)) == OK) 
                printf("\n");
            else printf("打印失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 21:     //广义表打印
            if ((GLPrint(*(multi_bitree + bitree_id - 1))) == OK) 
                printf("\n");
            else printf("打印失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 22:     //切换二叉树
            //循环用于限定用户输入为1-TREE_INIT_SIZE
            do
            {
                printf("请输入切换目标二叉树ID号:");
                //户键入目标二叉树ID
                scanf("%d", &bitree_id);
            }
            while(bitree_id < 1 || bitree_id > TREE_INIT_SIZE);
            printf("已切换至 No.%d 号二叉树", bitree_id);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 23:     //退出系统
            //保存多线二叉树
            SaveData(multi_bitree, visit);
            //销毁多二叉树
            for(bitree_id = 1;bitree_id <= TREE_INIT_SIZE;bitree_id++)
            {
                DestroyBiTree(*(multi_bitree + bitree_id - 1));
            }
            //销毁所有根结点
            free(multi_bitree);
            exit (OK);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        default:
            printf ("选择功能错误\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;
        }

        printf ("\n**********************************\n");
    }


}