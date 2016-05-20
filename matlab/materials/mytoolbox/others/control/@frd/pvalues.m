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
%       $Revision: 1.2 $  $Date: 1998/10/01 20:12:31 $

ni = nargin;

% Get all FRD-specific public properties and their values
FRDPropNames = pnames(sys,'specific');
FRDPropValues = struct2cell(sys);

if ni==2 & ischar(Property),
   % Value of single property
   % First look among FRD-specific properties
   imatch = find(strcmp(Property,FRDPropNames));
   
   if isempty(imatch),
      % Look among parent properties
      Value = pvalues(sys.lti,Property);
   else
      % FRD specific property
      Value = FRDPropValues{imatch};
   end
   
else
   % Return all public property values
   Value = [FRDPropValues(1:length(FRDPropNames)) ; pvalues(sys.lti)];
   if ni==2,
      Value = pvpdisp(Value);
   end
end
