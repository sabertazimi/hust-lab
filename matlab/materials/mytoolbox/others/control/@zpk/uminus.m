function sys = uminus(sys)
%UMINUS  Unary minus for LTI models.
%
%   MSYS = UMINUS(SYS) is invoked by MSYS = -SYS.
%
%   See also MINUS, LTIMODELS.

%       Author(s): A. Potvin, 3-1-94
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1998/02/12 22:28:24 $

% Effect on other properties: none

sys.k = -sys.k;

