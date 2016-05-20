function [Xk]=dfs(xn,N)
% Computes Discrete Fourier Series Coefficients
% --------------------------------------------
% [Xk]=dfs(xn,N)
% Xk=DFS coeff.arrray over 0<=k<N-1
% xn=One period of periodic signal over 0<=n<=N-1
% N=Fundmental period of xn
% 
n=[0:1:N-1];
k=[0:1:N-1];
WN=exp(-j*2*pi/N);       % Wn facter
nk=n'*k;
WNnk=WN.^nk;             % DFS matrix
Xk=xn*WNnk;              % row vector for DFS coefficients