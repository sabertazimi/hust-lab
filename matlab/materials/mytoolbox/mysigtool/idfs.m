function [xn]=idfs(Xk,N)
% Computes Inverse Discrete Fourier Series
% -------------------------------------
% [xn]=idfs(Xk,N)
% xn=One period of periodic signal over 0<=n<=N-1
% Xk=DFS coeff.array over 0<=k<=N-1
% N=Fundamental period of Xk
% 
n=[0:1:N-1];
k=[0:1:N-1];
WN=exp(-j*2*pi/N);            % WN facter
nk=n'*k;
WNnk=WN.^(-nk);                  % IDFS mettrix
xn=(Xk*WNnk)/N;               % row vector for IDFS coefficients
