function sys = loadobj(s)
%LOADOBJ  Load filter for SS objects

%   Author(s): G. Wolodkin 4-17-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/04/29 18:31:30 $

if isa(s,'ss')
  sys = s;
  return
end

% Create object of latest version
sys = ss(s.a,s.b,s.c,s.d,s.lti);
sys.e = s.e;
sys.StateName = s.StateName;

