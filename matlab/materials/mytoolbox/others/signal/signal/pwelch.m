function varargout = pwelch(varargin)
%PWELCH Power Spectral Density estimate via Welch's method.
%   Pxx = PWELCH(X) returns the Power Spectral Density (PSD) estimate, 
%   Pxx(w), of a discrete-time signal vector X using Welch's averaged, 
%   modified periodogram method.  Pxx(w) is a function of normalized 
%   angular frequency, w=2*pi*f/Fs [rads/sample].
%
%   The single-sided PSD is returned for real signals and the 
%   double-sided PSD is returned for complex signals.  
%
%   [Pxx,W] = PWELCH(X) returns a frequency vector, W, in units of 
%   rads/sample at which the PSD is estimated. Pxx(w) is computed over 
%   the interval [0, Pi] for a real signal X and over the interval 
%   [0, 2*Pi] for a complex X. 
%
%   [Pxx,F] = PWELCH(X,NFFT,Fs) returns the PSD estimate and the frequency
%   vector, F, in Hz, at which the PSD is estimated.  The PSD estimate is 
%   computed over the interval [0, Fs/2] for a real signal X and over the 
%   interval [0, Fs] for a complex X.
%
%   [Pxx,F] = PWELCH(X,NFFT,Fs,WINDOW,NOVERLAP) X is divided into overlap-
%   ping sections, then windowed by the WINDOW parameter, then zero-padded
%   to length NFFT.  The magnitude squared of the length NFFT DFTs of the 
%   sections are averaged to form Pxx.  Pxx is length NFFT/2+1 for NFFT
%   even, (NFFT+1)/2 for NFFT odd, or NFFT if the signal X is complex. If  
%   you specify a scalar for WINDOW, a Hanning window of that length is 
%   used.
%
%   [Pxx, Pxxc, F] = PWELCH(X,NFFT,Fs,WINDOW,NOVERLAP,P) where P is a
%   scalar between 0 and 1, returns the P*100% confidence interval for Pxx.
%
%   PWELCH with no output arguments plots the PSD in the current figure 
%   window, with confidence intervals if you provide the P parameter.  By 
%   default, PWELCH will plot the power spectral density, in dB per unit 
%   frequency.  The plot will have a frequency interval of [0,pi) for a 
%   real signal vector X, and a frequency interval of [0,2pi) for a complex
%   vector X.  If Fs is specified then the intervals become [0,Fs/2) and 
%   [0,Fs), respectively.
%
%   PWELCH(X,NFFT,Fs,WINDOW,NOVERLAP,P,RANGE,MAGUNITS), where RANGE can
%   be 'half' or 'whole', specifies the frequency intervals [0,Fs/2) and
%   [0,Fs) respectively.  MAGUNITS can be either 'squared' or 'db' and
%   it specifies the units of the PSD plot.  The MAGUNITS option only 
%   affects the plot. To plot the PSD without converting to decibels,
%   over the interval [0,Fs) for a real X use: 
%   PWELCH(X,NFFT,Fs,WINDOW,NOVERLAP,P,'whole','squared').
%
%   RANGE can take the place of any parameter in the parameter list
%   (besides X) as long as it is last, e.g. PWELCH(X,'whole');
%
%   The default values for the parameters are NFFT = 256 (or LENGTH(X),
%   whichever is smaller), NOVERLAP = 0, WINDOW = HANNING(NFFT), Fs = 1, 
%   P = .95, RANGE = 'half', and MAGUNITS = 'db'. You can obtain a 
%   default parameter by leaving it off or inserting an empty matrix [],
%   e.g. PWELCH(X,[],10000).
% 
%   See also CSD, COHERE, TFE, PCOV, PMCOV, PBURG, PYULEAR, PEIG, PMTM
%   and PMUSIC.  ETFE, SPA, and ARX in the System Identification Toolbox.

%   Author(s): P. Pacheco
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.14.1.2 $  $Date: 1999/01/22 03:42:33 $

%   References:
%     [1] Petre Stoica and Randolph Moses, Introduction To Spectral
%         Analysis, Prentice-Hall, 1997, pg. 15
%     [2] A.V. Oppenheim and R.W. Schafer, Digital Signal
%         Processing, Prentice-Hall, 1975, pg. 556

error(nargchk(1,9,nargin))
x = varargin{1};
[params,msg] = pwelchparse(varargin(2:end),x);
error(msg);

% Extract individual variables from structure; easier to use in calculations
nfft     = params.nfft;
Fs       = params.Fs;
noverlap = params.noverlap;
p        = params.p;
range    = params.range;

% Zero-pad x if it has length less than the window length
window = params.window(:);
n = length(x);		          % Number of data points
nwind = length(window);     % length of window
if n < nwind            
   x(nwind)=0;  n=nwind;
 end
% Make x a column vector; do this AFTER the zero-padding in case x is a scalar.
x = x(:);		

% Number of windows; (k = fix(n/nwind) for noverlap=0)
k = fix((n-noverlap)/(nwind-noverlap)); 

index = 1:nwind;
KMU = k*norm(window)^2;	% Normalizing scale factor ==> asymptotically unbiased
% KMU = k*sum(window)^2;% alt. Nrmlzng scale factor ==> peaks are about right

% Calculate PSD
Spec = zeros(nfft,1);
for i=1:k
   xw = window.*x(index);
   index = index + (nwind - noverlap);
   Xx = abs(fft(xw,nfft)).^2;
   Spec = Spec + Xx;
end

% Select first half - real or complex case
if strmatch(range,'half'),  
   if rem(nfft,2),         % nfft odd
      select = (2:(nfft+1)/2-1)';  % don't include DC or Nyquist components
      nyq    = (nfft+1)/2;         % they're included below
   else
      select = (2:nfft/2)';
      nyq    = nfft/2+1; 
   end
   if isreal(x),
      % Calculate the single-sided spectrum which includes the full power
      Spec = [Spec(1); 2*Spec(select); Spec(nyq)];
   else
      error('Range parameter must be ''WHOLE'' for complex signals.');
   end
end

% Normalize, and scale by 1/Fs or 1/2pi in order to get 
% Power per unit of frequency 
if params.fsFlag,      % Linear freq (Hz) specified
   scaleFactor = Fs;
else                   % Using default normalized, angular freq
   scaleFactor = 2*pi;
end
Spec = Spec / (KMU *scaleFactor);

% Default frequency vector is normalized angular frequency; either [0,pi) 
% or [0,2*pi).  If user specifies Fs, linear frequency in Hz is returned.
[freq_vector,xlab,xtickFlag,xlim] = calcfreqvector(length(Spec),Fs,...
                                                   params.fsFlag,range);
% Find confidence interval if needed
if (nargout == 3)|((nargout == 0)&~isempty(p)),
    if isempty(p),
        p = .95;    % default
    end
    % Confidence interval from Kay, p. 76, eqn 4.16:
    % (first column is lower edge of conf int., 2nd col is upper edge)
    confid = Spec*chi2conf(p,k);

    if noverlap > 0
        warning('Confidence intervals inaccurate for NOVERLAP > 0.')
    end
end

% Set up output parameters
if nargout >=1,
    varargout{1} = Spec;
    if (nargout == 2),
        varargout{2} = freq_vector;
    elseif (nargout == 3),
        varargout{2} = confid;
        varargout{3} = freq_vector;
    end   
else % (nargout == 0),
    if ~isempty(p),
        P = [Spec confid];
    else
        P = Spec;
    end
    pxxplot('Welch',P,freq_vector,range,xlab,xtickFlag,xlim,params.magUnits);
end

                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  %     Local Functions      %
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------------------------------------------------
function window = calcWindow(w,nfft)
% CALCWINDOW Caculate the window based on the input variable 'window'.

if length(w) == 1,          % Scalar input
    window = hanning(w);
elseif isempty(w),          % []; use default
    window = hanning(nfft);
else
    window = w;             % User specified window vector
end

%----------------------------------------------------------------------
function [params, msg] = pwelchparse(P, x)
%PWELCHPARSE Parses and validates the inputs to PWELCH.
%
%  Inputs:
%     P - cell array which has between 0 and 8 elements which are the
%         arguments to pwelch, after the x argument
%     x - input data
%  Outputs: 
%     msg    - error message, [] if no error
%
%     params - structure containing the complete set of input arguments
%              accepted by the pwelch function

% Default Values
nfft     = min(length(x),256);
Fs       = 1;
window   = hanning(nfft);
noverlap = 0;
p        = [];
magUnits = 'db';
fsFlag   = 1;     % Fs specified by the user

if isreal(x),
    range = 'half';
else
    range = 'whole';
end

switch length(P)
case 0, % psd(x)
   fsFlag = 0;  % Fs not specified by user
   
case 1, % psd(x,nfft) or psd(x,range)
   fsFlag = 0;  % Fs not specified by user
   
   if isstr(P{1}),
      range = P{1};
   elseif ~isempty(P{1}),
      nfft = P{1};
   end
   window = hanning(nfft);
   
case 2, % pwelch(x,nfft,Fs) or pwelch(x,nfft,range)
   if ~isempty(P{1}),
      nfft=P{1};
   end
   if isstr(P{2}), 
      % Range passed
      fsFlag = 0;  % Fs not specified by user
      range = P{2};
   elseif ~isempty(P{2}),
      % Fs passed
      Fs = P{2};
   end
   window = hanning(nfft);
   
case 3, % pwelch(x,nfft,Fs,window) or pwelch(x,nfft,Fs,range)
   if ~isempty(P{1}),
      nfft=P{1};
   end
   if ~isempty(P{2}),
      Fs = P{2};
   end
   
   if isstr(P{3}),
      range = P{3};
      window = hanning(nfft);
   else
      window = calcWindow(P{3},nfft);  % Handles the [] case
   end
   
case 4, % pwelch(x,nfft,Fs,window,noverlap) or  pwelch(x,nfft,Fs,window,range)
   if ~isempty(P{1}),
      nfft=P{1};
   end
   if ~isempty(P{2}),
      Fs = P{2};
   end
   
   window = calcWindow(P{3},nfft);      % Handles the [] case
   
   if isstr(P{4}),
      range = P{4};
   elseif ~isempty(P{4}),
      noverlap = P{4};
   end
   
case {5,6,7,8}, 
   % 5 pwelch(x,nfft,Fs,window,noverlap,p) or pwelch(x,nfft,Fs,window,noverlap,range)
   % 6 pwelch(x,nfft,Fs,window,noverlap,p,range)
   % 7 pwelch(x,nfft,Fs,window,noverlap,p,range,magUnits)
   if ~isempty(P{1}),
      nfft=P{1};
   end
   if ~isempty(P{2}),
      Fs = P{2};
   end
   window = calcWindow(P{3},nfft);       % Handles the [] case
   
   if ~isempty(P{4}), 
      noverlap = P{4};
   end
   if isstr(P{5})
      range = P{5};
   elseif isempty(P{5}), 
      p = .95;    
   else
      p = P{5};
   end
   
   if length(P) > 5,
      range = lower(P{6});        
      if length(P) > 6,      
         magUnits = lower(P{7});
      end
   end    
end % end swicth-case statement

params.nfft     = nfft;
params.Fs       = Fs;
params.window   = window;
params.noverlap = noverlap;
params.p        = p;
params.range    = range;
params.magUnits = magUnits;
params.fsFlag   = fsFlag;

% An error message is returned if input validation fails.
msg = pwelchErrorChk(x,params);

%----------------------------------------------------------------------
function msg = pwelchErrorChk(x,params),
% PWELCHERRORCHK Validate input to the pwelch function and return error
%                message if input is invalid. 
% Inputs:
%   x       - data passed to pwelch
%   params  - structure containing the following fields
%      nfft     - fft length
%      Fs       - sampling frequency (not used here)
%      window   - window vector
%      noverlap - overlap of sections, in samples
%      p        - confidence interval, [] if none desired
%      range    - specifies the interval to be [0,Fs/2) (default for real) 
%                 or [0,Fs) (default for complex)
%      magUnits - specifies the magnitude units, squared or db (default)
%      fsFlag   - flag indicating when Fs is specified by the user (not used here)
% Outputs:
%   msg      - error message, [] if no error

% Extract some individual variables from structure for ease of caculations.
nfft = params.nfft;
p    = params.p;

msg = [];

% Start error checking
if (nfft < length(params.window)), 
    msg = 'Requires window''s length to be no greater than the FFT length.';
end
if (params.noverlap >= length(params.window)),
    msg = 'Requires NOVERLAP to be strictly less than the window length.';
end
if (nfft ~= abs(round(nfft)))|(params.noverlap ~= abs(round(params.noverlap))),
    msg = 'Requires positive integer values for NFFT and NOVERLAP.';
end
if ~isempty(p),
    if (prod(size(p))>1)|(p(1,1)>1)|(p(1,1)<0),
        msg = 'Requires confidence parameter to be a scalar between 0 and 1.';
    end
end
if min(size(x))~=1 | ~isnumeric(x) | length(size(x))>2
    msg = 'Requires vector (either row or column) input.';
end

% Determine if user specified 'whole' or 'half' for the intervals [0,Fs) or [0,Fs/2) 
wholeopts={'half','whole'};
if ~isstr(params.range),
   msg = 'The parameter RANGE, must be a string.'; return
else
   indx = strmatch(params.range,wholeopts);
   if isempty(indx),
      msg = 'The parameter RANGE, must be either ''WHOLE'' or ''HALF''.';
   end
end

% Determine if user specified 'squared' or 'db' for the magnitude units 
magopts={'squared','db'};
if ~isstr(params.magUnits),
   msg = 'The parameter MAGUNITS, must be a string.'; return
else
   indx = strmatch(params.magUnits,magopts);
   if isempty(indx),
      msg = 'The parameter MAGUNITS, must be either ''SQUARED'' or ''DB''.';
   end
   
end

% [EOF] pwelch.m
