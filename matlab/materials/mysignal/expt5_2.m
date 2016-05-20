function expt5_2(action)
% EXPT5_2 Run the second subtopic in experiment5
% 
% Type "expt5_2" at the command line to browse the experiment.
% With the optional parameter
% EXPT5_2 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='差分方程求解';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H0=gcf;
   H=get(gcf,'userdata');
   a=str2num(get(H(2,1),'string'));
   b=str2num(get(H(2,2),'string'));
   k=str2num(get(H(2,4),'string'));
   if isempty(k)
      errordlg({'输出样点数不能为空' '请输入希望输出的样点数'},name)
      return
   end
   if isempty(a)
      errordlg({'差分方程系数向量 a 不能为空' '请输入差分方程系数a'},name)
      return
   end
   if isempty(b)
      errordlg({'差分方程系数向量 b 不能为空' '请输入差分方程系数b'},name)
      return
   end
   zi=str2num(get(H(2,3),'string'));
   N=max(length(a),length(b))-1;
   if isempty(zi)
      flag=questdlg({'初始状态 Yzi 输入为空' '将按照初始状态为零进行计算'},name)
      switch flag
      case 'Yes'
         zi=zeros(1,N);
      otherwise
         return
      end
   elseif length(zi)<N
      errordlg({'输入初始状态错误' '请输入 N 个初始条件' '若无初始条件则默认为零状态'},name)
      return
   end
   yzi=[0*ones(1,k+N+1)];
   h=yzi;
   yzs=yzi;
   for n=1:N
      yzi(n)=zi(N-n+1);
   end
   y=yzi;
   n=[-N:k];
   x=impseq(0,-N,k);
   try
      h(N+1:end)=filter(b,a,x(N+1:end));
   catch
      errordlg({'输入系数不满足构造滤波器的条件' '请重新输入系数或用迭代法求解'},name)
      return
   end
   x=stepseq(0,-N,k);
   try
      zic=filtic(b,a,zi);
      yzs(N+1:end)=filter(b,a,x(N+1:end));
      yzi(N+1:end)=filter([0*length(b)],a,x(N+1:end),zic);
      y(N+1:end)=filter(b,a,x(N+1:end),zic);
   catch
      errordlg({'输入系数不满足构造滤波器的条件' '请重新输入系数或用迭代法求解'},name)
      return
   end
   subplot(H(3,1))
   cla
   stem(n,x)
	title('激励 x(n)');
   subplot(H(3,2))
   cla
   stem(n,h)
	title('冲激响应 h(n)');
   subplot(H(3,3))
   cla
   hold on
   stem(n,yzs,'g')
   stem(n,yzi,'r')
   stem(n,y)
   legend('yzs','yzs','yzi','yzi','y','y')
	title('输出响应 y(n)');
   hold off
   text={...
      ''
      '  单位冲激响应 h='
      ''
      [' '*ones(1,12),num2str(h)]
      ''
      '  零状态响应 yzs='
      ''
      [' '*ones(1,12),num2str(yzs)]
      ''
      '  零输入响应 yzi='
      ''
      [' '*ones(1,12),num2str(yzi)]
      ''
      '  全响应 y='
      ''
      [' '*ones(1,12),num2str(y)]
      ''};
   textwin('差分方程数值解',text)


case 'runhelp'
   help5_2
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验五  离散时间系统的时域分析——差分方程求解');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_ktext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.85 0.1 0.04],...
   'string','输出点数 k=');
H_kedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.9 0.86 0.04 0.04],...
   'horizontal','left');
H_atext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.75 0.14 0.04],...
   'string','请输入 a(0)~a(N)',...
   'Tag','XText');
H_aedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.71 0.14 0.04],...
   'horizontal','left');
H_btext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.6 0.14 0.04],...
   'string','请输入 b(0)~b(N)',...
   'Tag','XText');
H_bedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.56 0.14 0.04],...
   'horizontal','left');
H_itext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.45 0.14 0.04],...
   'string','请输入 Yzi(N个)',...
   'Tag','XText');
H_iedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.41 0.14 0.04],...
   'horizontal','left');


H_x=axes('Position',[0.05 0.7 0.68 0.2]);
title('激励 x(n)');
H_h=axes('Position',[0.05 0.4 0.68 0.2]);
title('冲激响应 h(n)');
H_y=axes('Position',[0.05 0.1 0.68 0.2]);
title('输出响应 y(n)');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt5_2 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt5_2 runhelp');

set(gcf,'userdata',[H_atext,H_btext,H_itext,H_ktext;...
   H_aedit,H_bedit,H_iedit,H_kedit;...
   H_x,H_h,H_y,0]);

% set callback

%===============================
function help5_2
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(5,2).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(5,2).helptext);
