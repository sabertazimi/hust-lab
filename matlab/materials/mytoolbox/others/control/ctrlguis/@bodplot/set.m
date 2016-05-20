function Out = set(BodeRespObj,varargin)
%SET  Set properties of Bode Response Object RESPOBJ.
%
%   SET(RESPOBJ,'Property',VALUE)  sets the property of RESPOBJ specified
%   by the string 'Property' to the value VALUE.
%
%   SET(RESPOBJ,'Property1',Value1,'Property2',Value2,...) sets multiple 
%   Response Object property values with a single statement.
%
%   SET(RESPOBJ,'Property') displays possible values for the specified
%   property of RESPOBJ.
%
%   SET(RESPOBJ)  displays all properties of RESPOBJ and their admissible 
%   values.
%
%   Note:  Resetting the sampling time does not alter the state-space
%          matrices.  Use C2D or D2D for conversion purposes.
%
%   See also  GET, SS, TF, ZPK.
% $Revision: 1.5 $

%       Author(s): A. Potvin, 3-1-94
%       Revised: P. Gahinet, 4-1-96
%       Revised for Response Objects: K. Gondoly, 1-5-98
%       Copyright (c) 1986-98 by The MathWorks, Inc.

ni = nargin;
no = nargout;
if ~isa(BodeRespObj,'response'),
   % Call built-in SET. Handles calls like set(gcf,'user',ss)
   builtin('set',BodeRespObj,varargin{:});
   return
elseif no & ni>2,
   error('Output argument allowed only in SET(BodeRespObj) or SET(BodeRespObj,Property)');
end

% Get properties and their admissible values when needed
if ni>1,  flag = 'lower';  else flag = 'true';  end
if ni<=2,
   [AllProps,AsgnValues] = pnames(BodeRespObj,flag);
else
   AllProps = pnames(BodeRespObj,flag);
end

% Handle read-only cases
if ni==1,
   % SET(BodeRespObj) or S = SET(BodeRespObj)
   if no,
      Out = cell2struct(AsgnValues,AllProps,1);
   else
      pvpdisp(AllProps,AsgnValues,':  ')
   end
   return
   
elseif ni==2,
   % SET(BodeRespObj,'Property') or STR = SET(BodeRespObj,'Property')
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
   if no,
      Out = AsgnValues{imatch};
   else
      disp(AsgnValues{imatch})
   end
   return
   
end

% Now left with SET(BodeRespObj,'Prop1',Value1, ...)
name = inputname(1);
if rem(ni-1,2)~=0,
   error('Property/value pairs must come in even number.')
end

ContextMenu = get(BodeRespObj,'UicontextMenu');
RespObj = BodeRespObj.response;
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
   Property = lower(AllProps{imatch});
   Value = varargin{i+1};
   if ischar(Value),
      Value = lower(Value);
   end
   
   switch Property
      
   case 'magnitudeunits',
      if isempty(strmatch(Value,{'decibels';'absolute';'logrithmic'})),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         OldUnit = BodeRespObj.MagnitudeUnits;
         BodeRespObj.MagnitudeUnits = Value;
         if ~strcmp(OldUnit,Value)
            BodeRespObj = newunits(BodeRespObj,'magnitude',OldUnit);
         end
      end
      
   case 'peakresponse',
      if isempty(strmatch(Value,{'on';'off'})) | ...
            length(strmatch(Value,{'on';'off'}))>1,
         error(['Bad value for response property: ''',Property,'''.'])
      else
         BodeRespObj.PeakResponse = Value;
         set(ContextMenu.PlotOptions.PeakResponse,'Checked',Value);
         BodeRespObj = respfcn('showpeak',BodeRespObj);
      end
      
   case 'peakresponsevalue',
      BodeRespObj.PeakResponseValue = Value;
      
   case 'phaseunits',
      if isempty(strmatch(Value,{'degrees';'radians'})),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         OldUnit = BodeRespObj.PhaseUnits;
         BodeRespObj.PhaseUnits = Value;
         if ~strcmp(OldUnit,Value)
            BodeRespObj = newunits(BodeRespObj,'phase',OldUnit);
         end
      end
         
   case 'stabilitymargin',
      if isempty(strmatch(Value,{'on';'off'})) | ... 
            length(strmatch(Value,{'on';'off'}))>1,
         error(['Bad value for response property: ''',Property,'''.'])
      else
         BodeRespObj.StabilityMargin = Value;
         set(ContextMenu.PlotOptions.StabilityMargin,'Checked',Value);
         BodeRespObj = respfcn('showmargin',BodeRespObj);
      end
      
   case 'stabilitymarginvalue',
      BodeRespObj.StabilityMarginValue = Value;
      
   case 'frequencyunits',
      if isempty(strmatch(Value,{'hertz';'hz';'radianspersecond';'rad/s'})),
         error(['Bad value for response property: ''',Property,'''.'])
      else
         OldUnit = BodeRespObj.FrequencyUnits;
         BodeRespObj.FrequencyUnits = Value;
         if ~strcmp(OldUnit,Value)
            BodeRespObj = newunits(BodeRespObj,'frequency',OldUnit);
         end
      end
      
   otherwise,
      %---Do all properties, at once. To ensure proper Limit selections, etc.
      RespObjProp=[RespObjProp,i,i+1];
   end % switch Property
end % for i

if ~isempty(RespObjProp)
   set(RespObj,varargin{RespObjProp});
   BodeRespObj.response = RespObj;
end

% Make sure Response and UIcontextMenu have latest Bode Response Object
set(ContextMenu.Main,'UserData',BodeRespObj);

% Finally, assign sys in caller's workspace
if ~isempty(name),
   assignin('caller',name,BodeRespObj)
end

% end ../@bodplot/set.m
