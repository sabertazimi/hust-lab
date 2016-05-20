function expt8_1(action)
% EXPT8_1 Run the first subtopic in experiment8
% 
% Type "expt8_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT8_1 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='线性系统稳定性分析';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   aa=get(H(1,2),'string');
   a=str2num(aa);
   if isempty(a)|isempty(aa)|isempty(find(a))
      errordlg({'多项式系数为空或全零或行列数不对' '请重新输入多项式系数'},name)
      return
   end
   [d,flag]=poly2routh(a);
   [row,col]=size(d);
   if isempty(d)
      text={};
   else
      text={''
         ''
         ' Routh-Hurwitz 阵列如下所示'
         ''
         [' '*ones(row,10),num2str(d,'%25.3g')]
         ''};
   end
   set(H(1,3),'string',[flag;text])
case 'runhelp'
   help8_1
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验八  线性系统稳定性分析——线性系统稳定性分析');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_atext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.85 0.14 0.04],...
   'string','请输入多项式系数');
H_aedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.81 0.14 0.04],...
   'horizontal','left');
H_text=uicontrol(H0,'style','listbox',...
   'BackgroundColor',[1 1 1],...
   'max',2,...
   'Enable','inactive', ...
   'Value',[],...
   'string','',...
	'unit','normalized',...
   'position',[0.05 0.05 0.65 0.9],...
   'horizontal','left');


% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt8_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt8_1 runhelp');

set(gcf,'userdata',[H_atext,H_aedit,H_text]);

% set callback

%===============================
function help8_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(8,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(8,1).helptext);

