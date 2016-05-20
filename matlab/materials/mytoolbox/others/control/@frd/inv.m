function sysinv = inv(sys,method)
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
%        isys.ResponseData = myway(sys.ResponseData)
%     to perform the inversion.

%       Author(s): S. Almy
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.1 $  $Date: 1998/05/22 19:21:18 $

% Effect on other properties: exchange Input/Output Names, rest deleted.

sysResponse = sys.ResponseData;

sizes = size(sysResponse);

% Error checking and quick exits
if any(sizes==0),
   sysinv = sys.';  
   return
elseif sizes(1)~=sizes(2),
   error('Cannot invert non-square system.');
elseif nargin>1,
   % User-supplied method
   sysinv = sys;
   sysinv.ResponseData = feval(method,sys.ResponseData);
   sysinv.lti = inv(sys.lti);
   return
elseif hasdelay(sys)
   error('Inverse of delay system is non causal.');
end


% Compute inverse

for k = 1:prod(sizes(3:end))
   
   [L,U,P] = lu(sysResponse(:,:,k));
   if rcond(U) < 10*eps
      error('Cannot invert FRD model with singular frequency response.');
   else
      sysResponse(:,:,k) = U\(L\P);
   end
   
end

sysinv = sys;
sysinv.ResponseData = sysResponse;
sysinv.lti = inv(sys.lti);
