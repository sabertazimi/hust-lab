function [c,lags] = xcorr(a, b, maxlag, option)
%XCORR Cross-correlation function estimates.
%   C = XCORR(A,B), where A and B are length M vectors (M>1), returns
%   the length 2*M-1 cross-correlation sequence C. If A and B are of
%   different length, the shortest one is zero-padded.  C will be a
%   row vector if A is a row vector, and a column vector if A is a 
%   column vector.
%
%   XCORR(A), when A is a vector, is the auto-correlation sequence.   
%   XCORR(A), when A is an M-by-N matrix, is a large matrix with
%   2*M-1 rows whose N^2 columns contain the cross-correlation
%   sequences for all combinations of the columns of A.
%   The zeroth lag of the output correlation is in the middle of the 
%   sequence, at element or row M.
%
%   XCORR(A,B,MAXLAG) computes the cross-correlation over the
%   range of lags:  -MAXLAG to MAXLAG, i.e., 2*MAXLAG+1 lags.
%   XCORR(A,MAXLAG) computes the auto-correlation over the
%   range of lags.   If missing, default is MAXLAG = M-1.
%
%   [C,LAGS] = XCORR  returns a vector of lag indices (LAGS).
%
%   XCORR(A,'flag'), XCORR(A,B,'flag') or XCORR(A,B,MAXLAG,'flag') 
%   normalizes the correlation according to 'flag':
%       biased   - scales the raw cross-correlation by 1/M.
%       unbiased - scales the raw correlation by 1/(M-abs(lags))
%       coeff    - normalizes the sequence so that the auto-correlations
%                  at zero lag are identically 1.0.
%       none     - no scaling (this is the default).
%
%   See also XCOV, CORRCOEF, CONV, COV and XCORR2.

%   Author(s): L. Shure, 1-9-88
%   	   L. Shure, 4-13-92, revised
%   	   J. McClellan, 9-13-95, revised for maxlag
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/09/04 14:44:10 $ 
%
%   References:
%     [1] J.S. Bendat and A.G. Piersol, "Random Data:
%         Analysis and Measurement Procedures", John Wiley
%         and Sons, 1971, p.332.
%     [2] A.V. Oppenheim and R.W. Schafer, Digital Signal 
%         Processing, Prentice-Hall, 1975, pg 539.

error(nargchk(1,4,nargin))
if  length(a)<=1,
   error('1st input argument must be a vector or matrix.')
end
onearray = 0;
if  nargin == 1
   b = [];  maxlag = [];  option = 'none';
elseif  nargin == 2
   maxlag = [];  option = 'none';
   if  isstr(b)
      option = b;  b=[];   % normalization flag passed
   elseif  length(b)==1,
      maxlag = b; b = [];  % xcorr(A,MAXLAG)
   end
elseif  nargin == 3
   option = 'none';
   if  isstr(b)
      error('argument list not in correct order')
   end
   if  length(b)>1
      if isstr(maxlag), option = maxlag; maxlag = []; end
   elseif length(b)<=1
      if isstr(maxlag), option = maxlag;  maxlag = b;  b = []; end
   end
end

if  length(b)==1 & length(maxlag)==1
   error('3rd arg is maxlag, 2nd arg cannot be scalar')
end
if  length(maxlag)>1
   error('maxlag must be a scalar')
end
if  isempty(option)
   option = 'none';
end
option = lower(option);

[ar,ac] = size(a);
La = ar;
if  ar==1,  La = ac;  end
Lb = length(b);
if  Lb>1
   if La ~= Lb & ~strcmp(option,'none')
      error('OPTION must be ''none'' for different length vectors A and B')
   end
   if min(size(a))==1 & min(size(b))==1
      onearray = 2;   %-- do just one cross-correlation
      if La > Lb
         b(La) = 0;
      elseif La < Lb
         a(Lb) = 0;
      end
      a = [a(:) b(:)];
   elseif min(size(b))>1
      error('B must be a vector (min(size(B))==1).')
   else
      error('When B is a vector, A must be a vector.')
   end
end

% at this point b is guarenteed to be a vector or an empty matrix

if size(a,1)==1  &  Lb==0   % a is a row vector
   a = a(:);
end
if  isempty(maxlag)
   maxlag = size(a,1)-1;
end

% check validity of option
nopt = nan;
if  strcmp(option, 'none')
   nopt = 0;
elseif  strcmp(option, 'coeff')
   nopt = 1;
elseif  strcmp(option, 'biased')
   nopt = 2;
elseif  strcmp(option, 'unbiased')
   nopt = 3;
end
if isnan(nopt)
   error('Unknown OPTION')
end
[nr, nc] = size(a);
nsq  = nc^2;
mr = 2 * maxlag + 1;
nfft = 2^nextpow2(mr);
nsects = ceil(2*nr/nfft);
if nsects>4 & nfft<64
   nfft = min(4096,max(64,2^nextpow2(nr/4)));
end

pp = 1:nc;
n1 = pp(ones(nc,1),:);  n2 = n1';
aindx = n1(:)';   bindx = n2(:)';

c = zeros(nfft,nsq);
minus1 = (-1).^(0:nfft-1)' * ones(1,nc);
af_old = zeros(nfft,nc);
n1 = 1;
nfft2 = nfft/2;
while( n1 < nr )
   n2 = min( n1+nfft2-1, nr );
   af = fft(a(n1:n2,:), nfft);
   c = c + af(:,aindx).* conj( af(:,bindx) + af_old(:,bindx) );
   af_old = minus1.*af;
   n1 = n1 + nfft2;
end;
if  n1==nr
   af = ones(nfft,1)*a(nr,:);
   c = c + af(:,aindx).* conj( af(:,bindx) + af_old(:,bindx) );
end
c = ifft(c);

jkl = reshape(1:nsq,nc,nc)';
mxlp1 = maxlag+1;
c = [ conj(c(mxlp1:-1:2,:)); c(1:mxlp1,jkl(:))];

if nopt == 1	% return normalized by sqrt of each autocorrelation at 0 lag
   % do column arithmetic to get correct autocorrelations
   tmp = sqrt(c(mxlp1,diag(jkl)));
   tmp = tmp(:)*tmp;
   cdiv = ones(mr,1)*tmp(:).';
   c = c ./ cdiv;
elseif nopt == 2	% biased result, i.e. divide by nr for each element
   c = c / nr;
elseif nopt == 3	% unbiased result, i.e. divide by nr-abs(lag)
   c = c ./ ([nr-maxlag:nr (nr-1):-1:nr-maxlag]' * ones(1,nsq));
end

if onearray==2
   c = c(:,2);
end
if ar == 1              % make output a row, same as input
   c = c.';
end
if ~any(any(imag(a)))
   c = real(c);
end
lags = -maxlag:maxlag;

% make sure that the zero lag autocorrelation is always real

if min([ar ac])>1  % A is a matrix in this case
    c(maxlag+1,1+[0:ac-1]*(ac+1)) = real(c(maxlag+1,1+[0:ac-1]*(ac+1)));
elseif isequal(a(:,1),b(:)) | isempty(b) % A is a vector
    c(maxlag+1) = real(c(maxlag+1));
end
