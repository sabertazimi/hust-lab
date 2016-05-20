% design8_1.m
K=[-5 10 25];
text={};
blank={''
   ''
   ''};
for n=1:3
   a=[1 5 4 K(n)];
   [d,flag]=poly2routh(a);
   [row,col]=size(d);
   if isempty(d)
      text1={' '
         [' K=',num2str(K(n))] 
         ' '};
   else
      text1={''
         [' K=',num2str(K(n))]
         ' '
         ' Routh-Hurwitz 阵列如下所示'
         ''
         [' '*ones(row,10),num2str(d)]
         ''};
   end
   text2=[text1;flag];
   text=[text;blank;text2];
end
H0=figure;
H_text=uicontrol(H0,'style','listbox',...
   'BackgroundColor',[1 1 1],...
   'max',2,...
   'Enable','inactive', ...
   'Value',[],...
   'string','',...
   'unit','normalized',...
   'position',[0.05 0.05 0.9 0.9],...
   'horizontal','left');
set(H_text,'string',text)
