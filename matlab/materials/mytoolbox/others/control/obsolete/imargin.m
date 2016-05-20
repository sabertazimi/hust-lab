function [gm,pm,Wcg,Wcp] = imargin(mag,phase,w,NumOut,NumIn)
%IMARGIN  Gain and phase margins using interpolation.
%
%   [Gm,Pm,Wcg,Wcp] = IMARGIN(MAG,PHASE,W) returns gain margin Gm,
%   phase margin Pm, and associated frequencies Wcg and Wcp, given
%   the Bode magnitude, phase, and frequency vectors MAG, PHASE,
%   and W from a system.  
%
%   When invoked without left-hand arguments IMARGIN(MAG,PHASE,W) plots
%   the Bode response with the gain and phase margins marked with a 
%   vertical line.
%
%   IMARGIN works with the frequency response of both continuous and
%   discrete systems. It uses interpolation between frequency points 
%   to approximate the true gain and phase margins.  For more accurate
%   results, use MARGIN which calculates margins analytically for LTI
%   models.
%
%   Example of IMARGIN:
%     [mag,phase,w] = bode(a,b,c,d);
%     [Gm,Pm,Wcg,Wcp] = imargin(mag,phase,w)
%
%   See also  BODE, MARGIN.

%   Clay M. Thompson  7-25-90
%   Revised A.C.W.Grace 3-2-91, 6-21-92
%   Revised A.Potvin 10-1-94
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.9 $  $Date: 1999/01/05 15:22:27 $

ni = nargin;
no = nargout;
error(nargchk(3,5,ni));
if ndims(mag)>2,
   error('Inputs MAG and PHASE must be 2D arrays.')
end

Gm = []; Pm = []; Wcg = []; Wcp = [];

w = w(:);                   % Make sure freq. is a column
magdb = 20*log10(mag);
logw  = log10(w);

% Find the points where the phase wraps.
% The following code is based on the algorithm in the unwrap function.

cutoff = 200;                       % Arbitrary value > 180
[m, n] = size(phase);               % Assume column orientation.
p = rem(phase-360, 360);            % Phases modulo 360.
dp = [p(1,:);diff(p)];              % Differentiate phases.
jumps = (dp > cutoff) + (dp < -cutoff);     % Array of jumps locations
jvec = (jumps~=0);

% Find points where phase crosses -180 degrees

pad = 360*ones(1,n);
upcross = (([p;-pad] >= -180)&([pad;p] < -180));
downcross = (([p;pad] <= -180)&([-pad;p] > -180));
crossings = upcross + downcross;
pvec = (crossings~=0);

% Find points where magnitude crosses 0 db

pad = ones(1,n);
upcross = (([magdb;-pad] >= 0)&([pad;magdb] < 0));
downcross = (([magdb;pad] <= 0)&([-pad;magdb] > 0));
crossings = upcross + downcross;
mvec = (crossings~=0);

for i=1:n
    jloc = find(jvec(:,i)~=0);
    nj = length(jloc);

    % Remove points where phase has wrapped from pvec
    if ~isempty(jloc), pvec(jloc,i) = zeros(nj,1); end

    ploc = find(pvec(:,i)~=0);
    mloc = find(mvec(:,i)~=0);

    % Find phase crossover points and interpolate gain in db and log(freq)
    % at each point.
    lambda = (-180-p(ploc-1,i)) ./ (p(ploc,i)-p(ploc-1,i));
    gain = magdb(ploc-1,i) + lambda .* (magdb(ploc,i)-magdb(ploc-1,i));
    freq = logw(ploc-1,1) + lambda .* (logw(ploc,1)-logw(ploc-1,1));

    % Look for asymptotic behavior near -180 degrees.  (30 degree tolerance).
    % Linearly extrapolate gain and frequency based on first 2 or last 2 points.
    tol = 30;
    if m>=2,
        if (abs(p(1,i)+180)<tol),   % Starts near -180 degrees.
            lambda = (-180-p(1,i)) / (p(2,i)-p(1,i));
            if lambda<0,  % Extrapolation toward -Inf
               exgain = magdb(1,i) + lambda * (magdb(2,i)-magdb(1,i));
               exfreq = logw(1) + lambda * (logw(2)-logw(1));
               gain = [gain;exgain];  freq = [freq;exfreq];
            end
        end
        if (abs(p(m,i)+180)<tol),   % Ends near -180 degrees.
            lambda = (-180-p(m-1,i)) / (p(m,i)-p(m-1,i));
            if lambda>0,  % Extrapolation toward +Inf
               exgain = magdb(m-1,i) + lambda * (magdb(m,i)-magdb(m-1,i));
               exfreq = logw(m-1) + lambda * (logw(m)-logw(m-1));
               gain = [gain;exgain];  freq = [freq;exfreq];
            end
        end
    end
    
    if isempty(gain),
        Gm = [Gm,inf]; Wcg = [Wcg,NaN];
        ndx = [];
    else
        [Gmargin,ndx] = min(abs(gain));
        Gm = [Gm,-gain(ndx)];    Wcg = [Wcg,freq(ndx)];
    end

    % Find gain crossover points and interpolate phase in degrees and log(freq)
    % at each point.
    lambda = -magdb(mloc-1,i) ./ (magdb(mloc,i)-magdb(mloc-1,i));
    ph   = p(mloc-1,i) + lambda .* (p(mloc,i)-p(mloc-1,i));
    freq = logw(mloc-1,1) + lambda .* (logw(mloc,1)-logw(mloc-1,1));

    if isempty(ph),
        Pm = [Pm,inf];   Wcp = [Wcp,NaN];
        ndx = [];
    else
        [Pmargin,ndx] = min(abs(ph+180));
        Pm = [Pm,ph(ndx)+180];     Wcp = [Wcp,freq(ndx)];
    end

end

% Convert frequency back to rad/s and gain back to magnitudes.
Wcg(finite(Wcg)) = 10 .^ Wcg(finite(Wcg)); 
Wcp(finite(Wcp)) = 10 .^ Wcp(finite(Wcp));  
Gm(finite(Gm)) = 10 .^ (Gm(finite(Gm))/20);

% If no left hand arguments then plot graph and show location of margins.
if no==0,
   if ni==3,
      NumOut = size(mag,2);
      NumIn = 1;
   end
   % Call with graphical output: plot using LTIPLOT
   PlotAxes=get(gcf,'CurrentAxes');
   ltiplot('margin',[],PlotAxes,{mag,phase},w,[Gm,Pm,Wcg,Wcp]);
else
   gm = Gm;
   pm = Pm;
end

% end imargin

