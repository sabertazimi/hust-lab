function [Pxy, Pxyc, f] = csd(varargin)
%CSD Cross Spectral Density estimate.
%   Pxy = CSD(X,Y,NFFT,Fs,WINDOW) estimates the Cross Spectral Density of 
%   signal vectors X and Y using Welch's averaged periodogram method.  X and
%   Y are divided into overlapping sections, each of which is detrended, 
%   then windowed by the WINDOW parameter, then zero-padded to length NFFT.
%   The products of the length NFFT DFTs of the sections of X and Y are 
%   averaged to form Pxy.  Pxy is length NFFT/2+1 for NFFT even, (NFFT+1)/2
%   for NFFT odd, or NFFT if the either X or Y is complex.  If you specify 
%   a scalar for WINDOW, a Hanning window of that length is used.  Fs is the
%   sampling frequency which doesn't effect the cross spectrum estimate 
%   but is used for scaling of plots.
%
%   [Pxy,F] = CSD(X,Y,NFFT,Fs,WINDOW,NOVERLAP) returns a vector of frequen-
%   cies the same size as Pxy at which the CSD is estimated, and overlaps
%   the X and Y sections NOVERLAP samples.
%
%   [Pxy, Pxyc, F] = CSD(X,Y,NFFT,Fs,WINDOW,NOVERLAP,P) where P is a scalar
%   between 0 and 1, returns the P*100% confidence interval for Pxy.
%
%   CSD(X,Y,...,DFLAG), where DFLAG can be 'linear', 'mean' or 'none', 
%   specifies a detrending mode for the prewindowed sections of X and Y.
%   DFLAG can take the place of any parameter in the parameter list
%   (besides X and Y) as long as it is last, e.g. CSD(X,Y,'mean');
%   
%   CSD with no output arguments plots the CSD in the current figure window,
%   with confidence intervals if you provide the P parameter.
%
%   The default values for the parameters are NFFT = 256 (or LENGTH(X),
%   whichever is smaller), NOVERLAP = 0, WINDOW = HANNING(NFFT), Fs = 2, 
%   P = .95, and DFLAG = 'none'.  You can obtain a default parameter by 
%   leaving it off or inserting an empty matrix [], e.g. CSD(X,Y,[],10000).
%
%   See also PSD, COHERE, TFE
%   ETFE, SPA, and ARX in the Identification Toolbox.

%   Author(s): T. Krauss, 3-30-93
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:21 $

error(nargchk(2,8,nargin))
x = varargin{1};
y = varargin{2};
[msg,nfft,Fs,window,noverlap,p,dflag]=psdchk(varargin(3:end),x,y);
error(msg)
    
% compute CSD
window = window(:);
n = length(x);		% Number of data points
nwind = length(window); % length of window
if n < nwind    % zero-pad x , y if length is less than the window length
    x(nwind)=0;
    y(nwind)=0;  
    n=nwind;
end
x = x(:);		% Make sure x is a column vector
y = y(:);		% Make sure y is a column vector
k = fix((n-noverlap)/(nwind-noverlap));	% Number of windows
					% (k = fix(n/nwind) for noverlap=0)
index = 1:nwind;
KMU = k*norm(window)^2;	% Normalizing scale factor ==> asymptotically unbiased
% KMU = k*sum(window)^2;% alt. Nrmlzng scale factor ==> peaks are about right

Spec = zeros(nfft,1); Spec2 = zeros(nfft,1);
for i=1:k
    if strcmp(dflag,'none')
        xw = window.*x(index);
        yw = window.*y(index);
    elseif strcmp(dflag,'linear')
        xw = window.*detrend(x(index));
        yw = window.*detrend(y(index));
    else
        xw = window.*detrend(x(index),0);
        yw = window.*detrend(y(index),0);
    end
    index = index + (nwind - noverlap);
    Xx = fft(xw,nfft);
    Yy = fft(yw,nfft);
    Xy2 = Yy.*conj(Xx);
    Spec = Spec + Xy2;
    Spec2 = Spec2 + Xy2.*conj(Xy2);
end

% Select first half
if ~any(any(imag([x y])~=0)),   % if x and y are not complex
    if rem(nfft,2),    % nfft odd
        select = [1:(nfft+1)/2];
    else
        select = [1:nfft/2+1];   % include DC AND Nyquist
    end
    Spec = Spec(select);
    Spec2 = Spec2(select);
else
    select = 1:nfft;
end
freq_vector = (select - 1)'*Fs/nfft;

% find confidence interval if needed
if (nargout == 3)|((nargout == 0)&~isempty(p)),
    if isempty(p),
        p = .95;    % default
    end
    confid = Spec*chi2conf(p,k)/KMU;
end

Spec = Spec*(1/KMU);

% set up output parameters
if (nargout == 3),
   Pxy = Spec;
   Pxyc = confid;
   f = freq_vector;
elseif (nargout == 2),
   Pxy = Spec;
   Pxyc = freq_vector;
elseif (nargout == 1),
   Pxy = Spec;
elseif (nargout == 0),
   if ~isempty(p),
       P = [Spec confid];
   else
       P = Spec;
   end
   newplot;
   plot(freq_vector,10*log10(abs(P))), grid on
   xlabel('Frequency'), ylabel('Cross Spectrum Magnitude (dB)');
end
