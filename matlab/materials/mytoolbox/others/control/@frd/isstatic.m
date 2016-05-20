function static = isstatic(sys)
%ISSTATIC  True for static gains
%
%   ISSTATIC(SYS) returns 1 (true) if the LTI model SYS is a 
%   static gain, and 0 (false) otherwise.
%
%   For LTI arrays, ISSTATIC(SYS) is true if all models in the
%   array are static gains.
%
%   See also POLE, ZERO.

%      Author: S. Almy
%      Copyright (c) 1986-98 by The MathWorks, Inc.
%      $Revision: 1.1 $  $Date: 1998/04/14 21:40:35 $


% A static gain must be delay free
static = isstatic(sys.lti);

% static gain must have constant real response
% Test for real value in first ResponseData element,
% then check that all are equal ( consequently, real too )
if static
   FRData = sys.ResponseData;
   if size(FRData,3) & ~isreal(FRData(:,:,1,:))
      static = 0;
   else
      difference = diff(FRData,1,3);
      static = ~any(difference(:));
   end
end
