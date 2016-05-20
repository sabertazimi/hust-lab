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

%      Author: P. Gahinet, 5-1-96
%      Copyright (c) 1986-98 by The MathWorks, Inc.
%      $Revision: 1.4 $  $Date: 1998/02/12 22:28:14 $


% A static gain must be delay free
boo = isstatic(sys.lti);

% In addition, SYS must have no poles nor zeros
% RE: since common leading zeros are removed from 
%     NUM,DEN, this amounts to both having length 1.
if boo,
   for k=1:prod(size(sys.num)),
      if length(sys.num{k})>1 | length(sys.den{k})>1,
         boo = 0;
         return
      end
   end
end
