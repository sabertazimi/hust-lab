function varargout = peig( varargin )
%PEIG  Power Spectrum estimate via the EigenVector method.
%   Pxx = PEIG(X,P,NFFT) is the Power Spectral Density (PSD) estimate,
%   Pxx(w), of signal vector X using the eigenvector method.  P is the
%   number of eigenvectors in the signal subspace. If X is a data matrix,
%   each column is interpreted as a separate sensor measurement or trial.
%   Pxx is length (NFFT/2+1) for NFFT even, (NFFT+1)/2 for NFFT odd, and
%   NFFT if X is complex. NFFT is optional; it defaults to 256.
%
%   [Pxx,W] = PEIG(X,P,NFFT) returns the frequency vector, W, in
%   rads/sample, at which the PSD is estimated. The PSD estimate is
%   computed over the interval [0, Pi] for a real signal X and over the
%   interval [0, 2*Pi] for a complex X.
%
%   Pxx = PEIG(X,[P THRESH],NFFT) uses THRESH as a cutoff for signal 
%   and noise subspace separation.  All eigenvalues greater than THRESH
%   times the smallest eigenvalue are designated as signal eigenvalues.
%   In this case, the signal subspace dimension is at most P.
%
%   [Pxx,F] = PEIG(X,P,NFFT,Fs) returns the PSD estimate and the vector
%   of frequencies, F, in Hz, at which the PSD is estimated. Fs is the 
%   sampling frequency.  In this case, the PSD estimate is computed 
%   over the interval [0, Fs/2] for a real signal X and over the interval
%   [0, Fs] for a complex X.  If left empty, Fs defaults to 1 Hz.
%
%   [Pxx,F] = PEIG(X,P,NFFT,Fs,NW,NOVERLAP) divides signal vector
%   X into sections of length NW which overlap by NOVERLAP samples. The
%   sections are concatenated as the columns of a matrix whose
%   eigenvectors are used in computing Pxx. NOVERLAP is ignored if X is
%   already a matrix.  Default values are NW = 2*P, and NOVERLAP = NW-1,
%   if you leave them unspecified.  If NW is a vector, it is used to
%   window the overlapping sections  
%
%   PEIG with no output arguments plots the PSD in the next available
%   figure.
%
%   You can obtain a default parameter by inserting an empty matrix [],
%   e.g., PEIG(X,3,[],400,8).
%
%   [Pxx,F,V,E] = PEIG(...) returns a matrix V of eigenvectors that
%   compose the estimate (v_k in Marple) and vector E of eigenvalues. The
%   columns of V span the noise subspace. The dimension of the signal
%   subspace is equal to size(V,1) - size(V,2).
%   
%   See also PMUSIC, PMTM, PCOV, PMCOV, PBURG, PYULEAR, PWELCH, LPC, PRONY.

% 	 Author(s): R. Losada
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1.1.2 $  $Date: 1999/01/22 03:42:34 $

error(nargchk(2,7,nargin))

if nargout==0,
   pmusic(varargin{:},'ev');
else
   [varargout{1:nargout}] = pmusic(varargin{:},'ev');
end

% [EOF] peig.m
