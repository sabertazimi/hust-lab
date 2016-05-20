function boo = isstatic(sys)
%ISSTATIC  True for static gains
%
%   ISSTATIC(SYS) returns 1 (true) if the LTI model SYS is a 
%   static gain, and 0 (false) otherwise.
%
%   For LTI arrays, ISSTATIC(SYS) is true if all models in the
%   array are static gains.
%
%   See also POLE, ZERO.

%      Author: P. Gahinet, 5-23-97
%      Copyright (c) 1986-98 by The MathWorks, Inc.
%      $Revision: 1.4 $  $Date: 1998/02/12 19:56:00 $

% SYS is a static gain if it has dynamics and 
% no time delays
if isempty(sys.a) & isstatic(sys.lti),
   boo = 1;
else
   boo = 0;
end

