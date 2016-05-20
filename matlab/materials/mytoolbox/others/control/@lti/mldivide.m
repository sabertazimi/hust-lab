function sys = mldivide(sys1,sys2)
%MLDIVIDE  Left division for LTI models.
%
%   SYS = MLDIVIDE(SYS1,SYS2) is invoked by SYS=SYS1\SYS2
%   and is equivalent to SYS = INV(SYS1)*SYS2.
%
%   See also MRDIVIDE, INV, MTIMES, LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/09/23 17:07:08 $


% Simplify delays when SYS1 is SISO and delayed
if isa(sys1,'lti') & isa(sys2,'lti')
   [sys1,sys2] = simpdelay(sys1,sys2);
end

% Perform product INV(SYS1)*SYS2
try
   sys = inv(sys1)*sys2;
catch
   if isempty(findstr(lasterr,'causal')),
      error(lasterr)
   elseif issiso(sys1), 
      error('In SYS1\SYS2, resulting model is non causal.')
   else
      % SYS1 is MIMO 
      error('In SYS1\SYS2, MIMO model SYS1 must be delay free.')
   end
end
