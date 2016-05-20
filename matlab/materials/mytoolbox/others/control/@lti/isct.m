function boo = isct(sys)
%ISCT  True for continuous-time LTI models.
%
%   ISCT(SYS) returns 1 (true) if the LTI model SYS is continuous
%   (zero sampling time), and 0 (false) otherwise.
%
%   See also ISDT, LTIMODELS.

%   Author(s): P. Gahinet, 1-4-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/02/12 22:28:20 $

% SYS is continuous if Ts = 0
boo = (get(sys,'Ts')==0);

