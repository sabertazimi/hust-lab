function expt1_2(action)
% EXPT1_2 Run the second subtopic in experiment1
% 
% Type "expt1_2" at the command line to browse the experiment.
% With the optional parameter
% EXPT1_2 draw the specified figure out.
%
%

if nargin<1,
   action='start';
end
% run the experiment
name='微分方程求解';
switch action
   
case 'start'
   frame
case 'inpopup'
   H=get(gcf,'userdata');
   value=get(H(1,1),'value')-1;
   if value<3&value>0
      set(H(2,1),'string','a=');
      set(H(2,2),'Enable','off');
      set(H(2,2),'string','参数b');
	elseif value==3
      set(H(2,1),'string','a=');
      set(H(2,2),'Enable','on');
      set(H(2,2),'string','w=');
   elseif value==0
      set(H(2,1),'string','参数a');
      set(H(2,2),'Enable','on');
      set(H(2,2),'string','参数b');
      errordlg('请选择合适的激励电压源形式',name)
      return
   end
   
case 'lcpopup'
   H=get(gcf,'userdata');
   value=get(H(1,2),'value')-1;
   if value==0
      set(H(3,1),'string','参数R');
      set(H(3,2),'string','参数Lc');
      set(H(3,3),'string','初始态');
      errordlg('请选择一种电路组成形态',name)
      return
   elseif value==1
      set(H(3,1),'string','R=');
      set(H(3,2),'string','L=');
      set(H(3,3),'string','I(0)=');
      set(H(1,5),'string','L(di(t)/dt)+Ri(t)=E');
   elseif value==2
      set(H(3,1),'string','R=');
      set(H(3,2),'string','C=');
      set(H(3,3),'string','U(0)=');
   	set(H(1,5),'string','RC(du(t)/dt)+u(t)=E');
   end
   
case 'runexpt'
   H=get(gcf,'userdata');
   inpop=get(H(1,1),'value')-1;
   lcpop=get(H(1,2),'value')-1;
   a=get(H(2,3),'string');
   b=get(H(2,4),'string');
   r=get(H(3,4),'string');
   lc=get(H(3,5),'string');
   iu=get(H(3,6),'string');
   if isempty(a)|isempty(r)|isempty(r)|isempty(lc)|isempty(iu)|(inpop==3&isempty(b))
      errordlg({'参数项不能为空' '请输入合适的系统参数'},name)
      return
   end
   [in,E]=getfunc(inpop,a,b);
   subplot(H(1,3));
   ezplot(in,[0,2*pi])
   %axis([0,4*pi,-1,str2num(iu)+0.5])
   xlabel('t')
   intext(1,1:5+length(a))=[char(a),'*u(t)'];
   intext(2,1:12+length(a))=['exp(-',char(a),'t)*u(t)'];
   if ~isempty(b)
      intext(3,1:12+length(a)+length(b))=[char(a),'*sin(',char(b),'t)*u(t)'];
   end
      
   %intext=[char(a),'*u(t)         ';'exp(-',char(a),'t)*u(t)  ';char(a),'*sin(',char(b),'t)*u(t) '];

   outtext=['i(t)';'u(t)'];
   title(['激励电压源 ',intext(inpop,:)]);
   switch lcpop
   case 1
      ss=[lc,'*Dy+',r,'*y=',E];
      init=['y(0)=',iu];
      y=dsolve(ss,init,'t');
   case 2
      ss=[r,'*',lc,'*Dy+y=',E];
      init=['y(0)=',iu];
      y=dsolve(ss,init,'t');
   end
   subplot(H(1,4))
   ezplot(y,[0,2*pi])
   %axis([0,4*pi,-1,str2num(iu)+0.5])
   xlabel('t')
	title(['输出响应 ',outtext(lcpop,:)]);

case 'runhelp'
   help1_2
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验一  连续时间系统的时域分析——微分方程求解');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_inpopup=uicontrol(H0,'style','popup',...
   'backgroundcolor',[1 1 1],...
	'unit','normalized',...
   'position',[0.8 0.85 0.14 0.05],...
   'fontsize',10,...
   'max',2,...
   'string','请选择激励电压源的形式|阶跃信号a*u(t)|指数信号e^(-at)*u(t)|正弦信号asin(wt)*u(t)',...
   'Tag','InPopup');
H_atext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
	'position',[0.8 0.8 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数a');
H_aedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.81 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');
H_btext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.75 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数b');
H_bedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.76 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');

H_lcpopup=uicontrol(H0,'style','popup',...
   'backgroundcolor',[1 1 1],...
	'unit','normalized',...
	'position',[0.8 0.6 0.14 0.05],...
   'fontsize',10,...
   'max',2,...
   'string','请选择电路组成形式|一阶RL电路|一阶RC电路',...
   'tag','LcPopup');
H_rtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.55 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数R');
H_redit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.56 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');
H_lctext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.5 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数LC');
H_lcedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'fontsize',10,...
   'position',[0.87 0.51 0.07 0.04],...
   'horizontal','left');
H_iutext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.45 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','初始态');
H_iuedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.46 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');

H_text=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.8 0.8 0.8],...
   'fontsize',20,...
   'unit','normalized',...
   'position',[0.05 0.77 0.65 0.15],...
   'horizontal','center');
H_in=axes('position',[0.05 0.1 0.3 0.6]);
title('输入激励');
H_lc=axes('position',[0.4 0.1 0.3 0.6]);
title('输出响应');
set(gcf,'userdata',[H_inpopup,H_lcpopup,H_in,H_lc,H_text,0;...
      H_atext,H_btext,H_aedit,H_bedit,0,0;...
      H_rtext,H_lctext,H_iutext,H_redit,H_lcedit,H_iuedit]);

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt1_2 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_inpopup,'callback','expt1_2 inpopup');
set(H_lcpopup,'callback','expt1_2 lcpopup');
set(H_help,'callback','expt1_2 runhelp');



% pulse
%===============================
function help1_2
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(1,2).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(1,2).helptext);

%==============================
function [f,E]=getfunc(n,a,b)
%==============================
syms ca cb;
aa=str2num(a);
bb=str2num(b);
switch n
case 1
   f=sym('ca*Heaviside(t)');
   f=subs(f,ca,aa);
   E=[a,'*Heaviside(t)'];
case 2
   f=sym('exp(-ca*t)*Heaviside(t)');
   f=subs(f,ca,aa);
   E=['exp(-',a,'*t)*Heaviside(t)'];
case 3
   f=sym('ca*sin(cb*t)*Heaviside(t)');
   f=subs(f,ca,aa);
   f=subs(f,cb,bb);
   E=[a,'*sin(',b,'*t)*Heaviside(t)'];
end


