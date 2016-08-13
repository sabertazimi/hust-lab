#ifndef STUHOMEWORKMANAGEMENTSYS_H_INCLUDED
#define STUHOMEWORKMANAGEMENTSYS_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <wincon.h>
#include <conio.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
#include <ctype.h>
#include <time.h>

#define SCR_COL 80           /*屏幕列数*/
#define SCR_ROW 25           /*屏幕行数*/

/*作业信息链结点结构*/
typedef struct work_node
{
    char id[10];             /**< 作业编号 */
    char beStu[20];          /**< 所属学生 */
    char beCourse[20];       /**< 所属课程 */
    char comments[20];       /**< 作业完成情况说明 */
    float score;             /**< 作业分数 */
    struct work_node * next; /**< 指向下一结点的指针 */
} WORK_NODE, *PWORK_NODE;

/*学生信息链结点结构*/
typedef struct stu_node
{
    char id[10];             /**< 学生学号 */
    char name[20];           /**< 学生姓名 */
    short sexCode;           /**< 性别代码:0表示男性，1表示女性，2表示其他 */
    char sex[5];             /**< 性别名称:男、女、其他 */
    char beClass[10];        /**< 所属班级 */
    char beCourse[20];       /**< 所属课程 */
    short workAmount;        /**< 作业总数 */
    char address[20];        /**< 通讯地址 */
    struct work_node * wnext;/**< 指向作业信息支链的指针 */
    struct stu_node * next;  /**< 指向下一结点的指针 */
} STU_NODE, *PSTU_NODE;

/*课程信息链结点结构*/
typedef struct course_node
{
    char id[10];             /**< 课程编号 */
    char name[20];           /**< 课程名称 */
    short period;            /**< 学时数 */
    short stuAmount;         /**< 学生总人数 */
    char className[30];      /**< 授课班级名单 */
    struct stu_node * snext; /**< 指向学生信息支链的指针 */
    struct course_node * next;/**< 指向下一结点的指针 */
} COURSE_NODE, *PCOURSE_NODE;

/*课程作业平均数链结点结构:课程压力程度和难易程度*/
typedef struct course_average_node
{
    char id[10];                     /**< 课程编号 */
    char name[20];                   /**< 课程名称 */
    short stuAmount;                 /**< 学生总人数 */
    float averageNumber;              /**< 学生作业平均个数:课程压力程度 */
    float averageScore;              /**< 学生作业平均分数:课程难易程度 */
    struct course_average_node * next;/**< 指向下一结点的指针 */
} COURSE_AVERAGE_NODE, *PCOURSE_AVERAGE_NODE;

/*学生作业平均数链结点结构:学生优异程度*/
typedef struct stu_average_node
{
    char id[10];                     /**< 学生学号 */
    char name[20];                   /**< 学生姓名 */
    char beCourse[20];               /**< 所属课程 */
    short workAmount;                /**< 作业总数 */
    float averageScore;              /**< 作业平均分数:学生优异程度 */
    struct stu_average_node * next;    /**< 指向下一结点的指针 */
} STU_AVERAGE_NODE, *PSTU_AVERAGE_NODE;

/*屏幕窗口信息链结点结点结构*/
typedef struct layer_node
{
    char LayerNo;            /**< 弹出窗口层数 */
    SMALL_RECT rcArea;       /**< 弹出窗口区域坐标 */
    CHAR_INFO * pContent;    /**< 弹出窗口区域字符单元原信息存储缓冲区 */
    char * pScrAtt;          /**< 弹出窗口区域字符单元原属性值存储缓冲区 */
    struct layer_node * next;/**< 指向下一结点的指针 */
} LAYER_NODE, *PLAYER_NODE;

/*标签束结构*/
typedef struct label_bundle
{
    char ** ppLabel;         /**< 标签字符串数组首地址*/
    COORD * pLoc;            /**< 标签定位数组首地址*/
    int num;                 /**< 标签个数*/
} LABEL_BUNDLE;

/*热区结构*/
typedef struct hot_area
{
    SMALL_RECT * pArea;      /**< 热区定位数组首地址*/
    char * pSort;            /**< 热区类别(按键、文本框、选项框)数组首地址*/
    char * pTag;             /**< 热区序号数组首地址*/
    int num;                 /**< 热区个数*/
} HOT_AREA;

/**< 全局变量 */
unsigned long ul;
PCOURSE_NODE g_headp = NULL;               /*主链表链头*/
PLAYER_NODE g_top_layer = NULL;            /*弹出窗口信息链链头*/
HANDLE g_handle_out;                       /*标准输出设备句柄(HANLDE:void *)*/
HANDLE g_handle_in;                        /*标准输入设备句柄(HANDLE:void *)*/
CHAR_INFO * g_buff_menubar_info = NULL;    /*存放菜单条屏幕区字符信息的缓冲区*/
CHAR_INFO * g_buff_stateBar_info = NULL;   /*存放状态条屏幕区字符信息的缓冲区*/
char * g_scr_att = NULL;                   /*屏幕字符属性缓冲区*/

/**< 缓冲区文本大小和属性 */
/*主菜单大小*/
COORD g_scr_size = {SCR_COL, SCR_ROW};
/*缺省文本属性:白底黑字*/
WORD g_default_att =  BACKGROUND_BLUE | BACKGROUND_GREEN | BACKGROUND_RED;
/*被标记缺省文本属性:黑底白字*/
WORD g_tag_default_att = FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_RED;
/*主菜单文本属性*/
WORD g_scr_menu_att = FOREGROUND_GREEN | FOREGROUND_RED | FOREGROUND_INTENSITY | BACKGROUND_BLUE;
/*子菜单项快捷键文本属性:白底绿字*/
WORD g_sub_menu_shortcut_att = FOREGROUND_GREEN | BACKGROUND_BLUE | BACKGROUND_GREEN | BACKGROUND_RED;
/*系统提示语文本属性:绿底红字字*/
WORD g_sys_info_att = FOREGROUND_RED | BACKGROUND_GREEN | FOREGROUND_INTENSITY;
/*用户输入文本属性:白底蓝字*/
WORD g_user_input_att = FOREGROUND_BLUE | BACKGROUND_BLUE | BACKGROUND_GREEN | BACKGROUND_RED;

/**< 弹出菜单 */
/*系统名称*/
char * g_sys_name = "学生作业管理系统";
/*数据文件名称*/
char * g_course_filename = "Course.dat";
char * g_stu_filename = "Stu.dat";
char * g_work_filename = "Homework.dat";
/*备份文件名称*/
char * g_backup_course_filename = "CourseBackup.dat";
char * g_backup_stu_filename = "StuBackup.dat";
char * g_backup_work_filename = "HomeworkBackup.dat";
/*主菜单名称*/
char * g_main_menu[] =
{
    "文件|ALT+F",
    "数据维护|ALT+M",
    "数据查询|ALT+Q",
    "数据统计|ALT+S",
    "帮助|ALT+H",
};
/*系统子菜单名*/
char * g_sub_menu[] =
{
    /*文件*/
    "[N] 新建文件",
    "[L] 读取文件",
    "[S] 保存文件",
    "[R] 恢复文件",
    "[B] 备份文件",
    "[X] 退出    Alt+X",
    /*数据维护*/
    "[Q] 插入作业信息",
    "[W] 插入学生信息",
    "[E] 插入课程信息",
    "",           /*空串用来在弹出菜单中分隔子菜单项*/
    "[A] 删除作业信息",
    "[S] 删除学生信息",
    "[D] 删除课程信息",
    "",           /*空串用来在弹出菜单中分隔子菜单项*/
    "[Z] 修改作业信息",
    "[X] 修改学生信息",
    "[C] 修改课程信息",
    /*数据查询*/
    "[W] 查询作业信息",
    "[S] 查询学生信息",
    "[C] 查询课程信息",
    "",           /*空串用来在弹出菜单中分隔子菜单项*/
    "[A] 打印总表",
    /*数据统计*/
    "[Q]统计每个课程学生作业平均个数",
    "[W]统计每个课程学生作业平均分数",
    "[E]统计目标课程每个学生作业平均分数",
    /*帮助*/
    "[T] 帮助主题    F1",
    "[A] 关于..."
};
int g_main_menu_count = 5;                                   /*主菜单项个数*/
int g_sub_menu_count[] = {6, 11, 5, 3, 2};                   /*各主菜单项下子菜单的个数*/
int g_sel_menu = 1;                                          /*被选中的主菜单项号,初始为1*/
int g_sel_sub_menu = 0;                                      /*被选中的子菜单项号,初始为0,表示未选中*/

/**< 用户界面函数 */
void InitInterface (void);                                   /*系统界面初始化*/
void ClearScreen (void);                                     /*清屏*/
void ShowMenu (void);                                        /*显示菜单栏*/
void ShowState (void);                                       /*显示状态栏*/
void PopMenu (int num);                                      /*显示下拉菜单*/
COORD * PopPrompt (char ** pString, int num);                                 /*显示系统提示输入信息*/
void PopUp (SMALL_RECT *, WORD, LABEL_BUNDLE *, HOT_AREA *); /*弹出窗口屏幕信息维护*/
void PopOff (void);                                          /*关闭顶层弹出窗口*/
void DrawBox (SMALL_RECT * parea);                           /*绘制边框*/
void LocSubMenu (int num, SMALL_RECT * parea);               /*主菜单下拉菜单定位*/
void TagMainMenu (int num);                                  /*标记被选中的主菜单项*/
void TagSubMenu (int num);                                   /*标记被选中的子菜单项*/
int DealConInput (HOT_AREA * phot_area, int * pihot_num);    /*控制台输入处理*/
void SetHotPoint (HOT_AREA * phot_area, int hot_num);        /*设置热区*/
BOOL ShowModule (char ** pString, int n);                    /*以矩形块形式输出字符串数组*/
BOOL ExeFunction (int main_menu_num, int sub_menu_num);      /*功能模块的调用*/

/**< 基础功能函数 */
/*添加指定课程与学生的作业信息结点*/
PWORK_NODE AddWorkNode (char * course_name, char * stu_name);
/*添加指定课程的学生信息结点*/
PSTU_NODE AddStuNode (char * course_name);
/*添加一个独立的课程信息结点*/
PCOURSE_NODE AddCourseNode (void);
/*从三类二进制文件中读取链表数据*/
BOOL LoadData (PCOURSE_NODE * headp);
/*将链表信息存盘*/
BOOL SaveData (PCOURSE_NODE headp);
/*从三类备份文件中读取链表数据*/
BOOL RestoreData (PCOURSE_NODE * headp);
/*将链表信息备份*/
BOOL BackupData (PCOURSE_NODE headp);
/*按编号/名称查找课程信息链结点*/
PCOURSE_NODE SeekCourseNode (PCOURSE_NODE headp, char * course_info);
/*在指定课程按学号/姓名查找学生信息链结点*/
PSTU_NODE SeekStuNode (PCOURSE_NODE headp, char * course_info, char * stu_info);
/*按作业编号查找作业信息链结点*/
PWORK_NODE SeekWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, char * work_id);
/*在目标学生信息结点支链插入作业信息结点*/
BOOL InsertWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, PWORK_NODE new_work_node);
/*在目标课程信息结点支链插入学生信息结点*/
BOOL InsertStuNode (PCOURSE_NODE headp, char * course_info, PSTU_NODE new_stu_node);
/*插入课程信息结点*/
BOOL InsertCourseNode (PCOURSE_NODE * headp, PCOURSE_NODE new_course_node);
/*删除目标作业结点*/
BOOL DelWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, char * work_id);
/*删除目标学生结点*/
BOOL DelStuNode (PCOURSE_NODE headp, char * course_info, char * stu_info);
/*删除目标课程结点*/
BOOL DelCourseNode (PCOURSE_NODE * headp, char * course_info);
/*修改目标作业信息结点*/
BOOL ModifyWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, char * work_id, PWORK_NODE new_work_node);
/*修改目标学生信息结点*/
BOOL ModifyStuNode (PCOURSE_NODE headp, char * course_info, char * stu_info, PSTU_NODE new_stu_node);
/*修改目标课程信息结点*/
BOOL ModifyCourseNode (PCOURSE_NODE headp, char * course_info, PCOURSE_NODE new_course_node);
/*打印一个作业信息结点信息*/
BOOL PrintWorkNode (PWORK_NODE pwork_node);
/*打印一个学生信息结点(包括支链)*/
BOOL PrintStuNode (PSTU_NODE pstu_node);
/*打印一个课程信息结点(包括支链)*/
BOOL PrintCourseNode (PCOURSE_NODE pcourse_node);
/*输出总表*/
BOOL PrintAllCourseNode (PCOURSE_NODE headp);
/*对课程统计信息链按作业平均个数降序排列*/
BOOL SortStaCourseNumberNode (PCOURSE_AVERAGE_NODE * headp);
/*对课程统计信息链按作业平均分数降序排列*/
BOOL SortStaCourseScoreNode (PCOURSE_AVERAGE_NODE * headp);
/*对学生统计信息链按作业平均分数降序排列*/
BOOL SortStaStuScoreNode (PSTU_AVERAGE_NODE * headp);
/*退出系统*/
void CloseSys (PCOURSE_NODE headp);

/**< 模块功能函数 */
BOOL CreateList (void);             /*新建学生作业完成情况信息总表*/
BOOL LoadList (void);               /*读取数据*/
BOOL SaveList (void);               /*数据存盘*/
BOOL RestoreList (void);            /*恢复数据*/
BOOL BackupList (void);             /*数据备份*/
BOOL ExitSys (void);                /*退出系统 */
BOOL InsertWorkInfo (void);         /*插入作业信息*/
BOOL InsertStuInfo (void);          /*插入学生信息*/
BOOL InsertCourseInfo (void);       /*插入课程信息*/
BOOL DelWorkInfo (void);            /*删除作业信息*/
BOOL DelStuInfo (void);             /*删除学生信息*/
BOOL DelCourseInfo (void);          /*删除课程信息*/
BOOL ModifyWorkInfo (void);         /*修改作业信息*/
BOOL ModifyStuInfo (void);          /*修改学生信息*/
BOOL ModifyCourseInfo (void);       /*修改课程信息*/
BOOL PrintAllInfo (void);           /*打印总表*/
BOOL PrintCourseInfo (void);        /*打印查询目标课程信息*/
BOOL PrintStuInfo (void);           /*打印查询目标学生信息*/
BOOL PrintWorkInfo (void);          /*打印查询目标作业信息*/
BOOL StaCourseNumber (void);        /*统计课程作业平均个数*/
BOOL StaCourseScore (void);         /*统计课程作业平均分数*/
BOOL StaCourseStuScore (void);      /*统计目标课程每个学生作业平均分数*/
BOOL HelpTheme (void);              /*帮助*/
BOOL AboutSys (void);               /*更多信息*/
void RunSys (PCOURSE_NODE * headp); /*系统功能模块的选择和运行*/

#endif /*STUHOMEWORKMANAGEMENTSYS_H_INCLUDED*/
