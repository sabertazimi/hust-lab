function boo = isproper(sys)
%ISPROPER  True for proper LTI systems.
%
%   ISPROPER(SYS) returns 1 (true) if the LTI model SYS is proper 
%   (relative degree<=0), and 0 (false) otherwise.  If SYS is an
%   array of LTI models, ISPROPER(SYS) is true if all models are
%   proper.
%
%   See also ISSISO, ISEMPTY, LTIMODELS.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/02/12 22:28:11 $

boo=1;

