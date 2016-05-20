function y = chirp(t,f0,t1,f1,method,phi)
%CHIRP  Swept-frequency cosine generator.
%   Y = CHIRP(T,F0,T1,F1) generates samples of a linear swept-frequency
%   signal at the time instances defined in array T.  The instantaneous
%   frequency at time 0 is F0 Hertz.  The instantaneous frequency F1
%   is achieved at time T1.  By default, F0=0, T1=1, and F1=100.
%
%   Y = CHIRP(T,F0,T1,F1,'method') specifies alternate sweep methods.
%   Available methods are 'linear','quadratic', and 'logarithmic'; the
%   default is 'linear'.  Note that for a log-sweep, F1>F0 is required.
%
%   Y = CHIRP(T,F0,T1,F1,'method', PHI) allows an initial phase PHI to
%   be specified in degrees.  By default, PHI=0.
%
%   Default values are substituted for empty or omitted trailing input
%   arguments.
%
%   EXAMPLE 1: Compute the spectrogram of a linear chirp.
%     t=0:0.001:2;                 % 2 secs @ 1kHz sample rate
%     y=chirp(t,0,1,150);          % Start @ DC, cross 150Hz at t=1sec 
%     specgram(y,256,1E3,256,250); % Display the spectrogram
%
%   EXAMPLE 2: Compute the spectrogram of a quadratic chirp.
%     t=-2:0.001:2;                % +/-2 secs @ 1kHz sample rate
%     y=chirp(t,100,1,200,'q');    % Start @ 100Hz, cross 200Hz at t=1sec 
%     specgram(y,128,1E3,128,120); % Display the spectrogram
%
%   See also GAUSPULS, SAWTOOTH, SINC, SQUARE.

%   Author(s): D. Orofino, T. Krauss, 3/96
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.1 $
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:18 $

% Parse inputs, and substitute for defaults:
error(nargchk(1,6,nargin));
if nargin<6, phi=[]; end
if nargin<5, method=[]; end
if nargin<4, f1=[]; end
if nargin<3, t1=[]; end
if nargin<2, f0=[]; end
if isempty(phi), phi=0; end
if isempty(method), method='linear'; end
if isempty(f1), f1=100; end
if isempty(t1), t1=1; end
if isempty(f0), f0=0; end

% Parse the method string:
% Set p=1 for linear, 2 for quadratic, 3 for logarithmic
method=lower(method);
p=strmatch(method,strvcat('linear','quadratic','logarithmic'));
if isempty(p),
  error('Unknown method selected.');
elseif length(p)>1,
  error('Ambiguous method selected.');
end

if p==3,
  % Logarithmic chirp:
  if f1<f0, error('F1>F0 is required for a log-sweep.'); end
  beta = log10(f1-f0)/t1;
  y = cos(2*pi * ( (10.^(beta.*t)-1)./(beta.*log(10)) + f0.*t + phi/360));

else
  % Polynomial chirp: p is the polynomial order
  beta = (f1-f0).*(t1.^(-p));
  y = cos(2*pi * ( beta./(1+p).*(t.^(1+p)) + f0.*t + phi/360));
end

% end of chirp.m
