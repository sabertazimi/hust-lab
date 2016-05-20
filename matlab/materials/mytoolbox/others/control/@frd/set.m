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

%   Author(s): A. Potvin, P. Gahinet, S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 1998/10/01 20:12:29 $

ni = nargin;
no = nargout;
if ~isa(sys,'frd'),
   % Call built-in SET. Handles calls like set(gcf,'user',frd)
   builtin('set',sys,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(SYS) or SET(SYS,Property).');
end

% Get all public FRD properties and their assignable values
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
      disp(sprintf('\nType "ltiprops frd" for more details.'))
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
sysname = inputname(1);
errFlag = 1;
if isempty(sysname),
   error('First argument to SET must be a named variable.')
elseif rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end
valueChange = 0;
unitsChanged = 0;
freqChanged = 0;
L = sys.lti;

for i=1:2:ni-1,
   % Set each Property Name/Value pair in turn. 
   PropStr = varargin{i};
   Value = varargin{i+1};
   if ~ischar(PropStr) | size(PropStr,1)>1,
      error('Property names must be single-line strings.')
   end
    
   % Match specified property name against list of TF properties
   imatch = find(strncmpi(PropStr,AllProps,length(PropStr)));
   error(PropMatchCheck(length(imatch),PropStr));
   
   % Perform assignment
   PropStr = lower(AllProps{imatch});
   switch PropStr
   case 'frequency'
      if ~isa(Value,'double')
         error('The property "Frequency" must be set to a vector of doubles.');
      end
      sys.Frequency = Value;   
      valueChange = valueChange + 1;
      freqChanged = 1;
      
   case 'responsedata'
      if ~isa(Value,'double')
         error('The property "ResponseData" must be set to an array of doubles.');
      end
      sys.ResponseData = Value;
      valueChange = valueChange + 2;
      
   case 'units'
      if ~isstr(Value),
         error('The property "Units" must be set to a string.');
      elseif strncmpi(Value,'r',1)
         sys.Units = 'rad/s';
      elseif strncmpi(Value,'h',1)
         sys.Units = 'Hz';
      else
         error('"Units" property must be either ''rad/s'' or ''Hz''');
      end
      unitsChanged = 1;
      
   otherwise
      try
         set(L,PropStr,Value)
      catch
         error(lasterr)
      end      
   end % switch
end % for


% EXIT CHECKS:

% FREQ value/units check
if unitsChanged & ~freqChanged & errFlag
   warning(sprintf('%s\n%s','''Units'' property changed. To convert FRD Units and', ...
      'automatically scale frequency points, use CHGUNITS instead.'));
end

% FREQ/RESPONSEDATA check
if valueChange,
   try 
      sys = frdcheck(sys,valueChange);
   catch
      error(lasterr)
   end
end

% Check LTI property consistency
try
   sizes = size(sys.ResponseData);
   sys.lti = lticheck(L,[sizes(1:2) sizes(4:end)]);
catch
   error(lasterr)
end

% Finally, assign sys in caller's workspace
assignin('caller',sysname,sys)



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
