function [sos,g] = zp2sos(varargin)
%ZP2SOS Zero-pole-gain to second-order sections model conversion.
%   [SOS,G] = ZP2SOS(Z,P,K) finds a matrix SOS in second-order sections 
%   form and a gain G which represent the same system H(z) as the one
%   with zeros in vector Z, poles in vector P and gain in scalar K.
%   The poles and zeros must be in complex conjugate pairs. Because of
%   the scaling done, all poles must be inside the unit circle, i.e,
%   the system must be stable.
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
%   ZP2SOS(Z,P,K,DIR_FLAG) specifies the ordering of the 2nd order
%   sections. If DIR_FLAG is equal to 'UP', the first row will contain
%   the poles closest to the origin, and the last row will contain the
%   poles closest to the unit circle. If DIR_FLAG is equal to 'DOWN', the
%   sections are ordered in the opposite direction. The zeros are always
%   paired with the poles closest to them. DIR_FLAG defaults to 'UP'.
%
%   ZP2SOS(Z,P,K,DIR_FLAG,SCALE) specifies the desired scaling of the gain
%   and the numerator coefficients of all 2nd order sections. SCALE can be
%   either 'NONE', 'INF' or 'TWO' which correspond to no scaling, infinity
%   norm scaling and 2-norm scaling respectively. SCALE defaults to 'NONE'. 
%   Using infinity-norm scaling in conjunction with 'UP' ordering will
%   minimize the probability of overflow in the realization. On the other
%   hand, using 2-norm scaling in conjunction with 'DOWN' ordering will
%   minimize the peak roundoff noise.
%
%   See also TF2SOS, SOS2ZP, SOS2TF, SOS2SS, SS2SOS, CPLXPAIR.

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
%   $Revision: 1.3 $  $Date: 1998/07/30 19:05:40 $

error(nargchk(2,5,nargin))
z = varargin{1};
p = varargin{2};

% Setup default values
k = 1; 
direction_flag = 'up';
scale = 'none';

% Replace with given values
if nargin > 2,
   if ~isempty(varargin{3}),
      k = varargin{3};
   end
   if nargin > 3,
      if ~isempty(varargin{4}),
         direction_flag = varargin{4};
      end
      if nargin > 4,
         if ~isempty(varargin{5}),
            scale = varargin{5};
         end
      end
   end
end

% Input check
diropts = {'up','down'};
scaleopts = {'none','inf','two'};
indx1 = strmatch(lower(direction_flag),diropts);
if isempty(indx1),
   error('DIR_FLAG must be either ''UP'' or ''DOWN''.');
end
direction_flag = diropts{indx1};
indx2 = strmatch(lower(scale),scaleopts);
if isempty(indx2),
   error('SCALE must be either ''NONE'', ''INF'' or ''TWO''.');
end
scale = scaleopts{indx2};

% Check for stability
if 1 - max(abs(p)) < eps^(3/4),
   error('The system must be stable.');
end
   
% Order the poles and zeros in complex conj. pairs
z = cplxpair(z);
p = cplxpair(p);

% Get the number of poles and zeros
lz = length(z);
lp = length(p);
if lz > lp,
   error('The number of zeros cannot be greater than the number of poles.');
end
L = ceil(lp/2);

% break up conjugate pairs and real poles
ind = find(abs(imag(p))>0);
p_conj = p(ind);   % the poles that have conjugate pairs
ind_complement = 1:length(p);
if length(ind)>0
    ind_complement(ind) = [];
end
p_real = p(ind_complement);    % the poles that are real

% order the conjugate pole pairs according to proximity to unit circle
[temp,ind] = sort(abs(p_conj - exp(j*angle(p_conj))));
p_conj = p_conj(ind);
% order the real poles according to proximity to unit circle too
[temp,ind] = sort(abs(p_real - sign(p_real)));
p_real = p_real(ind);

% Save the ordered poles
new_p = [p_conj;p_real];

% break up conjugate pairs and real zeros
ind = find(abs(imag(z))>0);
z_conj = z(ind);   % the zeros that have conjugate pairs
ind_complement = 1:length(z);
if length(ind)>0
    ind_complement(ind) = [];
end
z_real = z(ind_complement);    % the zeros that are real

% order the conjugate zero pairs according to proximity to pole pairs
new_z = [];
for i = 1:length(z_conj)/2,
    if ~isempty(p_conj),
        [temp,ind1] = min(abs(z_conj-p_conj(1)));
        [temp,ind2] = min(abs(z_conj-p_conj(2)));
        new_z = [new_z; z_conj(ind1); z_conj(ind2)];
        p_conj([1 2]) = [];
        z_conj([ind1 ind2]) = [];
    elseif ~isempty(p_real),
        [temp,ind] = min(abs(z_conj-p_real(1)));
        new_z = [new_z; z_conj(ind); z_conj(ind+1)];
        z_conj([ind ind+1]) = [];
        p_real(1) = [];
        if ~isempty(p_real),
            p_real(1) = [];
        end
    else
        new_z = [new_z; z_conj];
        break
    end
end

% order the real zeros according to proximity to pole pairs too
for i = 1:length(z_real),
    if ~isempty(p_conj),
        [temp,ind] = min(abs(z_real-p_conj(1)));
        new_z = [new_z; z_real(ind)];
        z_real(ind) = [];
        p_conj(1) = [];
    elseif ~isempty(p_real),
        [temp,ind] = min(abs(z_real-p_real(1)));
        new_z = [new_z; z_real(ind)];
        z_real(ind) = [];
        p_real(1) = [];
    else
        new_z = [new_z; z_real];
        break
    end
end

sos = [];

if lz == 0,
   if lp == 0,
      sos = [1 0 0 1 0 0];
   elseif ~rem(lp,2),
      sos = sosfun(1,2*L-1,new_p,sos); %even number of poles
   else
      sos = sosfun(1,2*(L-1)-1,new_p,sos); %odd number of poles
      sos = last_pole([],new_p(end),sos);%handle the last pole separately
   end   
else
   if ~rem(lz,2),
      sos = sosfun2(1,lz-1,new_z,new_p,sos); %even number of zeros
      % Now continue for the excess poles if any
      if ~rem(lp,2),
         sos = sosfun(lz+1,lp,new_p,sos); %even number of poles
      else
         sos = sosfun(lz+1,lp-1,new_p,sos); %odd number of poles
         sos = last_pole([],new_p(end),sos);%handle the last pole separately
      end
   else
      sos = sosfun2(1,lz-1,new_z,new_p,sos); %odd number of zeros
      %handle the last zero separately
      if lz == lp, %if number of poles = number of zeros
         sos = last_pole(new_z(lz),new_p(lz),sos);%handle the last pole separately
      else % more poles than zeros      
         [num,den] = zp2tf(new_z(lz),new_p(lz:lz+1),1);
         sos = [num den;sos];
         % Now continue for the excess poles if any
         if ~rem(lp,2),
            sos = sosfun(lz+2,lp,new_p,sos); %even number of poles
         else
            sos = sosfun(lz+2,lp-1,new_p,sos); %odd number of poles
            sos = last_pole([],new_p(end),sos);%handle the last pole separately
         end
      end
   end
end

% Change direction if requested
if strcmp(direction_flag,'down'),
   sos = flipud(sos);
end

% At this point no scaling has been peformed
% The leading coefficients of both num and den are one.

% Perform appropriate scaling
if any(strcmp(scale,{'two','inf'})),
   [sos,k] = scaling(sos,k,L,scale);
end

% Embed the gain if only one output argument was specified
if nargout == 1,
   sos(1,1:3) = k*sos(1,1:3);   
else
   g = k;
end

function [sos,g] = scaling(sos,k,L,scale) 
% SCALING, scale the cascaded sos filters using the infinity norm
% or the 2 norm as specified.
% Find the L scaling factors s(m) and perform the scaling
Fnum = 1;
Fden = 1;
den = sos(1,4:6);
if strcmp(scale,'inf'),
   F = freqz(1,den,256);
   s(1) = max(abs(F));
elseif strcmp(scale,'two'),
   % Find the efective time constant of the transfer function by using
   % the abs of the largest pole (see Orfanidis, Intro. to Sig. Proc. 1996, pp 238)
   rho = max(abs(roots(den)));
   tol = 0.01; % This value can be modified for greater or less accuracy in the two norm approximation
   logtol = log(tol); % We don't want to be recomputing this all the time
   neff = logtol/log(rho);
   H = impz(1,den,neff);
   s(1) = norm(H);
end
for m = 2:L
   den = sos(m,4:6);
   Fnum = conv(Fnum,sos(m-1,1:3));
   Fden = conv(Fden,sos(m-1,4:6));
   Fden2 = conv(Fden,den);
   if strmatch(lower(scale),'inf'),
      F = freqz(Fnum,Fden2,256);
      s(m) = max(abs(F));
   elseif strmatch(lower(scale),'two'),
      rho = max(abs(roots(Fden2)));
      neff = logtol/log(rho); % Again, this is an approximation of the effective time it takes the impulse response to decay
      H = impz(Fnum,Fden2,neff);
      s(m) = norm(H);
   end
   % Now perform the scaling for the first L-1 sos sections
   sos(m-1,1:3) = s(m-1)./s(m).*sos(m-1,1:3);
end
% And now scale the last section
sos(end,1:3) = k*s(end)*sos(end,1:3);
g = 1/s(1);

function sos = last_pole(z,p,sos)
% Handle the last pole separately
[num,den] = zp2tf(z,p,1); 
num = [num 0];
den = [den 0];
sos = [num den;sos];

function sos = sosfun(start,stop,p,sos)
% This function was made to not repeat code in several places
for m = start:2:stop, 
   [num,den] = zp2tf([],p(m:m+1),1);
   sos = [num den;sos];
end

function sos = sosfun2(start,stop,z,p,sos)
% This function was made to not repeat code in several places
for m = start:2:stop, 
   [num,den] = zp2tf(z(m:m+1),p(m:m+1),1);
   sos = [num den;sos];
end

