function sys = uminus(sys)
%UMINUS  Unary minus for LTI models.
%
%   MSYS = UMINUS(SYS) is invoked by MSYS = -SYS.
%
%   See also MINUS, LTIMODELS.

%   Author(s): A. Potvin
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/02/12 22:28:17 $

% Effect on other properties: None

for k=1:prod(size(sys)),
   sys.num{k} = -sys.num{k};
end

