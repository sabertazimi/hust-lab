function expt2_2(action)
% EXPT2_2 Run the second subtopic in experiment2
% 
% Type "expt2_2" at the command line to browse the experiment.
% With the optional parameter
% EXPT2_2 draw the specified figure out.
%
%

if nargin<1,
   action='start';
end
name='Fourier 变换的性质及应用';

% run the experiment
switch action
case 'start'
   frame
case 'f1popup'
   H=get(gcf,'userdata');
   set(H(2,3),'string',[]);
   set(H(2,4),'string',[]);
   value=get(H(1,1),'value')-1;
   if value==3|value==4|value==6|value==7|value==11|value==12
      set(H(2,2),'Enable','off');
      set(H(2,2),'string','参数b');
   else
      if value==0
      set(H(2,1),'string','参数a');
      set(H(2,2),'string','参数b');
      errordlg('请选择函数f1的形式',name)
      return
      end
      set(H(2,2),'Enable','on');
   end
   
   if value==2|value==1
      set(H(2,1),'string','a=');
      set(H(2,2),'string','b=');
   elseif value==4|value==3
      set(H(2,1),'string','a=');
   elseif value==5
      set(H(2,1),'string','a=');
      set(H(2,2),'string','w=');
   elseif value==6|value==7
      set(H(2,1),'string','w=');
   elseif value==8
      set(H(2,1),'string','w=');
      set(H(2,2),'string','b=');
   elseif value==9|value==10
      set(H(2,1),'string','center=');
      set(H(2,2),'string','width=');
   elseif value==11|value==12
      set(H(2,1),'string','T=');
   end
   
case 'f2popup'
   H=get(gcf,'userdata');
   set(H(3,3),'string',[]);
   set(H(3,4),'string',[]);
   value=get(H(1,2),'value')-1;
   if value==3|value==4|value==6|value==7|value==11|value==12
      set(H(3,2),'Enable','off');
      set(H(3,2),'string','参数b');
   else
      if value==0
      set(H(3,1),'string','参数a');
      set(H(3,2),'string','参数b');
      errordlg('请选择函数f2的形式',name)
      return
      end
      set(H(3,2),'Enable','on');
   end  %if
   
   if value==2|value==1
      set(H(3,1),'string','a=');
      set(H(3,2),'string','b=');
   elseif value==4|value==3
      set(H(3,1),'string','a=');
   elseif value==5
      set(H(3,1),'string','a=');
      set(H(3,2),'string','w=');
   elseif value==6|value==7
      set(H(3,1),'string','w=');
   elseif value==8
      set(H(3,1),'string','w=');
      set(H(3,2),'string','b=');
   elseif value==9|value==10
      set(H(3,1),'string','center=');
      set(H(3,2),'string','width=');
   elseif value==11|value==12
      set(H(3,1),'string','T=');
   end  %if
   
case 'runexpt'
   H=get(gcf,'userdata');
   f1pop=get(H(1,1),'value')-1;
   if f1pop==0
      errordlg('请选择函数 f1 的形式',name)
      return
   end
   a=str2num(get(H(2,3),'string'));
   b=str2num(get(H(2,4),'string'));
   if f1pop~=15&(isempty(a)|((~isempty(find(f1pop==[1,2,5,8,9,10])))&isempty(b)))
      errordlg({'函数 f1 参数不能为空' '请输入合适的参数'},name)
      return
   end
   f2pop=get(H(1,2),'value')-1;
   if f2pop==0
      errordlg('请选择函数 f2 的形式',name)
      return
   end
   c=str2num(get(H(3,3),'string'));
   d=str2num(get(H(3,4),'string'));
   if f2pop~=15&(isempty(c)|((~isempty(find(f2pop==[1,2,5,8,9,10])))&isempty(d)))
      errordlg({'函数 f2 参数不能为空' '请输入合适的参数'},name)
      return
   end
   f1=getfunc(f1pop,a,b);
   f2=getfunc(f2pop,c,d);
   F1=fourier(f1);
   F2=fourier(f2);
   if f1pop==10|f1pop==9|f1pop==12
      F1=simple(F1);
   end
   if f2pop==10|f2pop==9|f2pop==12
      F2=simple(F2);
   end
   F1=subs(F1,'Dirac','Dirat');
   F2=subs(F2,'Dirac','Dirat');
   FF1=sym(maple('convert',F1,'piecewise','w'));
   %FF1=maple('convert',F1,'radical');
   FF2=sym(maple('convert',F2,'piecewise','w'));
   %FF2=maple('convert',F2,'radical');
   FFF1=sym(abs(FF1));
   FFF1=sym(subs(FFF1,'Im','imag'));
   FFF2=sym(abs(FF2));
   FFF2=sym(subs(FFF2,'Im','imag'));
   subplot(H(4,1))
   cla
   f1=subs(f1,'Dirac','Dirat');
   %f1=subs(f1,'Heaviside','Heavicide');
   %ff1=sym(maple('convert',f1,'piecewise','t'));
   if f1pop<=2|f1pop==9|f1pop==10
      if f1pop<=2
         dd1=-b/a;
      else 
         dd1=a;
      end
    
      ezplot(f1,[dd1-2*pi,dd1+2*pi])
   else
      ezplot(f1)
   end
	title('时域波形 f1(t)');
   subplot(H(4,2))
   cla
   %FFF1=subs(FFF1,'Dirac','Dirat');
   %ezplot(FFF1,[-2*pi,2*pi])
   if f1pop==8
      ezplot(F1,[-2*pi,2*pi])
   else
      ezplot(FFF1);
   end
   title('频域波形 F1(jw)');
   subplot(H(4,3))
   cla
   f2=subs(f2,'Dirac','Dirat');
   %ff2=sym(maple('convert',f2,'piecewise','t'));
   if f2pop<=2|f2pop==9|f2pop==10
      if f2pop<=2
         dd2=-d/c;
      else 
         dd2=c;
      end
      ezplot(f2,[dd2-2*pi,dd2+2*pi])
   else
      ezplot(f2)
   end
	title('时域波形 f2(t)');
   subplot(H(4,4))
   cla
   %FFF2=subs(FFF2,'Dirac','Dirat');
   %ezplot(FFF2,[-2*pi,2*pi])
   if f2pop==8
      ezplot(F2,[-2*pi,2*pi])
   else
      ezplot(FFF2,[-2*pi,2*pi]);
   end
   title('频域波形 F2(jw)');
case 'runhelp'
   help2_2
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验二  信号的 Fourier 分析——Fourier 变换的性质及应用');
text={...
   	'单位冲激 Delta(at+b)'
      '单位阶跃 u(at+b)'
      '单边指数 e^(-at)u(t)'
      '指数脉冲 te^(-at)u(t)'
      '减幅正弦 e^(-at)sin(wt)u(t)'
      '阶跃正弦 sin(wt)u(t)'
      '阶跃余弦 cos(wt)u(t)'
      '抽样函数 Sa(wt+b)'
      '矩形脉冲 Gate(center,width)'
      '三角脉冲 Triagle(center,width)'
      '升余弦 Up_cos(T)'
      '半余弦 Half_cos(T)'};

% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_f1popup=uicontrol(H0,'style','popup',...
   'backgroundcolor',[1 1 1],...
   'callback','expt2_2 f1popup',...
	'unit','normalized',...
   'position',[0.8 0.85 0.14 0.05],...
   'fontsize',10,...
   'string',[{'请选择信号 f1(t)'};text],...
   'max',2,...
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

H_f2popup=uicontrol(H0,'style','popup',...
   'backgroundcolor',[1 1 1],...
   'callback','expt2_2 f2popup',...
	'unit','normalized',...
	'position',[0.8 0.6 0.14 0.05],...
   'fontsize',10,...
   'max',1,...
   'string',[{'请选择信号 f2(t)'};text],...
   'tag','LcPopup');
H_ctext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.55 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数a');
H_cedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.87 0.56 0.07 0.04],...
   'fontsize',10,...
   'horizontal','left');
H_dtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'unit','normalized',...
   'position',[0.8 0.5 0.065 0.05],...
   'fontsize',10,...
   'horizontal','right',...
   'string','参数b');
H_dedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'fontsize',10,...
   'position',[0.87 0.51 0.07 0.04],...
   'horizontal','left');

H_f1=axes('position',[0.05 0.55 0.3 0.35]);
title('时域波形 f1(t)');
H_ff1=axes('position',[0.43 0.55 0.3 0.35]);
title('频域波形 F1(jw)');
H_f2=axes('position',[0.05 0.1 0.3 0.35]);
title('时域波形 f2(t)');
H_ff2=axes('position',[0.43 0.1 0.3 0.35]);
title('频域波形 F2(jw)');
set(gcf,'userdata',[H_f1popup,H_f2popup,0,0;...
      H_atext,H_btext,H_aedit,H_bedit;...
      H_ctext,H_dtext,H_cedit,H_dedit;...
      H_f1,H_ff1,H_f2,H_ff2]);

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt2_2 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt2_2 runhelp');



% pulse
%===============================
function help2_2
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(2,2).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(2,2).helptext);

%==============================
function f=getfunc(n,a,b)
%==============================
syms ca cb;
switch n
case 1
   %f=subs(sym('Dirac(ca*t+cb)'),{'ca','cb'},{a,b});
   f=sym('Dirac(ca*t+cb)');
   f=subs(f,ca,a);
   f=subs(f,cb,b);
case 2
   %f=subs(sym('Heaviside(ca*t+cb)'),{'ca','cb'},{a,b});
   f=sym('Heaviside(ca*t+cb)');
   f=subs(f,ca,a);
   f=subs(f,cb,b);
case 3
   %f=subs(sym('exp(-ca*t)*Heaviside(t)'),{'ca'},{a});
   f=sym('exp(-ca*t)*Heaviside(t)');
   f=subs(f,ca,a);
case 4
   %f=subs(sym('t*exp(-ca*t)*Heaviside(t)'),{'ca'},{a});
   f=sym('t*exp(-ca*t)*Heaviside(t)');
   f=subs(f,ca,a);
case 5
   %f=subs(sym('exp(-ca*t)*sin(cb*t)*Heaviside(t)'),{'ca','cb'},{a,b});
   f=sym('exp(-ca*t)*sin(cb*t)*Heaviside(t)');
   f=subs(f,ca,a);
   f=subs(f,cb,b);
case 6
   %f=subs(sym('sin(ca*t)*Heaviside(t)'),{'ca'},{a});
   f=sym('sin(ca*t)*Heaviside(t)');
   f=subs(f,ca,a);
case 7
   %f=subs(sym('cos(ca*t)*Heaviside(t)'),{'ca'},{a});
   f=sym('cos(ca*t)*Heaviside(t)');
   f=subs(f,ca,a);
case 8
   %f=subs(sym('sin(ca*t+cb)/(ca*t+cb)'),{'ca','cb'},{a,b});
   f=sym('sin(ca*t+cb)/(ca*t+cb)');
   f=subs(f,ca,a);
   f=subs(f,cb,b);
case 9
   %f=subs(sym('Heaviside(t-(ca-cb/2))-Heaviside(t-(ca+cb/2))'),{'ca','cb'},{a,b});
   f=sym('Heaviside(t-(ca-cb/2))-Heaviside(t-(ca+cb/2))');
   f=subs(f,ca,a);
   f=subs(f,cb,b);
case 10
   %f=subs(sym('(1-abs(t)/(cb/2))(Heaviside(t-(ca-cb/2))-Heaviside(t-(ca+cb/2)))'),{'ca','cb'},{a,b});
   f=sym('(1+t/cb-ca/cb)*(Heaviside(t-ca+cb)-Heaviside(t-ca))+(1-t/cb+ca/cb)*(Heaviside(t-ca)-Heaviside(t-ca-cb))');
   f=subs(f,ca,a);
   f=subs(f,cb,b/2);
case 11
   %f=subs(sym('(1+cos(2*pi*t/ca))*(Heaviside(t+ca/2)-Heaviside(t-ca/2))'),{'ca'},{a});
   f=sym('(1+cos(2*pi*t/ca))*(Heaviside(t+ca/2)-Heaviside(t-ca/2))');
   f=subs(f,ca,a);
case 12
   %f=subs(sym('(1+cos(pi*t/ca))*(Heaviside(t+ca/2)-Heaviside(t-ca/2))'),{'ca'},{a});
   f=sym('(cos(pi*t/ca))*(Heaviside(t+ca/2)-Heaviside(t-ca/2))');
   f=subs(f,ca,a);
end

   
   