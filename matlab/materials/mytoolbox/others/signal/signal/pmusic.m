function varargout = pmusic( xR, thresh, varargin )
%PMUSIC  Power Spectrum estimate via MUSIC eigenvector method.
%   Pxx = PMUSIC(X,P,NFFT) is the Power Spectral Density (PSD) estimate,
%   Pxx(w), of signal vector X using Schmidt's eigen-analysis method,
%   MUSIC (an acronym for "Multiple Signal Classification").  P is the
%   number of eigenvectors in the signal subspace. If X is a data matrix,
%   each column is interpreted as a separate sensor measurement or trial.
%   Pxx is length (NFFT/2+1) for NFFT even, (NFFT+1)/2 for NFFT odd, and
%   NFFT if X is complex. NFFT is optional; it defaults to 256.
%
%   The single-sided PSD is returned for real signals and the 
%   double-sided PSD is returned for complex signals.  
%
%   [Pxx,W] = PMUSIC(X,P,NFFT) returns the frequency vector, W, in
%   rads/sample, at which the PSD is estimated. The PSD estimate is
%   computed over the interval [0, Pi] for a real signal X and over the
%   interval [0, 2*Pi] for a complex X.
%
%   Pxx = PMUSIC(X,[P THRESH],NFFT) uses THRESH as a cutoff for signal 
%   and noise subspace separation.  All eigenvalues greater than THRESH
%   times the smallest eigenvalue are designated as signal eigenvalues.
%   In this case, the signal subspace dimension is at most P.
%
%   [Pxx,F] = PMUSIC(X,P,NFFT,Fs) returns the PSD estimate and the vector
%   of frequencies, F, in Hz, at which the PSD is estimated. Fs is the 
%   sampling frequency.  In this case, the PSD estimate is computed 
%   over the interval [0, Fs/2] for a real signal X and over the interval
%   [0, Fs] for a complex X.  If left empty, Fs defaults to 1 Hz.
%
%   [Pxx,F] = PMUSIC(X,P,NFFT,Fs,NW,NOVERLAP) divides signal vector
%   X into sections of length NW which overlap by NOVERLAP samples. The
%   sections are concatenated as the columns of a matrix whose
%   eigenvectors are used in computing Pxx. NOVERLAP is ignored if X is
%   already a matrix.  Default values are NW = 2*P, and NOVERLAP = NW-1,
%   if you leave them unspecified.  If NW is a vector, it is used to
%   window the overlapping sections.
%
%   Use a trailing 'corr' flag if X is a square correlation matrix, e.g.
%   [Pxx,F] = PMUSIC(X,P,NFFT,Fs,'corr').  This uses EIG directly
%   instead of SVD on the signal matrix and squaring the singular values.
%   In this case X must be hermitian and have no negative eigenvalues.
%
%   PMUSIC with no output arguments plots the PSD in the next available
%   figure.
%
%   You can obtain a default parameter by inserting an empty matrix [],
%   e.g., PMUSIC(X,3,[],400,8).
%
%   [Pxx,F,V,E] = PMUSIC(...) returns a matrix V of eigenvectors that
%   compose the estimate (v_k in Marple) and vector E of eigenvalues. The
%   columns of V span the noise subspace. The dimension of the signal
%   subspace is equal to size(V,1) - size(V,2).
%   
%   See also PEIG, PMTM, PCOV, PMCOV, PBURG, PYULEAR, PWELCH, LPC, PRONY.

%   Reference: S.L. Marple, DIGITAL SPECTRAL ANALYSIS WITH APPLICATIONS,
%              Prentice-Hall, 1987, pages 372-373 & 376-378

% 	 Author(s): J. McClellan, 9-15-95, 8-15-95
%   Modified by R. Losada, 8-8-98
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.7.1.2 $  $Date: 1999/01/22 03:42:34 $

error(nargchk(2,8,nargin))

[Mx,Nx] = size(xR);
xIsMatrix = Mx>1 & Nx>1;

if nargin < 2
   error('Must have at least 2 input arguments.')
else
   if( isempty(thresh) )
      error('P cannot be empty.')
   end
end

% Default values:
EV_flag = 0;   corr_flag = 0;
samprateflag = 0; Fs = 1; range = 'half'; magunits = 'db';
titlestring = 'MUSIC';

while length(varargin)>0 & isstr(varargin{end})
   s = lower(varargin{end});
   switch s(1)
   case 'e'
      EV_flag = 1;
   case 'c'
      corr_flag = 1;
   otherwise
      error('Unrecognized string input.')
   end
   varargin = varargin(1:end-1);
end

if length(varargin)>=1
   nfft = varargin{1};
else
   nfft = 256;
end
if length(varargin)>=2
   samprateflag = 1;
   if ~isempty(varargin{2}),
      Fs = varargin{2};      
   end
end
if length(varargin)>=3
   wind = varargin{3};
else
   if xIsMatrix,   wind = Mx;
   else,   wind = 2*thresh(1);   end
end
if length(varargin)>=4
   nover = varargin{4};
else
   nover = [];
end

if issparse(xR)
   error('Input signal or correlation cannot be sparse.')
end

if isempty(nfft),    nfft = 256;         end
if isempty(wind),    wind = 2*thresh(1); end
if length(wind)==1
   Lw = wind;  DoWindow = 0;
else
   Lw = length(wind);  DoWindow = 1;
end
if( xIsMatrix & Lw~=Mx )
   error('Window length must equal number of rows in X matrix.')
end
if isempty(nover),   nover = Lw-1;      end

[d1,d2] = size(thresh);
if  (d1*d2)>2
   error('Second input must have only 1 or 2 elements.')
elseif  (d1*d2)==1
   thresh(2) = 0;
end
if( any(thresh<0)  )
   error('Second input must contain non-negative entries.')
end
if( round(thresh(1))~=thresh(1) )
   error('P must be an integer.')
end

if( corr_flag )   %-- might be correlation matrix
   if Mx~=Nx
      error('Correlation matrix (R) is not square.')
   elseif  norm(xR'-xR) > 100*eps
      error('Correlation matrix (R) is not Hermitian symmetric.')
   else
      [eig_vec,eig_vals] = eig(xR);
      evals = diag(eig_vals);
      if min(evals)<0 | max(abs(imag(evals)))>1000*eps
         error('Correlation matrix (R) has negative or complex eigenvalue.')
      else
         eig_vals = real(eig_vals);   %---- we now have a valid correlation matrix
      end
   end
end

if  ~xIsMatrix
   Lx = max(Mx,Nx);
   nskip = Lw - nover;
   jkl = 1:nskip:Lx;
   nn = (0:Lw-1)';
   jkl = jkl(ones(Lw,1),:) + nn(:,ones(size(jkl)));
   if length(jkl(:)) ~= length(xR),  xR(length(jkl(:))) = 0.0;  end
   xR = reshape( xR(jkl), size(jkl) );
   [Mx,Nx] = size(xR);
end
xR = xR.';
if DoWindow & ~corr_flag
   wind = wind(:).';
   xR = xR .* wind(ones(Nx,1),:);
end

if( thresh(1)>Mx  &  thresh<1 )
   error('Noise subspace dimension cannot be zero.');
end
if  ~corr_flag
   [uu,ss,vv] = svd( xR, 0 );
   sing_vals = diag(ss) .^ 2;   %--- square to get eigenvalues of R matrix
   sing_vec = vv;
else
   [evals,jkl] = sort( diag(eig_vals) );
   sing_vec = eig_vec(:,flipud(jkl(:)));
   sing_vals = flipud( evals );
end

%--- either THRESH(1) or THRESH(2) defines the noise subspace, and
%---    they can be used simultaneously.
%---  STRATEGY: make the noise sub-space small to allow more sigs
%---            downside is that you may get extraneous peaks
p = thresh(1);     %-- p = dimension of signal subspace
if  thresh(2)>0
   nnn = find( sing_vals <= thresh(2)*min(sing_vals) );
   if  ~isempty(nnn)
      p = min( p, Mx-length(nnn) );
   end
end
if p>=Mx, error('Noise subspace dimension cannot be zero.'), end
nsubsp = p+1:Mx;

v_noise = sing_vec(:,nsubsp);

Spec2 = abs( fft( v_noise, nfft ) ) .^ 2;
wghts = ones(size(nsubsp));
if  EV_flag,
   titlestring = 'Eigenvector';
   wghts = 1./sing_vals(nsubsp);
end
Spec2 = Spec2*wghts(:);     %--- does weighting and summation
Pxx = ones(size(Spec2)) ./ Spec2;

%--- Select first half only, when input is real
if ~any(imag(xR(:))~=0),   % if x is real
   if rem(nfft,2),         % nfft odd
      select = (2:(nfft+1)/2-1)';  % don't include DC or Nyquist components
      nyq    = (nfft+1)/2;         % they're included below
   else
      select = (2:nfft/2)';
      nyq    = nfft/2+1; 
   end
   
   % Calculate single-sided spectrum which includes full power.
   Pxx = [Pxx(1); 2*Pxx(select); Pxx(nyq)]; 
else                       % x is complex
   select = (1:nfft)';
   range = 'whole';
   % Calculate double-sided spectrum which includes full power.
   Pxx = Pxx(select);
end

% Default frequency vector is normalized angular frequency; either [0,pi) 
% or [0,2*pi).  If user specifies Fs, linear frequency in Hz is returned.
[ff,xlab,xtickFlag,xlim] = calcfreqvector(length(Pxx),Fs,samprateflag,range);

% Scale by 1/Fs or 1/2pi in order to get Power per unit of frequency 
if samprateflag,      % Linear freq (Hz) specified
   scaleFactor = Fs;
else                  % Using default normalized, angular freq
   scaleFactor = 2*pi;
end
Pxx = Pxx ./ scaleFactor;

if nargout >= 1
   varargout{1} = Pxx;
end
if nargout >= 2
   varargout{2} =  ff;
end
if nargout >= 3
   varargout{3} = v_noise;
end
if nargout >= 4
   varargout{4} = sing_vals;
end

if nargout == 0
   newplot;
   pxxplot(titlestring,Pxx,ff,range,xlab,xtickFlag,xlim,magunits);
end

% [EOF] pmusic.m
