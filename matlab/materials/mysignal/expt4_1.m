function expt4_1(action)
% EXPT4_1 Run the first subtopic in experiment4
% 
% Type "expt4_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT4_1 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='Laplace 变换的性质';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   k=str2num(get(H(1,1),'string'));
   if isempty(k)
      errordlg({'增益系数不能为空' '请输入增益系数'},name)
      return
   end
   if k==0
      flag=questdlg({'系统增益为零' '继续？'},name);
      switch flag
      case 'Yes'
         k=0;
      otherwise
         return
      end
   end
   z=str2num(get(H(1,2),'string'));
   p=str2num(get(H(1,3),'string'));
   if isempty(z)&isempty(p)
      flag=questdlg({'系统为静态增益系统' '继续？'},name);
      switch flag
      case 'Yes'
         z=[];
         p=[];
      otherwise
         return
      end
   end
   if length(p)<length(z)
      errordlg({'极点数目少于零点数目' '无法构造传输系统' '请重新输入极、零点向量'},name)
      return
   end
   
   [num,den]=zp2tf(z',p',k);
   [num1,len1]=poly2str(num,'s');
   [den2,len2]=poly2str(den,'s');
   len=max(len1,len2);
   div=['H(s)=',' '*ones(1,5),'-'*ones(1,len+5),' '*ones(1,10)];
   num2=[' '*ones(1,10),num1,' '*ones(1,10)];
   den2=[' '*ones(1,10),den2,' '*ones(1,10)];
   text={num2;div;den2};
   if(len>60)
      set(H(2,3),'string','系统函数表达式太长，无法在此显示')
   else
      set(H(2,3),'string',text)
   end
   a1=poly2sym(num);
   a2=poly2sym(den);
   a=a1/a2;
   ft=ilaplace(a);
   %[y,t]=impulse(num,den);
   subplot(H(2,1))
   rlocus(num,den)
   title('系统函数 H(s) 极、零图');
   subplot(H(2,2))
   %impulse(num,den)
   %plot(t,y)
   ft=maple('convert',ft,'radical');
   ezplot(ft,[0,4*pi])
	title('时域原函数 h(t)');
case 'runhelp'
   help4_1
   
end %switch

%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验四  Laplace 逆变换及应用—— Laplace 变换的性质');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_ktext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
   'position',[0.8 0.85 0.095 0.04],...
   'string','增益系数 k=',...
   'horizontal','right');
H_kedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.9 0.86 0.04 0.04],...
   'horizontal','left');
H_ztext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.75 0.14 0.04],...
   'string','零点向量 z');
H_zedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.7 0.14 0.04],...
   'horizontal','left');
H_ptext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.6 0.14 0.04],...
   'string','极点向量 p');
H_pedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.55 0.14 0.04],...
   'horizontal','left');
H_text=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.8 0.8 0.8],...
   'fontsize',15,...
   'unit','normalized',...
   'position',[0.05 0.77 0.65 0.15],...
   'horizontal','center');


H_zp=axes('position',[0.05 0.1 0.3 0.6]);
title('系统函数 H(s) 极、零图');
H_ft=axes('position',[0.4 0.1 0.3 0.6]);
title('时域原函数 h(t)');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt4_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt4_1 runhelp');

set(gcf,'userdata',[H_kedit,H_zedit,H_pedit;H_zp,H_ft,H_text]);

% set callback


%===============================
function help4_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(4,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(4,1).helptext);

