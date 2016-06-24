% design5_2.m
% x = sin n , 1:5
% h = 1 -1 3 , 1:3

x=[sin(1) sin(2) sin(3) sin(4) sin(5)];
h=[1 -1 3];
y=conv(x,h);
figure
subplot(3,1,1)
stem(x)
ylabel('激励x(n)');
subplot(3,1,2)
stem(h)
ylabel('冲激响应h(n)');
subplot(3,1,3)
stem(y)
ylabel('输出响应y(n)');
text={...
   ' '
   '  输入序列 x='
   ' '
   [' '*ones(1,12),num2str(x,'%8g')]
   ' '
   '  单位冲激响应序列 h='
   ' '
   [' '*ones(1,12),num2str(h,'%8g')]
   ' '
   '  响应序列 y='
   ' '
   [' '*ones(1,12),num2str(y,'%8g')]
   ' '};
textwin('卷积结果——数值表示',text)
