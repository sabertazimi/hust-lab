function Out = set(InitRespObj,varargin)
%SET  Set properties of Response Object RESPOBJ.
%
%   SET(RESPOBJ,'Property',VALUE)  sets the property of RESPOBJspecified
%   by the string 'Property' to the value VALUE.
%
%   SET(RESPOBJ,'Property1',Value1,'Property2',Value2,...)  sets multiple 
%   Response Object property values with a single statement.
%
%   SET(RESPOBJ,'Property')  displays possible values for the specified
%   property of RESPOBJ.
%
%   SET(RESPOBJ)  displays all properties of RESPOBJand their admissible 
%   values.
%
%   Note:  Resetting the sampling time does not alter the state-space
%          matrices.  Use C2D or D2D for conversion purposes.
%
%   See also  GET, SS, TF, ZPK.
% $Revision: 1.4 $

%       Author(s): A. Potvin, 3-1-94
%       Revised: P. Gahinet, 4-1-96
%       Revised for Response Objects: K. Gondoly, 1-5-98
%       Copyright (c) 1986-98 by The MathWorks, Inc.

ni = nargin;
no = nargout;
if ~isa(InitRespObj,'response'),
   % Call built-in SET. 
   builtin('set',InitRespObj,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(InitRespObj) or SET(InitRespObj,Property)');
end

% Get properties and their admissible values when needed
if ni>1,  flag = 'lower';  else flag = 'true';  end
if ni<=2,
   [AllProps,AsgnValues] = pnames(InitRespObj,flag);
else
   AllProps = pnames(InitRespObj,flag);
end

% Handle read-only cases
if ni==1,
   % SET(StepRespObj) or S = SET(InitRespObj)
   if no,
      Out = cell2struct(AsgnValues,AllProps,1);
   else
      pvpdisp(AllProps,AsgnValues,':  ')
   end
   return

elseif ni==2,
   % SET(InitRespObj,'Property') or STR = SET(InitRespObj,'Property')
   Property = varargin{1};
   if ~isstr(Property),
      error('Property names must be single-line strings,')
   end
   
   % Return admissible property value(s)
   imatch = find(strncmpi(Property,AllProps,length(Property)));
   if isempty(imatch),
      error(['Invalid property name "' Property '".']);
   elseif length(imatch)>1,
      lenProp = zeros(size(imatch));
      for ct=1:length(imatch),
         lenProp(ct) = length(AllProps{imatch(ct)});
      end
      % Always take the property with the shortest name
      [garb,ind_imatch]=min(lenProp); 
      imatch = imatch(ind_imatch);
   end
   error(status)
   if no,
      Out = AsgnValues{imatch};
   else
      disp(AsgnValues{imatch})
   end
   return

end

% Now left with SET(InitRespObj,'Prop1',Value1, ...)
name = inputname(1);
if rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end

ContextMenu = get(InitRespObj,'UicontextMenu');
RespObj = InitRespObj.response;
RespObjProp = [];

for i=1:2:ni-1,
   % Set each PV pair in turn
   Property = varargin{i};
   imatch = find(strncmpi(Property,AllProps,length(Property)));
   if isempty(imatch),
      error(['Invalid property name "' Property '".']);
   elseif length(imatch)>1,
      lenProp = zeros(size(imatch));
      for ct=1:length(imatch),
         lenProp(ct) = length(AllProps{imatch(ct)});
      end
      % Always take the property with the shortest name
      [garb,ind_imatch]=min(lenProp); 
      imatch = imatch(ind_imatch);
   end
   Property = AllProps{imatch};
   Value = varargin{i+1};
   
   switch Property
      
   case 'peakresponse',
      OldVal = InitRespObj.PeakResponse;
      InitRespObj.PeakResponse = Value;
      set(ContextMenu.PlotOptions.PeakResponse,'Checked',Value);
      InitRespObj = respfcn('showpeak',InitRespObj);
      
   case 'peakresponsevalue',
      InitRespObj.PeakResponseValue = Value;
            
   otherwise,
      %---Do all properties, at once. To ensure proper Limit selections, etc.
      RespObjProp=[RespObjProp,i,i+1];
   end % switch Property
end % for i

if ~isempty(RespObjProp)
   set(RespObj,varargin{RespObjProp});
   InitRespObj.response = RespObj;
end

% Make sure Response and UIcontextMenu have latest Initial Condition Response Object
set(ContextMenu.Main,'UserData',InitRespObj);

% Finally, assign sys in caller's workspace
if ~isempty(name),
   assignin('caller',name,InitRespObj)
end

% end ../@icplot/set.m
