function [Xk]=dft(xn,N)
% computes Discrete Fourier Transform
% ------------------------------
% [Xk]=dft(xn,N)
% Xk=DFT coeff.array over 0<=k<=N-1
% xn=N-point finite-duration sequence
% N=Length of DFT
% 
n=[0:1:N-1];
k=[0:1:N-1];
WN=exp(-j*2*pi/N);            % WN factor
nk=n'*k;
WNnk=WN.^nk;                  % DFT matrix
Xk=xn*WNnk;                   % row vector for DFT coefficients

