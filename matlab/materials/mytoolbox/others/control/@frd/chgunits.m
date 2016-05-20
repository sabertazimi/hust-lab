function sys = chgunits(sys,newUnits)
%CHGUNITS  Change frequency units of an FRD model.
%
%   SYS = CHGUNITS(SYS,UNITS) changes the units of the frequency
%   points stored in the FRD model SYS to UNITS, where UNITS
%   is either 'Hz or 'rad/s'.  A 2*pi scaling factor is applied
%   to the frequency values and the 'Units' property is updated.
%   If the 'Units' field already matches UNITS, no action is taken.
%
%   See also FRD, SET, GET.

%       Author(s): S. Almy
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1998/08/25 22:08:25 $

if ~ischar(newUnits)
   error('Second argument to CHGUNITS must be a UNITS string');
elseif ~strncmpi(sys.Units,newUnits,1)
   if strncmpi(newUnits,'h',1)
      sys.Units = 'Hz';
      sys.Frequency = sys.Frequency / (2*pi);
   elseif strncmpi(newUnits,'r',1)
      sys.Units = 'rad/s';
      sys.Frequency = sys.Frequency * (2*pi);
   else
      error('Unrecognized UNITS string.');
   end
end

