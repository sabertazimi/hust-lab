function [a,b,c,d] = comden(Gain,Zero,Pole)
%COMDEN  Realization of SIMO or MISO ZPK model with common denominator.
%
%   [A,B,C,D] = COMDEN(GAIN,ZERO,POLE)  returns a state-space
%   realization for the SIMO or MISO model with data ZERO, POLE,
%   GAIN.  The last argument POLE is the vector of common poles.

%   Author: P. Gahinet, 5-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.10 $  $Date: 1998/09/18 17:55:26 $

% Get number of outputs/inputs 
[p,m] = size(Gain);

% Handle various cases
if ~any(Gain) | isempty(Pole),
   a = [];   
   b = zeros(0,m);  
   c = zeros(p,0);  
   d = Gain;
   
elseif p==1 & m==1,
   % SISO case: use specialized algorithm that realizes the ZPK 
   % transfer function as a series of first or second orders
   Zero = Zero{1};
   nz = length(Zero);
   np = length(Pole);
   
   % Assume zeros and poles are conjugate and put complex pairs first
   cp = Pole(imag(Pole)>0);  ncp = length(cp);
   cz = Zero(imag(Zero)>0);  ncz = length(cz);
   p = zeros(np,1);   
   p([1:2:2*ncp 2:2:2*ncp 2*ncp+1:np]) = [cp ; conj(cp) ; Pole(~imag(Pole))];
   z = zeros(nz,1);   
   z([1:2:2*ncz 2:2:2*ncz 2*ncz+1:nz]) = [cz ; conj(cz) ; Zero(~imag(Zero))];
   
   % Make number of poles even. If odd to start with, realize (s-z_np)/(s-p_np)
   np2 = floor(np/2);
   [a,b,c,d] = secondorder(z(2*np2+1:nz),p(2*np2+1:np));
   
   % Loop over remaining pairs of poles/zeros, realize 2nd-order system,
   % and form series interconnection
   npe = 2*np2;
   na = size(a,1);
   if npe,
      a(npe,npe) = 0;  b(npe,1) = 0;  c(1,npe) = 0;
   end
   for j=1:2:npe,
      % Inline series interconnection for max. speed
      [aj,bj,cj,dj] = secondorder(z(j:min(j+1,nz)),p([j j+1]));
      naj = size(aj,1);
      a(1:na+naj,na+1:na+naj) = [b(1:na,:)*cj ; aj];
      b(1:na+naj,1) = [b(1:na,:)*dj ; bj];
      c(1,na+1:na+naj) = d * cj;
      d = d*dj;
      na = na+naj;
   end
   
   % Add gain
   d = d * Gain;
   ks = sqrt(abs(Gain));
   b = b * ks; 
   c = c * (sign(Gain)*ks);
   
else
   % SIMO case: convert to TF and use COMPREAL.  First form the 
   % numerator array NUM (PxR matrix)
   mp = max(m,p);
   r = length(Pole)+1;       % common denominator length
   num = zeros(mp,r);
   for i=1:mp,
      % i-th row is numerator of i-th output channel
      ni = Gain(i) * poly(Zero{i});
      num(i,r-length(ni)+1:r) = ni;
   end
   
   % Call compreal
   [a,b,c,d] = compreal(num,poly(Pole));
   
   % Transpose/permute A,B,C,D in MISO case to make A upper Hessenberg
   if p<m,
      b0 = b;
      a = a';  b = c';  c = b0';  d = d';
      perm = size(a,1):-1:1;
      a = a(perm,perm);
      b = b(perm,:);
      c = c(:,perm);
   end
   
end


%%%%%%%%%%%%%

function [a,b,c,d] = secondorder(z,p)
%SECONDORDER  Fast companion realization for second-order models

lz = length(z);
lp = length(p);
d = (lz==lp);

switch lp
case 0
   a = [];
   b = zeros(0,1);
   c = zeros(1,0);
case 1
   % (s-z)/(s-p) or 1/(s-p)
   % T = multiplicative factor of B or C
   a = p;
   b = 1;
   c = [1 p-sum(z)];
   c = c(lz+1);
case 2
   % den = (s-p1)*(s-p2)
   den = [-(p(1)+p(2)) p(1)*p(2)];
   a = [-den ; 1 0];
   b = [1;0];
   c = [0 1 -sum(z) prod(z)];
   c = c(lz+1:lz+2) - (lz==2) * den;
end

% Scale B wrt C
t = max(abs(c));
if t>1,
   t = sqrt(t);
   b = t*b;
   c = c/t;
end

