function expt5_1(action)
% EXPT5_1 Run the first subtopic in experiment5
% 
% Type "expt5_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT5_1 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='离散卷积计算';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   x=str2num(get(H(3),'string'));
   if isempty(x)
      errordlg({'序列x(n)不能为空' '请输入序列x(n)'},name)
      return
   end
   h=str2num(get(H(4),'string'));
   if isempty(h)
      errordlg({'序列h(n)不能为空' '请输入序列h(n)'},name)
      return
   end
   y=conv(x,h);
	subplot(H(5))
   stem(x)
	title('激励x(n)');
   subplot(H(6))
   stem(h)
	title('冲激响应h(n)');
   subplot(H(7))
   stem(y)
   title('输出响应y(n)');
   text={...
      ''
      '  输入序列 x='
      ''
      [' '*ones(1,12),num2str(x,'%8g')]
      ''
      '  单位冲激响应序列 h='
      ''
      [' '*ones(1,12),num2str(h,'%8g')]
      ''
      '  响应序列 y='
      ''
      [' '*ones(1,12),num2str(y,'%8g')]
      ''};
   textwin('卷积结果——数值表示',text)

case 'runhelp'
   help5_1
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验五  离散时间系统的时域分析——离散卷积计算');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_xtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.85 0.14 0.04],...
   'string','请输入序列x(n)',...
   'Tag','XText');
H_xedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.8 0.14 0.04],...
   'horizontal','left');
H_htext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.7 0.14 0.04],...
   'string','请输入序列h(n)',...
   'tag','HText');
H_hedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.65 0.14 0.04],...
   'horizontal','left');

H_x=axes('Position',[0.05 0.7 0.68 0.2]);
title('激励x(n)');
H_h=axes('Position',[0.05 0.4 0.68 0.2]);
title('冲激响应h(n)');
H_y=axes('Position',[0.05 0.1 0.68 0.2]);
title('输出响应y(n)');
% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt5_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt5_1 runhelp');

set(gcf,'userdata',[H_xtext,H_htext,H_xedit,H_hedit,H_x,H_h,H_y]);

% set callback

%===============================
function help5_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(5,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(5,1).helptext);

