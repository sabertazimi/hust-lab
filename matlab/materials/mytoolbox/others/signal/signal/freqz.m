function [hh,ww] = freqz(varargin)
%FREQZ Z-transform digital filter frequency response.
%   When N is an integer, [H,W] = FREQZ(B,A,N) returns the N-point frequency
%   vector W in radians and the N-point complex frequency response vector H
%   of the filter B/A:
%               jw              -jw               -jnbw 
%        jw  B(e)   b(1) + b(2)e + .... + b(nb+1)e
%     H(e) = ---- = ----------------------------
%               jw              -jw               -jnaw
%            A(e)   a(1) + a(2)e + .... + a(na+1)e
%   given numerator and denominator coefficients in vectors B and A. The
%   frequency response is evaluated at N points equally spaced around the
%   upper half of the unit circle. If N isn't specified, it defaults to 512.
%
%   [H,W] = FREQZ(B,A,N,'whole') uses N points around the whole unit circle.
%
%   H = FREQZ(B,A,W) returns the frequency response at frequencies 
%   designated in vector W, in [radians/sample] (normally between 0 and pi).
%
%   [H,F] = FREQZ(B,A,N,Fs) and [H,F] = FREQZ(B,A,N,'whole',Fs) given a 
%   sampling freq Fs in Hz return a frequency vector F in Hz.
%   
%   H = FREQZ(B,A,F,Fs) given sampling frequency Fs in Hz returns the 
%   complex frequency response at the frequencies designated in vector F,
%   also in Hz.
%
%   FREQZ(B,A,...) with no output arguments plots the magnitude and
%   unwrapped phase of B/A in the current figure window.
%
%   See also FILTER, FFT, INVFREQZ, FREQS and GRPDELAY.

%   CAUTION, parameter-value pairs can be used, but this feature will be
%   removed in the next release.

%   Author(s): J.N. Little, 6-26-86
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.25.1.2 $  $Date: 1999/01/22 03:42:34 $

% ------------------------- %
% Parse the input arguments %
% ------------------------- %
[params,fvflag] = freqzparse(varargin{:});
% fvflag will be set to one if a freqvector was specified by the user.
b = params.numerator(:).';   % Make it a row vector
a = params.denominator(:).'; % 
fs = params.fs;
nb = length(b);
na = length(a);

% ------------------------------------- %
% Actual Frequency Response Computation %
% ------------------------------------- %
if fvflag, %   Frequency vector specified.  Use Horner's method of polynomial
   %   evaluation at the frequency points and divide the numerator
   %   by the denominator.
   %
   %   Note: we use positive i here because of the relationship
   %            polyval(a,exp(i*w)) = fft(a).*exp(i*w*(length(a)-1))
   %               ( assuming w = 2*pi*(0:length(a)-1)/length(a) )
   %        
   a = [a zeros(1,nb-na)];  % Make sure a and b have the same length
   b = [b zeros(1,na-nb)];
   [digw,xlab,xtickflag,xlim] = freqconv(params.freqvector,fs,...
      params.frequency,params.normfreq,params.range,'freq2dig'); % Scale w correctly
   s = exp(i*digw); % Digital frequency must be used for this calculation
   h = polyval(b,s) ./ polyval(a,s);
   w = params.freqvector; % Assign the correct freqvector to w
else   
   % freqvector not specified, use nfft and RANGE in calculation
   s = strmatch(lower(params.range),{'whole','half'});
   n = params.nfft;
   if s*n < na | s*n < nb
      nfft = lcm(n,max(na,nb));
      % dividenowarn temporarily shuts off warnings to avoid "Divide by zero"
      h = dividenowarn(fft([b zeros(1,s*nfft-nb)]),...
                       fft([a zeros(1,s*nfft-na)])).';
      h = h(1+(0:n-1)*nfft/n);
   else
      % dividenowarn temporarily shuts off warnings to avoid "Divide by zero"
      h = dividenowarn(fft([b zeros(1,s*n-nb)]),...
                       fft([a zeros(1,s*n-na)])).'; 
      h = h(1:n);
   end
   h = h(:); % Make it a column only when nfft is given (backwards comp.)
   [w,xlab,xtickflag,xlim] = freqconv(n,fs,params.frequency,...
      params.normfreq,params.range,'dig2freq',params.return_nyquist); % Scale w correctly
   w = w(:); % Make it a column only when nfft is given (backwards comp.)   
end

% ------------------------------ %
%  Plot or Compute the Output    %
% ------------------------------ %
if nargout == 0, % Plot when no output arguments are given
   % If it's normalized angular frequency divide by pi 
   % because the plot's x domain is 0 to 1.
   if strmatch(params.normfreq,'yes') & strmatch(params.frequency,'angular'),
      w = w./pi;
   end
   
   freqzplot(h,w,params,fvflag,xlim,xlab,xtickflag);
else % Don't plot, just return the (complex) frequency response.
   hh = h;
   ww = w;
end

% ------------------------------ %
%         Local Functions        %
% ------------------------------ %

%------------------------------------------------------------------------------
function freqzplot(h,w,params,fvflag,xlim,xlab,xtickflag)
% FREQZPLOT Plots the Magnitude and Phase response.
%
% Inputs:
%   h         - complex frequency response vector
%   w         - frequency vector
%   params    - structure containing the following fields
%      normmag   - YES/NO flag indicating if magnitude is normalized
%      magnitude - magnitude units string: 'DB', 'LINEAR' or 'SQUARED'
%      phase     - YES/NO flag indicating if phase plot is required
%      range     - frequency range, 'WHOLE' or 'HALF', which corresponds to 
%                  [0,Fs) or [0,Fs/2) respectively
%   fvflag    - flag indicating if a frequency vector was specified by user
%   xlim      - x-limits which corresponds to correct x-axis units
%   xlab      - x-axis label with correct units
%   xtickFlag - specifies the frequency units (angular, normalized angular,
%               linear, etc.)

newplot;
if ishold,
   holdflag = 1;
else
   holdflag = 0;
end   
% Check if we should scale the magnitude, this is for plotting only
[magh,ylab] = correctmag(h,params.normmag,params.magnitude);

if strmatch(lower(params.phase),'yes'),      
   subplot(212); % We plot the phase first to retain the functionality of freqz when hold is on
   plot(w,unwrap(angle(h))*180/pi);
   ax = gca;
   xlabel(xlab);
   ylabel('Phase (degrees)');     
   subplot(211);
   plot(w,magh);
   xlabel(xlab);
   ylabel(ylab);
   ax = [ax gca];
   if ~holdflag,        
      hfig = get(ax(1),'parent');
      set(hfig,'nextplot','replace'); % Resets the figure so that next plot does not subplot      
   end      
else,
   plot(w,magh);
   xlabel(xlab);
   ylabel(ylab);
   ax = gca;
end
axes(ax(1)); % Always bring the plot to the top
set(ax,'xgrid','on','ygrid','on');
if fvflag,
   xlim = [w(1) w(end)]; % If a freqvector was given, overwrite the xlim returned by freqconv 
end

% If hold is on, check if xlim in current plot is greater than the new calculated xlim
if holdflag,
   currxlim = get(ax(end),'xlim');
   xlim(1) = min([currxlim(1) xlim(1)]);
   xlim(2) = max([currxlim(2) xlim(2)]);
end
set(ax,'xlim',xlim);
if ~fvflag,
   % If xtickflag='normang' sets the ticks of x-axis in units of pi.
   %setxticks(ax,params.range,xtickflag); 
end   

%------------------------------------------------------------------------------
function [magh,ylab] = correctmag(h,normmag,magnitude)
%   CORRECTMAG scale the magnitude correctly according to given parameters.
%   CORRECTMAG will take the precomputed frequency response vector, h,
%   and calculate its magnitude according to the desired parameters.
%   MAGNITUDE can be either 'DB','LINEAR' or 'SQUARED' and NORMMAG can be
%   either 'YES' (divide everything by maximum value) or 'NO'.
%   [MAGH,YLAB] = correctmag(...) returns the correct y-axis label
%   YLAB.

magh = abs(h);
ylab = 'Magnitude';
if strmatch(lower(normmag),'yes'),
   magh = magh./max(magh);
   ylab = ['Normalized ' ylab];
end
if strmatch(lower(magnitude),'db'),
   % These next few lines of code are here to avoid "Log of zero" warnings
   zerosIndx = find(magh==0);  % Find the indicies where magnitude is zero
   magh(zerosIndx) = 1;        % Place holder
   magh = 20*log10(magh);
   magh(zerosIndx) = -inf;     % Set these magnitude values to log10(0)=-inf
   ylab = [ylab ' (dB)'];
elseif strmatch(lower(magnitude),'squared'),
   magh = magh.*magh;
   ylab = [ylab ' Squared'];
end

%------------------------------------------------------------------------------
function [params,fvflag] = freqzparse(varargin)
%FREQZPARSE Input parameter parser for the FREQZ function.
%   FREQZPARSE returns a structure, PARAMS, that contains all
%   relevant information for the FREQZ function. The elements
%   of the structure are assigned according to the input arguments.
%   Unspecified elements within the structure (that is, elements
%   corresponding to missing input arguments) are replaced by 
%   default values according to the help given in FREQZ.


% Search for 'nyquist' trailing option
return_nyquist = 0;
if nargin > 0, 
   return_nyquist = strcmp(varargin{end},'return_nyquist');   
   if return_nyquist,
      varargin = varargin(1:end-1);
   end
end
nargin = length(varargin);

%initialize flags
oldsyntax = 0;
mixedsyntax1 = 0;
mixedsyntax2 = 0;
newsyntax = 0;
fvflag = 0; % Initialize the freqvector flag at zero
rangeopts = {'half','whole'}; % These will be used in two different places
rangeerr = 'Options for ''RANGE'' are either ''HALF'' or ''WHOLE''';

switch nargin,
   % set flags for input argument types as follows:
   % oldsyntax    = 1, freqz(B,A,N,'whole',Fs)
   % mixedsyntax1 = 1, freqz(B,'parameter',value,...)
   % mixedsyntax2 = 1, freqz(B,A,'parameter',value,...)
   % newsyntax    = 1, freqz('param1',val1,'param2',val2,...)
case 1,
   % Numerator specified
   oldsyntax = 1;
case 2,
   % May be Num and Den or p-v pair
   if ~ischar(varargin{1}),
      % Numerator and denominator given
      oldsyntax = 1;
   else
      % P-V pair given
      newsyntax = 1;
   end
case 3,
   % May be old syntax (B,A,N) or Num and one p-v pair
   if ~ischar(varargin{2}),
      oldsyntax = 1;
   else
      % Num and one p-v pair
      mixedsyntax1 = 1;
   end
case 4,
   if ischar(varargin{1}),
      % 2 p-v pairs given
      newsyntax = 1;
   elseif ischar(varargin{3}),
      % (B,A,'param',val)
      mixedsyntax2 = 1;
   else
      oldsyntax = 1;
   end
case 5,
   if ischar(varargin{2}),
      % (B,'param1',val1,'param2',val2)
      mixedsyntax1 = 1;
   else
      oldsyntax = 1;
   end
otherwise, % From now on it can only be mixed syntax or new syntax
   if rem(nargin,2),
      % (B,'param1',val1,'param2',val2,...)
      mixedsyntax1 = 1;
   elseif ischar(varargin{1}),
      newsyntax = 1;
   else
      % (B,A,'param',val,...)
      mixedsyntax2 = 1;
   end
end
   
% To use the old syntax, we must check for empty input arguments and
% assign defaults
if oldsyntax,
   % Set default values
   b = varargin{1}; a = 1;  nfft = 512;  range = 'half';  freq = 'angular';
   Fs = 1; freqvector = 0:pi/512:pi-pi/512; normfreq = 'yes';
   if nargin > 1,
      a = varargin{2};
   end
   if nargin == 4,
      if ischar(varargin{4}),
         range = varargin{4};
      else
         Fs = varargin{4}; freq = 'linear';
         normfreq = 'no';
      end
   elseif nargin == 5,
      Fs = varargin{5}; freq = 'linear';
      range = varargin{4}; normfreq = 'no';
   end
   % Check that the given range is valid
   rangeindex = strmatch(lower(range),rangeopts);
   if isempty(rangeindex),
      error(rangeerr);
   else,
      range = rangeopts{rangeindex};
   end
         
   % The following code must be executed after Fs has been updated.
   if nargin > 2,
      % We must determine if it is (B,A,N) or (B,A,W)
      [m3,n3] = size(varargin{3}); % Get the size of the third argument
      if m3 > 1 & n3 > 1,
         error('Third argument must be either a frequency vector or a scalar');
      elseif m3 * n3 <= 1 ,
         % nfft given
         nfft = varargin{3};
      else
         % frequency vector given, may be linear or angular frequency
         freqvector = varargin{3}; 
         nfft = length(freqvector);
         fvflag = 1; % set a flag to indicate that a freqvector was given
      end
   end
      param = {'Numerator',b,'Denominator',a,'nfft',nfft,'range',range,...
     'frequency',freq,'Fs',Fs,'Freqvector',freqvector,'normfreq',normfreq};    
end

if mixedsyntax1,
   param = {'Numerator',varargin{1},varargin{2:end}};
elseif mixedsyntax2,
   param = {'Numerator',varargin{1},'Denominator',varargin{2},varargin{3:end}};
elseif newsyntax,
   param = varargin;
elseif ~oldsyntax,
   error('Invalid input syntax');
end

% Search param to see if a freqvector is given, if so flag it.
% search also if Fs was given, if so, set normfreq to 'no'
if ~oldsyntax,
   % Default values
   normfreq = 'yes'; 
   freq = 'angular'; 
   
   if mixedsyntax1,
      istart = 2; % start searching at the second varargin for this syntax
   else
      istart = 1; % start searching at the first varargin for the other two possible syntaxs.
   end
   for i = istart:2:nargin
      if strmatch('freqv',lower(varargin{i})),
         fvflag = 1; % set freqvector flag, this will ignore 'nfft' and 'range' if given
      end
      if strmatch('fs',lower(varargin{i})),
         % if Fs is given, these are the defaults
         normfreq = 'no'; 
         freq = 'linear';                  
      end
   end
end

% Set up default values and replace with specified values where appropriate
msg = '';
[params, msg] = parse_pv_pairs({'nfft',512;'fs',1;'freqvector',0:pi/512:pi-pi/512;...
      'range','half';'phase','yes';'normfreq',normfreq;'normmag','no';...
      'frequency',freq;'magnitude','db';...
      'numerator',1;'denominator',1},param{:});
error(msg);

% Now check that all string values set are valid. Note that this is not
% necessary when the old syntax is used since in that case the strings
% are automatically set
if ~oldsyntax
   % setup all options
   ynopts = {'yes','no'};
   rangeopts = {'half','whole'};
   phaseopts = ynopts;
   normfreqopts = ynopts;
   normmagopts = ynopts;
   freqopts = {'angular','linear'};
   magopts = {'db','linear','squared'};
   % search for parameter matching
   idx = strmatch(lower(params.range),rangeopts);
   if isempty(idx),
      error(rangeerr);
   end
   idx = strmatch(lower(params.phase),phaseopts);
   if isempty(idx),
      error('Options for ''PHASE'' are either ''YES'' or ''NO''');
   end
   idx = strmatch(lower(params.normfreq),normfreqopts);
   if isempty(idx),
      error('Options for ''NORMFREQ'' are either ''YES'' or ''NO''');
   end
   idx = strmatch(lower(params.normmag),normmagopts);
   if isempty(idx),
      error('Options for ''NORMMAG'' are either ''YES'' or ''NO''');
   end
   idx = strmatch(lower(params.frequency),freqopts);
   if isempty(idx),
      error('Options for ''FREQUENCY'' are either ''ANGULAR'' or ''LINEAR''');
   end
   idx = strmatch(lower(params.magnitude),magopts);
   if isempty(idx),
      error('Options for ''MAGNITUDE'' are either ''DB'',''LINEAR'' or ''SQUARED''');
   end
end

params.return_nyquist = return_nyquist;

% [EOF] freqz.m

