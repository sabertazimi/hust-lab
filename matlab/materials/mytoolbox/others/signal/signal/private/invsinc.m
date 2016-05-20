function [DH,DW] = invsinc(N, F, GF, W, sinc_arg, delay)
%INVSINC Desired amplitude response for invsinc filters.
%INVSINC Desired frequency response for invsinc filters.
%  CREMEZ(N,F,'invsinc', ...) designs a linear-phase inverse-sinc
%  filter response using CREMEZ.
%
%  CREMEZ(N,F,{'invsinc', A}, ...) specifies a gain for the argument
%  of the sinc-function, computed as sinc(A*f), where f contains the
%  optimization grid frequencies normalized to the range [-1,1].  By
%  default, A=1.
%
%  CREMEZ(N,F,{'invsinc', A, D}, ...) specifies group-delay offset D
%  such that the filter response will have a group delay of N/2 + D
%  in units of the sample interval, where N is the filter order.
%  Negative values create less delay, while positive values create
%  more delay.  By default, D=0.
%
%  The symmetry option SYM defaults to 'even' if unspecified in the
%  call to CREMEZ, if no negative band edge frequencies are
%  specified in F.
%
%  See also CREMEZ.

%   Authors: L. Karam, J. McClellan
%   Revised: October 1996, D. Orofino
%
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 16:14:42 $

%  [DH,DW]=INVSINC(N,F,GF,W,ARG,DELAY)
%       N: filter order (length minus one)
%       F: vector of band edges
%      GF: vector of frequencies at which to evaluate
%       W: vector of weights, one per band
%     ARG: gain argument to sinc-function
%   DELAY: negative slope of the phase.
%           M/2=(L-1)/2 for exact linear phase.
%
%     DH: vector of desired filter response (mag & phase)
%     DW: vector of weights (positive)
%
% NOTE: DH(GF) and DW(GF) are specified as functions of frequency

% Here are three examples of calling cremez:
%
% The following is equivalent to using remez (if it could do arb mag):
% [h,del,res] = cremez(32,[0 0.3 0.4 1],{'invsinc',3},[1,1],'even','trace');
%
% To get the same answer when approximating over the full band, use:
% [h,del,res] = cremez(32,[-1 -0.4 -0.3 0.3 0.4 1],{'invsinc',3,0},...
%                  [1,1,1],'real','trace');
%
% To get less delay, do a complex approx with the 2nd stage optimization:
% [h,del,res] = cremez(32,[-1 -0.4 -0.3 0.3 0.4 1],{'invsinc',3,-1},...
%                [1,1,1],'real','trace');
%
%  See also CREMEZ.

% Support query by CREMEZ for the default symmetry option:
if nargin==2,
  % Return symmetry default:
  if strcmp(N,'defaults'),
    % Second arg (F) is cell-array of args passed later to function:
    num_args = length(F);
    % Get the delay value:
    if num_args<6, delay=0; else delay=F{6}; end
    % Use delay arg to base symmetry decision:
    if isequal(delay,0), DH='even'; else DH='real'; end
    return
  end
end

% Standard call:
error(nargchk(4,6,nargin));
if nargin<5,
  error('Inverse-sinc designs require specification a gain argument');
end
if nargin < 6, delay = 0; end
delay = delay + N/2;  % adjust for linear-phase

Le = length(F);
if Le == 4,
  if any(F < 0)
    error(['Band edges must be non-negative for 2-band ' ...
           'Inverse-Sinc designs.']); 
  end
elseif Le == 6,
  if F(3)*F(4) > 0,
    error('Passband must include DC for 3-band Inverse-Sinc designs.');
  end
else
  error('There must be either 4 or 6 band edges for Inverse-Sinc designs.')
end

W    = [1;1] * (W(:).'); W = W(:);
mags = zeros(size(W)); mags(Le-3:Le-2) = 1;
DW   = table1( [F(:), W], GF );

% The following loop for generating DH(GF) assumes
% disjoint bands.  Otherwise, duplicate band edges will
% have to be detected and only one evaluation of DH(GF) made.

jkl = find( (GF >= F(1)) & (GF <= F(2)) );
if mags(1) == 1,
  DH = 1./sinc(sinc_arg*GF(jkl));
else
  DH = zeros(size(jkl));
end
for jj = 3:2:Le,
  jkl = find( (GF >= F(jj)) & (GF <= F(jj+1)) );
  if mags(jj) == 1,
    DH = [DH; 1./sinc(sinc_arg*GF(jkl))];
  else
    DH = [DH; zeros(size(jkl))];
  end
end
DH = DH .* exp(-1i*pi*GF*delay);

% end of invsinc.m
