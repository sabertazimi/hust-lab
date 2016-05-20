function h = freqresp(sys,w,npts,PlotType)
%FREQRESP  Frequency response of LTI models.
%
%   H = FREQRESP(SYS,W) computes the frequency response H of the 
%   LTI model SYS at the frequencies specified by the vector W.
%   These frequencies should be real and in radians/second.  
%
%   If SYS has NY outputs and NU inputs, and W contains NW frequencies, 
%   the output H is a NY-by-NU-by-NW array such that H(:,:,k) gives 
%   the response at the frequency W(k).
%
%   If SYS is a S1-by-...-Sp array of LTI models with NY outputs and 
%   NU inputs, then SIZE(H)=[NY NU NW S1 ... Sp] where NW=LENGTH(W).
%
%   See also EVALFR, BODE, SIGMA, NYQUIST, NICHOLS, LTIMODELS.

%   Clay M. Thompson 7-10-90
%   Revised: AFP 9-10-95, PG 5-2-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.17 $  $Date: 1998/09/18 17:57:56 $

error(nargchk(2,2,nargin));
if ~isa(w,'double') | ndims(w)>2 | min(size(w))>1,
   error('W must be a vector of real frequencies.')
end
w = w(:);
lw = length(w);

% Extract data
[z,p,k,Ts] = zpkdata(sys);
Ts = abs(Ts);
sizes = size(k);

% Quick exit if empty system or empty w 
if lw==0 | any(sizes==0),
   h = zeros([sizes(1:2) , lw , sizes(3:end)]);
   return
end

% Form vector s of complex frequencies
if Ts==0,
   % Watch for case where W contains complex frequencies (old syntax)
   if isreal(w),
      w = sqrt(-1)*w;
   end
   s = w;
elseif isreal(w),
   % Discrete with real freqs
   w = sqrt(-1)*w*abs(Ts);
   s = exp(w);  % z = exp(j*w*Ts)
else
   % Discrete with complex frequencies (old syntax)
   s = w;
   w = log(s);
end
s = s.';

% Compute frequency response
h = zeros([lw , sizes]); % More convenient for loop below

SingWarn = '';
wng = warning;
warning off

for i=1:prod(sizes),
   zi = z{i};
   pi = p{i};
   sz = s(ones(1,length(zi)),:) - zi(:,ones(1,lw));
   sp = s(ones(1,length(pi)),:) - pi(:,ones(1,lw));
   denval = prod(sp,1);
   if any(denval==0),
      SingularWarn = 'Singularity in frequency response due to jw-axis or unit-circle poles.';
   end
   szp = prod(sz,1) ./ denval;
   h(:,i) = k(i) * szp(:);
end

warning(wng)
if length(SingWarn)>0,
   warning(SingWarn)
end

% Reorder dimensions
h = permute(h,[2 3 1 4:length(sizes)+1]);

% Finally add delay contribution
Td = totaldelay(sys);
if any(Td(:)),
   hTd = delayfr(Td,w);
   if ndims(hTd)<length(sizes)+1,
      hTd = repmat(hTd,[1 1 1 sizes(3:end)]);
   end
   h = hTd .* h;
end
