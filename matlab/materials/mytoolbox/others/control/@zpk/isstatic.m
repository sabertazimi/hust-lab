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
%      $Revision: 1.4 $  $Date: 1998/02/12 22:28:23 $

% A static gain must be delay free
boo = isstatic(sys.lti);

% In addition, SYS must have no poles nor zeros
if boo,
   for k=1:prod(size(sys.k)),
      if ~isempty(sys.z{k}) | ~isempty(sys.p{k}),
         boo = 0;
         return
      end
   end
end

