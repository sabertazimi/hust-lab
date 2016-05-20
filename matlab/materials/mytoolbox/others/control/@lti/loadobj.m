function sys = loadobj(s)
% LOADOBJ  Load filter for LTI objects

%   Author(s): G. Wolodkin, P. Gahinet, 4-17-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/10/01 20:12:42 $

if isa(s,'lti')
  sys = s;
  return
end

ny = length(s.OutputName);
nu = length(s.InputName);
ts = s.Ts;

sys = lti(ny,nu,ts);

switch s.Version
case 1
  if any(s.Td)
    sys.InputDelay = s.Td';
  end
  sys.InputName    = s.InputName;
  sys.OutputName   = s.OutputName;
  sys.Notes        = s.Notes;
  sys.UserData     = s.UserData;
  
end
  
