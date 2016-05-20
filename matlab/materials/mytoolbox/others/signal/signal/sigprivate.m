function varargout = sigprivate(varargin)
%SIGPRIVATE This function allows access to the functions in the private directory.
%        SIGPRIVATE('FOO',ARG1,ARG2,...) is the same as
%        FOO(ARG1,ARG2,...).  
%
%     Copyright (c) 1988-98 by The MathWorks, Inc.
%     $Revision: 1.2 $  $Date: 1998/06/24 22:59:39 $

if (nargout == 0)
  feval(varargin{:});
else
  [varargout{1:nargout}] = feval(varargin{:});
end
