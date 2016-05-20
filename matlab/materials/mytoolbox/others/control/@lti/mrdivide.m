function sys = mrdivide(sys2,sys1)
%MRDIVIDE  Right division for LTI models.
%
%   SYS = MRDIVIDE(SYS1,SYS2) is invoked by SYS=SYS1/SYS2.
%   and is equivalent to SYS = SYS1*INV(SYS2).
%
%   See also MLDIVIDE, INV, MTIMES, LTIMODELS.

%   Author(s): A. Potvin, 3-1-94
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/09/23 17:07:09 $


% Simplify delays when SYS1 is SISO and delayed
if isa(sys1,'lti') & isa(sys2,'lti')
   [sys1,sys2] = simpdelay(sys1,sys2);
end

% Perform product SYS2*INV(SYS1)
try
   sys = sys2*inv(sys1);
catch
   if isempty(findstr(lasterr,'causal')),
      error(lasterr)
   elseif issiso(sys1), 
      error('In SYS1/SYS2, resulting model is non causal.')
   else
      % SYS1 is MIMO 
      error('In SYS1/SYS2, MIMO model SYS2 must be delay free.')
   end
end

