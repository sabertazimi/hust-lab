function w = dfrqint(a,b,c,d,Ts,npts)
%DFRQINT Discrete auto-ranging algorithm for DBODE plots.
%   W=DFRQINT(A,B,C,D,Ts,NPTS)
%   W=DFRQINT(NUM,DEN,Ts,NPTS)

%   Clay M. Thompson 7-10-90
%   Revised ACWG 11-25-91
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:21:56 $

if nargin==4,
   Ts = c; 
   npts = d;
   [a,b,c,d] = tf2ss(a,b);
end
[a1,b1] = d2cm(a,b,c,d,Ts,'tustin');
w = freqint(a1,b1,c,d,npts);
w = w(find(w<=pi/Ts));
if ~isempty(w), 
   w = sort([w(:); linspace(min(w),pi/Ts,128).']);
else
   w = linspace(pi/Ts/10,pi/Ts,128).';
end

% end dfrqint
