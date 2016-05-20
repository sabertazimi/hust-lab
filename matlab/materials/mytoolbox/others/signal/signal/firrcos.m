function [b,a]=firrcos(varargin)
%FIRRCOS Raised Cosine FIR Filter design.
%   B=FIRRCOS(N,F0,DF,Fs) returns an order N low pass linear phase FIR 
%   filter with a raised cosine transition band.  The filter has cutoff
%   frequency F0, sampling frequency Fs and transition bandwidth DF 
%   (all in Hz).
%
%   F0 +/- DF/2 must be in the range [0,Fs/2].    
%
%   The coefficients of B are normalized so that the nominal passband 
%   gain is always equal to one.
%
%   FIRRCOS(N,F0,DF) uses a default sampling frequency of Fs = 2.
%
%   B=FIRRCOS(N,F0,R,Fs,'rolloff') interprets the third argument as the
%   rolloff factor instead of as a transition bandwidth.
%
%   R must be in the range [0,1].
%
%   B=FIRRCOS(N,F0,DF,Fs,TYPE) or B=FIRRCOS(N,F0,R,Fs,'rolloff',TYPE) 
%   will design a regular FIR raised cosine filter when TYPE is 
%   'normal' or set to an empty matrix. If TYPE is 'sqrt', B is the 
%   square root FIR raised cosine filter.
%
%   B=FIRRCOS(...,TYPE,DELAY) allows for a variable integer delay to be 
%   specified. When omitted or left empty, DELAY defaults to N/2 or
%   (N+1)/2 depending on whether N is even or odd.
%
%   DELAY must be an integer in the range [0, N+1]
%
%   B=FIRRCOS(...,DELAY,WINDOW) applies a length N+1 window to the 
%   designed filter in order to reduce the ripple in the frequency 
%   response. WINDOW must be a N+1 long column vector. If no window
%   is specified a boxcar (rectangular) window is used.
%
%   WARNING: Care must be exercised when using a window with a delay
%   other than the default.
%
%   [B,A]=FIRRCOS(...) will always return A = 1.
%
%   See also FIRLS, FIR1, FIR2.

%   Author(s): R. Losada and D. Orofino
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/06/17 20:33:49 $

error(nargchk(3,8,nargin));
N = varargin{1}+1;
if round(N) ~= N,
   error('Order must be an integer')
end

fc = varargin{2};
if fc <= 0,
   error('Cutoff frequency must be greater than zero')
end

R = varargin{3};  % DF or R

% If optional arguments are not passed, substitute with empty:
for i = nargin+1:8,
   varargin{i}=[];
end

arg5opts = {'rolloff','sqrt','normal'};
% map 5th arg to one of 3 possible choices:
if isempty(varargin{5}),
   varargin{5} = arg5opts{3};
else
   idx = strmatch(lower(varargin{5}), arg5opts);
   if isempty(idx) | length(idx)>1,
      error('Argument 5 is unknown - must be one of: rolloff, sqrt, or normal');
   end
   varargin{5} = arg5opts{idx};
end

% Apply defaults as appropriate:
%
% Set up default values
fs     = 2;
type   = arg5opts{3};
if rem(N,2),
   delay  = (N-1)/2;
else
   delay = N/2;
end

window = [];


% Setup arg translation:
params = {'fs','type','delay','window'};
is_rolloff = strcmp(varargin{5},'rolloff');
if is_rolloff,
   xlat = [4 6:8];
else
   xlat = 4:7;
end
% Override defaults when needed:
for i=1:length(xlat),
   arg = varargin{xlat(i)};
   if ~isempty(arg),
   	 eval([params{i} '=arg;']);
   end
end

% Check for validity of fs
if ischar(fs),
   error('Fs must be a number');
end


% Fill in defaults if empty matrices are passed:
if is_rolloff,
   % check if input arguments are valid 
   if R < 0 | R > 1,
      error('R must satisfy 0 <= R <= 1');
   end
   % check for range of input arguments
   if fc - R.*fc < 0 | fc + R.*fc > fs/2
      error('F0 +/- F0*R must satisfy 0 <= F0 +/- F0*R <= Fs/2');
   end
else % sqrt or normal
   % check for range of input arguments
   if fc - R/2 < 0 | fc + R/2 > fs/2
      error('F0 +/- DF/2 must satisfy 0 <= F0 +/- DF/2 <= Fs/2');
   end
   % interpret third argument as a bandwidth and convert to rolloff:
   R = R / (2*fc);
end

if delay < 0 | delay > N
   error('DELAY must be in the range [0, N+1]');
elseif round(delay) ~= delay
   error('DELAY must be an integer');
end

% R is now always a rolloff factor - DF has been converted
if R == 0,
   R = realmin;
end

%n = -delay/fs : 1/fs : (N-delay-1)/fs;
n = ((0:N-1)-delay) ./ fs;

if is_rolloff, % 6th argument, if present, is type
   arg6opts = {'sqrt','normal'};
   % map 6th arg to one of 2 possible choices:
   if isempty(varargin{6}),
      type = arg6opts{2};
   else
      idx = strmatch(lower(varargin{6}), arg6opts);
      if isempty(idx) | length(idx)>1,
         error('Argument 6 is unknown - must be one of:sqrt, normal or []');
      end
      type = arg6opts{idx};
   end
end
   
switch type
case 'normal'   %normal raised cosine design
   
   ind1 = find(abs(4.*R.*fc.*n) ~= 1.0);
   if ~isempty(ind1),
      nind = n(ind1);
      b(ind1) =  sinc(2.*fc.*nind)./fs   ...
              .* cos(2.*pi.*R.*fc.*nind) ...
              ./ (1.0 - (4.*R.*fc.*nind).^2);
   end
   
   ind = 1:length(n);
   ind(ind1) = [];
   b(ind) = R ./ (2.*fs) .* sin(pi ./ (2.*R));

   b = 2.*fc.*b;

case 'sqrt'						 % square root raised cosine design
   
   ind1 = find(n == 0);
   if ~isempty(ind1),
      b(ind1) = - sqrt(2.*fc) ./ (pi.*fs) .* (pi.*(R-1) - 4.*R );
   end
   
   ind2 = find(abs(8.*R.*fc.*n) == 1.0);
   if ~isempty(ind2),
      b(ind2) = sqrt(2.*fc) ./ (2.*pi.*fs) ...
         * (    pi.*(R+1)  .* sin(pi.*(R+1)./(4.*R)) ...
                - 4.*R     .* sin(pi.*(R-1)./(4.*R)) ...
              + pi.*(R-1)  .* cos(pi.*(R-1)./(4.*R)) ...
           );
   end

   ind = 1:length(n);
   ind([ind1 ind2]) = [];
   nind = n(ind);
   
   b(ind) = -4.*R./fs .* ( cos((1+R).*2.*pi.*fc.*nind) + ...
                        sin((1-R).*2.*pi.*fc.*nind) ./ (8.*R.*fc.*nind) ) ...
            ./ (pi .* sqrt(1./(2.*fc)) .* ((8.*R.*fc.*nind).^2 - 1));
   
   b = sqrt(2.*fc) .* b;
   
end

if ~isempty(window),
   if length(window) ~= N,
      error('WINDOW must be of the same length as the filter');
   else
      b = b .* window(:).';
   end
end

if nargout > 1
   a = 1.0;
end
