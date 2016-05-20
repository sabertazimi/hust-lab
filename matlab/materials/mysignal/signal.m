function signal(action)
% SIGNAL run the experiment system. 
%
%   Type "signal" at the command line to browse available experiments.
%
%   With the optional menu argument 
%   SIGNAL opens the subtopic screen to the specified experiment.
%
%   With the optional experiment argument, 
%   SIGNAL opens to the specified experiment.
%
%


if nargin<1,
   action = 'start';
else
   action = lower(action);
end

load workdata;

% 
switch action
% 'START' initial the window
case 'start'
   frame
   H=get(gcf,'userdata');   % get handles of unicontrols in the window
   set(H(4),'callback','signal runhelp');
   set(H(5),'callback','signal runexpt');
	menutext=data.menu;
	set(H(1),'String',menutext);
	set(H(1),'value',1);
	menuvalue=get(H(1),'value');
	abouttext=data.about(menuvalue).text;
	runtext=data.run(menuvalue).text;
	set(H(3),'String',runtext);
	set(H(2),'String',abouttext);
	set(H(3),'value',1);
   runvalue=get(H(3),'value');
   
% 'SHOWLIST' show the list of experiments
case 'showlist'
   H=get(gcf,'userdata');
   menuvalue=get(H(1),'value');
	set(H(3),'value',1);
	abouttext=data.about(menuvalue).text;
	runtext=data.run(menuvalue).text;
	set(H(3),'String',runtext);
	set(H(2),'String',abouttext);
	runvalue=get(H(3),'value');
   
% 'RUNEXPT' run the specified experiment   
case 'runexpt'
   H=get(gcf,'userdata');
	menuvalue=get(H(1),'value');
	runvalue=get(H(3),'value');
	eval(expt{menuvalue,runvalue})   
   
% 'RUNHELP' show the text of how to use this system  
case 'runhelp'
      s_help
     
end % switch

% ==========================================
function frame
% this function initialize the window
% =========================================
window0;
set(findobj(gcf,'Tag','Window0'),'Name','信号与系统实验2.0版');
H_menu=findobj(gcf,'Tag','MenuList');
H_about=findobj(gcf,'Tag','AboutList');
H_expt=findobj(gcf,'Tag','RunList');
H_help=findobj(gcf,'Tag','RunHelp');
H_run=findobj(gcf,'Tag','RunExpt');
set(gcf,'userdata',[H_menu,H_about,H_expt,H_help,H_run])
axis off
I=imread('.\mysignal\title0.jpg');
imshow(I);

% ==========================================
function s_help
% this function show the help text
% ==========================================
text={...
   ''
   ' 《信号与线性系统》是电子与通信类专业的主要技术基础课之一，'
   ' 本课程的主要任务在于研究信号与系统理论的基本概念和基本分析方法，'
   ' 使学生初步认识如何建立信号与系统的数学模型，如何经适当的数学分析求解，'
   ' 并对所得结果给予物理解释，赋予物理意义。'
   ' “信号与线性实验系统”既可直接直接作为信号处理的程序库，'
   ' 又可作为实验演示，还可让学生参与编程。'
   ' 下面介绍本实验系统的主要内容和使用方法。'
   ' 本系统共包括十个实验，包括：'
   ' 信号的分析、卷积计算、'
   ' 连续时间系统和离散时间系统的时域分析、'
   ' 频域分析、变换域分析、'
   ' 状态变量分析、稳定性分析等，'
   ' 基本覆盖了信号与线性系统理论的主要内容。'
   ' '
   ' '
   ' 1. 安装本实验系统'
   '    本实验系统只能在 MATLAB 环境下运行，'
   '    所以要求必须先安装 MATLAB5.3 以上版本的 MATLAB 软件。'
   '    然后运行本软件的安装程序 SetupEx.exe，按照提示输入信息即可。'
   ' '
   ' 2. 运行本实验系统'
   '    在 MATLAB 命令窗口下，键入启动命令 start，回车后'
   '    即可运行本实验系统，进入主实验界面。'
   ' '
   ' 3. 本实验系统的操作'
   '    本实验系统的主实验界面由三个窗口组成：'
	'          主实验列表窗口： 位于界面左边，列出本实验系统的实验主题列表，共有十个实验；'
   '           实验目的窗口： 列出选中实验主题的实验目的；'
   '          分实验列表窗口： 列出选中实验主题下设的分实验。'
   '    实验步骤：'
   '        i  利用鼠标在左边的主实验列表中选择将要进行的实验主题，'
   '           鼠标左键点击确认，同时可以在实验目的窗口看到该实验主题的实验目的；'
   '       ii  利用鼠标在右下方的分实验列表中选择将要进行的具体实验内容，'
   '           鼠标左键点击确认，进入选定的实验界面。'
   ' '
   '    各实验界面都具有较好的人机交互界面，'
   '    实验者可查询各个实验的帮助文档，了解各个实验的具体使用方法。'
   ' '
   ' 4. 关闭本实验系统'
   '    鼠标左键单击界面关闭按钮，关闭实验。'
   ' '
   ' 注意：'
   '    1. 为了提高实验者编程能力，本系统所有实验的主程序都在帮助文档中给出，'
   '       实验者可参照文档自行进行设计性实验；'
   '    2. 所有在帮助文档中出现的设计脚本文件均可在 MATLAB 命令窗口下直接运行，'
   '       脚本文件存放在 mydesign 文件夹中，可以用 open *.m 命令在编辑器中打开；'
   '    3. 编写设计性实验要求使用者掌握一定的 MATLAB 基础编程技巧，'
   '       请参阅光盘上 Help word 文档；'
   '    4. 由于 MATLAB 命令行不能识别中文命令，请不要使用中文文件名，'
   '       另外在编辑器中也无法正常看到以中文形式输入的内容，请先打开中文输入法，'
   '       然后再打开所要察看的文件，即可正常阅读。'
   '       或者使用 WORD 打开 *.m 文件，但是需要安装 notebook。'
   '       安装方法：在命令窗口输入 notebook -setup。'
   ' '
   ' '
	' '};
myhelp
set(gcf,'Name','帮助：信号与线性系统实验');
set(findobj(gcf,'Tag','HelpList'),'String',text);
