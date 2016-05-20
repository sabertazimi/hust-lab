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

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/10/01 20:12:29 $

ni = nargin;
no = nargout;
if ~isa(sys,'zpk'),
   % Call built-in SET. Handles calls like set(gcf,'user',zpk)
   builtin('set',sys,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(SYS) or SET(SYS,Property).');
end

% Get all public ZPK properties and their assignable values
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
      disp(sprintf('\nType "ltiprops zpk" for more details.'))
   end
   return

elseif ni==2,
   % SET(SYS,'Property') or STR = SET(SYS,'Property')
   Property = varargin{1};
   if ~isstr(Property),
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
if isempty(sysname),
   error('First argument to SET must be a named variable.')
elseif rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end
zpkflag = 0;
SetVar = 0;
SetTs = 0;
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
   case 'z'
      if isa(Value,'double'),  Value = {Value};  end
      sys.z = Value;   
      zpkflag = zpkflag + 1;
      
   case 'p'
      if isa(Value,'double'),  Value = {Value};  end
      sys.p = Value;
      zpkflag = zpkflag + 1;
      
   case 'k'
      sys.k = Value;
      zpkflag = zpkflag + 1;
      
   case 'variable'
      if ~isstr(Value),
         error('Property "Variable" must be set to a string.');
      elseif isempty(strmatch(Value,{'s';'p';'z';'z^-1';'q'},'exact')),
         error('Invalid value for property "Variable"');
      end
      OldVar = sys.Variable;
      sys.Variable = Value;
      SetVar = 1;
      
   otherwise
      try
         set(L,PropStr,Value)
      catch
         error(lasterr)
      end
      SetTs = SetTs | strcmp(PropStr,'ts');
   end % switch
end % for



% EXIT CHECKS:
% (1) Variable vs. Sampling time:
var = sys.Variable;
sp = strcmp(var,'s') | strcmp(var,'p');
Ts = getst(L); 

if Ts==0 & ~sp,
   % First conflicting case: Ts = 0 with Variable 'z', 'z^-1', or 'q'
   if ~SetTs,
      % Variable 'z', 'q', 'z^-1' used to mean "discrete". Set Ts to -1
      set(L,'Ts',-1)
   else
      % Ts explicitly set to zero: reset Variable to default 's'
      sys.Variable = 's';
      if SetVar,
         warning(['Variable ' var ' inappropriate for continuous systems.'])
      end
   end

elseif Ts~=0 & sp,
   % Second conflicting case: nonzero Ts with Variable 's' or 'p'
   sys.Variable = 'z';   % default
   if SetVar,
      % Variable was set to 's' or 'p': revert to old value if adequate
      warning(['Variable ' var ' inappropriate for discrete systems.'])
      if ~isempty(strmatch(OldVar,{'z';'z^-1';'q'},'exact')),
         sys.Variable = OldVar;
      end
   end
end

% (2) Z,P,K consistency
try 
   sys = zpkcheck(sys,zpkflag);
catch
   error(lasterr)
end

% (3) Check LTI property consistency
try
   sys.lti = lticheck(L,size(sys.k));
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
