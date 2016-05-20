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
%       $Revision: 1.5 $  $Date: 1998/10/01 20:12:27 $

ni = nargin;

% Get all SS-specific public properties and their values
SSPropNames = pnames(sys,'specific');
SSPropValues = struct2cell(sys);

if ni==2 & ischar(Property),
   % Value of single property
   % First look among SS-specific properties
   imatch = find(strcmp(Property,SSPropNames));
   
   if isempty(imatch),
      % Must be a parent property
      Value = pvalues(sys.lti,Property);
   else
      % SS specific property
      Value = SSPropValues{imatch};
      
      % Post-processing for A,B,C
      if length(sys.Nx)>1 & ...
            (any(strcmp(Property,{'a' 'b' 'c'})) | ...
             (size(sys.e,1) & strcmp(Property,'e'))),
         % A,B,C,E cannot be represented as ND arrays
         error(sprintf('Cannot get or set %s directly when models have different numbers of states.\n%s\n%s',...
            upper(Property),...
            'To extract state matrices as cell arrays, use [a,b,c]=ssdata(sys,''cell'').',...
            'To modify the data, use assignments of the form sys(:,:,k).a=anew.'))
      end
   end
   
else
   % Return all public property values
   Value = [SSPropValues(1:length(SSPropNames)) ; pvalues(sys.lti)];
   if ni==2,
      Value = pvpdisp(Value);
   end
   
   % Post-processing when state dimension is non uniform
   if length(sys.Nx)>1,
      ArraySizes = size(sys.Nx);   
      ne = size(sys.e,1);
      if ni==1,
         % Convert A,B,C,E to cell arrays if state dimension varies 
         a = cell(ArraySizes);
         b = cell(ArraySizes);
         c = cell(ArraySizes);
         e = cell(ArraySizes);
         for k=1:prod(ArraySizes),
            nx = sys.Nx(k);
            a{k} = sys.a(1:nx,1:nx,k);
            b{k} = sys.b(1:nx,:,k);
            c{k} = sys.c(:,1:nx,k);
            e{k} = sys.e(1:min(ne,nx),1:min(ne,nx),k);
         end
         Value(1:3) = {a;b;c};
         if ne, 
            Value(5) = {e};
         end
      else
         % Update the corresponding value info
         Value{1} = sprintf('A matrices (varying size)');
         Value{2} = sprintf('B matrices (varying size)');
         Value{3} = sprintf('C matrices (varying size)');
         if ne,
            Value{5} = sprintf('E matrices (varying size)');
         end
      end   
   end
end
