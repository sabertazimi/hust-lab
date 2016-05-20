function varargout = pmem( xR, p, nfft, Fs, flag )
%PMEM   Power Spectrum estimate via MEM (Maximum Entropy Method).
%   Pxx = PMEM(X,ORDER,NFFT) is the Power Spectral Density estimate of signal 
%   vector X using the MEM method. ORDER is the model order of the AR model 
%   equations. NFFT is the FFT length which determines the frequency grid.
%   If X is a data matrix, each column is interpreted as a separate 
%   sensor measurement or trial.  Pxx is length (NFFT/2+1) for NFFT even, 
%   (NFFT+1)/2 for NFFT odd, and NFFT if X is complex.  NFFT is optional;
%   it defaults to 256.
%
%   [Pxx,F] = PMEM(X,ORDER,NFFT,Fs) returns a vector of frequencies at which
%   the PSD is estimated, where Fs is the sampling frequency.  Fs defaults to
%   2 Hz.
%
%   PMEM(X,ORDER,'corr'), PMEM(X,ORDER,NFFT,'corr') and 
%   PMEM(X,ORDER,NFFT,Fs,'corr') is the PSD of the process with correlation
%   matrix X.  X must be square.
%
%   [Pxx,F,A] = PMEM(X,ORDER,NFFT) returns the vector A of model coefficients
%   on which Pxx is based.
%
%   PMEM with no output arguments plots the PSD in the next available figure.
%
%   You can obtain a default parameter by inserting an empty matrix [],
%   e.g., PMEM(X,8,400,[],'corr').
%
%   See also PBURG, PCOV, PMCOV, PMTM, PMUSIC, PWELCH, PYULEAR, LPC, PRONY.

%   Ref: S.L. Marple, DIGITAL SPECTRAL ANALYSIS WITH APPLICATIONS,
%              Prentice-Hall, 1987, Chapter 7

%   Author(s): J. McClellan, 9-17-95
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/07/31 14:40:14 $

error(nargchk(2,5,nargin));

[Mx,Nx] = size(xR);
xIsMatrix = Mx>1 & Nx>1;

if nargin < 1
   error('Must have at least 2 input arguments.')
elseif  isempty(p)
   error('Model order must be given, empty not allowed.')
end
if issparse(xR)
   error('Input signal or correlation cannot be sparse.')
end
if nargin < 5,   flag = [];   end
if nargin < 4,   Fs = [];     end  
if nargin < 3,   nfft = [];   end
if isstr(nfft)
   tflag = nfft; nfft = Fs; Fs = flag; flag = tflag;
elseif isstr(Fs)
   tflag = Fs;  Fs = flag; flag = tflag;
end

if isempty(nfft),    nfft = 256;  end
if isempty(Fs),      Fs = 2;      end
corr_flag = 0;     %<---- not expecting correlation
if ~isempty(flag)
   flag = upper(flag);
   if  (~isempty( findstr(flag,'CORR') )),  corr_flag = 1;  end
end

if( corr_flag )   %-- might be correlation matrix
   if Mx~=Nx
      error('PMEM: correlation matrix (R) is not square.')
   elseif  norm(xR'-xR) > 100*eps
      error('PMEM: correlation matrix (R) is not Hermitian symmetric.')
   end
end

if  ~xIsMatrix
   [RR,lags] = xcorr(xR,p,'biased');
   xR = toeplitz( RR(p+1:2*p+1), RR(p+1:-1:1) );
else  %-- Matrix case
   if  p>= Mx
      error('Column length of matrix must be greater than order.')
   elseif  ~corr_flag
      xR = corrcoef( xR.' );
   end
end
a = [1;  xR(2:p+1,2:p+1)\(-xR(2:p+1,1)) ];
EE = abs( xR(1,1:p+1) * a );

Spec2 = abs( fft( a, nfft ) ) .^ 2;
Pxx = EE*ones(size(Spec2)) ./ Spec2;

%--- Select first half only, when input is real
if isreal(xR)   
    if rem(nfft,2),    % nfft odd
        select = (1:(nfft+1)/2)';
    else
        select = (1:nfft/2+1)';
    end
else
    select = (1:nfft)';
end

Pxx = Pxx(select);
ff = (select - 1)*Fs/nfft;

if nargout == 0
   newplot;
   plot(ff,10*log10(Pxx)), grid on
   xlabel('Frequency'), ylabel('Power Spectrum Magnitude (dB)');
   title('Maximum Entropy Spectral Estimate')
end

if nargout >= 1
    varargout{1} = Pxx;
end
if nargout >= 2
    varargout{2} = ff;
end
if nargout >= 3
    varargout{3} = a;
end
