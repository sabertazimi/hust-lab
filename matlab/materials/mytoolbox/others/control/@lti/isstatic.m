function boo = isstatic(L)
%ISSTATIC  True for static gains
%
%   ISSTATIC(SYS.LTI) returns 1 if the LTI parent SYS.LTI has
%   no time delays.
%
%   See also TF/ISSTATIC.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/04/14 21:10:21 $

boo = ~any(L.ioDelayMatrix(:)) & ~any(L.InputDelay(:)) & ...
      ~any(L.OutputDelay(:));
