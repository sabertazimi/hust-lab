function Ts = getst(sys)
%GETST  Fast access to sample time of LTI models
%
%   TS = GETST(SYS) returns the sample time of the
%   LTI object SYS.
%
%   See also GET.

%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.1 $  $Date: 1998/02/12 19:55:33 $

Ts = sys.Ts;