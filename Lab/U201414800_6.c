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
//将Boolean定义为int型
typedef int Boolean;
//将ElemType定义为char型
typedef int ElemType;

//系统可操作图的顶点最大值
#define MAX_VERTEX_NUM 20

//访问标志数组
Boolean visited[MAX_VERTEX_NUM];

//弧的相关信息
typedef char InfoType;

//顶点的相关信息
typedef char VertexType;  //顶点名称

typedef struct ArcNode {
    int adjvex;                   //该弧所指向的顶点的位置
    struct ArcNode * nextarc;     //指向下一条弧的指针
    InfoType info[6];             //该弧的相关信息
} ArcNode;

typedef struct VNode {
    VertexType data;        //顶点相关信息
    ArcNode * firstarc;     //指向第一条依附该顶点的弧的指针
} VNode, AdjList[MAX_VERTEX_NUM];

typedef struct {
    AdjList vertices;
    int vexnum, arcnum;    //图的当前顶点数和弧数
} ALGraph;

/**
 * 建立邻接存储的无向图
 * @param G  无向图
 * @call  InsertVex
 * @call  InsertArc
 * @return   OK/ERROR
 */
Status CreateGraph(ALGraph * G);

/**
 * 销魂图G
 * 初始条件:图G存在
 * @param G  无向图
 * @return   OK/ERROR
 */
Status DestroyGraph(ALGraph * G);

/**
 * 定位目标顶点的位置，返回位置信息
 * 初始条件:图G存在
 * @param   G  无向图
 * @param   u  目标顶点的信息
 * @return  u的位置信息(编号)/-1
 */
int LocateVex(ALGraph * G, VertexType u);   

/**
 * 返回顶点v的第一个邻接顶点
 * 初始条件:图G存在
 * @param  G  无向图
 * @param  v  目标顶点
 * @call   LocateVex
 * @return    v的邻接顶点地址/NULL
 */
VNode * FirstAdjVex(ALGraph * G, VertexType v);

/**
 * 返回v的(相对于w)下一个邻接顶点
 * 初始条件 图G存在;w是v的邻接顶点
 * @param  G  无向图
 * @param  v  目标顶点
 * @param  w  目标顶点的邻接顶点
 * @call   LocateVex
 * @call   FirstAdjVex
 * @return    v的下一邻接顶点地址/NULL
 */
VNode * NextAdjVex(ALGraph * G, VertexType v, VertexType w);

/**
 * 插入新顶点v
 * 初始条件:图G存在
 * @param  G  无向图
 * @param  v  插入顶点
 * @return    OK/ERROR
 */
Status InsertVex(ALGraph * G, VertexType v);

/**
 * 删除顶点v
 * 初始条件:图G存在且不为空
 * @param  G  无向图 
 * @param  v  删除顶点
 * @call   LocateVex
 * @return    OK/ERROR
 */
Status DeleteVex(ALGraph * G, VertexType v);

/**
 * 插入弧<v, w>与<w, v>
 * 初始条件:图G存在
 * @param  G  无向图
 * @param  v  弧的顶点
 * @param  w  弧的顶点
 * @call   LocateVex
 * @return    OK/ERROR
 */
Status InsertArc(ALGraph * G, VertexType v, VertexType w);

/**
 * 删除弧<v, w>与<w, v>
 * 初始条件:图G存在且不为空
 * @param  G  无向图
 * @param  v  弧的顶点
 * @param  w  弧的顶点
 * @call   LocateVex
 * @return    OK/ERROR
 */
Status DeleteArc(ALGraph * G,VertexType v,VertexType w);  

/**
 * 深度遍历无向图G
 * 初始条件:图G存在且不为空
 * @param  G      无向图
 * @param  visit  访问操作函数指针
 * @call   LocateVex
 * @call   FirstAdjVex
 * @call   NextAdjVex
 * @call   Visit
 * @return        OK/ERROR
 */
Status DFSTraverse(ALGraph * G, Status (*visit)(VNode * v));
Status DFS(ALGraph *G, VNode * v, Status (*visit)(VNode * v));

/**
 * 广度遍历无向图G
 * 初始条件:图G存在且不为空
 * @param  G      无向图
 * @param  visit  访问操作函数指针
 * @call   LocateVex
 * @call   FirstAdjVex
 * @call   NextAdjVex
 * @call   Visit
 * @call   Queue相关函数
 * @return        OK/ERROR
 */
Status BFSTraverse(ALGraph * G, Status (*visit)(VNode * v));

/**
 * 输出顶点v的信息
 * @param  v 图G中顶点
 * @return   操作结果状态Status OK/ERROR
 */
Status Visit (VNode * v);

/**
 * 输出顶点v的邻接弧的信息
 * @param  v 图G中顶点
 * @return   操作结果状态Status OK/ERROR
 */
Status Print (VNode * v);

/**
 * 从output.txt读取数据
 * @param  G 无向图
 * @call   LocateVex
 * @call   InsertVex
 * @call   InsertArc
 * @return   操作结果状态Status OK/ERROR
 */
Status LoadData (ALGraph * G);

/**
 * 保存数据至output.txt
 * @param  G 无向图
 * @return   操作结果状态Status OK/ERROR
 */
Status SaveData (ALGraph * G);


/*************************************************************************
 * 说明：利用队列, 实现广度优先遍历算法
 ************************************************************************/

//最大队列长度
#define MAXQSIZE 100

//定义顺序存储循环队列数据结构
typedef struct Queue
{
    VNode * * base;    //初始化的动态分配存储空间, 在队列构造之前和销毁之后, base的值为NULL
    int front;         //头指针, 若队列不空, 指向队列首元素
    int rear;          //尾指针, 若队列不空, 指向队列尾元素的下一个位置
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
 * @return   若Q为空队列, 则返回TRUE, 否则返回FALSE
 */
Status QueueEmpty (Queue Q);

/**
 * 插入元素v为新的队列尾元素
 * 初始条件:队列Q已存在
 * @param  Q 队列地址值
 * @param  v 插入数据元素值
 * @return   操作结果状态Status OK/ERROR
 */
Status EnQueue (Queue * Q, VNode * v);

/**
 * 删除队列Q的队列首元素
 * 初始条件：队列Q已存且非空
 * @param  Q 队列地址值
 * @return   操作结果状态Status OK/ERROR
 */
Status DeQueue (Queue * Q, VNode * * v);

Status CreateGraph(ALGraph * G)
{
    int i,j;          //顶点位置(编号)
    int k;            //循环变量
    int vexnum, arcnum;//顶点总数和弧总数

    printf("请输入\"顶点数 边数\":");  
    scanf("%d %d", &vexnum, &arcnum);

    //初始化图的顶点数和边数
    G->vexnum = G->arcnum = 0;
    //建立顶点表
    for (i = 0;i < vexnum; i++)  
    {
        //输入顶点名称
        printf("请输入 No.%d 顶点名称(单字符):", i);
        scanf("%1s", &j );
        //插入顶点
        InsertVex(G, j);
    }
    //向顶点表中插入弧结点,建立完整的邻接表
    for (k = 0;k < arcnum;k++)
    {  
        //输入弧结点信息
        printf("请输入顶点对(形式:v w):");  
        scanf("%1s %1s", &i, &j);
        //插入弧
        InsertArc(G, i, j);
    }
    //处理顶点表中空位置
    for(k = G->vexnum;k < MAX_VERTEX_NUM;k++)
    {
        G->vertices[k].data = '\0';
        G->vertices[k].firstarc = NULL;
    }

    return OK;
}

Status DestroyGraph(ALGraph * G)
{
    int i;                           //遍历顶点表的循环变量
    ArcNode * priorArc, * currentArc;//遍历每个顶点的邻接链表的循环变量
    //图不存在,ERROR
    if (G == NULL) return ERROR;

    //循环遍历并释放邻接表的内存空间
    for(i = 0;i < G->vexnum;i++)
    {
        //当前顶点邻接链表为空，无需遍历
        if (G->vertices[i].firstarc == NULL) continue;
        //否则遍历邻接链表
        for (priorArc = G->vertices[i].firstarc, currentArc = priorArc->nextarc;
                priorArc != NULL;
                priorArc = currentArc, currentArc = currentArc->nextarc)
        {
            free (priorArc);
            if (currentArc == NULL) break;    //遍历结束
        }
    }
    //释放顶点表以及图
    free(G);
    return OK;
}

int LocateVex(ALGraph *G, VertexType u)
{
    int i;            //遍历顶点表的循环变量
    //图不存在或顶点不存在，返回-1编号
    if(G == NULL) return -1;
    //遍历邻接表，定位目标顶点
    for(i = 0;i <= G->vexnum;i++)
    {
        if(G->vertices[i].data == u) return i;
    }
    //定位失败，返回-1编号
    return -1;
}   

VNode * FirstAdjVex(ALGraph * G, VertexType v)
{
    int pos;    //目标顶点在图中的位置序号
    //图不存在，返回NULL
    if(G == NULL) return NULL;
    //否则,定位目标顶点v
    if((pos = LocateVex(G, v)) != -1)
    {   //定位v成功，寻找其邻接顶点
        if(G->vertices[pos].firstarc != NULL)
        {   //顶点v拥有邻接顶点
            //将邻接顶点的位置序号存入pos
            pos = G->vertices[pos].firstarc->adjvex;
            //根据pos返回邻接顶点地址
            return G->vertices + pos;
        }
        else
        {   //顶点v没有邻接顶点
            return NULL;
        }
    }
    else
    {   //定位失败
        return NULL;
    }

}

VNode * NextAdjVex(ALGraph * G, VertexType v, VertexType w)
{
    int pos;           //目标顶点在图中的位置序号
    VNode * vex;       //存放目标顶点v的第一个邻接顶点
    ArcNode * arc;    //遍历每个顶点的邻接链表的循环变量

    //图不存在或，返回NULL
    if(G == NULL) return NULL;

    //否则,定位目标顶点v的第一个邻接顶点
    if( (vex = FirstAdjVex(G, v)) != NULL)
    {   //定位第一个邻接顶点成功
        pos = LocateVex(G, v);    //定位顶点v
        //遍历顶点v的邻接链表，查找v相对于w的下一邻接顶点
        for(arc = G->vertices[pos].firstarc;arc != NULL;arc = arc->nextarc)
        {   
            if(arc->adjvex == LocateVex(G, w) && arc->nextarc != NULL)
            {   //定位顶点w，且v相对于w的下一邻接顶点存在
                pos = arc->nextarc->adjvex;    //定位v相对于w的下一邻接顶点
                return G->vertices + pos;      //返回下一邻接顶点的地址
            }
        }
    }

    return NULL;
}

Status InsertVex(ALGraph * G, VertexType v)
{
    //图不存在，返回NULL
    if(G == NULL) return ERROR;
    //建立顶点
    //读入顶点名称
    G->vertices[G->vexnum].data = v;
    //将依附于顶点的第一条弧置为NULL
    G->vertices[G->vexnum].firstarc = NULL; 
    //顶点数加1
    G->vexnum ++;
    return  OK;
}

Status DeleteVex(ALGraph * G,VertexType v)
{
    int pos1, pos2;                        //目标顶点及其邻接顶点的位序
    ArcNode * arc, * priorArc, *currentArc;//用以遍历邻接链表的指针
    //图不存在或为空，ERROR
    if(G == NULL || G->vexnum == 0) return ERROR;
    //定位目标顶点v
    if ((pos1 = LocateVex(G, v)) != -1)
    {
        //从头遍历邻接链表
        for (arc = G->vertices[pos1].firstarc;arc != NULL;arc = arc->nextarc)
        {        
            for(//第一个邻接结点位序 //删除邻接顶点的邻接链表中对应弧
                pos2 = arc->adjvex , priorArc = G->vertices[pos2].firstarc,currentArc = priorArc;
                currentArc != NULL;priorArc = currentArc,currentArc = currentArc->nextarc)
            {
                if (currentArc->adjvex == pos1)
                {   //删除目标弧结点是否是邻接表首结点
                    if(currentArc == G->vertices[pos2].firstarc)
                    {
                        G->vertices[pos2].firstarc = G->vertices[pos2].firstarc->nextarc;
                    }
                    else 
                    {
                        priorArc->nextarc = currentArc->nextarc;
                        free(currentArc);
                    }
                    //弧数自减
                    G->arcnum--;
                    break;
                }  //if
            }  //for
        }  //for

        //从顶点表中删除顶点v
        for(pos2 = pos1;pos2 < MAX_VERTEX_NUM - 1;pos2++)
        {
            G->vertices[pos2] = G->vertices[pos2 + 1];
        }
        G->vertices[MAX_VERTEX_NUM - 1].data = '\0';
        G->vertices[MAX_VERTEX_NUM - 1].firstarc = NULL;
        //顶点数自减
        G->vexnum--;

        return OK;
    }  //if

    return ERROR;
}

Status InsertArc(ALGraph * G,VertexType v,VertexType w)
{
    ArcNode * arc;

    //弧端点在顶点表中的位序
    int vpos, wpos;
    if((vpos = LocateVex(G, v)) == -1) return ERROR;
    if((wpos = LocateVex(G, w)) == -1) return ERROR;

    //图不存在，ERROR
    if(G == NULL) return ERROR;

    //插入弧<v, w>  
    arc = (ArcNode*)malloc(sizeof(ArcNode));
    if (arc == NULL) return OVERFLOW;
    //将新弧所指顶点位置置为wpos
    arc->adjvex = wpos;
    //建立该弧相关信息
    arc->info[0] = '<';
    arc->info[1] = G->vertices[vpos].data;
    arc->info[2] = ',';
    arc->info[3] = G->vertices[wpos].data;
    arc->info[4] = '>';
    arc->info[5] = '\0';
    //插入操作
    arc->nextarc = G->vertices[vpos].firstarc; 
    G->vertices[vpos].firstarc = arc;

    //该图为无向图，故同时插入弧<w, v>
    arc = (ArcNode*)malloc(sizeof(ArcNode));  
    if (arc == NULL) return OVERFLOW;
    //弧<w, v>指向顶点编号vpos
    arc->adjvex = vpos;
    //建立该弧相关信息
    arc->info[0] = '<';
    arc->info[1] = G->vertices[wpos].data;
    arc->info[2] = ',';
    arc->info[3] = G->vertices[vpos].data;
    arc->info[4] = '>';
    arc->info[5] = '\0';
    //插入操作
    arc->nextarc = G->vertices[wpos].firstarc;  
    G->vertices[wpos].firstarc = arc;  

    //弧数自加
    G->arcnum++;
    return OK;
}   

Status DeleteArc(ALGraph * G,VertexType v,VertexType w)
{
    //用以遍历邻接链表的指针
    ArcNode * priorArc, * currentArc;

    //弧端点在顶点表中的位序
    int vpos, wpos;
    if((vpos = LocateVex(G, v)) == -1) return ERROR;
    if((wpos = LocateVex(G, w)) == -1) return ERROR;

    //图不存在或为空，ERROR
    if(G == NULL || G->vexnum == 0) return ERROR;

    //删除弧<v, w>     
    for(priorArc = G->vertices[vpos].firstarc, currentArc = priorArc;
        currentArc != NULL;priorArc = currentArc, currentArc = currentArc->nextarc)
    {
        if (currentArc->adjvex == wpos)
        {   //目标弧结点为邻接表是否为首结点
            if(currentArc == G->vertices[vpos].firstarc)
            {
                G->vertices[vpos].firstarc = G->vertices[vpos].firstarc->nextarc;
            }
            else 
            {
                priorArc->nextarc = currentArc->nextarc;
            }
            //释放内存空间
            free(currentArc);
            break;
        }
    }

    //删除弧<w, v>     
    for(priorArc = G->vertices[wpos].firstarc, currentArc = priorArc;
        currentArc != NULL;priorArc = currentArc, currentArc = currentArc->nextarc)
    {
        if (currentArc->adjvex == vpos)
        {   //目标弧结点为邻接表是否为首结点
            if(currentArc == G->vertices[wpos].firstarc)
            {
                G->vertices[wpos].firstarc = G->vertices[wpos].firstarc->nextarc;
            }
            else 
            {
                priorArc->nextarc = currentArc->nextarc;
            }
            //释放内存空间
            free(currentArc);
            break;
        }
    }

    //弧数自减
    G->arcnum--;
    return OK;
    
}  

Status DFSTraverse(ALGraph * G, Status (*visit)(VNode * v))
{
    int vpos = 0;    //从第0个顶点开始遍历
    //图不存在或为空，ERROR
    if(G == NULL || G->vexnum == 0) return ERROR;
    //访问标志数组初始化
    for(vpos = 0;vpos < G->vexnum;vpos++) visited[vpos] = FALSE;
    //对尚未访问的顶点调用DFS
    for(vpos = 0;vpos < G->vexnum;vpos++)
    {
        if(!visited[vpos]) DFS(G, G->vertices + vpos, visit);
    }

    return OK;
}

Status DFS(ALGraph *G, VNode * v, Status (*visit)(VNode * v))
{
    int vpos, wpos;    //顶点位序
    VNode * w;         //邻接顶点

    //图不存在或为空，ERROR
    if(G == NULL || G->vexnum == 0) return ERROR;

    //从第v个顶点出发，递归地深度优先遍历图G
    if ((vpos = LocateVex(G, v->data)) == -1) return ERROR;
    //标记已访问该顶点
    visited[vpos] = TRUE;
    //访问第v个顶点
    visit(v);
    //访问邻接顶点
    for(w = FirstAdjVex(G, v->data); w != NULL; w = NextAdjVex(G, v->data, w->data))
    {
        if ((wpos = LocateVex(G, w->data)) == -1) return ERROR;
        //对v的尚未访问的邻接顶点w递归调用DFS
        if(!visited[wpos]) DFS(G, w, visit);
    }

    return OK;
}
    
Status BFSTraverse(ALGraph * G, Status (*visit)(VNode * v))
{
    //顶点位序
    int vpos, wpos;    
    //邻接顶点
    VNode * u;
    VNode * v;
    VNode * w;
    //辅助用队列
    Queue Q;           

    //图不存在或为空，ERROR
    if(G == NULL || G->vexnum == 0) return ERROR;

    //访问标志数组初始化
    for(vpos = 0;vpos < G->vexnum;vpos++) visited[vpos] = FALSE;
    //置空的辅助队列Q
    InitQueue(&Q);
    for(vpos = 0;vpos < G->vexnum;vpos++)
    {
        //尚未访问v
        if(!visited[vpos])
        {
            visited[vpos] = TRUE;
            v = G->vertices + vpos;
            visit(v);
            //v入队列
            EnQueue(&Q, v);

            while(!QueueEmpty(Q))
            {
                //队首元素出队并置为u
                DeQueue(&Q, &u);

                for (w = FirstAdjVex(G, u->data);w != NULL;w = NextAdjVex(G, u->data, w->data))
                {
                    if ((wpos = LocateVex(G, w->data)) == -1) return ERROR;
                    //w为u的尚未访问的邻接顶点
                    if(!visited[wpos])
                    {
                        visited[wpos] = TRUE;
                        visit(w);
                        EnQueue(&Q, w);
                    }  //if
                }  //for
            }  //while
        }  //if
    }
    DestroyQueue(&Q);
    return OK;
}

Status Visit (VNode * v)
{
    //顶点不存在,ERROR
    if (v == NULL || v->firstarc == NULL) return ERROR;
    //否则，访问该顶点，输出顶点信息
    printf("%c\n", v->data);
    return OK;
}

Status Print (VNode * v)
{
    ArcNode * arc;    //遍历目标顶点的邻接链表的循环变量
    //顶点不存在,ERROR
    if (v == NULL || v->data == '\0') return ERROR;
    //遍历输出目标顶点的邻接链表
    for(arc = v->firstarc;arc != NULL;arc = arc->nextarc)
    {
        //邻接顶点未被访问，则访问邻接顶点，并输出弧信息
        if(visited[arc->adjvex] == FALSE)
        {
            //打印邻接弧的信息
            printf("%s\n",arc->info);
        }
    }
    return OK;
}

Status LoadData (ALGraph * G)
{
    int i, j;                  //循环变量
    VertexType vex_data;    //某一顶点的名称
    VertexType adjvex_data; //某一顶点的邻接顶点名称
    int vexnum;             //图的顶点总数
    int nextarc_num;        //某一顶点的邻接边数
    
    FILE *fp;           //文件指针

    if ((fp = fopen("output.txt","r")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //将G的顶点总数和边总数初始化为0
    G->vexnum = G->arcnum = 0;

    //图不存在,ERROR
    if(G == NULL) return ERROR;

    //否则，读取数据
    //读取顶点表信息
    if (!fread(&vexnum, sizeof(int), 1, fp)) return ERROR;
    for(i = 0;i < vexnum;i++)
    {
        if(!fread(&(vex_data), sizeof(char), 1, fp)) return ERROR;
        InsertVex(G, vex_data);
    }
    //读取邻接表信息
    for(i = 0;i < vexnum;i++)
    {
        //读取当前顶点的邻接顶点数
        if(!fread(&nextarc_num, sizeof(int), 1, fp)) return ERROR;
        //读取当前顶点的邻接顶点名称，并插入连接两点的弧
        for(j = 0;j < nextarc_num;j++)
        {
            if(!fread(&adjvex_data, sizeof(char), 1, fp)) break;
            if(LocateVex(G, adjvex_data) > i)
            {
                InsertArc(G, G->vertices[i].data, adjvex_data);
            }
        }
    }

    fclose(fp);
    return OK;
}

Status SaveData (ALGraph * G)
{
    int nextarc_num;      //某一顶点的邻接边数
    int pos;              //位序循环变量
    ArcNode * arc;        //弧顶点循环变量
    FILE *fp;             //文件指针

    //以覆盖原有数据的形式,打开output.txt
    if ((fp = fopen("output.txt","w+")) == NULL)
    {
        printf("File OPEN ERROR\n ");
        return ERROR;
    }

    //图不存在或为空，ERROR
    if(G == NULL || G->vexnum == 0) return ERROR;

    //否则,保存数据
    //保存顶点表信息
    //保存顶点总数
    fwrite(&(G->vexnum), sizeof(int), 1, fp);
    //保存顶点信息
    for(pos = 0;pos < G->vexnum;pos++)
    {
        fwrite(&(G->vertices[pos].data), sizeof(char), 1, fp);
    }
    //保存各顶点邻接链表信息
    for (pos = 0;pos < G->vexnum;pos++)
    {
        //每个邻接链表的第一个数据用于保存当前顶点的邻接顶点数
        //初始化当前顶点的邻接边数
        nextarc_num = 0;
        //遍历邻接链表计算邻接顶点数
        for(arc = G->vertices[pos].firstarc;arc != NULL;arc = arc->nextarc)
        {
            nextarc_num++;
        }
        //保存邻接顶点数
        fwrite(&nextarc_num, sizeof(int), 1, fp);

        //每个邻接链表的其余数据保存当前顶点的邻接顶点名称
        for(arc = G->vertices[pos].firstarc;arc != NULL;arc =arc->nextarc)
        {
            fwrite(&(G->vertices[arc->adjvex].data), sizeof(char), 1, fp);
        }
    }

    fclose(fp);
    return OK;
}

/*************************************************************************
 * 说明：利用队列,实现广度优先遍历算法
 ************************************************************************/

Status InitQueue (Queue * Q)
{
    //分配定长字节内存单元，并进行成功性检查
    Q->base = (VNode **)malloc(MAXQSIZE * sizeof(VNode *));
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

Status EnQueue (Queue * Q, VNode * v)
{
    //队列不存在
    if (! Q->base) return ERROR;
    //队列满
    if ( (Q->rear + 1) % MAXQSIZE == Q->front ) return ERROR;
    //队列存在且未满
    Q->base[Q->rear] = v;
    //队列尾下标自增
    Q->rear = (Q->rear + 1) % MAXQSIZE;
    return OK;
}

Status DeQueue (Queue * Q, VNode * * v)
{
    //队列不存在
    if (! Q->base) return ERROR;
    //队列为空
    if (QueueEmpty(*Q)) return ERROR;
    //队列存在且非空
    (*v) = Q->base[Q->front];
    Q->front = (Q->front + 1) % MAXQSIZE;
    return OK;
}

int main (void)
{
    int choice = '\0';   //用户功能选择变量
    VertexType input;    //用户输入变量
    ALGraph * graph = NULL;
    VNode * vex;         //用于存放各个功能函数输入参数以及反馈的数据元素
    Status (*visit) (VNode *) = Visit;//访问操作函数指针
    Status (*print) (VNode *) = Print;//打印操作函数指针

    //为图指针分配内存空间
    graph = (ALGraph *)malloc(sizeof(ALGraph));
    if (graph == NULL) return OVERFLOW;
    //读取文本数据
    LoadData(graph);
    //打印系统菜单界面
    printf ("\t\t欢迎使用无向图系统\n\n");

    while (TRUE)
    {
        //打印系统菜单界面
        printf ("1:创建图\n");
        printf ("2:查询顶点编号\n");
        printf ("3:查询第一邻接顶点\n");
        printf ("4:查询下一邻接顶点\n");
        printf ("5:插入顶点\n");
        printf ("6:删除顶点\n");
        printf ("7:插入弧\n");
        printf ("8:删除弧\n");
        printf ("9:深度优先遍历\n");
        printf ("10:广度优先遍历\n");
        printf ("11:打印无向图\n");
        printf ("12:退出系统\n\n");
        //提示用户选择功能
        printf ("请选择功能:");
        //用户选择事件
        scanf ("%d", &choice);

        //处理用户选择事件
        switch (choice)
        {
        case 1:     //创建图
            if (CreateGraph(graph) == OK) 
                printf("创建成功\n");
            else printf("创建失败\n");
            printf("\n");
            system("pause");
            system("CLS");
            break;

        case 2:     //查询顶点编号
            printf("请输入目标结点名称:");
            scanf("%1s", &input);
            if ((choice = LocateVex(graph, input)) != -1) 
                printf("%c 位序:%d\n", input, choice);
            else printf("定位 %c 失败\n", input);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 3:     //查询第一邻接顶点   
            printf("请输入目标结点名称:");
            scanf("%1s", &input);
            if ((vex = FirstAdjVex(graph, input)) != NULL) 
                printf("%c 第一个邻接顶点:%c\n", input, vex->data);
            else printf("查询失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 4:     //查询下一邻接顶点
            printf("请输入目标结点名称:");
            scanf("%1s", &input);
            printf("请输入%c的一个邻接顶点:", input);
            scanf("%1s", &choice);
            if ((vex = NextAdjVex(graph, input, choice)) != NULL) 
                printf("%c 相对于 %c 的下一个邻接顶点:%c\n", input, choice, vex->data);
            else printf("查询失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 5:     //插入顶点
            printf("请输入插入结点名称:");
            scanf("%1s", &input);
            if (InsertVex(graph, input) == OK) 
                printf("插入 %c 成功\n", input);
            else printf("插入 %c 失败\n", input);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 6:     //删除顶点
            printf("请输入删除结点名称:");
            scanf("%1s", &input);
            if (DeleteVex(graph, input) == OK) 
                printf("删除 %c 成功\n", input);
            else printf("删除 %c 失败\n", input);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 7:     //插入弧
            printf("请输入插入弧端点(v w):");
            scanf("%1s %1s", &input, &choice);
            if (InsertArc(graph, input, choice) == OK) 
                printf("插入 <%c,%c> 成功\n", input, choice);
            else printf("插入 <%c,%c> 失败\n", input, choice);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 8:     //删除弧
            printf("请输入删除弧端点(v w):");
            scanf("%1s %1s", &input, &choice);
            if (DeleteArc(graph, input, choice) == OK) 
                printf("删除 <%c,%c> 成功\n", input, choice);
            else printf("删除 <%c,%c> 失败\n", input, choice);
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 9:     //深度优先遍历
            if (DFSTraverse(graph, visit) == OK) 
                ;
            else printf("深度优先遍历失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 10:    //广度优先遍历        
            if (BFSTraverse(graph, visit) == OK) 
                ;
            else printf("深度优先遍历失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 11:     //打印无向图
            if (DFSTraverse(graph, print) == OK) 
                ;
            else printf("打印失败\n");
            printf("\n");
            system("pause");
            system("CLS");  
            break;

        case 12:     //退出系统
            //保存图
            SaveData(graph);
            //销毁图
            DestroyGraph(graph);

            printf("\n");
            system("pause");
            system("CLS");  
            exit (OK); 
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
