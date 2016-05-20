function exresp(fun,ssflag) 
%EXRESP Example response, used by plotting control routines to give
%       an example or their use.
%	EXRESP('fun')
%	EXRESP('fun',ssflag)

%	Andrew Grace  7-9-90
%	Revised ACWG 6-21-92
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.5 $  $Date: 1999/01/05 15:22:20 $

if nargin==1, ssflag = 0; end

order=round(abs(randn(1,1))*5+2);
disp('')
disp([' Here is an example of how the function ', fun, ' works'])
disp('')
disp(' Consider a randomly generated stable Transfer Function Model:')
if fun(1)=='d'
  disp(' of the form G(z)=num(z)/den(z):')
  [num,den]=drmodel(order)
else
  disp(' of the form G(s)=num(s)/den(s):')
  [num,den]=rmodel(order)
end
if ssflag, 
  disp('Transform to state space with: [a,b,c,d] = tf2ss(num,den);');
  [a,b,c,d] = tf2ss(num,den);
  call=[fun,'(ss(a,b,c,d));'];
else
  call=[fun,'(tf(num,den));'];
end
disp('')
disp(['Call ', fun, ' using the following command (see also, help ',fun,'):'])
disp('')
disp(call)
disp('')
eval(call)
