function [a,error_str] = cstrchk(a,Name)
%CSTRCHK Determines if argument is a vector cell of single line strings.
% $Revision: 1.1 $

%	P. Gahinet 5-1-96
%  Copied to @response/cstrchk: K. Gondoly - 1-5-98
%	Copyright (c) 1986-98 by The MathWorks, Inc.

error_str = '';
if isempty(a),  
   return
end

if ndims(a)>2 | (~isstr(a) & ~isa(a,'cell')),
   error_str = sprintf([Name ...
     ' must be a 2D array of padded strings (like [''a'' ; ''b'' ; ''c''])\n' ...
     'or a cell vector of strings (like {''a'' ; ''b'' ; ''c''}).']);
   return
elseif isstr(a),
   % A is a 2D array of paded strings
   a = cellstr(a);
else
   % A is a cell array
   if min(size(a))>1,
      error_str = [Name ' must be a cell vector of strings (like {''a'' ; ''b'' ; ''c''}).'];
      return
   end
   a = a(:);
   for k=1:length(a),
      str = a{k};
      if isempty(str), 
         a{k} = '';
      elseif ~isstr(str) | ndims(str)>2 | size(str,1)>1,
         error_str = ['All cell entries of ' Name ' must be single-line strings'];
         return
      end
   end
end

% end cstrchk
