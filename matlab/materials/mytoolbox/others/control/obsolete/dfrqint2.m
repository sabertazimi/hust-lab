function w = dfrqint2(a,b,c,d,Ts,npts)
%DFRQINT2 Discrete auto-ranging algorithm for Nyquist and Nichols plots.
%   W=DFRQINT2(A,B,C,D,Ts,NPTS)
%   W=DFRQINT2(NUM,DEN,Ts,NPTS)

%   Clay M. Thompson 7-10-90
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:21:58 $

if nargin==4,
   Ts = c; 
   npts = d;
   [a,b,c,d] = tf2ss(a,b);
end
[a1,b1] = d2c(a,b,Ts);
w = freqint2(a1,b1,c,d,npts);
w = w(find(w<=pi/Ts));
if ~isempty(w), 
  w = sort([w; linspace(min(w),pi/Ts,128).']);
else
  w = linspace(pi/Ts/10,pi/Ts,128).';
end

% end dfrqint2
