function expt9_2(action)
% EXPT9_2 Run the second subtopic in experiment9
% 
% Type "expt9_2" at the command line to browse the experiment.
% With the optional parameter
% EXPT9_2 draw the specified figure out.
%

if nargin<1,
   action='start';
end
name='DFT的实序列对称性';
% run the experiment
switch action
   
case 'start'
   frame
case 'runexpt'
   H=get(gcf,'userdata');
   T=0.1;
   N=str2num(get(H(1,2),'string'));
   if isempty(N)|N==0
      errordlg({'取样点数不能为空或为零' '请输入采样点数'},name)
      return
   end
   ct=get(H(1,4),'string');
   if isempty(ct)
      errordlg({'x(n) 表达式不能为空' '请输入 x(n) 表达式'},name)
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
   [xec,xoc]=circevod(x);
   X=dft(x,N);
   Xec=dft(xec,N);
   Xoc=dft(xoc,N);
   subplot(H(2,1))
   stem(n,xec)
	title('偶分量 xec(n)');
   subplot(H(2,2))
   stem(n,xoc)
   title('奇分量 xoc(n)');
   subplot(H(2,3))
   stem(n,real(X))
   title('DFT[x(n)] 的实部分量');
   subplot(H(2,4))
   stem(n,imag(X))
   title('DFT[x(n)] 的虚部分量');
   subplot(H(2,5))
   stem(n,real(Xec))
   title('DFT[xec(n)]');
   subplot(H(2,6))
   stem(n,imag(Xoc))
   title('DFT[xoc(n)]');
case 'runhelp'
   help9_2
   
end %switch


%==============================
function frame
%==============================
% the name of this experiment
window1
H0=findobj(gcf,'Tag','Window1');
set(H0,'Name','实验九  离散 Fourier 变换 (DFT)——DFT 的实序列对称性');
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
   'position',[0.8 0.71 0.14 0.04],...
   'horizontal','left');

H_xecn=axes('position',[0.05 0.7 0.3 0.2]);
title('偶分量 xec(n)');
H_xocn=axes('position',[0.4 0.7 0.3 0.2]);
title('奇分量 xoc(n)');
H_RealX=axes('position',[0.05,0.4,0.3,0.2]);
title('DFT[x(n)] 的实部分量');
H_ImagX=axes('position',[0.4,0.4,0.3,0.2]);
title('DFT[x(n)] 的虚部分量');
H_DFTxecn=axes('position',[0.05,0.1,0.3,0.2]);
title('DFT[xec(n)]');
H_DFTxocn=axes('position',[0.4,0.1,0.3,0.2]);
title('DFT[xoc(n)]');

% set callback
H_run=findobj(gcf,'Tag','Run');
set(H_run,'callback','expt9_2 runexpt');
H_help=findobj(gcf,'Tag','Help');
set(H_help,'callback','expt9_2 runhelp');

set(gcf,'userdata',[H_ntext,H_nedit,H_xtext,H_xedit,0,0;...
      H_xecn,H_xocn,H_RealX,H_ImagX,H_DFTxecn,H_DFTxocn]);

% set callback

%===============================
function help9_2
%===============================
load .\mysignal\helpdata
myhelp
set(gcf,'Name',data(9,2).helpname);
set(findobj(gcf,'Tag','HelpList'),'String',data(9,2).helptext);

