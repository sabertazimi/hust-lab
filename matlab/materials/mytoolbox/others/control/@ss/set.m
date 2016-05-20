function Out = set(sys,varargin)
%SET  Set properties of LTI models.
%
%   SET(SYS,'PropertyName',VALUE) sets the property 'PropertyName'
%   of the LTI model SYS to the value VALUE.  An equivalent syntax 
%   is 
%       SYS.PropertyName = VALUE .
%
%   SET(SYS,'Property1',Value1,'Property2',Value2,...) sets multiple 
%   LTI property values with a single statement.
%
%   SET(SYS,'Property') displays legitimate values for the specified
%   property of SYS.
%
%   SET(SYS) displays all properties of SYS and their admissible 
%   values.  Type HELP LTIPROPS for more details on LTI properties.
%
%   Note: Resetting the sampling time does not alter the model data.
%         Use C2D or D2D for conversions between the continuous and 
%         discrete domains.
%
%   See also GET, LTIMODELS, LTIPROPS.

%   Author(s): A. Potvin, P. Gahinet, 4-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/10/01 20:12:28 $

ni = nargin;
no = nargout;
if ~isa(sys,'ss'),
   % Call built-in SET. Handles calls like set(gcf,'user',ss)
   builtin('set',sys,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(SYS) or SET(SYS,Property).');
end

% Get public SS properties and their assignable values
if ni<=2,
   [AllProps,AsgnValues] = pnames(sys);
else
   % Add obsolete property Td   
   AllProps = [pnames(sys) ; {'Td'}];
end


% Handle read-only cases
if ni==1,
   % SET(SYS) or S = SET(SYS)
   if no,
      Out = cell2struct(AsgnValues,AllProps,1);
   else
      disp(pvpdisp(AllProps,AsgnValues))
      disp(sprintf('\nType "ltiprops ss" for more details.'))
   end
   return

elseif ni==2,
   % SET(SYS,'Property') or STR = SET(SYS,'Property')
   Property = varargin{1};
   if ~ischar(Property) | size(Property,1)>1,
      error('Property names must be single-line strings,')
   end

   % Return admissible property value(s)
   imatch = find(strncmpi(Property,AllProps,length(Property)));
   error(PropMatchCheck(length(imatch),Property));
   if no,
      Out = AsgnValues{imatch};
   else
      disp(AsgnValues{imatch})
   end
   return

end


% Now left with SET(SYS,'Prop1',Value1, ...)
abcdex = zeros(1,6);  % keeps track of which state-space matrices are reset
sysname = inputname(1);
if isempty(sysname),
   error('First argument to SET must be a named variable.')
elseif rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end
L = sys.lti;

for i=1:2:ni-1,
   % Set each Property Name/Value pair in turn. 
   PropStr = varargin{i};
   Value = varargin{i+1};
   if ~ischar(PropStr) | size(PropStr,1)>1,
      error('Property names must be single-line strings.')
   end
   
   % Match specified property name against list of public SS properties
   % RE: Include all properties to appropriately detect multiple matches
   imatch = find(strncmpi(PropStr,AllProps,length(PropStr)));
   if isempty(imatch) & strcmpi(PropStr,'nx'),
      % REVISIT: delete when Nx is gone
      PropStr = 'nx';
   else
      error(PropMatchCheck(length(imatch),PropStr));
      PropStr = lower(AllProps{imatch});
   end
   
   % Perform assignment
   switch PropStr
   case 'a'
      sys.a = Value;
      abcdex(1) = 1;
      
   case 'b'
      sys.b = Value;
      abcdex(2) = 1;
      
   case 'c'
      sys.c = Value;
      abcdex(3) = 1;
      
   case 'd'
      sys.d = Value;
      abcdex(4) = 1;
      
   case 'e'
      sys.e = Value;
      abcdex(5) = 1;
      
   case 'statename',
      [Value,errmsg] = StateNameCheck(Value);
      error(errmsg);
      sys.StateName = Value;
      
   case 'nx'
      sys.Nx = Value;
      abcdex(6) = 1;
      
   otherwise
      try
         set(L,PropStr,Value)
      catch
         error(lasterr)
      end
   end % switch
end % for


% EXIT CHECKS:
%%%%%%%%%%%%%%

% Check consistency of A,B,C,D,E
try 
   sys = abcdechk(sys,abcdex);
catch
   error(lasterr)
end

% Check length of state name
ns = size(sys.a,1);
Sname = sys.StateName;
if length(Sname)~=ns,
   if isempty(Sname) | isequal('',Sname{:}),
      EmptyStr = {''};
      sys.StateName = EmptyStr(ones(ns,1),1);
   else
      error('Invalid system: length of StateName does not match number of states.')
   end
end

% Check LTI property consistency
try
   sys.lti = lticheck(L,size(sys.d));
catch
   error(lasterr)
end

% Finally, assign sys in caller's workspace
assignin('caller',sysname,sys)



% Subfunction StateNameCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a,errmsg] = StateNameCheck(a)
% Checks specified I/O names
errmsg = '';
if isempty(a),  
   a = a(:);   % make 0x1
   return  
end

% Determine if first argument is an array or cell vector 
% of single-line strings.
if ischar(a) & ndims(a)==2,
   % A is a 2D array of padded strings
   a = cellstr(a);
   
elseif iscellstr(a) & ndims(a)==2 & min(size(a))==1,
   % A is a cell vector of strings. Check that each entry
   % is a single-line string
   a = a(:);
   if any(cellfun('ndims',a)>2) | any(cellfun('size',a,1)>1),
      errmsg = 'All cell entries of StateName must be single-line strings.';
   end
   
else
   errmsg = sprintf([ ...
     'StateName must be set to a 2D array of padded strings (like [''a'' ; ''b'' ; ''c''])\n' ...
     'or a cell vector of strings (like {''a'' ; ''b'' ; ''c''}).']);

end


% subfunction PropMatchCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%
function errmsg = PropMatchCheck(nhits,Property)
% Issues a standardized error message when the property name 
% PROPERTY is not uniquely matched.

if nhits==1,
   errmsg = '';
elseif nhits==0,
   errmsg = ['Invalid property name "' Property '".']; 
else
   errmsg = ['Ambiguous property name "' Property '". Supply more characters.'];
end
