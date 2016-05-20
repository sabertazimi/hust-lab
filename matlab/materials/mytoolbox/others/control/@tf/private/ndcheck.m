function sys = ndcheck(sys,ndchange)
%NDCHECK  Checks the validity and consistency of numerator and 
%         denominator values NUM and DEN.

%   Author: P. Gahinet, 5-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/07/28 12:59:44 $

if ~ndchange,
   return
end

% Make sure both NUM and DEN are cell arrays
if isa(sys.num,'double'), 
   % TF([1 0],[2 0]):  NUM should be a row vector
   if ndims(sys.num)>2,
      error('NUM must be a row vector (for SISO) or a cell array of row vectors.')
   end
   sys.num = {sys.num};
end
if isa(sys.den,'double'), 
   % TF(NUM,[1 0]) (common denominator)
   den0 = sys.den;
   if ndims(den0)>2,
      error('DEN must be a row vector (for SISO) or a cell array of row vectors.')
   end
   sys.den = cell(size(sys.num));
   sys.den(:) = {den0};
end

% Get sizes
snum = size(sys.num);  ndnum = length(snum);
sden = size(sys.den);  ndden = length(sden);
Resizable = [(ndnum==2 & ndden>2)  (ndden==2 & ndnum>2)];

% Check dimension consistency
if ~isequal(snum(1:2),sden(1:2)) | ...
      (~any(Resizable) & ~isequal(snum(3:end),sden(3:end))),
   errmsg = 'Cell arrays NUM and DEN must have matching dimensions.';
   if ndchange<2,  % only NUM or DEN modified
      errmsg = sprintf('%s\n%s',errmsg, ...
         'Use SET(SYS,''num'',NUM,''den'',DEN) to modify input/output dimensions');
   end
   error(errmsg)
elseif Resizable(1),
   % NUM is 2D and DEN is ND: replicate NUM
   sys.num = repmat(sys.num,[1 1 sden(3:end)]);
elseif Resizable(2)
   % DEN is 2D and NUM is ND: replicate NUM
   sys.den = repmat(sys.den,[1 1 snum(3:end)]);
end

% Check that all elements of NUM and DEN are row vectors
num = sys.num(:);
den = sys.den(:);
if ~all(cellfun('isclass',num,'double')) | ...
      ~all(cellfun('isreal',num)),
   error('Numerator array NUM must contain real numbers.')
elseif ~all(cellfun('isclass',den,'double')) | ...
      ~all(cellfun('isreal',den)),
   error('Denominator array DEN must contain real numbers.')
elseif any(cellfun('ndims',num)>2) | ...
      any(cellfun('ndims',den)>2) | ...
      any(cellfun('isempty',num)) | ...
      any(cellfun('isempty',den)) | ...
      any(cellfun('size',num,1)~=1) | ...
      any(cellfun('size',den,1)~=1),
   if length(num)==1,
      error('NUM and DEN must be non-empty row vectors.') 
   else
      error('NUM and DEN must be cell arrays of non-empty row vectors.') 
   end 
end

% Denominators should be nonzero
for k = 1:length(num),
   if ~any(den{k}),
      error('DEN must consist of nonzero vectors')
   end
end



   