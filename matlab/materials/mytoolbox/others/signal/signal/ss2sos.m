function varargout=ss2sos(A,B,C,D,IU,varargin)
%SS2SOS State-space to second-order sections model conversion.
%   [SOS,G]=SS2SOS(A,B,C,D) finds a matrix SOS in second-order sections
%   form and a gain G which represent the same system as the one with
%   single-input, single-output state space matrices A, B, C, and D. 
%   The zeros and poles of the system A, B, C, D must be in complex
%   conjugate pairs. The system must be stable.
%
%   [SOS,G] = SS2SOS(A,B,C,D,IU) uses the IUth input of the multi-input,
%   single-output state space matrices A, B, C and D.
% 
%   SOS is an L by 6 matrix with the following structure:
%       SOS = [ b01 b11 b21  1 a11 a21 
%               b02 b12 b22  1 a12 a22
%               ...
%               b0L b1L b2L  1 a1L a2L ]
%
%   Each row of the SOS matrix describes a 2nd order transfer function:
%                 b0k +  b1k z^-1 +  b2k  z^-2
%       Hk(z) =  ----------------------------
%                  1 +  a1k z^-1 +  a2k  z^-2
%   where k is the row index.
%
%   G is a scalar which accounts for the overall gain of the system. If
%   G is not specified, the gain is embedded in the first section. 
%   The second order structure thus describes the system H(z) as:
%       H(z) = G*H1(z)*H2(z)*...*HL(z)
%
%   SS2SOS(A,B,C,D,DIR_FLAG) specifies the ordering of the 2nd order
%   sections. If DIR_FLAG is equal to 'UP', the first row will contain
%   the poles closest to the origin, and the last row will contain the
%   poles closest to the unit circle. If DIR_FLAG is equal to 'DOWN', the
%   sections are ordered in the opposite direction. The zeros are always
%   paired with the poles closest to them. DIR_FLAG defaults to 'UP'.
%
%   SS2SOS(A,B,C,D,DIR_FLAG,SCALE) specifies the desired scaling of the
%   gain and the numerator coefficients of all 2nd order sections. SCALE
%   can be either 'NONE', 'INF' or 'TWO' which correspond to no scaling,
%   infinity norm scaling and 2-norm scaling respectively. SCALE defaults
%   to 'NONE'. Using infinity-norm scaling in conjunction with 'UP'
%   ordering will minimize the probability of overflow in the realization.
%   On the other hand, using 2-norm scaling in conjunction with 'DOWN' 
%   ordering will minimize the peak roundoff noise.
%
%   See also ZP2SOS, SOS2ZP, SOS2TF, SOS2SS, tf2SOS, CPLXPAIR.

%   NOTE: restricted to real coefficient systems (poles  and zeros 
%             must be in conjugate pairs)

%   References:
%     [1] L. B. Jackson, DIGITAL FILTERS AND SIGNAL PROCESSING, 3rd Ed.
%              Kluwer Academic Publishers, 1996, Chapter 11.
%     [2] S.K. Mitra, DIGITAL SIGNAL PROCESSING. A Computer Based Approach.
%              McGraw-Hill, 1998, Chapter 9.
%     [3] P.P. Vaidyanathan. ROBUST DIGITAL FILTER STRUCTURES. Ch 7 in
%              HANDBOOK FOR DIGITAL SIGNAL PROCESSING. S.K. Mitra and J.F.
%              Kaiser Eds. Wiley-Interscience, N.Y.

%   Author(s): R. Losada 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/07/30 14:43:20 $

error(nargchk(4,7,nargin))
if nargin < 5,
   IU = 1;
end

if ~isempty(B),
   if IU > size(B,2),
      error(['State-space system has only ' sprintf('%d',size(B,2)) ' inputs.']);
   end
else,
   if IU > 1,
      error(['State-space system has only one input.']);
   end
end

% Find Poles and Zeros
[z,p,k] = ss2zp(A,B,C,D,IU);

[varargout{1:nargout}] = zp2sos(z,p,k,varargin{:});

