function DispStr = pvpdisp(varargin)
%PVPDISP  Displays all property names and values.
%
%   VALSTR = PVPDISP(VALUES) formats the property value 
%   information.
%
%   DISPSTR = PVPDISP(PROPS,VALUES) returns the character
%   array to be displayed by GET(SYS).

%       Author(s): A. Potvin, 3-29-95, P. Gahinet, 7-9-96
%       Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%       $Revision: 1.8 $  $Date: 1999/01/05 12:09:07 $

sep = ': ';
pad = blanks(3);
too_big_constant = 50;

if nargin==1,
   % Build property value display
   Values = varargin{1};
   Nprops = length(Values);
   DispStr = cell(Nprops,1);
   
   for i=1:Nprops,
      val = Values{i};
      
      % Only display row vectors (string or double) or 1x1 cell thereof
      cellflag = 0;
      if isa(val,'cell') & isequal(size(val),[1 1]),
         val1 = val{1};
         if (isstr(val1) | isa(val1,'double')) & ndims(val1)==2 & size(val1,1)<=1,
            val = val1;
            cellflag = 1;
         end
      end
      
      if isstr(val) & ndims(val)==2 & size(val,1)<=1 & size(val,2)<too_big_constant,
         val_str = ['''' val ''''];
      elseif isa(val,'double') & ndims(val)==2 & ...
            (isempty(val) | (size(val,1)<=1 & size(val,2)<too_big_constant)),
         if isempty(val) & ~isequal(size(val),[0 0]),
            val_str = sprintf('[%dx%d double]',size(val,1),size(val,2));
         else
            val_str = mat2str(val,3);
         end
      elseif isa(val,'cell') & isempty(val),
         if isequal(size(val),[0 0]),
            val_str = '{}';
         else
            val_str = sprintf('{%dx%d cell}',size(val,1),size(val,2));
         end
      else
         % Too big to be displayed
         val_str = sprintf('%dx',size(val));
         val_str = [val_str(1:end-1) ' ' class(val)];
         if isa(val,'cell'),
            val_str = ['{' val_str '}'];
         else
            val_str = ['[' val_str ']'];
         end
      end
      
      if cellflag,  
         val_str = ['{' val_str '}'];  
      end
      
      DispStr{i} = [val_str];
   end
   
else
   % Build display for GET(SYS) and SET(SYS)
   [Props,Vals] = deal(varargin{:});
   Nprops = length(Props);
   pad = pad(ones(1,Nprops),:);
   sep = sep(ones(1,Nprops),:);
   
   DispStr = [pad strjust(char(Props),'right') sep strjust(char(Vals),'left')];
end

