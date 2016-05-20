function expt10_1(action)
% EXPT10_1 Run the first subtopic in experiment10
% 
% Type "expt10_1" at the command line to browse the experiment.
% With the optional parameter
% EXPT10_1 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='FFT 的实现';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   ct=get(H(1,2),'string');
   if isempty(ct)
      errordlg({'x(t) 表达式不能为空' '请输入 x(t) 表达式'},name)
      return
   end
   NUM1=45;
   NUM2=65;
   number=0:NUM1-1;
   t=0.01*number;
   if any(isletter(ct))
      try
         x=eval(ct);
      catch
         errordlg({'x(t) 的表达式有错！' '详细情况请参照帮助文件'},name)
         return
      end
   else
      x=ones(1,NUM1)*str2num(ct);
   end
   number1=number*2*pi/NUM1;
   %x=eval(ct);
   X1=fft(x,NUM1);
   xw=x+randn(1,NUM1);
   Y1=fft(xw,NUM1);
   number=0:NUM2-1;
   t=0.01*number;
   if any(isletter(ct))
      try
         x=eval(ct);
      catch
         errordlg({'x(t) 的表达式有错！' '详细情况请参照帮助文件'},name)
         return
      end
   else
      x=ones(1,NUM2)*str2num(ct);
   end
   number2=number*2*pi/NUM2;
   %x=eval(ct);
   X2=fft(x,NUM2);
   xw=x+randn(1,NUM2);
   Y2=fft(xw,NUM2);
   subplot(H(1,3))
   %stem(number1,abs(X1))
   plot(number1,abs(X1))
   title('FFT N=45');
   subplot(H(1,4))
   plot(number2,abs(X2))
   title('FFT N=65');
	subplot(H(1,5))
   plot(number1,abs(Y1))
   title('FFT N=45(正态噪声）');
   subplot(H(1,6))
   plot(number2,abs(Y2))
   title('FFT N=65(正态噪声）');
case 'runhelp'
   help10_1
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验十  快速 Fourier 变换 (FFT及其应用)——FFT 的实现');
% set the control frame
H_c=findobj(gcf,'Tag','Control');

H_xtext=uicontrol(H0,'style','text',...
   'BackgroundColor',[0.5 0.5 0.5],...
   'fontsize',10,...
   'unit','normalized',...
	'position',[0.8 0.85 0.14 0.04],...
   'string','请输入 x(t) 表达式',...
   'tag','HText');
H_xedit=uicontrol(H0,'style','edit',...
   'BackgroundColor',[1 1 1],...
   'unit','normalized',...
   'position',[0.8 0.81 0.14 0.04],...
   'horizontal','left');

H_xn1=axes('position',[0.05 0.55 0.3 0.35]);
title('FFT N=45');
H_xn2=axes('position',[0.4 0.55 0.3 0.35]);
title('FFT N=65');
H_xn3=axes('position',[0.05 0.1 0.3 0.35]);
title('FFT N=45(正态噪声）');
H_xn4=axes('position',[0.4 0.1 0.3 0.35]);
title('FFT N=65(正态噪声）');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt10_1 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt10_1 runhelp');

set(gcf,'userdata',[H_xtext,H_xedit,H_xn1,H_xn2,H_xn3,H_xn4]);

% set callback

%===============================
function help10_1
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(10,1).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(10,1).helptext);

