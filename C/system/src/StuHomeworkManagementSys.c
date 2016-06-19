/********************
 *作者:计科1409班 U201414800 刘一龙
 *说明:2015年夏 C语言课程设计:学生作业管理系统
********************/

#include "StuHomeworkManagementSys.h"

int main (void)
{
    g_handle_out = GetStdHandle (STD_OUTPUT_HANDLE); /* 获取标准输出设备句柄*/
    g_handle_in = GetStdHandle (STD_INPUT_HANDLE);  /* 获取标准输入设备句柄*/

    SetConsoleTitle (g_sys_name);                         /*设置窗口标题*/
    SetConsoleScreenBufferSize (g_handle_out, g_scr_size); /*设置窗口缓冲区大小80*25*/

    InitInterface();          /*界面初始化*/
    LoadData (&g_headp);      /*链表自动初始化*/
    RunSys (&g_headp);        /*系统功能模块的选择及运行*/
    CloseSys (g_headp);       /*退出系统*/

    return 0;
}


/** \brief InitInterface:初始化界面
 *
 * \param void
 * \return void
 *
 */
void InitInterface (void)
{
    SetConsoleTextAttribute (g_handle_out, g_scr_menu_att); /*设置控制台屏幕缓冲区字符属性*/

    ClearScreen();  /* 清屏*/

    /*创建弹出窗口信息堆栈*/
    g_scr_att = (char *) calloc (SCR_COL * SCR_ROW, sizeof (char)); /*屏幕字符属性*/
    g_top_layer = (LAYER_NODE *) malloc (sizeof (LAYER_NODE));
    g_top_layer->LayerNo = 0;      /*弹出窗口的层号为0*/
    g_top_layer->rcArea.Left = 0;  /*弹出窗口的区域为整个屏幕窗口*/
    g_top_layer->rcArea.Top = 0;
    g_top_layer->rcArea.Right = SCR_COL - 1;
    g_top_layer->rcArea.Bottom = SCR_ROW - 1;
    g_top_layer->pContent = NULL;
    g_top_layer->pScrAtt = g_scr_att;
    g_top_layer->next = NULL;

    ShowMenu();     /*显示菜单栏*/
    ShowState();    /*显示状态栏*/
}

/** \brief ClearScreen:清除屏幕信息
 *
 * \param void
 * \return void
 *
 */
void ClearScreen (void)
{
    CONSOLE_SCREEN_BUFFER_INFO bInfo;
    COORD home = {0, 0};
    unsigned long size;

    GetConsoleScreenBufferInfo (g_handle_out, &bInfo); /*取屏幕缓冲区信息*/
    size =  bInfo.dwSize.X * bInfo.dwSize.Y; /*计算屏幕缓冲区字符单元数*/

    /*设置屏幕缓冲区字符属性*/
    FillConsoleOutputAttribute (g_handle_out, bInfo.wAttributes, size, home, &ul);

    /*填充空格字符*/
    FillConsoleOutputCharacter (g_handle_out, ' ', size, home, &ul);

    return;
}

/** \brief ShowMenu:在屏幕上显示主菜单, 并设置热区, 在主菜单第一项上置选中标记
 *
 * \param void
 * \return void
 *
 */
void ShowMenu (void)
{
    CONSOLE_SCREEN_BUFFER_INFO bInfo;
    CONSOLE_CURSOR_INFO lpCur;
    COORD size;
    COORD pos = {0, 0};
    int i, j;
    int PosA = 2, PosB;
    char ch;

    GetConsoleScreenBufferInfo (g_handle_out, &bInfo);
    size.X = bInfo.dwSize.X;
    size.Y = 1;
    SetConsoleCursorPosition (g_handle_out, pos);

    for (i = 0; i < g_main_menu_count; i++) /*在窗口原点处输出主菜单项*/
    {
        printf ("  %s  ", g_main_menu[i]);
    }

    GetConsoleCursorInfo (g_handle_out, &lpCur);
    lpCur.bVisible = FALSE;
    SetConsoleCursorInfo (g_handle_out, &lpCur); /*隐藏光标*/

    /*申请存放菜单条信息缓冲区*/
    g_buff_menubar_info = (CHAR_INFO *) malloc (size.X * size.Y * sizeof (CHAR_INFO));
    SMALL_RECT rcMenu = {0, 0, size.X - 1, 0} ;

    /*将菜单条读入到缓冲区*/
    ReadConsoleOutput (g_handle_out, g_buff_menubar_info, size, pos, &rcMenu);

    /*英文字母置为红色,其他字符单元置为缺省值*/
    for (i = 0; i < size.X; i++)
    {
        (g_buff_menubar_info + i)->Attributes = g_default_att;
        ch = (char) ( (g_buff_menubar_info + i)->Char.AsciiChar);

        if ( (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
        {
            (g_buff_menubar_info + i)->Attributes |= FOREGROUND_RED;
        }
    }

    /*修改后的菜单条信息回写到窗口首行*/
    WriteConsoleOutput (g_handle_out, g_buff_menubar_info, size, pos, &rcMenu);
    COORD endPos = {0, 1};
    SetConsoleCursorPosition (g_handle_out, endPos); /*将光标位置设置在第2行第1列*/

    /*将菜单项置为热区,热区编号为菜单项号,热区类型为按钮型*/
    i = 0;

    do
    {
        PosB = PosA + strlen (g_main_menu[i]); /*定位第i+1号菜单项的起止位置*/

        for (j = PosA; j < PosB; j++)
        {
            g_scr_att[j] |= (i + 1) << 2; /*设置菜单项属性值*/
        }

        PosA = PosB + 4;
        i++;
    }
    while (i < g_main_menu_count);

    TagMainMenu (g_sel_menu); /*标记选中主菜单,g_sel_menu初值为1*/

    return;
}

/** \brief ShowState:显示状态条
 *
 * \param void
 * \return void
 * \comments 状态条字符属性为缺省值, 初始状态无状态信息
 */
void ShowState (void)
{
    CONSOLE_SCREEN_BUFFER_INFO bInfo;
    COORD size;
    COORD pos = {0, 0};
    int i;

    GetConsoleScreenBufferInfo (g_handle_out, &bInfo);
    size.X = bInfo.dwSize.X;
    size.Y = 1;
    SMALL_RECT rcMenu = {0, bInfo.dwSize.Y - 1, size.X - 1, bInfo.dwSize.Y - 1};

    if (g_buff_stateBar_info == NULL)
    {
        g_buff_stateBar_info = (CHAR_INFO *) malloc (size.X * size.Y * sizeof (CHAR_INFO));
        ReadConsoleOutput (g_handle_out, g_buff_stateBar_info, size, pos, &rcMenu);
    }

    for (i = 0; i < size.X; i++)
    {
        (g_buff_stateBar_info + i)->Attributes = g_default_att;
    }

    WriteConsoleOutput (g_handle_out, g_buff_stateBar_info, size, pos, &rcMenu);

    return;
}

/** \brief TagMainMenu:在指定主菜单项上置选中标志
 *
 * \param num 选中的主菜单项号
 * \return void
 *
 */
void TagMainMenu (int num)
{
    CONSOLE_SCREEN_BUFFER_INFO bInfo;
    COORD size;
    COORD pos = {0, 0};
    int PosA = 2, PosB;
    char ch;
    int i;

    if (num == 0) /*num为0:去除主菜单项选中标记*/
    {
        PosA = 0;
        PosB = 0;
    }
    else        /*否则,定位选中主菜单项的起止位置: PosA为起始位置, PosB为截止位置*/
    {
        for (i = 1; i < num; i++)
        {
            PosA += strlen (g_main_menu[i - 1]) + 4;
        }

        PosB = PosA + strlen (g_main_menu[num - 1]);
    }

    GetConsoleScreenBufferInfo (g_handle_out, &bInfo);
    size.X = bInfo.dwSize.X;
    size.Y = 1;

    /*去除选中菜单项前面的菜单项选中标记*/
    for (i = 0; i < PosA; i++)
    {
        (g_buff_menubar_info + i)->Attributes = g_default_att;
        ch = (g_buff_menubar_info + i)->Char.AsciiChar;

        if ( (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
        {
            (g_buff_menubar_info + i)->Attributes |= FOREGROUND_RED;
        }
    }

    /*标记选中菜单项:黑底白字*/
    for (i = PosA; i < PosB; i++)
    {
        (g_buff_menubar_info + i)->Attributes = g_tag_default_att;
    }

    /*去除选中菜单项后面的菜单项选中标记*/
    for (i = PosB; i < bInfo.dwSize.X; i++)
    {
        (g_buff_menubar_info + i)->Attributes = g_default_att;
        ch = (char) ( (g_buff_menubar_info + i)->Char.AsciiChar);

        if ( (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
        {
            (g_buff_menubar_info + i)->Attributes |= FOREGROUND_RED;
        }
    }

    /*将做好标记的菜单条信息写到窗口首行*/
    SMALL_RECT rcMenu = {0, 0, size.X - 1, 0};
    WriteConsoleOutput (g_handle_out, g_buff_menubar_info, size, pos, &rcMenu);

    return;
}

/** \brief PopMenu:弹出指定主菜单项对应的子菜单
 *
 * \param num 指定的主菜单项号
 * \return void
 *
 */
void PopMenu (int num)
{
    LABEL_BUNDLE labels;
    HOT_AREA areas;
    SMALL_RECT rcPop;
    COORD pos;
    char * pCh;
    int i, j, loc = 0;

    if (num != g_sel_menu)             /*非选中主菜单*/
    {
        if (g_top_layer->LayerNo != 0) /*关闭已弹出其它子菜单*/
        {
            PopOff();
            g_sel_sub_menu = 0;
        }
    }
    else
        if (g_top_layer->LayerNo != 0) /*对应子菜单已弹出*/
        {
            return;
        }

    g_sel_menu = num;                   /*数字标记*/
    TagMainMenu (g_sel_menu);           /*文本标记*/
    LocSubMenu (g_sel_menu, &rcPop);    /*计算弹出子菜单的区域位置*/

    /*计算该子菜单位置(下标)*/
    for (i = 1; i < g_sel_menu; i++)
    {
        loc += g_sub_menu_count[i - 1];
    }

    /*将该组子菜单项项名存入标签束结构变量*/
    labels.ppLabel = g_sub_menu + loc;
    labels.num = g_sub_menu_count[g_sel_menu - 1];
    COORD aLoc[labels.num];/*存放每个标签字符串输出位置坐标*/

    for (i = 0; i < labels.num; i++) /*确定标签字符串的输出位置*/
    {
        aLoc[i].X = rcPop.Left + 2;
        aLoc[i].Y = rcPop.Top + i + 1;
    }

    labels.pLoc = aLoc; /*使标签束结构变量labels的成员pLoc指向坐标数组的首元素*/
    /*设置热区信息*/
    areas.num = labels.num;       /*热区个数*/
    SMALL_RECT aArea[areas.num];                    /*定义热区位置*/
    char aSort[areas.num];                      /*定义热区对应类别*/
    char aTag[areas.num];                         /*定义每个热区编号*/

    for (i = 0; i < areas.num; i++)
    {
        aArea[i].Left = rcPop.Left + 2;  /*热区定位*/
        aArea[i].Top = rcPop.Top + i + 1;
        aArea[i].Right = rcPop.Right - 2;
        aArea[i].Bottom = aArea[i].Top;
        aSort[i] = 0;                    /*热区类别为按钮型*/
        aTag[i] = i + 1;           /*热区按顺序编号*/
    }

    areas.pArea = aArea;/*使热区结构变量areas的成员pArea指向热区位置数组首元素*/
    areas.pSort = aSort;/*使热区结构变量areas的成员pSort指向热区类别数组首元素*/
    areas.pTag = aTag;   /*使热区结构变量areas的成员pTag指向热区编号数组首元素*/

    PopUp (&rcPop, g_default_att, &labels, &areas);
    DrawBox (&rcPop); /*画边框*/
    pos.X = rcPop.Left + 2;

    for (pos.Y = rcPop.Top + 1; pos.Y < rcPop.Bottom; pos.Y++)
    {
        /*在空串子菜项位置画线形成分隔，并取消此菜单项的热区属性*/
        pCh = g_sub_menu[loc + pos.Y - rcPop.Top - 1];

        if (strlen (pCh) == 0) /*空串*/
        {
            /*画横线*/
            FillConsoleOutputCharacter (g_handle_out, '-', rcPop.Right - rcPop.Left - 3, pos, &ul);

            for (j = rcPop.Left + 2; j < rcPop.Right - 1; j++)
            {
                /*取消热区属性*/
                g_scr_att[pos.Y * SCR_COL + j] &= 3; /*按位与的结果保留了低两位*/
            }
        }

    }

    /*快捷键设为白底绿字*/
    pos.X = rcPop.Left + 3;

    for (pos.Y = rcPop.Top + 1; pos.Y < rcPop.Bottom; pos.Y++)
    {
        if (strlen (g_sub_menu[loc + pos.Y - rcPop.Top - 1]) == 0)
        {
            continue;  /*跳过空串*/
        }

        FillConsoleOutputAttribute (g_handle_out, g_sub_menu_shortcut_att, 1, pos, &ul);
    }

    return;
}

/** \brief PopPrompt:显示系统提示输入信息
 *
 * \param pString 系统提示信息字符串数组
 * \param num 字符串个数
 * \return 提示信息输出区域中用户输入区域的坐标变量的地址值
 *
 */
COORD * PopPrompt (char ** pString, int num)
{
    /*循环变量*/
    int i;
    /*存放最长字符串长度*/
    int maxLenth = 0;
    /*读取光标信息*/
    CONSOLE_CURSOR_INFO lpCur;
    /*设置指定位置*/
    COORD pos;
    COORD * posRet = (COORD *) malloc (sizeof (COORD));

    /*计算提示信息中最长字符串长度*/
    for (i = 0; i < num; i++)
    {
        if (strlen (pString[i]) > maxLenth)
        {
            maxLenth = strlen (pString[i]);
        }
    }

    /*设置提示语出现区域*/
    pos.X = (SCR_COL - maxLenth - 10) / 2;
    pos.Y = 5;

    /*设置提示语文本属性*/
    for (i = 0; i < num; i++)
    {
        pos.X = (SCR_COL - maxLenth - 10) / 2;
        /*绿色填充矩形空间*/
        FillConsoleOutputAttribute (g_handle_out, g_sys_info_att, maxLenth + 10, pos, &ul);
        /*输出系统提示语*/
        pos.X += 3;
        WriteConsoleOutputCharacter (g_handle_out, pString[i], strlen (pString[i]), pos, &ul);
        /*设置输入框*/
        pos.X += maxLenth;
        FillConsoleOutputAttribute (g_handle_out, g_user_input_att, 10, pos, &ul);
        /*填充间隔行*/
        pos.X = (SCR_COL - maxLenth - 10) / 2;
        pos.Y += 1;
        FillConsoleOutputAttribute (g_handle_out, g_sys_info_att, maxLenth + 13, pos, &ul);
        /*移向下行*/
        pos.Y += 1;
    }

    /*存储用输入区域坐标值*/
    posRet->X = (SCR_COL - maxLenth - 10) / 2 + 3 + maxLenth;
    posRet->Y = 5;
    /*显示光标*/
    GetConsoleCursorInfo (g_handle_out, &lpCur);
    lpCur.bVisible = TRUE;
    SetConsoleCursorInfo (g_handle_out, &lpCur);

    return posRet;
}

/** \brief PopUp:在指定区域输出弹出窗口信息, 同时设置热区, 将弹出窗口位置信息入栈
 *
 * \param pRc 弹出窗口位置数据存放的地址
 * \param att 弹出窗口区域字符属性
 * \param pLabel 弹出窗口中标签束信息存放的地址
 * \param pHotArea 弹出窗口中热区信息存放的地址
 * \return void
 *
 */
void PopUp (SMALL_RECT * pRc, WORD att, LABEL_BUNDLE * pLabel, HOT_AREA * pHotArea)
{
    LAYER_NODE * nextLayer;
    COORD size;
    COORD pos = {0, 0};
    char * pCh;
    int i, j, row;

    /*弹出窗口所在位置字符单元信息入栈*/
    size.X = pRc->Right - pRc->Left + 1;    /*弹出窗口的宽度*/
    size.Y = pRc->Bottom - pRc->Top + 1;    /*弹出窗口的高度*/
    /*申请动态存储区*/
    nextLayer = (LAYER_NODE *) malloc (sizeof (LAYER_NODE));
    nextLayer->next = g_top_layer;
    nextLayer->LayerNo = g_top_layer->LayerNo + 1;
    nextLayer->rcArea = *pRc;
    nextLayer->pContent = (CHAR_INFO *) malloc (size.X * size.Y * sizeof (CHAR_INFO));
    nextLayer->pScrAtt = (char *) malloc (size.X * size.Y * sizeof (char));
    pCh = nextLayer->pScrAtt;
    /*保存字符单元信息*/
    ReadConsoleOutput (g_handle_out, nextLayer->pContent, size, pos, pRc);

    for (i = pRc->Top; i <= pRc->Bottom; i++)
    {
        /*保存字符单元文本属性*/
        for (j = pRc->Left; j <= pRc->Right; j++)
        {
            *pCh = g_scr_att[i * SCR_COL + j];
            pCh++;
        }
    }

    g_top_layer = nextLayer;  /*完成入栈*/
    /*设置弹出窗口区域字符的新属性*/
    pos.X = pRc->Left;
    pos.Y = pRc->Top;

    for (i = pRc->Top; i <= pRc->Bottom; i++)
    {
        FillConsoleOutputAttribute (g_handle_out, att, size.X, pos, &ul);
        pos.Y++;
    }

    /*输出标签束信息*/
    for (i = 0; i < pLabel->num; i++)
    {
        pCh = pLabel->ppLabel[i];

        if (strlen (pCh) != 0)
        {
            WriteConsoleOutputCharacter (g_handle_out, pCh, strlen (pCh),
                                         pLabel->pLoc[i], &ul);
        }
    }

    /*设置弹出窗口区域字符单元的新属性*/
    for (i = pRc->Top; i <= pRc->Bottom; i++)
    {
        /*设置字符单元的层号*/
        for (j = pRc->Left; j <= pRc->Right; j++)
        {
            g_scr_att[i * SCR_COL + j] = g_top_layer->LayerNo;
        }
    }

    for (i = 0; i < pHotArea->num; i++)
    {
        /*设置所有热区中字符单元的热区类型和热区编号*/
        row = pHotArea->pArea[i].Top;

        for (j = pHotArea->pArea[i].Left; j <= pHotArea->pArea[i].Right; j++)
        {
            g_scr_att[row * SCR_COL + j] |= (pHotArea->pSort[i] << 6)
                                            | (pHotArea->pTag[i] << 2);
        }
    }

    return;
}

/** \brief PopOff:关闭顶层弹出窗口, 恢复覆盖区域字符单元
 *
 * \param void
 * \return void
 *
 */
void PopOff (void)
{
    LAYER_NODE * nextLayer;
    COORD size;
    COORD pos = {0, 0};
    char * pCh;
    int i, j;

    if ( (g_top_layer->next == NULL) || (g_top_layer->pContent == NULL))
    {
        return;
    }

    nextLayer = g_top_layer->next;
    /*恢复字符单元*/
    size.X = g_top_layer->rcArea.Right - g_top_layer->rcArea.Left + 1;
    size.Y = g_top_layer->rcArea.Bottom - g_top_layer->rcArea.Top + 1;
    WriteConsoleOutput (g_handle_out, g_top_layer->pContent, size, pos, & (g_top_layer->rcArea));
    /*恢复文本属性*/
    pCh = g_top_layer->pScrAtt;

    for (i = g_top_layer->rcArea.Top; i <= g_top_layer->rcArea.Bottom; i++)
    {
        for (j = g_top_layer->rcArea.Left; j <= g_top_layer->rcArea.Right; j++)
        {
            g_scr_att[i * SCR_COL + j] = *pCh;
            pCh++;
        }
    }

    free (g_top_layer->pContent);   /*释放动态存储区*/
    free (g_top_layer->pScrAtt);
    free (g_top_layer);
    g_top_layer = nextLayer;
    g_sel_sub_menu = 0;
    return;
}

/** \brief DrawBox:在指定区域画边框
 *
 * \param pRc 存放区域位置信息的地址
 * \return void
 *
 */
void DrawBox (SMALL_RECT * pRc)
{
    char chBox[] = {'+', '-', '|'};     /*画框用的字符*/
    COORD pos = {pRc->Left, pRc->Top};  /*定位在区域的左上角*/

    WriteConsoleOutputCharacter (g_handle_out, &chBox[0], 1, pos, &ul); /*画边框左上角*/

    for (pos.X = pRc->Left + 1; pos.X < pRc->Right; pos.X++)
    {
        /*画上边框横线*/
        WriteConsoleOutputCharacter (g_handle_out, &chBox[1], 1, pos, &ul);
    }

    pos.X = pRc->Right;
    WriteConsoleOutputCharacter (g_handle_out, &chBox[0], 1, pos, &ul); /*画边框右上角*/

    for (pos.Y = pRc->Top + 1; pos.Y < pRc->Bottom; pos.Y++)
    {
        /*画左边线和右边线*/
        pos.X = pRc->Left;
        WriteConsoleOutputCharacter (g_handle_out, &chBox[2], 1, pos, &ul);
        pos.X = pRc->Right;
        WriteConsoleOutputCharacter (g_handle_out, &chBox[2], 1, pos, &ul);
    }

    pos.X = pRc->Left;
    pos.Y = pRc->Bottom;
    WriteConsoleOutputCharacter (g_handle_out, &chBox[0], 1, pos, &ul); /*画边框左下角*/

    for (pos.X = pRc->Left + 1; pos.X < pRc->Right; pos.X++)
    {
        /*画下边框横线*/
        WriteConsoleOutputCharacter (g_handle_out, &chBox[1], 1, pos, &ul);
    }

    pos.X = pRc->Right;
    WriteConsoleOutputCharacter (g_handle_out, &chBox[0], 1, pos, &ul); /*画边框右下角*/
    return;
}

/** \brief TagSubMenu:在指定子菜单项上做选中标记
 *
 * \param num 选中的子菜单项号
 * \return void
 *
 */
void TagSubMenu (int num)
{
    SMALL_RECT rcPop;
    COORD pos;
    int width;

    LocSubMenu (g_sel_menu, &rcPop); /*计算弹出子菜单位置*/

    if ( (num < 1) || (num == g_sel_sub_menu) || (num > rcPop.Bottom - rcPop.Top - 1))
    {
        /*已选中子菜单或无效选择*/
        return;
    }

    pos.X = rcPop.Left + 2;
    width = rcPop.Right - rcPop.Left - 3;

    if (g_sel_sub_menu != 0) /*取消原选中子菜单项标记*/
    {
        pos.Y = rcPop.Top + g_sel_sub_menu;
        FillConsoleOutputAttribute (g_handle_out, g_default_att, width, pos, &ul);
        pos.X += 1;
        FillConsoleOutputAttribute (g_handle_out, g_sub_menu_shortcut_att, 1, pos, &ul);
    }

    /*标记*/
    pos.X = rcPop.Left + 2;
    pos.Y = rcPop.Top + num;
    FillConsoleOutputAttribute (g_handle_out, g_tag_default_att, width, pos, &ul);
    g_sel_sub_menu = num;  /*修改选中子菜单项号*/
    return;
}

/** \brief LocSubMenu:计算弹出子菜单区域左上角和右下角的位置
 *
 * \param num 选中的主菜单项号
 * \param rc 存放区域位置信息的地址
 * \return void
 *
 */
void LocSubMenu (int num, SMALL_RECT * rc)
{
    int i, len, loc = 0;

    rc->Top = 1;
    rc->Left = 1;

    for (i = 1; i < num; i++)
    {
        /*计算区域左边界*/
        rc->Left += strlen (g_main_menu[i - 1]) + 4;
        loc += g_sub_menu_count[i - 1];
    }

    rc->Right = strlen (g_sub_menu[loc]);

    for (i = 1; i < g_sub_menu_count[num - 1]; i++)
    {
        /*查找最长子菜单字符串*/
        len = strlen (g_sub_menu[loc + i]);

        if (rc->Right < len)
        {
            rc->Right = len;
        }
    }

    rc->Right += rc->Left + 3;  /*计算区域右边界*/
    rc->Bottom = rc->Top + g_sub_menu_count[num - 1] + 1; /*计算区域下边的行号*/

    if (rc->Right >= SCR_COL)  /*右边界越界处理*/
    {
        len = rc->Right - SCR_COL + 1;
        rc->Left -= len;
        rc->Right = SCR_COL - 1;
    }

    return;
}

/** \brief DealInput:在弹出窗口区域设置热区, 等待并相应用户输入
 *
 * \param pHotArea 焦点热区
 * \param piHot 焦点热区编号的存放地址, 即指向焦点热区编号的指针
 * \return piHot 用鼠标单击、按回车或空格时返回当前热区编号
 *
 */
int DealInput (HOT_AREA * pHotArea, int * piHot)
{
    INPUT_RECORD inRec;
    DWORD res;
    COORD pos = {0, 0};
    int num, arrow, iRet = 0;
    int cNo, cTag, cSort;/*cNo:层号, cTag:热区编号, cSort: 热区类型*/
    char vkc, asc;       /*vkc:虚拟键代码, asc:字符的ASCII码值*/

    SetHotPoint (pHotArea, *piHot);

    while (TRUE)
    {
        ReadConsoleInput (g_handle_in, &inRec, 1, &res);

        if ( (inRec.EventType == MOUSE_EVENT) &&
                (inRec.Event.MouseEvent.dwButtonState
                 == FROM_LEFT_1ST_BUTTON_PRESSED))
        {
            pos = inRec.Event.MouseEvent.dwMousePosition;
            cNo = g_scr_att[pos.Y * SCR_COL + pos.X] & 3;
            cTag = (g_scr_att[pos.Y * SCR_COL + pos.X] >> 2) & 15;
            cSort = (g_scr_att[pos.Y * SCR_COL + pos.X] >> 6) & 3;

            if ( (cNo == g_top_layer->LayerNo) && cTag > 0)
            {
                *piHot = cTag;
                SetHotPoint (pHotArea, *piHot);

                if (cSort == 0)
                {
                    iRet = 13;
                    break;
                }
            }
        }
        else
            if (inRec.EventType == KEY_EVENT && inRec.Event.KeyEvent.bKeyDown)
            {
                vkc = inRec.Event.KeyEvent.wVirtualKeyCode;
                asc = inRec.Event.KeyEvent.uChar.AsciiChar;;

                if (asc == 0)
                {
                    arrow = 0;

                    switch (vkc)
                    {
                    /*方向键(左、上、右、下)的处理*/
                    case 37:
                        arrow = 1;
                        break;

                    case 38:
                        arrow = 2;
                        break;

                    case 39:
                        arrow = 3;
                        break;

                    case 40:
                        arrow = 4;
                        break;
                    }

                    if (arrow > 0)
                    {
                        num = *piHot;

                        while (TRUE)
                        {
                            if (arrow < 3)
                            {
                                num--;
                            }
                            else
                            {
                                num++;
                            }

                            if ( (num < 1) || (num > pHotArea->num) ||
                                    ( (arrow % 2) && (pHotArea->pArea[num - 1].Top
                                                      == pHotArea->pArea[*piHot - 1].Top)) || ( (! (arrow % 2))
                                                              && (pHotArea->pArea[num - 1].Top
                                                                  != pHotArea->pArea[*piHot - 1].Top)))
                            {
                                break;
                            }
                        }

                        if (num > 0 && num <= pHotArea->num)
                        {
                            *piHot = num;
                            SetHotPoint (pHotArea, *piHot);
                        }
                    }
                }
                else
                    if (vkc == 27)
                    {
                        /*ESC键*/
                        iRet = 27;
                        break;
                    }
                    else
                        if (vkc == 13 || vkc == 32)
                        {
                            /*回车键或空格表示按下当前按钮*/
                            iRet = 13;
                            break;
                        }
            }
    }

    return iRet;
}

/** \brief SetHotPoint:设置热区
 *
 * \param pHotArea 焦点热区
 * \param piHot 焦点热区编号的存放地址, 即指向焦点热区编号的指针
 * \return void
 *
 */
void SetHotPoint (HOT_AREA * pHotArea, int iHot)
{
    CONSOLE_CURSOR_INFO lpCur;
    COORD pos = {0, 0};
    int i, width;

    for (i = 0; i < pHotArea->num; i++)
    {
        /*将按钮类热区置为白底黑字*/
        pos.X = pHotArea->pArea[i].Left;
        pos.Y = pHotArea->pArea[i].Top;
        width = pHotArea->pArea[i].Right - pHotArea->pArea[i].Left + 1;

        if (pHotArea->pSort[i] == 0)
        {
            FillConsoleOutputAttribute (g_handle_out, g_default_att, width, pos, &ul);
        }
    }

    pos.X = pHotArea->pArea[iHot - 1].Left;
    pos.Y = pHotArea->pArea[iHot - 1].Top;
    width = pHotArea->pArea[iHot - 1].Right - pHotArea->pArea[iHot - 1].Left + 1;

    if (pHotArea->pSort[iHot - 1] == 0)
    {
        /*被激活热区是按钮类*/
        FillConsoleOutputAttribute (g_handle_out, g_tag_default_att, width, pos, &ul);
    }
    else
        if (pHotArea->pSort[iHot - 1] == 1)
        {
            /*被激活热区是文本框类*/
            SetConsoleCursorPosition (g_handle_out, pos);
            GetConsoleCursorInfo (g_handle_out, &lpCur);
            lpCur.bVisible = TRUE;
            SetConsoleCursorInfo (g_handle_out, &lpCur);
        }
}

/** \brief 以矩形文本框形式输出字符串数组
 *
 * \param pString 字符串数组
 * \param n 字符串个数
 * \return BOOL值:TRUE/FALSE
 *
 */
BOOL ShowModule (char ** pString, int n)
{
    LABEL_BUNDLE labels;
    HOT_AREA areas;
    BOOL bRet = TRUE;
    SMALL_RECT rcPop;
    COORD pos;
    int iHot = 1;
    int i, maxlen, str_len;

    for (i = 0, maxlen = 0; i < n; i++)
    {
        str_len = strlen (pString[i]);

        if (maxlen < str_len)
        {
            maxlen = str_len;
        }
    }

    pos.X = maxlen + 6;
    pos.Y = n + 5;
    rcPop.Left = (SCR_COL - pos.X) / 2;
    rcPop.Right = rcPop.Left + pos.X - 1;
    rcPop.Top = (SCR_ROW - pos.Y) / 2;
    rcPop.Bottom = rcPop.Top + pos.Y - 1;

    labels.num = n;
    labels.ppLabel = pString;
    COORD aLoc[n];

    for (i = 0; i < n; i++)
    {
        aLoc[i].X = rcPop.Left + 3;
        aLoc[i].Y = rcPop.Top + 2 + i;

    }

    str_len = strlen (pString[n - 1]);
    aLoc[n - 1].X = rcPop.Left + 3 + (maxlen - str_len) / 2;
    aLoc[n - 1].Y = aLoc[n - 1].Y + 2;

    labels.pLoc = aLoc;

    areas.num = 1;
    SMALL_RECT aArea[] = {{
            aLoc[n - 1].X, aLoc[n - 1].Y,
            aLoc[n - 1].X + 3, aLoc[n - 1].Y
        }
    };

    char aSort[] = {0};
    char aTag[] = {1};

    areas.pArea = aArea;
    areas.pSort = aSort;
    areas.pTag = aTag;
    PopUp (&rcPop, g_default_att, &labels, &areas);

    pos.X = rcPop.Left + 1;
    pos.Y = rcPop.Top + 2 + n;
    FillConsoleOutputCharacter (g_handle_out, '-', rcPop.Right - rcPop.Left - 1, pos, &ul);

    DealInput (&areas, &iHot);
    PopOff();

    return bRet;

}

/** \brief ExeFunction:执行由主菜单号和子菜单号确定的功能函数
 *
 * \param m 主菜单项号
 * \param s 子菜单项号
 * \return BOOL值:TRUE/FALSE
 */
BOOL ExeFunction (int m, int s)
{
    BOOL bRet = TRUE;

    int i, loc, sub_menu_number = 0;

    /*函数指针数组，用来存放所有功能函数的入口地址*/
    for (i = 0; i < g_main_menu_count; i++)
    {
        sub_menu_number += g_sub_menu_count[i];
    }

    BOOL (*pFunction[sub_menu_number]) (void);

    /*将功能函数入口地址存入与功能函数所在主菜单号和子菜单号对应下标的数组元素*/
    pFunction[0] = CreateList;
    pFunction[1] = LoadList;
    pFunction[2] = SaveList;
    pFunction[3] = RestoreList;
    pFunction[4] = BackupList;
    pFunction[5] = ExitSys;
    pFunction[6] = InsertWorkInfo;
    pFunction[7] = InsertStuInfo;
    pFunction[8] = InsertCourseInfo;
    pFunction[9] = NULL;
    pFunction[10] = DelWorkInfo;
    pFunction[11] = DelStuInfo;
    pFunction[12] = DelCourseInfo;
    pFunction[13] = NULL;
    pFunction[14] = ModifyWorkInfo;
    pFunction[15] = ModifyStuInfo;
    pFunction[16] = ModifyCourseInfo;
    pFunction[17] = PrintWorkInfo;
    pFunction[18] = PrintStuInfo;
    pFunction[19] = PrintCourseInfo;
    pFunction[20] = NULL;
    pFunction[21] = PrintAllInfo;
    pFunction[22] = StaCourseNumber;
    pFunction[23] = StaCourseScore;
    pFunction[24] = StaCourseStuScore;
    pFunction[25] = HelpTheme;
    pFunction[26] = AboutSys;

    for (i = 1, loc = 0; i < m; i++) /*根据主菜单号和子菜单号计算对应下标*/
    {
        loc += g_sub_menu_count[i - 1];
    }

    loc += s - 1;

    if (pFunction[loc] != NULL)
    {
        bRet = (*pFunction[loc]) (); /*用函数指针调用所指向的功能函数*/
    }

    return bRet;
}

/** \brief CreateList():创建一个完整的课程作业信息链表
 *
 * \param headp 课程信息链结点指针的地址值
 * \param
 * \return BOOL值:TRUE表示创建成功,FALSE表示创建失败
 *
 */
BOOL CreateList (void)
{
    PCOURSE_NODE course_head, course_tail;
    /*课程总数*/
    short course_amount = 0;
    /*三个计数器*/
    short course_count = 0;

    /*用户输入区域坐标值*/
    COORD * pos;
    /*系统提示语*/
    char * promptInfo[] = {"请输入课程总数:  "};
    char * pCh[] = {"新建完成",
                    "确认"
                   };
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 1);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%hd", &course_amount);
    InitInterface();
    /*课程信息首结点*/
    printf ("\n******************************请输入第%d个课程信息:******************************", ++course_count);
    course_head = AddCourseNode();
    /*课程信息后继结点*/
    course_tail = course_head;

    while (course_count < course_amount)
    {
        printf ("\n******************************请输入第%d个课程信息:******************************", ++course_count);
        course_tail->next = AddCourseNode();
        course_tail = course_tail->next;
    }

    /*课程信息链尾结点*/
    course_tail->next = NULL;

    g_headp = course_head;
    ShowModule (pCh, 2);

    return TRUE;
}

/**< 封装函数LoadData */
BOOL LoadList (void)
{
    BOOL bRet = TRUE;
    char * plabel_success[] = {"读取成功",
                               "确认"
                              };

    char * plabel_fail[] = {"读取失败",
                            "确认"
                           };

    if (LoadData (&g_headp))
    {
        ShowModule (plabel_success, 2);
    }
    else
    {
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 封装函数SaveData */
BOOL SaveList (void)
{
    BOOL bRet = TRUE;
    char * plabel_success[] = {"保存成功",
                               "确认"
                              };

    char * plabel_fail[] = {"保存失败",
                            "确认"
                           };

    if (SaveData (g_headp))
    {
        ShowModule (plabel_success, 2);
    }
    else
    {
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 封装函数RestoreData */
BOOL RestoreList (void)
{
    BOOL bRet = TRUE;
    char * plabel_success[] = {"恢复成功",
                               "确认"
                              };

    char * plabel_fail[] = {"恢复失败",
                            "确认"
                           };

    if (RestoreData (&g_headp))
    {
        ShowModule (plabel_success, 2);
    }
    else
    {
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 封装函数BackupData */
BOOL BackupList (void)
{
    BOOL bRet = TRUE;
    char * plabel_success[] = {"备份成功",
                               "确认"
                              };

    char * plabel_fail[] = {"备份失败",
                            "确认"
                           };

    if (BackupData (g_headp))
    {
        ShowModule (plabel_success, 2);
    }
    else
    {
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 退出系统 */
BOOL ExitSys (void)
{
    LABEL_BUNDLE labels;
    HOT_AREA areas;
    BOOL bRet = TRUE;
    SMALL_RECT rcPop;
    COORD pos;
    char * pCh[] = {"确认退出系统吗？", "确定    取消"};
    int iHot = 1;

    pos.X = strlen (pCh[0]) + 6;
    pos.Y = 7;
    rcPop.Left = (SCR_COL - pos.X) / 2;
    rcPop.Right = rcPop.Left + pos.X - 1;
    rcPop.Top = (SCR_ROW - pos.Y) / 2;
    rcPop.Bottom = rcPop.Top + pos.Y - 1;

    labels.num = 2;
    labels.ppLabel = pCh;
    COORD aLoc[] = {{rcPop.Left + 3, rcPop.Top + 2},
        {rcPop.Left + 5, rcPop.Top + 5}
    };
    labels.pLoc = aLoc;

    areas.num = 2;
    SMALL_RECT aArea[] = {{
            rcPop.Left + 5, rcPop.Top + 5,
            rcPop.Left + 8, rcPop.Top + 5
        },
        {
            rcPop.Left + 13, rcPop.Top + 5,
            rcPop.Left + 16, rcPop.Top + 5
        }
    };
    char aSort[] = {0, 0};
    char aTag[] = {1, 2};
    areas.pArea = aArea;
    areas.pSort = aSort;
    areas.pTag = aTag;
    PopUp (&rcPop, g_default_att, &labels, &areas);

    pos.X = rcPop.Left + 1;
    pos.Y = rcPop.Top + 4;
    FillConsoleOutputCharacter (g_handle_out, '-', rcPop.Right - rcPop.Left - 1, pos, &ul);

    if (DealInput (&areas, &iHot) == 13 && iHot == 1)
    {
        bRet = FALSE;
    }
    else
    {
        bRet = TRUE;
    }

    PopOff();

    return bRet;
}

/**< 封装InsertWorkNode函数 */
BOOL InsertWorkInfo (void)
{
    BOOL bRet = TRUE;
    /*新建作业信息结点*/
    PWORK_NODE new_node;
    /*目标学生信息支链*/
    PSTU_NODE stu_temp;
    /*系统提示语*/
    char * plabel_success[] = {"插入成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,插入失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                          };
    /*目标信息*/
    char course_info[20], stu_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 2);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    InitInterface();

    /*查找目标支链*/
    if ( (stu_temp = SeekStuNode (g_headp, course_info, stu_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else
    {
        /*新增所目标支链目标结点*/
        new_node = AddWorkNode (stu_temp->beCourse, stu_temp->name);

        /*插入目标结点*/
        if (InsertWorkNode (g_headp, course_info, stu_info, new_node))
        {
            /*打印提示信息*/
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    return bRet;
}

/**< 封装InsertStuNode函数 */
BOOL InsertStuInfo (void)
{
    BOOL bRet = TRUE;
    /*新建学生信息结点*/
    PSTU_NODE new_node;
    /*目标课程信息支链*/
    PCOURSE_NODE course_temp;
    /*系统提示语*/
    char * plabel_success[] = {"插入成功",
                               "确认"
                              };

    char * plabel_fail[] = {"无法找到目标信息,插入失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:"
                          };
    /*目标信息*/
    char course_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 1);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    InitInterface();

    /*查找目标支链*/
    if ( (course_temp = SeekCourseNode (g_headp, course_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else
    {
        /*新增所目标支链目标结点*/
        new_node = AddStuNode (course_temp->name);

        /*插入目标结点*/
        if (InsertStuNode (g_headp, course_info, new_node))
        {
            /*打印提示信息*/
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    return bRet;
}

/**< 封装InsertCourseNode函数 */
BOOL InsertCourseInfo (void)
{
    BOOL bRet = TRUE;
    /*新建课程信息结点*/
    PCOURSE_NODE new_node;
    /*系统提示语*/
    char * plabel_success[] = {"插入成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,插入失败",
                            "确认"
                           };
    /*新增所目标支链目标结点*/
    new_node = AddCourseNode();

    /*插入目标结点*/
    if (InsertCourseNode (&g_headp, new_node))
    {
        /*打印提示信息*/
        ShowModule (plabel_success, 2);
    }
    else
    {
        ShowModule (plabel_fail, 2);
    }


    return bRet;
}

/**< 封装DelWorkNode函数 */
BOOL DelWorkInfo (void)
{
    BOOL bRet = TRUE;
    /*系统提示语*/
    char * plabel_success[] = {"删除成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,删除失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                           "请输入目标作业编号:"
                          };
    /*目标信息*/
    char course_info[20], stu_info[20], work_id[10];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 3);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%9s", work_id);
    InitInterface();

    /*查找目标支链*/
    if (DelWorkNode (g_headp, course_info, stu_info, work_id))
    {
        /*打印提示信息*/
        ShowModule (plabel_success, 2);
    }
    else
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 封装DelStuNode函数 */
BOOL DelStuInfo (void)
{
    BOOL bRet = TRUE;
    /*系统提示语*/
    char * plabel_success[] = {"删除成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,删除失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                          };
    /*目标信息*/
    char course_info[20], stu_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 2);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    InitInterface();

    /*查找目标支链*/
    if (DelStuNode (g_headp, course_info, stu_info))
    {
        /*打印提示信息*/
        ShowModule (plabel_success, 2);
    }
    else
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 封装DelCourseNode函数 */
BOOL DelCourseInfo (void)
{
    BOOL bRet = TRUE;
    /*系统提示语*/
    char * plabel_success[] = {"删除成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,删除失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                          };
    /*目标信息*/
    char course_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 1);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    InitInterface();

    /*查找目标支链*/
    if (DelCourseNode (&g_headp, course_info))
    {
        /*打印提示信息*/
        ShowModule (plabel_success, 2);
    }
    else
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/**< 封装ModifyWorkNode函数 */
BOOL ModifyWorkInfo (void)
{
    BOOL bRet = TRUE;
    /*新建作业信息结点*/
    PWORK_NODE new_node;
    /*目标学生信息支链*/
    PSTU_NODE stu_temp;
    /*系统提示语*/
    char * plabel_success[] = {"修改成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,修改失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                           "请输入目标作业编号:"
                          };
    /*目标信息*/
    char course_info[20], stu_info[20], work_id[10];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 3);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%9s", work_id);
    InitInterface();

    /*查找目标支链*/
    if ( (stu_temp = SeekStuNode (g_headp, course_info, stu_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else
    {
        /*新增所目标支链目标结点*/
        new_node = AddWorkNode (stu_temp->beCourse, stu_temp->name);

        /*插入目标结点*/
        if (ModifyWorkNode (g_headp, course_info, stu_info, work_id, new_node))
        {
            /*打印提示信息*/
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    return bRet;
}

/**< 封装ModifyStuNode函数 */
BOOL ModifyStuInfo (void)
{
    BOOL bRet = TRUE;
    /*新建学生信息结点*/
    PSTU_NODE new_node;
    /*目标课程信息支链*/
    PCOURSE_NODE course_temp;
    /*系统提示语*/
    char * plabel_success[] = {"修改成功",
                               "确认"
                              };

    char * plabel_fail[] = {"无法找到目标信息,修改失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                          };
    /*目标信息*/
    char course_info[20], stu_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 2);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    InitInterface();

    /*查找目标支链*/
    if ( (course_temp = SeekCourseNode (g_headp, course_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else
    {
        /*新增所目标支链目标结点*/
        new_node = AddStuNode (course_temp->name);

        /*插入目标结点*/
        if (ModifyStuNode (g_headp, course_info, stu_info, new_node))
        {
            /*打印提示信息*/
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    return bRet;
}

/**< 封装ModifyCourseNode函数 */
BOOL ModifyCourseInfo (void)
{
    BOOL bRet = TRUE;
    /*新建课程信息结点*/
    PCOURSE_NODE new_node;
    /*目标结点*/
    PCOURSE_NODE course_temp;
    /*系统提示语*/
    char * plabel_success[] = {"修改成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,修改失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                          };
    /*目标信息*/
    char course_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 1);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    InitInterface();

    /*查找目标结点*/
    if ( (course_temp = SeekCourseNode (g_headp, course_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else
    {
        /*新增所目标支链目标结点*/
        new_node = AddCourseNode();

        /*插入目标结点*/
        if (ModifyCourseNode (g_headp, course_info, new_node))
        {
            /*打印提示信息*/
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    return bRet;
}

/**< 封装PrintAllCourseNode函数 */
BOOL PrintAllInfo (void)
{
    BOOL bRet = TRUE;
    /*系统提示语*/
    char * plabel_success[] = {"打印成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,打印失败",
                            "确认"
                           };

    if (PrintAllCourseNode (g_headp))
    {
        ShowModule (plabel_success, 2);
    }
    else
    {
        ShowModule (plabel_fail, 2);
    }

    return bRet;
}

/** \brief PrintCourseInfo:输出用户查询目标课程信息
 *
 * \param void
 * \return BOOL
 *
 */
BOOL PrintCourseInfo (void)
{
    BOOL bRet = TRUE;
    PCOURSE_NODE course_temp;
    /*系统提示语*/
    char * plabel_success[] = {"打印成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,打印失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                          };
    /*目标信息*/
    char course_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 1);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    InitInterface();

    /*查找目标*/
    if ( (course_temp = SeekCourseNode (g_headp, course_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else
    {
        if (PrintCourseNode (course_temp))
        {
            /*打印提示信息*/
            system ("pause");
            InitInterface();
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    return bRet;
}

/** \brief PrintStuInfo:输出用户查询目标学生信息(相同/不同课程)
 *
 * \param void
 * \return BOOL
 *
 */
BOOL PrintStuInfo (void)
{
    BOOL bRet = TRUE;
    PCOURSE_NODE course_temp;
    PSTU_NODE stu_temp;
    short count = 0;
    /*系统提示语*/
    char * plabel_success[] = {"查询成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,查询失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                          };
    /*目标信息*/
    char course_info[20], stu_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 2);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    InitInterface();

    /*查找目标*/
    /*用户未输入课程信息,全局查找*/
    if (strcmp (course_info, "NULL") == 0)
    {
        for (course_temp = g_headp; course_temp != NULL; course_temp = course_temp->next)
        {
            for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
            {
                if (strcmp (stu_temp->id, stu_info) == 0 || strcmp (stu_temp->name, stu_info) == 0)
                {
                    /*查找整个链表,输出所有目标学生信息*/
                    PrintStuNode (stu_temp);
                    count ++;

                    /*换页操作*/
                    if (count > 0)
                    {
                        printf ("按下任意键查看更多查询结果:");
                        system ("pause");
                        InitInterface();
                    }
                }
            }
        }

        /*判断运行成功与否*/
        if (count > 0)
        {
            InitInterface();
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }
    /*用户输入课程信息,精确查找*/
    else
    {
        if (! (stu_temp = SeekStuNode (g_headp, course_info, stu_info)))
        {
            /*打印提示信息*/
            ShowModule (plabel_fail, 2);
            return bRet;
        }
        else
        {
            if (PrintStuNode (stu_temp))
            {
                /*打印提示信息*/
                system ("pause");
                InitInterface();
                ShowModule (plabel_success, 2);
            }
            else
            {
                ShowModule (plabel_fail, 2);
            }
        }
    }

    return bRet;
}

/** \brief PrintWorkInfo:输出用户查询目标作业信息(相同/不同课程,相同/不同学生)
 *
 * \param void
 * \return BOOL
 *
 */
BOOL PrintWorkInfo (void)
{
    BOOL bRet = TRUE;
    /*遍历指针*/
    PCOURSE_NODE course_temp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    /*计数器*/
    short count;
    /*系统提示语*/
    char * plabel_success[] = {"查询成功",
                               "确认"
                              };
    char * plabel_fail[] = {"无法找到目标信息,查询失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                           "请输入目标学生学号/姓名:",
                           "请输入目标作业编号:"
                          };
    /*目标信息*/
    char course_info[20], stu_info[20], work_id[10];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 3);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", stu_info);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%9s", work_id);
    InitInterface();

    /*查找目标*/
    /*用户未输入课程及学生信息,全局查找*/
    if (strcmp (course_info, "NULL") == 0 && strcmp (stu_info, "NULL") == 0)
    {
        /*初始化计数器*/
        count = 0;

        for (course_temp = g_headp; course_temp != NULL; course_temp = course_temp->next)
        {
            for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
            {
                for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
                {
                    if (strcmp (work_temp->id, work_id) == 0)
                    {
                        /*查找整个链表,输出所有目标学生信息*/
                        printf ("│──────────────────────────────────────│");
                        printf ("│作业编号 │     所属课程    │     所属学生    │     作业说明    │作业分数│");
                        PrintWorkNode (work_temp);
                        count++;
                    }
                }
            }
        }

        /*运行成功性*/
        if (count > 0)
        {
            system ("pause");
            InitInterface();
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    /*用户仅输入课程信息,全局查找*/
    if (strcmp (course_info, "NULL") != 0 && strcmp (stu_info, "NULL") == 0)
    {
        /*初始化计数器*/
        count = 0;

        /*查找目标结点*/
        if ( (course_temp = SeekCourseNode (g_headp, course_info)) == NULL)
        {
            /*打印提示信息*/
            ShowModule (plabel_fail, 2);
            return bRet;
        }
        else
        {
            for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
            {
                for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
                {
                    if (strcmp (work_temp->id, work_id) == 0)
                    {
                        /*查找整个课程信息支链,输出所有目标学生信息*/
                        printf ("│──────────────────────────────────────│");
                        printf ("│作业编号 │     所属课程    │     所属学生    │     作业说明    │作业分数│");
                        PrintWorkNode (work_temp);
                        count++;
                    }
                }
            }
        }

        /*运行成功性*/
        if (count > 0)
        {
            system ("pause");
            InitInterface();
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    /*用户仅输入学生信息,全局查找*/
    if (strcmp (course_info, "NULL") == 0 && strcmp (stu_info, "NULL") != 0)
    {
        /*初始化计数器*/
        count = 0;

        for (course_temp = g_headp; course_temp != NULL; course_temp = course_temp->next)
        {
            for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
            {
                if (strcmp (stu_temp->id, stu_info) == 0 || strcmp (stu_temp->name, stu_info) == 0)
                {
                    for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
                    {
                        if (strcmp (work_temp->id, work_id) == 0)
                        {
                            /*查找整个链表,输出所有目标学生信息*/
                            printf ("│──────────────────────────────────────│");
                            printf ("│作业编号 │     所属课程    │     所属学生    │     作业说明    │作业分数│");
                            PrintWorkNode (work_temp);
                            count++;
                        }
                    }
                }

            }
        }

        /*运行成功性*/
        if (count > 0)
        {
            system ("pause");
            InitInterface();
            ShowModule (plabel_success, 2);
        }
        else
        {
            ShowModule (plabel_fail, 2);
        }
    }

    /*用户输入课程及学生信息,精确查找*/
    if (strcmp (course_info, "NULL") != 0 && strcmp (stu_info, "NULL") != 0)
    {
        if (! (work_temp = SeekWorkNode (g_headp, course_info, stu_info, work_id)))
        {
            /*打印提示信息*/
            ShowModule (plabel_fail, 2);
            return bRet;
        }
        else
        {
            if (PrintWorkNode (work_temp))
            {
                InitInterface();
                printf ("│──────────────────────────────────────│");
                printf ("│作业编号 │     所属课程    │     所属学生    │     作业说明    │作业分数│");
                PrintWorkNode (work_temp);
                /*打印提示信息*/
                system ("pause");
                InitInterface();
                ShowModule (plabel_success, 2);
            }
            else
            {
                ShowModule (plabel_fail, 2);
            }
        }
    }

    return bRet;
}

/** \brief StaCourseNumber:统计课程作业平均个数
 *
 * \param void
 * \return BOOL值
 *
 */
BOOL StaCourseNumber (void)
{
    BOOL bRet = TRUE;
    /*系统提示语*/
    char * plabel_success[] = {"统计成功",
                               "确认"
                              };
    char * plabel_fail[] = {"发生未知错误,统计失败",
                            "确认"
                           };
    PCOURSE_AVERAGE_NODE chead, ctail;
    /*遍历指针*/
    PCOURSE_NODE course_temp = g_headp;
    PSTU_NODE stu_temp;
    /*创建课程统计信息首结点*/
    chead = (PCOURSE_AVERAGE_NODE) malloc (sizeof (COURSE_AVERAGE_NODE));
    /*处理已知信息*/
    strcpy (chead->id, course_temp->id), strcpy (chead->name, course_temp->name), chead->stuAmount = course_temp->stuAmount;
    /*计算作业平均个数*/
    chead->averageNumber = 0;

    for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
    {
        chead->averageNumber += stu_temp->workAmount;
    }

    chead->averageNumber /= chead->stuAmount;

    /*创建后继结点*/
    for (ctail = chead, course_temp = g_headp -> next; course_temp != NULL; course_temp = course_temp->next)
    {
        ctail->next = (PCOURSE_AVERAGE_NODE) malloc (sizeof (COURSE_AVERAGE_NODE));
        ctail = ctail->next;
        /*处理已知信息*/
        strcpy (ctail->id, course_temp->id), strcpy (ctail->name, course_temp->name), ctail->stuAmount = course_temp->stuAmount;
        /*计算作业平均个数*/
        ctail->averageNumber = 0;

        for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
        {
            ctail->averageNumber += stu_temp->workAmount;
        }

        ctail->averageNumber /= ctail->stuAmount;
    }

    /*创建尾结点*/
    ctail->next = NULL;

    /*降序排序*/
    SortStaCourseNumberNode (&chead);
    /*遍历输出*/
    printf ("│──────────────────────────────────────│");
    printf ("│   课程编号   │      课程名称      │  课程人数  │   学生作业平均个数     │");

    for (ctail = chead; ctail != NULL; ctail = ctail->next)
    {
        printf ("│%-14s│%-20s│%-12hd│%-24.2f│", ctail->id, ctail->name, ctail->stuAmount, ctail->averageNumber);
    }

    /*界面初始化*/
    system ("pause");
    InitInterface();
    ShowModule (plabel_success, 2);

    return bRet;
}

/** \brief StaCourseScore:统计课程作业平均分数
 *
 * \param void
 * \return BOOL值
 *
 */
BOOL StaCourseScore (void)
{
    BOOL bRet = TRUE;
    /*作业计数器*/
    short work_count;
    /*系统提示语*/
    char * plabel_success[] = {"统计成功",
                               "确认"
                              };
    char * plabel_fail[] = {"发生未知错误,统计失败",
                            "确认"
                           };
    PCOURSE_AVERAGE_NODE chead, ctail;
    /*遍历指针*/
    PCOURSE_NODE course_temp = g_headp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    /*创建课程统计信息首结点*/
    chead = (PCOURSE_AVERAGE_NODE) malloc (sizeof (COURSE_AVERAGE_NODE));
    /*处理已知信息*/
    strcpy (chead->id, course_temp->id), strcpy (chead->name, course_temp->name), chead->stuAmount = course_temp->stuAmount;
    /*计算作业平均分数*/
    chead->averageScore = 0;
    work_count = 0;

    for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
    {
        for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
        {
            chead->averageScore += work_temp->score;
        }

        work_count += stu_temp->workAmount;
    }

    chead->averageScore /= work_count;

    /*创建后继结点*/
    for (ctail = chead, course_temp = g_headp -> next; course_temp != NULL; course_temp = course_temp->next)
    {
        ctail->next = (PCOURSE_AVERAGE_NODE) malloc (sizeof (COURSE_AVERAGE_NODE));
        ctail = ctail->next;
        /*处理已知信息*/
        strcpy (ctail->id, course_temp->id), strcpy (ctail->name, course_temp->name), ctail->stuAmount = course_temp->stuAmount;
        /*计算作业平均分数*/
        ctail->averageScore = 0;
        work_count = 0;

        for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
        {
            for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
            {
                ctail->averageScore += work_temp->score;
            }

            work_count += stu_temp->workAmount;
        }

        ctail->averageScore /= work_count;
    }

    /*创建尾结点*/
    ctail->next = NULL;

    /*降序排序*/
    SortStaCourseScoreNode (&chead);
    /*遍历输出*/
    printf ("│──────────────────────────────────────│");
    printf ("│   课程编号   │      课程名称      │  课程人数  │   学生作业平均分数     │");

    for (ctail = chead; ctail != NULL; ctail = ctail->next)
    {
        printf ("│%-14s│%-20s│%-12hd│%-24.2f│", ctail->id, ctail->name, ctail->stuAmount, ctail->averageScore);
    }

    /*界面初始化*/
    system ("pause");
    InitInterface();
    ShowModule (plabel_success, 2);

    return bRet;
}

/** \brief StaCourseStuScore:统计目标课程每个学生作业平均分数
 *
 * \param void
 * \return BOOL值
 *
 */
BOOL StaCourseStuScore (void)
{
    BOOL bRet = TRUE;
    PSTU_AVERAGE_NODE chead, ctail;
    /*遍历指针*/
    PCOURSE_NODE course_temp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    /*系统提示语*/
    char * plabel_success[] = {"统计成功",
                               "确认"
                              };
    char * plabel_fail[] = {"发生未知错误,统计失败",
                            "确认"
                           };
    char * promptInfo[] = {"请输入目标课程编号/名称:",
                          };
    /*目标信息*/
    char course_info[20];
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 1);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", course_info);
    InitInterface();

    /*查找目标结点*/
    if ( (course_temp = SeekCourseNode (g_headp, course_info)) == NULL)
    {
        /*打印提示信息*/
        ShowModule (plabel_fail, 2);
        return bRet;
    }
    else/*开始创建统计链表*/
    {
        /*创建统计信息首结点*/
        chead = (PSTU_AVERAGE_NODE) malloc (sizeof (STU_AVERAGE_NODE));
        stu_temp = course_temp->snext;
        /*处理已知信息*/
        strcpy (chead->id, stu_temp->id), strcpy (chead->name, stu_temp->name), strcpy (chead->beCourse, stu_temp->beCourse);
        chead->workAmount = stu_temp->workAmount;
        /*计算作业平均分数*/
        chead->averageScore = 0;

        for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
        {
            chead->averageScore += work_temp->score;
        }

        chead->averageScore /= chead->workAmount;

        /*创建后继结点*/
        for (ctail = chead, stu_temp = stu_temp->next; stu_temp != NULL; stu_temp = stu_temp->next)
        {
            ctail->next = (PSTU_AVERAGE_NODE) malloc (sizeof (STU_AVERAGE_NODE));
            ctail = ctail->next;
            /*处理已知信息*/
            strcpy (ctail->id, stu_temp->id), strcpy (ctail->name, stu_temp->name), strcpy (ctail->beCourse, stu_temp->beCourse);
            ctail->workAmount = stu_temp->workAmount;
            /*计算作业平均分数*/
            ctail->averageScore = 0;

            for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
            {
                ctail->averageScore += work_temp->score;
            }

            ctail->averageScore /= ctail->workAmount;
        }

        /*创建尾结点*/
        ctail->next = NULL;

        /*降序排序*/
        SortStaStuScoreNode (&chead);
        /*遍历输出*/
        printf ("│──────────────────────────────────────│");
        printf ("│学生学号│    学生姓名    │    所属课程    │  作业个数  │  作业平均分数  │");

        for (ctail = chead; ctail != NULL; ctail = ctail->next)
        {
            printf ("│%-8s│%-16s│%-16s│%-12hd│%-16.2f│", ctail->id, ctail->name, ctail->beCourse, ctail->workAmount, ctail->averageScore);
        }

        /*界面初始化*/
        system ("pause");
        InitInterface();
        ShowModule (plabel_success, 2);
    }

    return bRet;
}

/**< 系统帮助主题*/
BOOL HelpTheme (void)
{
    BOOL bRet = TRUE;
    COORD pos = {20, 5};
    SetConsoleCursorPosition (g_handle_out, pos);
    printf ("\t学生管理操作系统系统操作指南\n");
    pos.Y += 2;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 1.Alt + X   退出系统;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 2.Alt + F   弹出\"文件\"的下拉菜单;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 3.Alt + M   弹出\"数据维护\"的下拉菜单;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 4.Alt + Q   弹出\"数据查询\"的下拉菜单;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 5.Alt + S   弹出\"数据统计\"的下拉菜单;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 6.Alt + H   弹出\"帮助\"的下拉菜单;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 7.[字母]    对应子菜单快捷键;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 8.F1        帮助主题;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 9.ESC   键  关闭弹出窗口;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 10.Enter键  确认键/输入键;\n");
    pos.Y++;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf (" 11.查询中输入\"NULL\"表示此信息不受限制;\n");
    pos.X += 5;
    pos.Y += 3;
    SetConsoleCursorPosition (g_handle_out, pos);
    system ("pause");
    InitInterface();
    return bRet;
}

/**< 系统使用说明*/
BOOL AboutSys (void)
{
    BOOL bRet = TRUE;
    COORD pos = {25, 5};
    SetConsoleCursorPosition (g_handle_out, pos);
    printf ("更多关于 \"学生作业管理系统\"\n");
    pos.X += 2;
    pos.Y += 6;
    SetConsoleCursorPosition (g_handle_out, pos);
    printf ("请致信 HustLyl@163.com\n");
    pos.X += 2;
    pos.Y += 6;
    SetConsoleCursorPosition (g_handle_out, pos);
    system ("pause");
    InitInterface();
    return bRet;
}

/** \brief AddWorkNode:添加指定课程与学生的作业信息结点
 *
 * \param course_name 课程名称
 * \return NULL/结点地址值
 */
PWORK_NODE AddWorkNode (char * course_name, char * stu_name)
{
    PWORK_NODE pwork_node;
    pwork_node = (PWORK_NODE) malloc (sizeof (WORK_NODE));

    /*系统提示语*/
    char * promptInfo[] = {"请输入作业编号:", "请输入作业说明:", "请输入作业分数:"};
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 3);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%s", pwork_node->id);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%s", pwork_node->comments);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%f", &pwork_node->score);
    InitInterface();

    /*存储所属学生作业名称*/
    strcpy (pwork_node->beStu, stu_name);
    /*存储所属课程名称*/
    strcpy (pwork_node->beCourse, course_name);

    return pwork_node;
}

/** \brief AddStuNode:添加指定课程的学生信息结点
 *
 * \param course_name 课程名称
 * \return NULL/独立结点地址值
 *
 */
PSTU_NODE AddStuNode (char * course_name)
{
    PSTU_NODE pstu_node;
    PWORK_NODE work_tail;
    short work_count = 0;
    pstu_node = (PSTU_NODE) malloc (sizeof (STU_NODE));
    /*系统提示语*/
    char * promptInfo[] = {"请输入学生学号:", "请输入学生姓名:", "请输入学生性别(数字)(0-男,1-女,2-其他):",
                           "请输入学生所属班级:", "请输入学生通讯地址:", "请输入该学生作业总数:"
                          };
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 6);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%9s", pstu_node->id);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", pstu_node->name);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%hd", &pstu_node->sexCode);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%9s", pstu_node->beClass);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", pstu_node->address);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%hd", &pstu_node->workAmount);
    InitInterface();

    /*处理性别代码*/
    switch (pstu_node->sexCode)
    {
    case 0:
        strcpy (pstu_node->sex, "男");
        break;

    case 1:
        strcpy (pstu_node->sex, "女");
        break;

    case 2:
        strcpy (pstu_node->sex, "其他");
        break;

    default:
        pstu_node->sexCode = 2, strcpy (pstu_node->sex, "其他");
    }

    /*存储所属课程信息*/
    strcpy (pstu_node->beCourse, course_name);

    /*作业信息链首结点*/
    printf ("\n******************************请输入第%hd个作业信息:******************************", ++work_count);
    pstu_node->wnext = AddWorkNode (course_name, pstu_node->name);
    /*作业信息链后继结点*/
    work_tail = pstu_node->wnext;

    while (work_count < pstu_node->workAmount)
    {
        printf ("\n******************************请输入第%hd个作业信息:******************************", ++work_count);
        work_tail->next = AddWorkNode (course_name, pstu_node->name);
        work_tail = work_tail->next;
    }

    /*作业信息链尾结点*/
    work_tail->next = NULL;
    return pstu_node;
}

/** \brief AddCourseNode:添加一个独立的课程信息结点
 *
 * \param void
 * \return NULL/独立结点地址值
 *
 */
PCOURSE_NODE AddCourseNode (void)
{
    PCOURSE_NODE pcourse_node;
    PSTU_NODE stu_tail;
    short stu_count = 0;
    pcourse_node = (PCOURSE_NODE) malloc (sizeof (COURSE_NODE));
    /*系统提示语*/
    char * promptInfo[] = {"请输入课程编号:", "请输入课程名称:", "请输入学时数:",
                           "请输入授课班级名单(班级名之间不留空格或换行符):", "请输入本课程学生总人数:"
                          };
    /*用户输入区域坐标值*/
    COORD * pos;
    /*显示系统提示信息*/
    pos = PopPrompt (promptInfo, 5);
    /*用户输入*/
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%9s", pcourse_node->id);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%19s", pcourse_node->name);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%hd", &pcourse_node->period);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%29s", pcourse_node->className);
    pos->Y += 2;
    SetConsoleCursorPosition (g_handle_out, *pos);
    scanf ("%hd", &pcourse_node->stuAmount);
    InitInterface();
    /*学生信息链首结点*/
    printf ("\n******************************请输入第%hd个学生信息:******************************", ++stu_count);
    pcourse_node->snext = AddStuNode (pcourse_node->name);
    stu_tail = pcourse_node->snext;

    /*学生信息后继结点*/
    while (stu_count < pcourse_node->stuAmount)
    {
        printf ("\n******************************请输入第%hd个学生信息:******************************", ++stu_count);
        stu_tail->next = AddStuNode (pcourse_node->name);
        stu_tail = stu_tail->next;
    }

    /*学生信息尾结点*/
    stu_tail->next = NULL;
    return pcourse_node;
}

/** \brief PrintAllCourseNode:输出总表
 *
 * \param headp 头指针
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL PrintAllCourseNode (PCOURSE_NODE headp)
{
    /*遍历指针*/
    PCOURSE_NODE course_temp;

    /*遍历输出信息总表*/
    if (headp != NULL)
    {
        for (course_temp = headp; course_temp != NULL; course_temp = course_temp->next)
        {
            PrintCourseNode (course_temp);
            printf ("按下任意键查看更多查询结果:");
            system ("pause");
            InitInterface();
        }

        return TRUE;
    }

    return FALSE;
}

/** \brief PrintWorkNode:打印一个作业信息结点信息
 *
 * \param pwork_node 目标作业信息结点
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL PrintWorkNode (PWORK_NODE pwork_node)
{
    if (pwork_node != NULL)
    {
        printf ("│%-9s│%-17s│%-17s│%-17s│%-8.2f│", pwork_node->id, pwork_node->beCourse, pwork_node->beStu, pwork_node->comments, pwork_node->score);
        return TRUE;
    }

    return FALSE;
}

/** \brief PrintStuNode:打印一个学生信息结点(包括支链)
 *
 * \param pstu_node 目标信息结点
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL PrintStuNode (PSTU_NODE pstu_node)
{
    /*遍历指针*/
    PWORK_NODE work_temp;

    if (pstu_node != NULL)
    {
        printf ("│──────────────────────────────────────│");
        printf ("│学生学号│  学生姓名 │ 性别│所属班级│  所属课程  │  通讯地址  │作业总数│");
        printf ("│%-8s│%-11s│%-5s│%-8s│%-12s│%-12s│%-8hd│", pstu_node->id, pstu_node->name, pstu_node->sex, pstu_node->beClass, pstu_node->beCourse, pstu_node->address, pstu_node->workAmount);
        printf ("│──────────────────────────────────────│");
        printf ("│作业编号 │     所属课程    │     所属学生    │     作业说明    │作业分数│");

        for (work_temp = pstu_node->wnext; work_temp != NULL; work_temp = work_temp->next)
        {
            PrintWorkNode (work_temp);
        }

        return TRUE;
    }

    return FALSE;
}


/** \brief PrintCourseNode:打印一个课程信息结点(包括支链)
 *
 * \param pcourse_node 目标课程结点
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL PrintCourseNode (PCOURSE_NODE pcourse_node)
{
    /*遍历指针*/
    PSTU_NODE stu_temp;
    /*行数计数器*/
    short line_count = 3;

    /*遍历输出信息总表*/
    if (pcourse_node != NULL)
    {
        printf ("│课程编号 │     课程名称     │学时数│学生人数│       授课班级名单        │");
        printf ("│%-9s│%-18s│%-6hd│%-8hd│%-27s│", pcourse_node->id, pcourse_node->name, pcourse_node->period, pcourse_node->stuAmount, pcourse_node->className);

        for (stu_temp = pcourse_node->snext; stu_temp != NULL; stu_temp = stu_temp->next)
        {
            PrintStuNode (stu_temp);
            line_count = line_count + 5 + stu_temp->workAmount;

            if (line_count > 16)
            {
                /*换页操作*/
                line_count = 3;

                if (stu_temp->next != NULL)
                {
                    printf ("按下任意键查看更多查询结果:");
                    system ("pause");
                    InitInterface();
                    printf ("│课程编号 │     课程名称     │学时数│学生人数│       授课班级名单        │");
                    printf ("│%-9s│%-18s│%-6hd│%-8hd│%-27s│", pcourse_node->id, pcourse_node->name, pcourse_node->period, pcourse_node->stuAmount, pcourse_node->className);
                }

            }
        }

        return TRUE;
    }

    return FALSE;
}

/** \brief SaveData:将链表信息存盘
 *
 * \param headp 主链表头指针
 * \return BOOL值
 *
 */
BOOL SaveData (PCOURSE_NODE headp)
{
    PCOURSE_NODE course_temp = headp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    FILE * course_pFile, * stu_pFile, * work_pFile;

    /*以只写二进制文件方式打开三个数据文件*/
    if ( (course_pFile = fopen (g_course_filename, "wb")) == NULL)
    {
        return FALSE;
    }

    if ( (stu_pFile = fopen (g_stu_filename, "wb")) == NULL)
    {
        return FALSE;
    }

    if ( (work_pFile = fopen (g_work_filename, "wb")) == NULL)
    {
        return FALSE;
    }

    /*利用三重循环将数据以二进制方式写入磁盘文件*/
    while (course_temp != NULL)
    {
        fwrite (course_temp, sizeof (COURSE_NODE), 1, course_pFile);
        stu_temp = course_temp->snext;

        while (stu_temp != NULL)
        {
            fwrite (stu_temp, sizeof (STU_NODE), 1, stu_pFile);
            work_temp = stu_temp->wnext;

            while (work_temp != NULL)
            {
                fwrite (work_temp, sizeof (WORK_NODE), 1, work_pFile);
                work_temp = work_temp->next;
            }

            stu_temp = stu_temp->next;
        }

        course_temp = course_temp->next;
    }

    fclose (course_pFile);
    fclose (stu_pFile);
    fclose (work_pFile);
    return TRUE;
}

/** \brief LoadData:从三类二进制文件中读取链表数据
 *
 * \param headp 主链表头指针的地址值
 * \return BOOL值
 *
 */
BOOL LoadData (PCOURSE_NODE * headp)
{
    PCOURSE_NODE head_temp = NULL, course_temp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    FILE * course_pFile, *stu_pFile, *work_pFile;
    int  find = 0;

    /*二进制文件打开失败*/
    if ( (course_pFile = fopen (g_course_filename, "rb")) == NULL)
    {
        return FALSE;
    }

    if ( (stu_pFile = fopen (g_stu_filename, "rb")) == NULL)
    {
        return FALSE;
    }

    if ( (work_pFile = fopen (g_work_filename, "rb")) == NULL)
    {
        return FALSE;
    }

    /*创建主链*/
    while (!feof (course_pFile))
    {
        course_temp = (PCOURSE_NODE) malloc (sizeof (COURSE_NODE));
        fread (course_temp, sizeof (COURSE_NODE), 1, course_pFile);

        /*检查文件尾*/
        if (!feof (course_pFile))
        {
            /*后进先出*/
            course_temp->snext = NULL;
            course_temp->next = head_temp;
            head_temp = course_temp;
        }
    }

    (*headp) = head_temp;

    while (!feof (stu_pFile))
    {
        stu_temp = (PSTU_NODE) malloc (sizeof (STU_NODE));
        fread (stu_temp, sizeof (STU_NODE), 1, stu_pFile);

        /*检查文件尾*/
        if (!feof (stu_pFile))
        {
            course_temp = (*headp);
            stu_temp->wnext = NULL;

            while (course_temp != NULL)
            {
                /*检查该学生是否属于本课程*/
                if (strcmp (course_temp->name, stu_temp->beCourse) == 0)
                {
                    /*后进先出*/
                    stu_temp->next = course_temp->snext;
                    course_temp->snext = stu_temp;
                    break;
                }
                else
                {
                    /*该学生不属于本课程,此支链读取完毕*/
                    course_temp = course_temp->next;
                }
            }
        }
    }

    while (!feof (work_pFile))
    {
        work_temp = (PWORK_NODE) malloc (sizeof (WORK_NODE));
        fread (work_temp, sizeof (WORK_NODE), 1, work_pFile);
        find = 0;

        /*检查文件尾*/
        if (!feof (work_pFile))
        {
            course_temp = (*headp);

            while (course_temp != NULL && find == 0)
            {
                stu_temp = course_temp->snext;

                while (stu_temp != NULL && find == 0)
                {
                    /*该学生有本作业*/
                    if (strcmp (stu_temp->name, work_temp->beStu) == 0 && strcmp (stu_temp->beCourse, work_temp->beCourse) == 0)
                    {
                        find = 1;
                        break;
                    }

                    /*该学生无本作业,此支链读取完毕*/
                    stu_temp = stu_temp->next;
                }

                /*读取下一支链*/
                course_temp = course_temp->next;
            }

            if (find)
            {
                /*后进先出*/
                work_temp->next = stu_temp->wnext;
                stu_temp->wnext = work_temp;
            }
            else
            {
                free (work_temp);
            }
        }
    }

    fclose (course_pFile);
    fclose (stu_pFile);
    fclose (work_pFile);
    return TRUE;
}

/** \brief BackupData:将链表信息备份
 *
 * \param headp 主链表头指针
 * \return BOOL值
 *
 */
BOOL BackupData (PCOURSE_NODE headp)
{
    PCOURSE_NODE course_temp = headp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    FILE * course_pFile, * stu_pFile, * work_pFile;

    /*以只写二进制文件方式打开三个数据文件*/
    if ( (course_pFile = fopen (g_backup_course_filename, "wb")) == NULL)
    {
        return FALSE;
    }

    if ( (stu_pFile = fopen (g_backup_stu_filename, "wb")) == NULL)
    {
        return FALSE;
    }

    if ( (work_pFile = fopen (g_backup_work_filename, "wb")) == NULL)
    {
        return FALSE;
    }

    /*利用三重循环将数据以二进制方式写入磁盘文件*/
    while (course_temp != NULL)
    {
        fwrite (course_temp, sizeof (COURSE_NODE), 1, course_pFile);
        stu_temp = course_temp->snext;

        while (stu_temp != NULL)
        {
            fwrite (stu_temp, sizeof (STU_NODE), 1, stu_pFile);
            work_temp = stu_temp->wnext;

            while (work_temp != NULL)
            {
                fwrite (work_temp, sizeof (WORK_NODE), 1, work_pFile);
                work_temp = work_temp->next;
            }

            stu_temp = stu_temp->next;
        }

        course_temp = course_temp->next;
    }

    fclose (course_pFile);
    fclose (stu_pFile);
    fclose (work_pFile);
    return TRUE;
}

/** \brief RestoreData:从三类备份文件中恢复链表数据
 *
 * \param headp 主链表头指针的地址值
 * \return BOOL值
 *
 */
BOOL RestoreData (PCOURSE_NODE * headp)
{
    PCOURSE_NODE head_temp = NULL, course_temp;
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    FILE * course_pFile, *stu_pFile, *work_pFile;
    int  find = 0;

    /*二进制文件打开失败*/
    if ( (course_pFile = fopen (g_backup_course_filename, "rb")) == NULL)
    {
        return FALSE;
    }

    if ( (stu_pFile = fopen (g_backup_stu_filename, "rb")) == NULL)
    {
        return FALSE;
    }

    if ( (work_pFile = fopen (g_backup_work_filename, "rb")) == NULL)
    {
        return FALSE;
    }

    /*创建主链*/
    while (!feof (course_pFile))
    {
        course_temp = (PCOURSE_NODE) malloc (sizeof (COURSE_NODE));
        fread (course_temp, sizeof (COURSE_NODE), 1, course_pFile);

        /*检查文件尾*/
        if (!feof (course_pFile))
        {
            /*后进先出*/
            course_temp->snext = NULL;
            course_temp->next = head_temp;
            head_temp = course_temp;
        }
    }

    (*headp) = head_temp;

    while (!feof (stu_pFile))
    {
        stu_temp = (PSTU_NODE) malloc (sizeof (STU_NODE));
        fread (stu_temp, sizeof (STU_NODE), 1, stu_pFile);

        /*检查文件尾*/
        if (!feof (stu_pFile))
        {
            course_temp = (*headp);
            stu_temp->wnext = NULL;

            while (course_temp != NULL)
            {
                /*检查该学生是否属于本课程*/
                if (strcmp (course_temp->name, stu_temp->beCourse) == 0)
                {
                    /*后进先出*/
                    stu_temp->next = course_temp->snext;
                    course_temp->snext = stu_temp;
                    break;
                }
                else
                {
                    /*该学生不属于本课程,此支链读取完毕*/
                    course_temp = course_temp->next;
                }
            }
        }
    }

    while (!feof (work_pFile))
    {
        work_temp = (PWORK_NODE) malloc (sizeof (WORK_NODE));
        fread (work_temp, sizeof (WORK_NODE), 1, work_pFile);
        find = 0;

        /*检查文件尾*/
        if (!feof (work_pFile))
        {
            course_temp = (*headp);

            while (course_temp != NULL && find == 0)
            {
                stu_temp = course_temp->snext;

                while (stu_temp != NULL && find == 0)
                {
                    /*该学生有本作业*/
                    if (strcmp (stu_temp->name, work_temp->beStu) == 0 && strcmp (stu_temp->beCourse, work_temp->beCourse) == 0)
                    {
                        find = 1;
                        break;
                    }

                    /*该学生无本作业,此支链读取完毕*/
                    stu_temp = stu_temp->next;
                }

                /*读取下一支链*/
                course_temp = course_temp->next;
            }

            if (find)
            {
                /*后进先出*/
                work_temp->next = stu_temp->wnext;
                stu_temp->wnext = work_temp;
            }
            else
            {
                free (work_temp);
            }
        }
    }

    fclose (course_pFile);
    fclose (stu_pFile);
    fclose (work_pFile);
    return TRUE;
}

/** \brief SeekCourseNode:按编号/名称查找课程信息链结点
 *
 * \param headp 课程信息链头指针
 * \param coruse_info 目标课程信息
 * \return NULL/目标结点的地址值
 */
PCOURSE_NODE SeekCourseNode (PCOURSE_NODE headp, char * course_info)
{
    /*遍历指针*/
    PCOURSE_NODE course_temp;

    for (course_temp = headp; course_temp != NULL; course_temp = course_temp->next)
    {
        if (strcmp (course_temp->id, course_info) == 0 || strcmp (course_temp->name, course_info) == 0)
        {
            return course_temp;
        }
    }

    return NULL;
}

/** \brief SeekStuNode:在指定课程按学号/姓名查找学生信息链结点
 *
 * \param headp 课程信息链头指针
 * \param course_info 目标学生信息
 * \param stu_info 目标学生信息
 * \return NULL/目标点的地址值
 */
PSTU_NODE SeekStuNode (PCOURSE_NODE headp, char * course_info, char * stu_info)
{
    /*遍历指针*/
    PCOURSE_NODE course_temp;
    PSTU_NODE stu_temp;
    /*查找目标课程*/
    course_temp = SeekCourseNode (headp, course_info);

    /*查找目标学生*/
    if (course_temp != NULL)
    {
        for (stu_temp = course_temp->snext; stu_temp != NULL; stu_temp = stu_temp->next)
        {
            if (strcmp (stu_temp->id, stu_info) == 0 || strcmp (stu_temp->name, stu_info) == 0)
            {
                return stu_temp;
            }
        }
    }

    return NULL;
}

/** \brief SeekWorkNode:按作业编号查找作业信息链结点
 *
 * \param headp 课程信息链头指针
 * \param course_info 目标课程信息
 * \param stu_info 目标学生信息
 * \param work_id 目标作业编号
 * \return NULL/目标结点的地址值
 */
PWORK_NODE SeekWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, char * work_id)
{
    /*遍历指针*/
    PSTU_NODE stu_temp;
    PWORK_NODE work_temp;
    /*查找目标*/
    stu_temp = SeekStuNode (headp, course_info, stu_info);

    if (stu_temp != NULL)
    {
        for (work_temp = stu_temp->wnext; work_temp != NULL; work_temp = work_temp->next)
        {
            if (strcmp (work_temp->id, work_id) == 0)
            {
                return work_temp;
            }
        }
    }

    return NULL;
}

/** \brief InsertWorkNode():在目标学生信息结点支链插入作业信息结点
 *
 * \param headp 课程信息头指针
 * \param course_info 目标课程信息
 * \param stu_info 目标学生信息
 * \param new_work_node 待插入作业信息结点
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL InsertWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, PWORK_NODE new_work_node)
{
    /*目标学生信息链结点*/
    PSTU_NODE stu_temp;
    /*查找目标学生信息支链*/
    stu_temp = SeekStuNode (headp, course_info, stu_info);

    /*找到目标学生信息链结点*/
    if (stu_temp != NULL)
    {
        stu_temp->workAmount++;
        new_work_node->next = stu_temp->wnext;
        stu_temp->wnext = new_work_node;
        return TRUE;
    }

    return FALSE;
}

/** \brief InsertStuNode():在目标课程信息结点支链插入学生信息结点
 *
 * \param headp 课程信息头指针
 * \param course_info 目标课程信息
 * \param new_stu_node 待插入学生信息结点
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL InsertStuNode (PCOURSE_NODE headp, char * course_info, PSTU_NODE new_stu_node)
{
    /*目标课程信息链结点*/
    PCOURSE_NODE course_temp;
    /*查找目标课程信息结点*/
    course_temp = SeekCourseNode (headp, course_info);

    /*找到目标课程信息链结点*/
    if (course_temp != NULL)
    {
        course_temp->stuAmount++;
        new_stu_node->next = course_temp->snext;
        course_temp->snext = new_stu_node;
        return TRUE;
    }

    return FALSE;
}

/** \brief InsertCourseNode():插入课程信息结点
 *
 * \param headp 课程信息头指针的地址值
 * \param new_course_node 待插入课程信息结点
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL InsertCourseNode (PCOURSE_NODE * headp, PCOURSE_NODE new_course_node)
{
    if (new_course_node != NULL)
    {
        new_course_node->next = (*headp)->next;
        (*headp)->next = new_course_node;
        return TRUE;
    }

    return FALSE;
}

/** \brief DelWorkNode():删除目标作业结点
 *
 * \param headp 课程信息头指针
 * \param course_info 目标课程信息
 * \param stu_info 目标学生信息
 * \param work_id 目标作业编号
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL DelWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, char * work_id)
{
    /*前继作业结点, 目标作业结点*/
    PWORK_NODE work_prior, work_current;
    /*目标学生信息链结点*/
    PSTU_NODE stu_temp;
    /*查找目标学生信息支链*/
    stu_temp = SeekStuNode (headp, course_info, stu_info);

    /*找到目标学生信息支链*/
    if (stu_temp != NULL)
    {
        work_prior = stu_temp->wnext, work_current = stu_temp->wnext;

        while (work_current != NULL)
        {
            if (strcmp (work_current->id, work_id) == 0)
            {
                break;
            }

            work_prior = work_current;
            work_current = work_current->next;
        }

        if (work_current != NULL)
        {
            stu_temp->workAmount--;

            if (work_current == stu_temp->wnext)
            {
                stu_temp->wnext = work_current->next;
            }
            else
            {
                work_prior->next = work_current->next;
            }

            free (work_current);
            return TRUE;
        }
    }

    return FALSE;
}

/** \brief DelStuNode():删除目标学生结点
 *
 * \param headp 课程信息头指针
 * \param course_info 目标课程信息
 * \param stu_info 目标学生信息
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL DelStuNode (PCOURSE_NODE headp, char * course_info, char * stu_info)
{
    /*前继学生结点, 目标学生结点*/
    PSTU_NODE stu_prior, stu_current;
    /*目标课程信息链结点*/
    PCOURSE_NODE course_temp;
    /*查找目标课程信息结点*/
    course_temp = SeekCourseNode (headp, course_info);

    /*找到目标课程信息链结点*/
    if (course_temp != NULL)
    {
        stu_prior = course_temp->snext, stu_current = course_temp->snext;

        while (stu_current != NULL)
        {
            if (strcmp (stu_current->id, stu_info) == 0 || strcmp (stu_current->name, stu_info) == 0)
            {
                break;
            }

            stu_prior = stu_current;
            stu_current = stu_current->next;
        }

        if (stu_current != NULL)
        {
            course_temp->stuAmount--;

            if (stu_current == course_temp->snext)
            {
                course_temp->snext = stu_current->next;
            }
            else
            {
                stu_prior->next = stu_current->next;
            }

            free (stu_current);
            return TRUE;
        }
    }

    return FALSE;
}

/** \brief DelCourseNode():删除目标课程结点
 *
 * \param headp 课程信息头指针的地址值
 * \param course_info 目标课程信息
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL DelCourseNode (PCOURSE_NODE * headp, char * course_info)
{
    PCOURSE_NODE course_prior = (*headp), course_current = (*headp);

    while (course_current != NULL)
    {
        if (strcmp (course_current->id, course_info) == 0 || strcmp (course_current->name, course_info) == 0)
        {
            break;
        }

        course_prior = course_current;
        course_current = course_current->next;
    }

    if (course_current != NULL)
    {
        if (course_current == (*headp))
        {
            (*headp) = course_current->next;
        }
        else
        {
            course_prior->next = course_current->next;
        }

        free (course_current);
        return TRUE;
    }

    return FALSE;
}



/** \brief ModifyWorkNode:修改目标作业信息结点
 *
 * \param headp 课程信息链头指针
 * \param course_info 目标课程信息
 * \param stu_info 目标学生信息
 * \param work_id 目标作业编号
 * \param new_work_info 新作业信息结点，存放修改值
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL ModifyWorkNode (PCOURSE_NODE headp, char * course_info, char * stu_info, char * work_id, PWORK_NODE new_work_node)
{
    PWORK_NODE work_temp, work_next;
    /*查找目标结点*/
    work_temp = SeekWorkNode (headp, course_info, stu_info, work_id);

    /*找到目标结点,修改之*/
    if (work_temp != NULL)
    {
        work_next = work_temp->next;    /*赋值前保存指针域*/
        *work_temp = *new_work_node;
        work_temp->next = work_next;    /*恢复指向关系*/
        return TRUE;
    }

    return FALSE;
}

/** \brief ModifyStuNode:修改目标学生信息结点
 *
 * \param headp 课程信息链头指针
 * \param course_info 目标课程信息
 * \param stu_info 目标学生信息
 * \param new_stu_info 新学生信息结点，存放修改值
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL ModifyStuNode (PCOURSE_NODE headp, char * course_info, char * stu_info, PSTU_NODE new_stu_node)
{
    PSTU_NODE stu_temp, stu_next;
    /*查找目标学生信息结点*/
    stu_temp = SeekStuNode (headp, course_info, stu_info);

    /*找到目标结点,修改之*/
    if (stu_temp != NULL)
    {
        stu_next = stu_temp->next;    /*赋值前保存指针域*/
        *stu_temp = *new_stu_node;
        stu_temp->next = stu_next;    /*恢复指向关系*/
        return TRUE;
    }

    return FALSE;
}

/** \brief ModifyCourseNode:修改目标课程信息结点
 *
 * \param headp 课程信息链头指针
 * \param course 目标课程信息
 * \param new_course_info 新课程信息结点，存放修改值
 * \return BOOL值:1-成功,0-失败
 *
 */
BOOL ModifyCourseNode (PCOURSE_NODE headp, char * course_info, PCOURSE_NODE new_course_node)
{
    PCOURSE_NODE course_temp, course_next;
    /*查找目标课程信息结点*/
    course_temp = SeekCourseNode (headp, course_info);

    /*找到目标结点,修改之*/
    if (course_temp != NULL)
    {
        course_next = course_temp->next;    /*赋值前保存指针域*/
        *course_temp = *new_course_node;
        course_temp->next = course_next;    /*恢复指向关系*/
        return TRUE;
    }

    return FALSE;
}

/** \brief SortStaCourseNumberNode:对课程统计信息链按作业平均个数降序排列
 *
 * \param headp:链头的地址
 * \return BOOL值
 *
 */
BOOL SortStaCourseNumberNode (PCOURSE_AVERAGE_NODE * headp)
{
    /*循环变量*/
    PCOURSE_AVERAGE_NODE p = *headp;                    /*p:遍历指针*/
    PCOURSE_AVERAGE_NODE p1, p2, prior1, prior2, temp;  /*用于交换指针域(四个遍历指针)*/

    /*冒泡排序,交换指针域*/
    /*单独处理表头,使其为最小项*/
    for (p1 = *headp, p2 = p1->next, prior2 = p1; p2 != NULL; prior2 = p2, p2 = p2->next)
    {
        if (p1->averageNumber < p2->averageNumber)
        {
            prior2->next = p1;
            temp = p1->next;
            p1->next = p2->next;
            (*headp) = p2;
            p2->next = temp;
            p1 = p2;
        }
    }

    if ( (*headp)->next != NULL)
    {
        /*交换后继结点*/
        for (prior1 = *headp, p1 = prior1->next; p1->next != NULL; prior1 = p1, p1 = p1->next)
        {
            for (p2 = p1->next, prior2 = p1; p2 != NULL; prior2 = p2, p2 = p2 ->next)
            {
                if (p1->averageNumber < p2->averageNumber)
                {
                    temp = p2->next;
                    prior1->next = p2;
                    prior2->next = p1;
                    p2->next = p1->next;
                    p1->next = temp;
                    p1 = p2;
                }
            }
        }
    }

}

/** \brief SortStaCourseScoreNode:对课程统计信息链按作业平均分数降序排列
 *
 * \param headp:链头的地址
 * \return BOOL值
 *
 */
BOOL SortStaCourseScoreNode (PCOURSE_AVERAGE_NODE * headp)
{
    /*循环变量*/
    PCOURSE_AVERAGE_NODE p = *headp;                    /*p:遍历指针*/
    PCOURSE_AVERAGE_NODE p1, p2, prior1, prior2, temp;  /*用于交换指针域(四个遍历指针)*/

    /*冒泡排序,交换指针域*/
    /*单独处理表头,使其为最小项*/
    for (p1 = *headp, p2 = p1->next, prior2 = p1; p2 != NULL; prior2 = p2, p2 = p2->next)
    {
        if (p1->averageScore < p2->averageScore)
        {
            prior2->next = p1;
            temp = p1->next;
            p1->next = p2->next;
            (*headp) = p2;
            p2->next = temp;
            p1 = p2;
        }
    }

    if ( (*headp)->next != NULL)
    {
        /*交换后继结点*/
        for (prior1 = *headp, p1 = prior1->next; p1->next != NULL; prior1 = p1, p1 = p1->next)
        {
            for (p2 = p1->next, prior2 = p1; p2 != NULL; prior2 = p2, p2 = p2 ->next)
            {
                if (p1->averageScore < p2->averageScore)
                {
                    temp = p2->next;
                    prior1->next = p2;
                    prior2->next = p1;
                    p2->next = p1->next;
                    p1->next = temp;
                    p1 = p2;
                }
            }
        }
    }

}

/** \brief SortStaStuScoreNode:对学生统计信息链按作业平均分数降序排列
 *
 * \param headp:链头的地址
 * \return BOOL值
 *
 */
BOOL SortStaStuScoreNode (PSTU_AVERAGE_NODE * headp)
{
    /*循环变量*/
    PSTU_AVERAGE_NODE p = *headp;                    /*p:遍历指针*/
    PSTU_AVERAGE_NODE p1, p2, prior1, prior2, temp;  /*用于交换指针域(四个遍历指针)*/

    /*冒泡排序,交换指针域*/
    /*单独处理表头,使其为最小项*/
    for (p1 = *headp, p2 = p1->next, prior2 = p1; p2 != NULL; prior2 = p2, p2 = p2->next)
    {
        if (p1->averageScore < p2->averageScore)
        {
            prior2->next = p1;
            temp = p1->next;
            p1->next = p2->next;
            (*headp) = p2;
            p2->next = temp;
            p1 = p2;
        }
    }

    if ( (*headp)->next != NULL)
    {
        /*交换后继结点*/
        for (prior1 = *headp, p1 = prior1->next; p1->next != NULL; prior1 = p1, p1 = p1->next)
        {
            for (p2 = p1->next, prior2 = p1; p2 != NULL; prior2 = p2, p2 = p2 ->next)
            {
                if (p1->averageScore < p2->averageScore)
                {
                    temp = p2->next;
                    prior1->next = p2;
                    prior2->next = p1;
                    p2->next = p1->next;
                    p1->next = temp;
                    p1 = p2;
                }
            }
        }
    }
}

/** \brief CloseSys:关闭系统
 *
 * \param headp 主链头指针
 * \return
 *
 */
void CloseSys (PCOURSE_NODE headp)
{
    PCOURSE_NODE course_temp = headp, course_temp_after;
    PSTU_NODE stu_temp, stu_temp_after;
    PWORK_NODE work_temp, work_temp_after;

    while (course_temp != NULL) /*释放十字交叉链表的动态存储区*/
    {
        course_temp_after = course_temp->next;
        stu_temp = course_temp->snext;

        while (stu_temp != NULL) /*释放学生基本信息支链的动态存储区*/
        {
            stu_temp_after = stu_temp->next;
            work_temp = stu_temp->wnext;

            while (work_temp != NULL) /*释放缴费信息支链的动态存储区*/
            {
                work_temp_after = work_temp->next;
                free (work_temp);
                work_temp = work_temp_after;
            }

            free (stu_temp);
            stu_temp = stu_temp_after;
        }

        free (course_temp); /*释放主链结点的动态存储区*/
        course_temp = course_temp_after;
    }

    ClearScreen();        /*清屏*/

    /*释放存放菜单条、状态条、性别代码和学生类别代码等信息动态存储区*/
    free (g_buff_menubar_info);
    free (g_buff_stateBar_info);

    /*关闭标准输入和输出设备句柄*/
    CloseHandle (g_handle_out);
    CloseHandle (g_handle_in);

    /*将窗口标题栏置为运行结束*/
    SetConsoleTitle ("Running Out");

    return;
}

/** \brief RunSys:运行系统, 在系统主界面下运行用户所选择的功能模块
 *
 * \param headp 主链头指针的地址
 * \return void
 *
 */
void RunSys (PCOURSE_NODE * headp)
{
    INPUT_RECORD inRec;
    DWORD res;
    COORD pos = {0, 0};
    BOOL bRet = TRUE;
    int i, loc, num;
    int cNo, cAtt;      /*cNo:字符单元层号, cAtt:字符单元属性*/
    char vkc, asc;      /*vkc:虚拟键代码, asc:字符的ASCII码值*/

    while (bRet)
    {
        /*从控制台输入缓冲区中读一条记录*/
        ReadConsoleInput (g_handle_in, &inRec, 1, &res);

        if (inRec.EventType == MOUSE_EVENT)                   /*如果记录由鼠标事件产生*/
        {
            pos = inRec.Event.MouseEvent.dwMousePosition;     /*获取鼠标坐标位置*/
            cNo = g_scr_att[pos.Y * SCR_COL + pos.X] & 3;     /*取该位置的层号*/
            cAtt = g_scr_att[pos.Y * SCR_COL + pos.X] >> 2;   /*取该字符单元属性*/

            if (cNo == 0)                                     /*层号为0，表明该位置未被弹出子菜单覆盖*/
            {
                /* cAtt > 0 表明该位置处于热区(主菜单项字符单元)
                 * cAtt != g_sel_menu 表明该位置的主菜单项未被选中
                 * g_top_layer->LayerNo > 0 表明当前有子菜单弹出
                 */
                if (cAtt > 0 && cAtt != g_sel_menu && g_top_layer->LayerNo > 0)
                {
                    PopOff();                                 /*关闭弹出的子菜单*/
                    g_sel_sub_menu = 0;                       /*将选中子菜单项的项号置为0*/
                    PopMenu (cAtt);                           /*弹出鼠标所在主菜单项对应的子菜单*/
                }
            }
            else
                if (cAtt > 0)                                /*鼠标所在位置为弹出子菜单的菜单项字符单元*/
                {
                    TagSubMenu (cAtt);                            /*标记选中子菜单*/
                }

            if (inRec.Event.MouseEvent.dwButtonState
                    == FROM_LEFT_1ST_BUTTON_PRESSED) /*按下鼠标左键*/
            {
                if (cNo == 0) /*该位置未被弹出子菜单覆盖*/
                {
                    if (cAtt > 0) /*该位置处于热区*/
                    {
                        PopMenu (cAtt);  /*弹出对应子菜单*/
                    }
                    /*该位置已弹出子菜单*/
                    else
                        if (g_top_layer->LayerNo > 0)
                        {
                            PopOff();            /*关闭子菜单*/
                            g_sel_sub_menu = 0;  /*将选中子菜单项的项号置为0*/
                        }
                }
                else /*层号不为0，表明该位置被弹出子菜单覆盖*/
                {
                    if (cAtt > 0) /*如果该位置处于热区(子菜单项字符单元)*/
                    {
                        PopOff(); /*关闭子菜单*/
                        g_sel_sub_menu = 0; /*将选中子菜单项的项号置为0*/

                        /*执行对应功能函数:g_sel_menu主菜单项号,cAtt子菜单项号*/
                        bRet = ExeFunction (g_sel_menu, cAtt);
                    }
                }
            }
            else
                if (inRec.Event.MouseEvent.dwButtonState
                        == RIGHTMOST_BUTTON_PRESSED) /*按下鼠标右键*/
                {
                    if (cNo == 0) /*该位置未被弹出子菜单覆盖*/
                    {
                        PopOff();            /*关闭子菜单*/
                        g_sel_sub_menu = 0; /*将选中子菜单项的项号置为0*/
                    }
                }
        }
        else
            if (inRec.EventType == KEY_EVENT  /*如果记录由按键产生*/
                    && inRec.Event.KeyEvent.bKeyDown) /*且键被按下*/
            {
                vkc = inRec.Event.KeyEvent.wVirtualKeyCode; /*获取按键的虚拟键码*/
                asc = inRec.Event.KeyEvent.uChar.AsciiChar; /*获取按键的ASC码*/

                /*系统快捷键的处理*/
                if (vkc == 112) /*如果按下F1键*/
                {
                    if (g_top_layer->LayerNo != 0) /*当前有子菜单弹出*/
                    {
                        PopOff();            /*关闭子菜单*/
                        g_sel_sub_menu = 0; /*将选中子菜单项的项号置为0*/
                    }

                    bRet = ExeFunction (5, 1); /*运行帮助主题功能函数*/
                }
                else
                    if (inRec.Event.KeyEvent.dwControlKeyState
                            & (LEFT_ALT_PRESSED | RIGHT_ALT_PRESSED))
                    {
                        /*如果按下左或右Alt键*/
                        switch (vkc)  /*判断组合键Alt+字母*/
                        {
                        case 88:  /*Alt+X 退出*/
                            if (g_top_layer->LayerNo != 0)
                            {
                                PopOff();
                                g_sel_sub_menu = 0;
                            }

                            bRet = ExeFunction (1, 4);
                            break;

                        case 70:  /*Alt+F*/
                            PopMenu (1);
                            break;

                        case 77: /*Alt+M*/
                            PopMenu (2);
                            break;

                        case 81: /*Alt+Q*/
                            PopMenu (3);
                            break;

                        case 83: /*Alt+S*/
                            PopMenu (4);
                            break;

                        case 72: /*Alt+H*/
                            PopMenu (5);
                            break;
                        }
                    }
                    else
                        if (asc == 0) /*其他控制键的处理*/
                        {
                            if (g_top_layer->LayerNo == 0) /*如果未弹出子菜单*/
                            {
                                switch (vkc) /*处理方向键(左、右、下)，不响应其他控制键*/
                                {
                                /*左*/
                                case 37:
                                    g_sel_menu--;

                                    if (g_sel_menu < 1)
                                    {
                                        g_sel_menu = g_main_menu_count;
                                    }

                                    TagMainMenu (g_sel_menu);
                                    break;

                                /*右*/
                                case 39:
                                    g_sel_menu++;

                                    if (g_sel_menu > g_main_menu_count)
                                    {
                                        g_sel_menu = 1;
                                    }

                                    TagMainMenu (g_sel_menu);
                                    break;

                                /*下*/
                                case 40:
                                    PopMenu (g_sel_menu);
                                    TagSubMenu (1);
                                    break;
                                }
                            }
                            else  /*已弹出子菜单时*/
                            {
                                for (loc = 0, i = 1; i < g_sel_menu; i++)
                                {
                                    loc += g_sub_menu_count[i - 1];
                                }  /*计算该子菜单位置(下标)*/

                                switch (vkc) /*方向键(左、右、上、下)的处理*/
                                {
                                case 37:
                                    g_sel_menu--;

                                    if (g_sel_menu < 1)
                                    {
                                        g_sel_menu = g_main_menu_count;
                                    }

                                    TagMainMenu (g_sel_menu);
                                    PopOff();
                                    PopMenu (g_sel_menu);
                                    TagSubMenu (1);
                                    break;

                                case 38:
                                    num = g_sel_sub_menu - 1;

                                    if (num < 1)
                                    {
                                        num = g_sub_menu_count[g_sel_menu - 1];
                                    }

                                    if (strlen (g_sub_menu[loc + num - 1]) == 0)
                                    {
                                        num--;
                                    }

                                    TagSubMenu (num);
                                    break;

                                case 39:
                                    g_sel_menu++;

                                    if (g_sel_menu > g_main_menu_count)
                                    {
                                        g_sel_menu = 1;
                                    }

                                    TagMainMenu (g_sel_menu);
                                    PopOff();
                                    PopMenu (g_sel_menu);
                                    TagSubMenu (1);
                                    break;

                                case 40:
                                    num = g_sel_sub_menu + 1;

                                    if (num > g_sub_menu_count[g_sel_menu - 1])
                                    {
                                        num = 1;
                                    }

                                    if (strlen (g_sub_menu[loc + num - 1]) == 0)
                                    {
                                        num++;
                                    }

                                    TagSubMenu (num);
                                    break;
                                }
                            }
                        }
                        else
                            if ( (asc - vkc == 0) || (asc - vkc == 32)) /*按下普通键*/
                            {
                                if (g_top_layer->LayerNo == 0)            /*未弹出子菜单时*/
                                {
                                    switch (vkc)
                                    {
                                    case 13: /*回车*/
                                        PopMenu (g_sel_menu);
                                        TagSubMenu (1);
                                        break;
                                    }
                                }
                                else /*已弹出子菜单时*/
                                {
                                    if (vkc == 27) /*按下ESC键*/
                                    {
                                        PopOff();
                                        g_sel_sub_menu = 0;
                                    }
                                    else
                                        if (vkc == 13) /*按下回车键*/
                                        {
                                            num = g_sel_sub_menu;
                                            PopOff();
                                            g_sel_sub_menu = 0;
                                            bRet = ExeFunction (g_sel_menu, num);
                                        }
                                        else /*其他普通键的处理*/
                                        {
                                            /*计算该子菜单位置(下标)*/
                                            for (loc = 0, i = 1; i < g_sel_menu; i++)
                                            {
                                                loc += g_sub_menu_count[i - 1];
                                            }

                                            /*比较每项子菜单代表字符*/
                                            for (i = loc; i < loc + g_sub_menu_count[g_sel_menu - 1]; i++)
                                            {
                                                if (strlen (g_sub_menu[i]) > 0 && vkc == g_sub_menu[i][1])
                                                {
                                                    /*匹配成功*/
                                                    PopOff();
                                                    g_sel_sub_menu = 0;
                                                    bRet = ExeFunction (g_sel_menu, i - loc + 1);
                                                }
                                            }
                                        }
                                }
                            }
            }
    }
}
