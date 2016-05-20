function [X,W]=ctfts(x,T)
% CTFTS calculate the continuous-time Fourier transform (CTFT) of a
% periodic signal x(t) which is reconstructed from the samples in the 
% vector x using ideal bandlimited interpolation. The vector x
% contains samples of x(t) over an integer number of periods, and T
% contains the sampling period.
%   
% This vector X contains the area of the impulses at the frequency
% values stored in the vector w.
%    
% This function makes use of the relationship between the CTFT
% of x(t) and the DTFT of its sample x[n], as well as the 
% relatioship between the DTFT of the samples x[n] and the DTFTs of x[n].

N=length(x);
X=fftshift(fft(x,N))*(2*pi/N);
w=linspace(-1,1,-1/N,N)/(2*T);
