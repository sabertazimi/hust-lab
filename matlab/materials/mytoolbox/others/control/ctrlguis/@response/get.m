function Value = get(RespObj,Property)
%GET  Access/query Response Object property values.
%
%   VALUE = GET(RespObj,'Property')  returns the value of the specified
%   property of the Response Object RespObj.
%
%   See also  SET

%       Copyright (c) 1986-98 by The MathWorks, Inc.

ni = nargin;
error(nargchk(1,2,ni));

% Get all public properties and their values
if ni>1, flag = 'lower'; else flag = 'true'; end
AllProps = pnames(RespObj,flag);
AllValues = pvalues(RespObj);
AllProps = AllProps(1:length(AllValues)); % Remove private properties

% Handle various cases
if ni==2,
   if isstr(Property)
      % GET(RespObj,'Property')
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
      
      Value = AllValues{imatch};
      %---If the Value for any of the Plot Options is empty, calculate it.
      if any(strcmpi(AllProps{imatch},{'peakresponsevalue';'risetimevalue'; ...
               'stabilitymarginvalue';'settlingtimevalue'})),
         C = cell(length(Value),1);
         [C{:}]=deal(Value.System);
         if size(strvcat(C{:}),1)<length(C), % Some systems not entered,
            Value = calcopt(AllProps{imatch},RespObj);
            ContextMenu = RespObj.UIContextMenu;
            set(RespObj,AllProps{imatch},Value)
            set(ContextMenu.Main,'UserData',RespObj);
         end % if size
      end % if isempty(Value)...
   else
      % GET(RespObj,{'Prop1','Prop2',...})
      np = prod(size(Property));
      Value = cell(1,np);
      for i=1:np,
         imatch = find(strncmpi(Property{i},AllProps,length(Property{i})));
         if isempty(imatch),
            error(['Invalid property name "' Property{i} '".']);
         elseif length(imatch)>1,
            lenProp = zeros(size(imatch));
            for ct=1:length(imatch),
               lenProp(ct) = length(AllProps{imatch(ct)});
            end
            % Always take the property with the shortest name
            [garb,ind_imatch]=min(lenProp); 
         	imatch = imatch(ind_imatch);   
         end
         Value{i} = AllValues{imatch};
         if isempty(Value{i}) & ...
               any(strcmpi(AllProps{imatch},{'peakresponsevalue';'risetimevalue'; ...
                  'stabilitymarginsvalues';'settlingtimevalue'})),
            C = cell(length(Value{i}),1);
            [C{:}]=deal(Value{i}.System);
            if size(strvcat(C{:}),1)<length(C), % Some systems not entered,
               Value{i} = calcopt(AllProps{imatch},RespObj);
               ContextMenu = get(RespObj,'UIcontextMenu');
               set(RespObj,AllProps{imatch},Value);   
               set(ContextMenu.Main,'UserData',RespObj);
            end
         end % if isempty(Value)...
      end
   end
   
elseif nargout,
   % STRUCT = GET(RespObj)
   Value = cell2struct(AllValues,AllProps,1);
   
else
   % GET(RespObj)
   pvpdisp(AllProps,AllValues,' = ');
   
end

% end response/get.m
