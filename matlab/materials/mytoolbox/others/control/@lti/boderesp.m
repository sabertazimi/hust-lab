function [mag,phase,w] = boderesp(sys,w,NoW)
%BODERESP   Computes the Bode response MAG and PHASE of the single
%           LTI model SYS over the frequency grid w.
%
%   WARNING: BODERESP MAY MODIFY W (WHEN W IS UNSPECIFIED).
%
%    LOW-LEVEL FUNCTION.

%   Author(s)  P. Gahinet  8-14-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/05/18 22:41:39 $

[Ny,Nu] = size(sys);
Td = totaldelay(sys);
if sys.Ts,
   Td = Td * sys.Ts;
end

% In continuous-time SISO case, determine phase extrema
% and add corresponding freqs.
if NoW & sys.Ts==0 & Nu*Ny==1 & size(sys,'order')<20,
   % Get NUM and DEN of equivalent continuous system
   [num,den] = tfdata(sys,'v');

   % Write NUM(jw) = N1(x) + jw N2(x) 
   %       DEN(jw) = D1(x) + jw D2(x)  with x = w^2
   altsgn = ones(1,max(length(num),length(den)));
   altsgn(2:2:end) = -1;
   n1 = num(end:-2:1);     n1 = fliplr(n1 .* altsgn(1:length(n1)));
   n2 = num(end-1:-2:1);   n2 = fliplr(n2 .* altsgn(1:length(n2)));
   d1 = den(end:-2:1);     d1 = fliplr(d1 .* altsgn(1:length(d1)));
   d2 = den(end-1:-2:1);   d2 = fliplr(d2 .* altsgn(1:length(d2)));

   % Extrema are solutions x>0 of 
   %    [N1*N2+2x*(N2'N1-N1'N2)] * [D1^2+x*D2^2] = 
   %    [D1*D2+2x*(D2'D1-D1'D2)] * [N1^2+x*N2^2]
   lhs1 = psum(conv(n1,n2),2*[psum(conv(polyder(n2),n1),-conv(polyder(n1),n2)) 0]);
   lhs2 = psum(conv(d1,d1),[conv(d2,d2) 0]);
   rhs1 = psum(conv(d1,d2),2*[psum(conv(polyder(d2),d1),-conv(polyder(d1),d2)) 0]);
   rhs2 = psum(conv(n1,n1),[conv(n2,n2) 0]);
   x = roots(psum(conv(lhs1,lhs2),-conv(rhs1,rhs2)));
   wp = sqrt(real(x(real(x)>w(1)^2 & abs(imag(x))<10*sqrt(eps)*real(x))));  
   w = sort([w ; wp(wp<w(end))]);   % wp = frequencies of phase extrema
end


% Calculate complex frequency response (ignore delays at this point)
sys.ioDelayMatrix = zeros(Ny,Nu);
sys.InputDelay = zeros(Nu,1);
sys.OutputDelay = zeros(Ny,1);
h = freqresp(sys,w);  
lw = length(w);

% Calculate mag and phase
mag = abs(h);
% Comment out only one of next two lines for (un)wrapping
% Note that phase unwrapping will not always work; it is
% only a "guess" as to whether +-360 should be added to the phase 
% to make it more aesthetically pleasing.  (See UNWRAP.M)
%phase = (180/pi)*atan2(imag(h),real(h));
phase = (180/pi)*unwrap(atan2(imag(h),real(h)),[],3);

% Add exact phase shift -W*Td due to time delay
if any(Td(:)),
   for k=1:lw,
      phase(:,:,k) = phase(:,:,k) - (180/pi*w(k)) * Td;
   end
end

% Correct phase anomaly for plants with integrators by subtracting 360 deg
ix = find(phase(:,:,1)>0 & ~isfinite(dcgain(sys)));
if ~isempty(ix),
   phase = reshape(phase,[Ny*Nu lw]);
   phase(ix,:) = phase(ix,:) - 360;
   phase = reshape(phase,[Ny Nu lw]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  p = psum(p1,p2)
%PSUM   Sums two polynomials
l1 = length(p1);
l2 = length(p2);
p = [zeros(1,l2-l1) p1] + [zeros(1,l1-l2) p2];
