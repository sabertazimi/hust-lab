function Value = get(ViewerObj,Property)
%GET  Access/query LTI Viewer Object property values.
%
%   VALUE = GET(ViewerObj,'Property') returns the value of the specified
%   property of the LTI Viewer Object ViewerObj.
%
%   See also  SET
% $Revision: 1.2 $

%       Copyright (c) 1986-98 by The MathWorks, Inc.

ni = nargin;
error(nargchk(1,2,ni));

% Get all public properties and their values
if ni>1, flag = 'lower'; else flag = 'true'; end
AllProps = pnames(ViewerObj,flag);
AllValues = pvalues(ViewerObj);
AllProps = AllProps(1:length(AllValues)); % Remove private properties

% Handle various cases
if ni==2,
   if isstr(Property)
      % GET(ViewerObj,'Property')
      imatch = strmatch(lower(Property),AllProps);
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
   else
      % GET(ViewerObj,{'Prop1','Prop2',...})
      np = prod(size(Property));
      Value = cell(1,np);
      for i=1:np,
         imatch = strmatch(lower(Property{i}),AllProps);
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
      end
   end
   
elseif nargout,
   % STRUCT = GET(ViewerObj)
   Value = cell2struct(AllValues,AllProps,1);
   
else
   % GET(ViewerObj)
   pvpdisp(AllProps,AllValues,' = ');
   
end

% end viewgui/get.m
