function expt2_1(action)
% EXPT2_1 Run the first subtopic in experiment2
% 
% Type "expt2_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT2_1 draw the specified curve out.
%

if nargin<1,
   action='start';
end
% run the experiment
name='周期信号的频谱分析';
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   hpop=get(H(1,1),'value')-1;
   if hpop==0
      errordlg('请选择一种周期信号形式',name)
      return
   end
   T=str2num(get(H(1,2),'string'));
   N=str2num(get(H(1,3),'string'));
   if isempty(T)|isempty(N)
      errordlg({'参数项不能为空' '请输入合适的参数'},name)
      return
   elseif T==0|N==0
      errordlg({'参数不可为零' '请输入合适的参数'},name)
      return
   end
   y=Timefun(hpop,T);
   [f,a]=mycal(y,T,N);
   n=-N:N;
   as=abs(a)*2;
   subplot(H(2,1))
   ezplot(y,[-T,T])
   title('原函数');
   subplot(H(2,2))
   ezplot(f,[-T,T])
   title('合成函数');
   subplot(H(2,3))
   stem(n,as)
	title('幅度频谱图');
case 'runhelp'
   help2_1
   
end %switch

%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验二  信号的Fourier分析——周期信号的频谱分析');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_popup=uicontrol(H0,'style','popup',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'fontsize',10,...
	'position',[0.8 0.85 0.14 0.04],...
   'string','请选择周期信号|矩形脉冲|半余弦脉冲|锯齿波|方波');
H_Ttext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.75 0.09 0.04],...
   'string','基波周期 T=',...
   'horizontal','right');
H_Tedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.895 0.76 0.045 0.04],...
   'horizontal','left');
H_ntext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.7 0.09 0.04],...
   'string','谐波次数 N=',...
   'horizontal','right');
H_nedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.895 0.71 0.045 0.04],...
   'horizontal','left');

H_ft=axes('Position',[0.05 0.7 0.68 0.2]);
title('原函数');
H_fn=axes('Position',[0.05 0.4 0.68 0.2]);
title('合成函数');
H_mg=axes('Position',[0.05 0.1 0.68 0.2]);
title('幅度频谱图');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt2_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt2_1 runhelp');

set(gcf,'userdata',[H_popup,H_Tedit,H_nedit;H_ft,H_fn,H_mg]);

% set callback


%===============================
function help2_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(2,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(2,1).helptext);

%=================================
function [f,a]=mycal(y,T,N)
%=================================
syms t k;
A0=int(y,t,-T/2,T/2)/T;
Ak=int(y*exp(-2*i*pi*k*t/T),t,-T/2,T/2)/T;
fk=symmul(Ak,sym(exp(2*i*k*pi*t/T)));
for m=-N:-1
   a(m+N+1)=numeric(subs(Ak,k,m));
end
a(N+1)=numeric(A0);
for m=1:N
   a(m+N+1)=numeric(subs(Ak,k,m));
end
f=symsum(fk,k,-N,-1)+A0+symsum(fk,k,1,N);
%==================================
function y=Timefun(hpop,T)
%==================================
syms t;
switch hpop
case 1
   yt=subs(sym('Heaviside(t+T/10)-Heaviside(t-T/10)'),'T',T);
   y=yt;
case 2
   yt=subs(sym('(cos(pi*t*5/T))*(Heaviside(t+T/10)-Heaviside(t-T/10))'),'T',T);
   y=yt;
case 3
   yt=subs(sym('(2*(t)/T)*(Heaviside(t)-Heaviside(t-T/2))'),'T',T);
   y=-subs(yt,t,t+T/2)+yt;
case 4
   yt=subs(sym('Heaviside(t)-Heaviside(t-T/2+0.02)'),'T',T);
   y=-subs(yt,t,t+T/2)+yt;
end

