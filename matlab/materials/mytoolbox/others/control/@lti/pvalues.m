function Value = pvalues(sys,Property)
%PVALUES  Get values of public LTI properties.
%
%   VALUE = PVALUES(SYS,PROPERTY) returns the value of the
%   single property with name PROPERTY.
%
%   VALUES = PVALUES(SYS) returns all public values as a cell
%   vector.
%
%   VALSTR = PVALUES(SYS,0) returns the property value info
%   to be displayed by GET(SYS).
%
%   See also GET.

%       Author(s): P. Gahinet, 7-8-97
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.5 $  $Date: 1998/10/01 20:12:28 $

ni = nargin;

% Get all public properties and their values
% RE: Private properties always come last
LTIPropNames = pnames(sys);
LTIPropValues = struct2cell(sys);

if ni==2 & ischar(Property),
   % Value of single property
   if strcmp(Property,'Td'),
      % Obsolete Td property
      warning(sprintf([...
            'LTI property TD is obsolete. Use ''InputDelay'' or ''ioDelayMatrix''.\n         ' ...
            'See LTIPROPS for details.']))
      if sys.Ts,
         Value = [];
      else
         Value = sys.InputDelay';
      end
   else
      % Public LTI properties
      Value = LTIPropValues{find(strcmp(Property,LTIPropNames))};
   end
   
else
   % Return all public property values
   Value = LTIPropValues(1:length(LTIPropNames));
   
   if ni==2,
      % Return value display for GET(SYS)
      Value = pvpdisp(Value);
   end
end
