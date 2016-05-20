function y = medfilt1(x,n,blksz)
%MEDFILT1  One dimensional median filter.
%   Y = MEDFILT1(X,N) returns the output of the order N, one dimensional 
%   median filtering of vector X.  Y is the same length as X; for the edge
%   points, zeros are assumed to the left and right of X. 
%
%   For N odd, Y(k) is the median of X( k-(N-1)/2 : k+(N-1)/2 ).
%   For N even, Y(k) is the median of X( k-N/2 : k+N/2-1 ).
%
%   If you do not specify N, MEDFILT1 uses a default of N = 3.
%
%   MEDFILT1(X,N,BLKSZ) uses a for-loop to compute BLKSZ ("block size") 
%   output samples at a time.  Use this option with BLKSZ << LENGTH(X) if 
%   you are low on memory (MEDFILT1 uses a working matrix of size
%   N x BLKSZ).  By default, BLKSZ == LENGTH(X); this is the fastest
%   execution if you have the memory for it.
%
%   See also MEDIAN, FILTER, SGOLAYFILT, and MEDFILT2 in the Image
%   Processing Toolbox.


%   Author(s): L. Shure and T. Krauss, 8-3-93
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.2 $  $Date: 1998/07/13 19:02:12 $

if nargin < 2
   n = 3;
end
if all(size(x) > 1)
    nx = size(x,1);
    if nargin < 3
        blksz = nx;    % default: one big block (block size = length(x))
    end
    y = zeros(size(x));
    for i = 1:size(x,2)
        y(:,i) = medfilt1(x(:,i),n,blksz);
    end
    return
end
nx = length(x);
if nargin < 3
    blksz = nx;    % default: one big block (block size = length(x))
end
if rem(n,2)~=1    % n even
    m = n/2;
else
    m = (n-1)/2;
end
X = [zeros(1,m) x(:)' zeros(1,m)];
y = zeros(1,nx);
% Work in chunks to save memory
indr = (0:n-1)';
indc = 1:nx;
for i=1:blksz:nx
    ind = indc(ones(1,n),i:min(i+blksz-1,nx)) + ...
          indr(:,ones(1,min(i+blksz-1,nx)-i+1));
    xx = reshape(X(ind),n,min(i+blksz-1,nx)-i+1);
    y(i:min(i+blksz-1,nx)) = median(xx);
end

% transpose if necessary
if size(x,2) == 1  % if x is a column vector ...
    y = y.';
end

