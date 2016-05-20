function dexresp(fun,ssflag) 
%DEXRESP Example response for discrete functions.
%
%	DEXRESP('fun')

%	Andrew Grace 7-9-90 
%	Revised 6-21-92
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.4 $  $Date: 1999/01/05 15:21:55 $

if nargin==1, ssflag=0; end;

order=round(abs(randn(1,1))*5+2);
disp('')
disp([' Here is an example of how the function ', fun, ' works:'])
disp('')
disp(' Consider a randomly generated stable Transfer Function Model')
disp(' of the form G(z)=num(z)/den(z):')
[num,den]=drmodel(order)
Ts = exp(randn(1,1)-2)
if ssflag, 
  disp('Transform to state space with: [a,b,c,d] = tf2ss(num,den);');
  [a,b,c,d] = tf2ss(num,den);
  call=[fun,'(a,b,c,d,Ts);'];
else
  call=[fun,'(num,den,Ts);'];
end
disp('')
disp(['Call ', fun, ' using the following command (see also, help ',fun,'):'])
disp('')
disp(call)
disp('')
eval(call)
