function [Pxx,f] = pfreqz(varargin)
%PFREQZ Power Spectrum estimate via a specified method.
%   PFREQZ(METHOD,TITLESTRING,X,P) plots the order P parametric PSD estimate of X 
%   estimated via METHOD. METHOD can be one of: 'arcov', 'arburg', etc.
%
%   [Pxx,F] = PFREQZ(METHOD,TITLESTRING,X,P) returns the PSD estimate vector Pxx
%   and the frequency vector F at which Pxx is evaluated.
%
%   PFREQZ(METHOD,TITLESTRING,X,P,NFFT) uses NFFT points in the plot/computation. 
%   When ommited or left empty, NFFT defauts to 256.
%
%   By default, PFREQZ will calculate the PSD over the frequency
%   interval [0,Pi) for a real signal vector X and over the frequency
%   interval [0,2*pi) for a complex vector X.  To plot the PSD over the
%   interval [0,2*Pi) for a real X use:
%   PFREQZ(METHOD,TITLESTRING,X,P,NFFT,'whole').
%
%   PFREQZ(METHOD,TITLESTRING,X,ORDER,NFFT,Fs,'whole') or 
%   PBURG(METHOD,TITLESTRING,X,ORDER,NFFT,Fs) specifies a sampling frequency 
%   Fs to be used in the plotting and computation. If left empty, Fs defaults
%   to 1 Hz. If no output arguments are given and Fs is specified, the plot 
%   will be over the frequency interval [0,Fs/2) for a real signal vector 
%   X and over the frequency interval [0,Fs) for a complex vector X.
%   
%   [Pxx,F] = PFREQZ(METHOD,TITLESTRING,X,P,NFFT,Fs) and 
%   [Pxx,F] = PFREQZ(METHOD,TITLESTRING,X,P,NFFT,Fs,'whole')
%   use a sampling frequency Fs in the scaling of the frequency axis and 
%   the PSD. When ommited or left empty, Fs defauts to 1 Hz.
%
%   PFREQZ(METHOD,TITLESTRING,X,ORDER,NFFT,Fs,'whole','squared') will plot the PSD
%   estimate directly instead of converting to decibels.
%
%   See also FREQZ, FFT, INVFREQZ, FREQS, PCOV, PMCOV, PBURG and PYULEAR.

%   Author(s): D. Orofino and R. Losada
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.9.1.2 $  $Date: 1999/01/22 03:42:30 $

error(nargchk(4,8,nargin))

method = varargin{1};
titlestring = varargin{2};
x = varargin{3};
p = varargin{4};

% generate defaults
nfft = 256;
Fs = 1;
if isreal(x),
   range = 'half';
else
   range = 'whole';
end
magnitude = 'db'; % By default we plot in decibels
samprateflag = 0; % We want to know when Fs is given to do the psd scaling accordingly

if nargin > 4,
   if ~isempty(varargin{5}),
      nfft = varargin{5};
   end
   switch nargin,
   case 6,
      % 5th arg may be either Fs or 'whole', if empty then Fs = 1
      samprateflag = 1; % if 5th argument empty or an Fs we flag it.
      if ischar(varargin{6}),
         range = varargin{6};
         samprateflag = 0; % No Fs given
      elseif ~isempty(varargin{6}),
         Fs = varargin{6};
      end
   case 7,
      if ischar(varargin{6}), % METHOD,X,ORDER,NFFT,'whole','db'
         range = varargin{6};
         magnitude = varargin{7};
         samprateflag = 0; % No Fs given
      else,                   % METHOD,X,ORDER,NFFT,Fs,'whole'
         samprateflag = 1; % Fs was given or left empty
         range = varargin{7};
         if ~isempty(varargin{6}),
            Fs = varargin{6};
         end
      end
   case 8,                   % METHOD,X,ORDER,NFFT,Fs,'whole','db'
      samprateflag = 1; % Fs was given or left empty
      range = varargin{7};
      magnitude = varargin{8};
      if ~isempty(varargin{6}),
         Fs = varargin{6};
      end
   end
end

wholeopts={'whole','half'};
idx = strmatch(lower(range),wholeopts);
if isempty(idx),
   error('String must be either ''WHOLE'' or ''HALF''');
elseif idx == 2,
   % range = 'half';
   if rem(nfft,2), % odd length nfft
      nfft = (nfft+1)/2;
   else
      nfft = (nfft/2+1);
   end
end

[a,v] = feval(method,x,p);

% Scale the psd appropriately, by Fs when linear freq is specified or
% by 2*pi when using normalized, angular freq (default).
if samprateflag,
   num = sqrt(v)./sqrt(Fs);
   frequency = 'linear';
   normfreq = 'no';
else
   num = sqrt(v)./sqrt(2*pi);
   frequency = 'angular';
   normfreq = 'yes';
end

args = {'Numerator',num,'Denominator',a,'nfft',nfft,'fs',Fs,...
      'frequency',frequency,'normfreq',normfreq,'range',range,...
      'magnitude',magnitude,'phase','no','return_nyquist'};
  
if nargout==0,
   freqz(args{:});
   ylab = 'Power Spectral Density';
   if strmatch(lower(magnitude),'db'),
      if strmatch(frequency,'linear'),
         ylab = [ylab ' (dB/Hz)'];
      else
         ylab = [ylab ' (dB / rads/sample)'];
      end
   end
   ylabel(ylab); 
   title(titlestring);
else
   [Pxx,f] = freqz(args{:});
   
   if strcmp(range,'half'),
      sel = 2:nfft-1;         % Don't include the DC or the Nyquist term
      if isreal(x),
         % Real signal; calculate the one-sided PSD with full power.
         Pxx = [Pxx(1); 2*Pxx(sel); Pxx(nfft)];
      else
         error('Range parameter must be ''WHOLE'' for complex signals.');
      end
   end
   
   Pxx = abs(Pxx).^2;   
end
