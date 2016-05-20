function sys = inv(sys,method)
%INV  Inverse LTI model.
%
%   ISYS = INV(SYS) computes the inverse model ISYS such that
%
%       y = SYS * u   <---->   u = ISYS * y 
%
%   The LTI model SYS must have the same number of inputs and
%   outputs.
%
%   For arrays of LTI models, INV is performed on each individual
%   model.
%   
%   See also MLDIVIDE, MRDIVIDE, LTIMODELS.

%     Users can supply their own inversion method with the
%     syntax  INV(SYS,METHOD).  For instance, 
%        isys = inv(sys,'myway')
%     executes
%        [isys.num,isys.den] = myway(sys.num,sys.den)
%     to perform the inversion.

%       Author(s): A. Potvin, 3-1-94
%       Revised: P. Gahinet, 4-1-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.11 $

% Effect on other properties: exchange Input/Output Names, rest deleted.

sizes = size(sys.num);
ny = sizes(1);  
nu = sizes(2);

% Error checking and quick exits
if any(sizes==0),
   sys = sys.';  
   return
elseif ny~=nu,
   error('Cannot invert non-square system.');
elseif nargin>1,
  % User-supplied method
  [sys.num,sys.den] = feval(method,sys.num,sys.den);
  sys.lti = inv(sys.lti);
  return
elseif hasdelay(sys)
   Ts = getst(sys);
   if Ts,
      % Map delay times to poles at z=0 in discrete-time case
      sys = delay2z(sys);
   else
      error('Inverse of delay system is non causal.')
   end  
end


% Compute inverse
if ny>1,
   % MIMO system: let ss/inv handle it
   if ~isproper(sys),
      error('Inversion of non proper MIMO systems not available');
   end
   
   % Convert to state space and then invert
   try 
      sys = tf(inv(ss(sys)));
   catch
      error('Cannot invert specified MIMO transfer functions.');
   end
else
   % SISO system
   [num,den] = tfdata(sys);
   sys.num = den;
   sys.den = num;
   sys.lti = inv(sys.lti);
end


