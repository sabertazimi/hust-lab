function expt1_1(action)
% EXPT1_1 Run the first subtopic in experiment1
% 
% Type "expt1_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT1_1 draw the specified curve out.
%

if nargin<1,
   action='start';
end
T=0.01;
name='卷积计算';
% run the experiment
switch action
   
case 'start'
   frame
case 'xpopup'
   H=get(gcf,'userdata');
   value=get(H(1,1),'value')-1;
   set(H(2,1),'string','参数a');
   set(H(2,2),'string','参数b');
   set(H(2,3),'string','');
   set(H(2,4),'string','');
   if value==0|value>4
      errordlg('请选择合适的输入激励函数 x(t)',name)
      return
   end
   text={'a=','b=';'a=','b=';'center=','width=';'center=','width='};
   set(H(2,1),'string',text(value,1));
   set(H(2,2),'string',text(value,2));
case 'hpopup'
   H=get(gcf,'userdata');
   value=get(H(1,2),'value')-1;
   set(H(3,1),'string','参数a');
   set(H(3,2),'string','参数b');
   set(H(3,3),'string','');
   set(H(3,4),'string','');
   if value==0|value>4
      errordlg('请选择合适的冲激响应 h(t)',name)
      return
   end
   text={'a=','b=';'a=','b=';'center=','width=';'center=','width='};
   set(H(3,1),'string',text(value,1));
   set(H(3,2),'string',text(value,2));
case 'runexpt'
   H=get(gcf,'userdata');
   xpop=get(H(1,1),'value');
   xpop=xpop-1;
   hpop=get(H(1,2),'value');
   hpop=hpop-1;
   if xpop==0|xpop>4
      errordlg('请选择合适的输入激励函数 x(t)',name)
      return
   end
   if hpop==0|hpop>4
      errordlg('请选择合适的单位冲激响应 h(t)',name)
      return
   end
   xa=str2num(get(H(2,3),'string'));
   xb=str2num(get(H(2,4),'string'));
   ha=str2num(get(H(3,3),'string'));
   hb=str2num(get(H(3,4),'string'));
   if isempty(xa)|isempty(xb)|isempty(ha)|isempty(hb)
      errordlg({'参数项不能为空' '请输入适当的参数'},name)
      return
   end
   [tx1,tx2,x]=myimp(xpop,xa,xb);
   [th1,th2,h]=myimp(hpop,ha,hb);
   t1=tx1+th1;
   t2=tx2+th2;
   t=t1:T:t2;
   if hpop==1|xpop==1
      y=conv(x,h);
   else
      y=T*conv(x,h);
   end
   if xpop==2|hpop==2
      t2=tx2+th1;
      t=t1:T:t2;
      n=length(t);
      y=y(1:n);
   end
   tx=tx1:T:tx2;
   subplot(H(4,1));
   plot(tx,x);
   title('输入激励 x(t)');
   th=th1:T:th2;
   subplot(H(4,2));
   plot(th,h)
	title('单位冲激响应 h(t)');
   subplot(H(4,3));
   plot(t,y)
   title('输出响应 y(t)');
case 'runhelp'
   help1_1
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验一  连续时间系统的时域分析——卷积计算');
% set the control frame
H_c=findobj(gcf,'Tag','Control');
text={'Delta(at-b)'
   'U(at-b)'
   'Triangle(center,width)'
   'Gate(center,width)'};
H_xpopup=uicontrol(H0,'style','popup',...
   'unit','normalized',...
   'BackgroundColor',[1 1 1],...
   'fontsize',10,...
   'max',2,...
   'position',[0.8 0.85 0.14 0.05],...
   'string',[{'输入激励 x(t)'};text],...
   'Tag','XPopup');
H_xatext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
	'position',[0.8 0.8 0.065 0.04],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数a');
H_xaedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.81 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');
H_xbtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.75 0.065 0.04],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数b');
H_xbedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.76 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');

H_hpopup=uicontrol(H0,'style','popup',...
   'unit','normalized',...
   'BackgroundColor',[1 1 1],...
	'max',2,...
	'position',[0.8 0.6 0.14 0.05],...
   'fontsize',10,...
   'string',[{'单位冲激响应 h(t)'};text],...
   'tag','HPopup');
H_hatext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.55 0.065 0.04],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数a');
H_haedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.56 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');
H_hbtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.5 0.065 0.04],...
   'horizontal','right',...
   'fontsize',10,...
   'string','参数b');
H_hbedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.51 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');

H_x=axes('Position',[0.05 0.7 0.68 0.2]);
title('输入激励 x(t)');
H_h=axes('Position',[0.05 0.4 0.68 0.2]);
title('单位冲激响应 h(t)');
H_y=axes('Position',[0.05 0.1 0.68 0.2]);
title('输出响应 y(t)');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt1_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_xpopup,'callback','expt1_1 xpopup');
set(H_hpopup,'callback','expt1_1 hpopup');
set(H_help,'callback','expt1_1 runhelp');

set(gcf,'userdata',[H_xpopup,H_hpopup,0,0 ;...
      H_xatext,H_xbtext,H_xaedit,H_xbedit;...
      H_hatext,H_hbtext,H_haedit,H_hbedit;...
      H_x,H_h,H_y,0]);

%===============================
function help1_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(1,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(1,1).helptext);


%================================
function [t1,t2,f]=myimp(n,a,b)
%================================
name='卷积计算';
T=0.01;
switch n
case 1
   t0=b/a;
   t1=t0-1;
   t2=t0+4;
   t=t1:T:t2;
   f=((a.*t-b)==0);
case 2
   t0=b/a;
   t1=t0-1;
   t2=t0+10;
   t=t1:T:t2;
   f=((a.*t-b)>0);
case 3
   if b==0
      errordlg('波形宽度不能为零',name)
      return
   end
   t0=b/2;
   t1=a-t0;
   t2=a+t0;
   t=t1:T:t2;
   f=tripuls((t-a),b);
case 4
   if b==0
      errordlg('波形宽度不能为零',name)
      return
   end
   t0=b/2;
   t1=a-t0;
   t2=a+t0;
   t=t1:T:t2;
	f=rectpuls((t-a),b);
end   


