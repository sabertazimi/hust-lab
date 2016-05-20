function y=sgolayfilt(x,k,F,varargin)
%SGOLAYFILT Savitzky-Golay Filtering.
%   SGOLAYFILT(X,K,F) smoothes the signal X using a Savitzky-Golay 
%   (polynomial) smoothing filter.  The polynomial order, K, must
%   be less than the frame size, F, and F must be odd.  The length 
%   of the input X must be >= F.  If X is a matrix, the filtering
%   is done on the columns of X.
%
%   Note that if the polynomial order K equals F-1, no smoothing
%   will occur.
%
%   SGOLAYFILT(X,K,F,W) specifies a weighting vector W with length F
%   containing real, positive valued weights employed during the
%   least-squares minimization.
%
%   See also SGOLAY, MEDFILT1, FILTER

%   References:
%     [1] Sophocles J. Orfanidis, INTRODUCTION TO SIGNAL PROCESSING,
%              Prentice-Hall, 1995, Chapter 8.

%   Author(s): R. Losada
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/07/21 11:53:16 $

error(nargchk(3,4,nargin));

% Check if the input arguments are valid
if round(F) ~= F, error('Frame length must be an integer.'), end
if rem(F,2) ~= 1, error('Frame length must be odd.'), end
if round(k) ~= k, error('Polynomial degree must be an integer.'), end
if k > F-1, error('The degree must be less than the frame length.'), end
[mx,nx]=size(x);
if mx == 1,
   x = x(:);
   nrows = nx;
   ncols = 1;
else
   nrows = mx;
   ncols = nx;
end
if nrows < F, error('The length of the input must be >= frame length.'), end

if nargin < 4,
   % No weighting matrix, make W an identity
   W = ones(F,1);
else
   W = varargin{1};
   % Check for right length of W
   if length(W) ~= F, error('The weight vector must be have the same length as the frame length.'),end
   % Check to see if all elements are positive
   if min(W) <= 0, error('All the elements of the weight vector must be greater than zero.'), end
end

% Compute the projection matrix B
B = sgolay(k,F,W);

% Compute smoothing result for each signal column:
for col=1:ncols,
   % Compute the transient on
   wit = flipud(x(1:F,col));
   yit = flipud(B((F-1)./2+1:end,:))*wit;
   
   % Compute the steady state output
   
   [xb,z] = buffer(x(:,col), F, F-1, 'nodelay'); % Buffer the input
   xb = xb(:,2:end-1);                 % Take the part used for steady state
   yss = (B((F-1)./2+1,:)*xb).';       % Compute the steady state output
   
   % Compute the transient off
   wot = flipud(x(end-(F-1):end,col));
   yot = flipud(B(1:(F-1)./2+1,:))*wot;
   
   % Form the total output
   y(:,col) = [yit;yss;yot];
   
end


