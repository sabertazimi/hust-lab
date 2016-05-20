function Value = get(sys,Property)
%GET  Access/query LTI property values.
%
%   VALUE = GET(SYS,'PropertyName') returns the value of the 
%   specified property of the LTI model SYS.  An equivalent
%   syntax is 
%       VALUE = SYS.PropertyName .
%   
%   GET(SYS) displays all properties of SYS and their values.  
%   Type HELP LTIPROPS for more detail on LTI properties.
%
%   See also SET, TFDATA, ZPKDATA, SSDATA, LTIMODELS, LTIPROPS.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.11 $  $Date: 1998/10/01 20:12:28 $

% Generic GET method for all LTI children.
% Uses the object-specific methods PNAMES and PVALUES
% to get the list of all public properties and their
% values (PNAMES and PVALUES must be defined for each 
% particular child object)

ni = nargin;
error(nargchk(1,2,ni));

if ni==2,
   % GET(SYS,'Property') or GET(SYS,{'Prop1','Prop2',...})
   if ischar(Property),
      PropList = 0;
      Property = {Property};
   elseif iscellstr(Property),
      PropList = 1;
      Property = Property(:);
   else
      error('Property name must be a string or a cell vector of strings.')
   end
   
   % Get all public properties, add obsolete property Td
   AllProps = [pnames(sys) ; {'Td'}];
   
   % Loop over each queried property 
   Nq = length(Property); 
   Value = cell(1,Nq);
   for i=1:Nq,
      % Find matches for k-th property name
      % RE: Must include all properties to detect multiple hits
      imatch = find(strncmpi(Property{i},AllProps,length(Property{i})));
      % Error if no hit or multiple hits
      error(PropMatchCheck(length(imatch),Property{i}));
      % Get property value
      try
         Value{i} = pvalues(sys,AllProps{imatch});
      catch
         error(lasterr)
      end
   end
   
   % Strip cell header if PROPERTY was a string
   if ~PropList,
      Value = Value{1};
   end

elseif nargout,
   % STRUCT = GET(SYS)
   Value = cell2struct(pvalues(sys),pnames(sys),1);
   
else
   % GET(SYS)
   disp(pvpdisp(pnames(sys),pvalues(sys,0)))

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subfunction PropMatchCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function errmsg = PropMatchCheck(nhits,Property)
% Issues a standardized error message when the property name 
% PROPERTY is not uniquely matched
if nhits==1,
   errmsg = '';
elseif nhits==0,
   errmsg = ['Invalid property name "' Property '".']; 
elseif nhits>1
   errmsg = ['Ambiguous property name "' Property '". Supply more characters.'];
end


        
   
   
