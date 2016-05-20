function expt9_1(action)
% EXPT9_1 Run the first subtopic in experiment9
% 
% Type "expt9_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT9_1 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='DFT计算';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   N=str2num(get(H(1,2),'string'));
   if isempty(N)|N==0
      errordlg({'取样点数不能为空或为零' '请输入采样点数'},name)
      return
   end
   ct=get(H(1,4),'string');
   if isempty(ct)
      errordlg({'x(n) 表达式不能为空' '请输入x(n)表达式'},name)
      return
   end
   n=0:N-1;
   if any(isletter(ct))
      try
         x=eval(ct);
      catch
         errordlg({'x(n) 的表达式有错！' '详细情况请参照帮助文件'},name)
         return
      end
   elseif length(ct)==1
      x=ones(1,N)*str2num(ct);
   else
      x=str2num(ct);
      N=length(x);
      n=0:N-1;
   end
   subplot(H(2,1))
   stem(n,x)
   title('原序列 x(n)');
   Xk=dfs(x,N);
   magXk=abs(Xk);
   %magXk=abs([Xk(N/2+1:N) Xk(1:N/2+1)]);
   angXk=angle(Xk);
   %angXk=angle([Xk(N/2+1:N) Xk(1:N/2+1)]);
   angXk=unwrap(angXk)*180/pi;
   %w=[-N/2:N/2];
   subplot(H(2,2))
   %stem(w,magXk)
   stem(n,magXk)
   title('DFT 系数幅度响应 |X(K)|');
   subplot(H(2,3))
   %stem(w,angXk)
   stem(n,angXk)
   title('DFT 系数相位响应 \theta(K)');
case 'runhelp'
   help9_1
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验九  离散 Fourier 变换 (DFT)——DFT 计算');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_ntext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.85 0.095 0.04],...
   'string','取样点数 N=',...
   'horizontal','right');
H_nedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'max',2,...
   'unit','normalized',...
   'position',[0.9 0.86 0.04 0.04],...
   'horizontal','left');
H_xtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.75 0.14 0.04],...
   'string','请输入 x(n) 表达式',...
   'tag','HText');
H_xedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.7 0.14 0.04],...
   'horizontal','left');

H_xn=axes('position',[0.05 0.7 0.68 0.2]);
title('原序列 x(n)');
H_Xmg=axes('position',[0.05 0.4 0.68 0.2]);
title('DFT 系数幅度响应 |X(K)|');
H_Xph=axes('position',[0.05 0.1 0.68 0.2]);
title('DFT 系数相位响应 \theta(K)');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt9_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt9_1 runhelp');

set(gcf,'userdata',[H_ntext,H_nedit,H_xtext,H_xedit;...
      H_xn,H_Xmg,H_Xph,0]);

% set callback

%===============================
function help9_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(9,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(9,1).helptext);

