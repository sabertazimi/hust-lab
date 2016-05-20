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
%   $Revision: 1.14 $ $Date: 1998/10/01 20:12:28 $

ni = nargin;
no = nargout;
if ~isa(sys,'lti'),
   % Call built-in SET. Handles calls like set(gcf,'user',ss)
   builtin('set',sys,varargin{:});
   return
end

% Get properties and their admissible values when needed
if ni<=2,
   [AllProps,AsgnValues] = pnames(sys);
else
   AllProps = pnames(sys);
end


% Handle read-only cases
if ni==1,
   % SET(SYS) or S = SET(SYS)
   if no,
      Out = cell2struct(AsgnValues,AllProps,1);
   else
      pvpdisp(AllProps,AsgnValues)
   end
   return

elseif ni==2,
   % SET(SYS,'Property') or STR = SET(SYS,'Property')
   Property = varargin{1};
   if ~ischar(Property),
      error('Property names must be single-line strings.')
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
   
elseif rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end


% Now left with SET(SYS,'Prop1',Value1, ...)
for i=1:2:ni-1,
   % Set each PV pair in turn
   PropStr = varargin{i};
   if ~isstr(PropStr),
      error('Property names must be single-line strings.')
   elseif strcmp(lower(PropStr),'td'),
      % Trap for obsolete TD property
      PropStr = 'inputdelay';
      warning(sprintf([...
            'LTI property TD is obsolete. Use ''InputDelay'' or ''ioDelayMatrix''.\n         ' ...
            'See LTIPROPS for details.']))
   end
   
   imatch = find(strncmpi(PropStr,AllProps,length(PropStr)));
   error(PropMatchCheck(length(imatch),PropStr));
   Property = lower(AllProps{imatch});
   Value = varargin{i+1};
   
   switch Property      
   case 'inputdelay',
      if ~isreal(Value) | ~all(isfinite(Value(:))) | any(Value(:)<0),
         error('Input delay times must be non negative numbers.')
      end
      sys.InputDelay = Value;
         
   case 'outputdelay',
      if ~isreal(Value) | ~all(isfinite(Value(:))) | any(Value(:)<0),
         error('Output delay times must be non negative numbers.')
      end
      sys.OutputDelay = Value;
         
   case 'iodelaymatrix'
      if ~isreal(Value) | ~all(isfinite(Value(:))) | any(Value(:)<0),
         error('I/O delay times must be non negative numbers.')
      end
      sys.ioDelayMatrix = Value;

   case 'ts'
      if isempty(Value),  
         Value = -1;  
      end
      if ndims(Value)>2 | length(Value)~=1 | ~isreal(Value) | ~isfinite(Value),
         error('Sample time must be a real number.')
      elseif Value<0 & Value~=-1,
         error('Negative sample time not allowed (except Ts=-1 to mean unspecified).');
      end
      sys.Ts = Value;

   case 'inputname'
      [sys.InputName,errmsg] = ChannelNameCheck(Value,'InputName');
      error(errmsg);
 
   case 'outputname'
      [sys.OutputName,errmsg] = ChannelNameCheck(Value,'OutputName');
      error(errmsg);
       
   case 'inputgroup'
      [sys.InputGroup,errmsg] = GroupCheck(Value,'InputGroup');
      error(errmsg);
      
   case 'outputgroup'
      [sys.OutputGroup,errmsg] = GroupCheck(Value,'OutputGroup');
      error(errmsg);

   case 'notes'
      if isstr(Value),  Value = {Value};  end
      sys.Notes = Value;

   case 'userdata'
      sys.UserData = Value;

   otherwise
      % This should not happen
      error('Unexpected property name.')

   end % switch
end % for


if nargout,
   Out = sys;
else
   % Assign sys in caller's workspace
   if isempty(inputname(1)),
      error('First argument to SET must be a named variable.')
   end
   assignin('caller',inputname(1),sys)
end

% Note: size consistency checks deferred to LTICHECK in ss/set, tf/set,...
%       to allow resizing of the I/O dimensions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subfunction ChannelNameCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a,errmsg] = ChannelNameCheck(a,Name)
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
      errmsg = ['All cell entries of ' Name ' must be single-line strings.'];
      return
   end
   
else
   errmsg = sprintf([Name ...
     ' must be a 2D array of padded strings (like [''a'' ; ''b'' ; ''c''])\n' ...
     '  or a cell vector of strings (like {''a'' ; ''b'' ; ''c''}).']);
   return
end

% Make sure that nonempty I/O names are unique
as = sortrows(char(a));
repeat = (any(as~=' ',2) & all(as==strvcat(as(2:end,:),' '),2));
if any(repeat),
   errmsg = [Name ': channel names must be unique.'];
end

   
% subfunction GroupCheck
%%%%%%%%%%%%%%%%%%%%%%%%
function [a,errmsg] = GroupCheck(a,Name)
% Checks specified I/O groups

errmsg = '';
info = sprintf(['%s must be a two-column cell array where each row\n' ...
           '  specifies one I/O group (set of channels + group name)'],Name);
          
% Basic checks
if isempty(a)
   a = cell(0,2);   return
elseif ~iscell(a) | ndims(a)>2,
   errmsg = info;   return
elseif size(a,1)==1 & (size(a,2)<2 | ~isstr(a{1,2}))
   % Row vector of cells with only channel indices
   a = a(:);
end

% Turn into an M-by-2 cell array
[nr,nc] = size(a);
if nc==1,
   % Group names are unspecified
   EmptyStr = {''};
   a = [a , EmptyStr(ones(1,nr),1)];
elseif nc>2,
   errmsg = info;   return
end

% Check that the second column contains single-line strings
% RE: checking of channel indices is deferred to LTICHECK
GroupNames = a(:,2);
if ~iscellstr(GroupNames) | ...
      any(cellfun('ndims',GroupNames)>2) | ...
      any(cellfun('size',GroupNames,1)>1),
   errmsg = [Name ': group names must be single-line strings.'];
   return
end

% Check that nonempty group names are unique
if nc==2,
   as = sortrows(char(a(:,2)));
   repeat = (any(as~=' ',2) & all(as==strvcat(as(2:end,:),' '),2));
   if any(repeat),
      errmsg = [Name ': group names must be unique.'];
   end
end


% subfunction PropMatchCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
