function varargout = tf2sos(B,A,varargin)
%TF2SOS Transfer Function to Second Order Section conversion.
%   [SOS,G] = TF2SOS(B,A) finds a matrix SOS in second-order sections 
%   form and a gain G which represent the same system H(z) as the one
%   with numerator B and denominator A.  The poles and zeros of H(z)
%   must be in complex conjugate pairs. Because of the scaling done,
%   all poles must be inside the unit circle, i.e, the system must be
%   stable.
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
%   TF2SOS(B,A,DIR_FLAG) specifies the ordering of the 2nd order
%   sections. If DIR_FLAG is equal to 'UP', the first row will contain
%   the poles closest to the origin, and the last row will contain the
%   poles closest to the unit circle. If DIR_FLAG is equal to 'DOWN', the
%   sections are ordered in the opposite direction. The zeros are always
%   paired with the poles closest to them. DIR_FLAG defaults to 'UP'.
%
%   TF2SOS(B,A,DIR_FLAG,SCALE) specifies the desired scaling of the gain
%   and the numerator coefficients of all 2nd order sections. SCALE can be
%   either 'NONE', 'INF' or 'TWO' which correspond to no scaling, infinity
%   norm scaling and 2-norm scaling respectively. SCALE defaults to 'NONE'. 
%   Using infinity-norm scaling in conjunction with 'UP' ordering will
%   minimize the probability of overflow in the realization. On the other
%   hand, using 2-norm scaling in conjunction with 'DOWN' ordering will
%   minimize the peak roundoff noise.
%
%   See also ZP2SOS, SOS2ZP, SOS2TF, SOS2SS, SS2SOS, CPLXPAIR.

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
%   $Revision: 1.5 $  $Date: 1998/12/23 22:37:04 $

error(nargchk(2,4,nargin))

% Pad A or B with trailing zeros if B and A are of different length
if length(B) < length(A)
   B = [B zeros(1,length(A)-length(B))];
elseif length(A) < length(B)
   A = [A zeros(1,length(B)-length(A))];
end

% Remove trailing zeros when they are at both num and den
while B(end) == 0 & A(end) == 0,
   B(end) = [];
   A(end) = [];
end

% Find Poles and Zeros
[z,p,k] = tf2zp(B,A);
[varargout{1:nargout}] = zp2sos(z,p,k,varargin{:});

