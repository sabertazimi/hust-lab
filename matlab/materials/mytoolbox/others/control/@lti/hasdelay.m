function boo = hasdelay(sys)
%HASDELAY  True for LTI models with time delays.
%
%   HASDELAY(SYS) returns 1 (true) if the LTI model SYS has input, 
%   output, or I/O delays.
%
%   See also TOTALDELAY, DELAY2Z, LTIPROPS.

%   Author(s):  P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/05/06 17:07:07 $


% Check for delays
if any(sys.ioDelayMatrix(:)) | ...
      any(sys.InputDelay(:)) | ...
      any(sys.OutputDelay(:)),
   boo = 1;
else
   boo = 0;
end

