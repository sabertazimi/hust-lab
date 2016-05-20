function c = xcorr2(a,b)
%XCORR2 Two-dimensional cross-correlation.
%   XCORR2(A,B) computes the crosscorrelation of matrices A and B.
%   XCORR2(A) is the autocorrelation function.
%
%   See also CONV2, XCORR and FILTER2.

%   Author(s): M. Ullman, 2-6-86
%   	   J.N. Little, 6-13-88, revised
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/07/13 19:02:13 $

if nargin == 1
	b = a;
end

[ma,na] = size(a);
[mb,nb] = size(b);

b = conj(b(mb:-1:1,:));
apad = [a ; zeros(mb-1,na)];

c = zeros(ma+mb-1,na+nb-1);

for k=1:(na+nb-1)
	count = k		*(k<min(na,nb)) ...
		+min(na,nb)	*(k>=min(na,nb))*(k<=max(na,nb)) ...
		+(na+nb-k)	*(k>max(na,nb));

	starta = 1		*(k<=nb) ...
		+(k-nb+1)	*(k>nb);

	startb = (nb-k+1)	*(k<=nb) ...
		+1		*(k>nb);

	for i=0:(count-1)
		c(:,k) = c(:,k) + filter( b(:,startb+i), 1, apad(:,starta+i) ); 
	end
end

