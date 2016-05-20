function boo = isempty(sys)
%ISEMPTY  True for empty LTI models.
%
%   ISEMPTY(SYS) returns 1 (true) if the LTI model SYS has 
%   no input or no output, and 0 otherwise.
%
%   For LTI arrays, ISEMPTY(SYS) is true if the array has
%   empty dimensions, or the LTI models themselves are empty.
%
%   See also SIZE, ISSISO, LTIMODELS.
 
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.6 $  $Date: 1998/02/12 22:28:19 $

boo = any(size(sys)==0);

