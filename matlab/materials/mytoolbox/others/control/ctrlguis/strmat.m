function val = strmat(str);
%STRMAT Convert string to double precision matrix
%   N = STRMAT(STR) converts a string STR into a double precision
%   matrix N. The string may be delimited by blanks, commas,
%   or semi-colons. The string may also be surrounded by square
%   brackets, but does not have to be enclosed in brackets.
%
%   N is always returned as a row vector, regardless of the type
%   of delimiter used. 
%  
%   If the string STR does not represent a valid matrix value,
%   STRMAT(S) returns NaN.
%
%   Examples
%      N = strmat('2,3')
%      N2 = strmat('2;3')
%      N3 = strmat('[2 3]')

%   Karen D. Gondoly
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.2 $  $Date: 1999/01/05 15:21:07 $

error(nargchk(1,1,nargin));

%---First, check for any letters and automatically return.
if any(isletter(str)),
   val=NaN;
	return   
end

%---Find all brackets
indOpenBrac = findstr(str,'[');
indCloseBrac = findstr(str,']');

if (length(indOpenBrac)>1 | length(indCloseBrac)>1) | ...   
      (~isempty(indCloseBrac) & ~isequal(indCloseBrac,length(str))) | ...
      (isempty(indOpenBrac) & ~isempty(indCloseBrac)) | ...
      (~isempty(indOpenBrac) & isempty(indCloseBrac)),
   %---Too many brackets, close bracket not at end, or one bracket
   %    is empty when the other is present
   val=NaN;
   return
elseif ~isempty(indOpenBrac) & ~isempty(indCloseBrac),
   %---Parce out brackets
   str = str(indOpenBrac+1:indCloseBrac-1);   
end

%---Find all blanks, commas, and semicolons 
indDelim = sort([findstr(str,' '),findstr(str,','),findstr(str,';')]);
indDelim = [0,indDelim,length(str)+1];

val = zeros(1,length(indDelim)-1);
s=0;
for ctDelim = 1:length(indDelim)-1,
   %---Make sure two delimiters aren't next to each other
   if ~isequal(diff([indDelim(ctDelim) indDelim(ctDelim+1)]),1),
      s=s+1;
      val(s) = str2double(str(indDelim(ctDelim)+1:indDelim(ctDelim+1)-1));
   end
   val = val(1:s);
end % for ctDelim
if any(isnan(val)),
   val=NaN;
end
