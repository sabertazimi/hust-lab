function [xn]=idft(Xk,N)
% Computes Inversse Discrete Fourier Transform
% ---------------------------------------
% [xn]=idft(Xk,N)
% xn=N-point sequence over 0<=n<=N-1
% Xk=DFT coeff.array over 0<=k<=N-1
% N=Length of DFT
% 
n=[0:1:N-1];
k=[0:1:N-1];
WN=exp(-j*2*pi/N);       % Wn factor
nk=n'*k;
WNnk=WN.^(-nk);          % IDFT matrix
xn=(Xk*WNnk)/N;          % row vector for IDFT values
