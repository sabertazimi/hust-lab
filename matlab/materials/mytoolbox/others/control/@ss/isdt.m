function boo = isdt(sys)
%ISDT  Check if LTI model is discrete time.
%
%   ISDT(SYS) returns 1 (true) if the LTI model SYS is 
%   discrete, 0 (false) otherwise.  ISDT always returns 1 
%   for empty systems or static gains.
%
%   See also ISCT.

%       Author(s): P. Gahinet, 5-1-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1998/02/12 19:56:01 $

% SYS is discrete if Ts ~= 0
boo = (getst(sys.lti) | isempty(sys.a));

