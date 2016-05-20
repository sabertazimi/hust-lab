function [DH,DW] = lowpass(N, F, GF, W, delay)
%LOWPASS Desired frequency response for lowpass filters.
%  CREMEZ(N,F,'lowpass', ...) designs a linear-phase lowpass filter
%  response using CREMEZ.
%
%  CREMEZ(N,F,{'lowpass', D}, ...) specifies group-delay offset D such
%  that the filter response will have a group delay of N/2 + D in
%  units of the sample interval, where N is the filter order.
%  Negative values create less delay, while positive values create
%  more delay.  By default, D=0.
%
%  The symmetry option SYM defaults to 'even' if unspecified in the
%  call to CREMEZ, and if no negative band edge frequencies are
%  specified in F.
%
%  EXAMPLE: Design a 31-tap, complex lowpass filter
%    b = cremez(30,[-1 -.5 -.4 .7 .8 1],'lowpass');
%    freqz(b,1,512,'whole');
%
%  EXAMPLE: Reduced group delay filter response:
%    b = cremez(30,[0 .6 .7 1],{'lowpass',-1});
%
%  See also CREMEZ.

%   Authors: L. Karam, J. McClellan
%   Revised: October 1996, D. Orofino
%
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 16:14:46 $

%  [DH,DW]=LOWPASS(N,F,GF,W,DELAY)
%      N: filter order (length minus one)
%      F: vector of band edges
%     GF: vector of interpolated grid frequencies
%      W: vector of weights, one per band
%  DELAY: negative slope of the phase.
%           N/2=(L-1)/2 for exact linear phase.
%
%     DH: vector of desired filter response (mag & phase)
%     DW: vector of weights (positive)
%
% NOTE: DH(GF) and DW(GF) are specified as functions of frequency

% Support query by CREMEZ for the default symmetry option:
if nargin==2,
  % Return symmetry default:
  if strcmp(N,'defaults'),
    % Second arg (F) is cell-array of args passed later to function:
    num_args = length(F);
    % Get they delay value:
    if num_args<5, delay=0; else delay=F{5}; end
    % Use delay arg to base symmetry decision:
    if isequal(delay,0), DH = 'even'; else DH='real'; end
    return
  end
end

% Standard call:
error(nargchk(4,5,nargin));
if nargin < 5, delay = 0; end
delay = delay + N/2;  % adjust for linear phase

Le = length(F);
if (Le == 4),
  if any(F < 0),
    error('Band edges must be non-negative for 2-band Lowpass designs.');
  end
elseif (Le == 6),
  if F(3)*F(4) > 0,
    error('Passband must include DC for 3-band Lowpass designs.');
  end
else
  error('There must be either 4 or 6 band edges for Lowpass designs.')
end

% Optimization weighting:
W = [1;1]*(W(:).'); W = W(:);

% Construct "lowpass" magnitude response:
mags = zeros(size(W));
mags(Le-3:Le-2) = 1;   % Unity in 2nd-to-last band

DH = table1([F(:), mags], GF) .* exp(-1i*pi*GF*delay);
DW = table1([F(:),    W], GF);

% end of lowpass.m
