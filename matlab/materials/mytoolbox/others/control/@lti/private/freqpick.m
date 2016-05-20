function w = freqpick(PlotType,zp,Ts,fmin,fmax,dnpts,highestMin,lowestMax,hardBounds,SysOrder)
%FREQPICK  Generate appropriate frequency grid for frequency plots
%        
%    W = FREQPICK(PLOTTYPE,ZP,TS,FMIN,FMAX,DNPTS,HIGHESTMIN,LOWESTMAX,...
%                 HARDBOUNDS,SYSORDER)  
%    generates a grid W of frequencies given the vector ZP of zeros and
%    poles for each channel of the system.  FMIN and FMAX specify the
%    grid lower and upper limits, TS is the sample time for discrete 
%    systems, and DNPTS is the minimum number of points per decade.
%    HIGHESTMIN / LOWESTMAX, if non-empty, mark the inner limits of the
%    frequency bounds which cannot be removed from the frequency range.
%
%    LOW-LEVEL FUNCTION, called by FGRID

%    Author(s): P. Gahinet, 5-1-96
%    Copyright (c) 1986-98 by The MathWorks, Inc.
%    $Revision: 1.12 $ $Date: 1998/05/26 12:56:41 $


NNP = (PlotType(1)=='n');          % 1 if Nyquist/Nichols
NYQ = strcmp(PlotType,'nyquist');  % 1 if Nyquist
nf = [];
fzp = abs(zp);
integ = any(fzp<1e-3);
dampfact = 0.5+0.3*NYQ;    % critical value for selection of resonant modes

% Adjust frequency range [FMIN,FMAX]
fmin = (1+1e4*eps) * fmin;
fmax = (1-1e4*eps) * fmax;
if Ts~=0,
   % For discrete systems, clip the range at the Nyquist frequency
   nf = pi/Ts;               % Nyquist freq.
   fmax = min(fmax,nf);      % Grid upper limit
end

% Ignore zeros and poles outside of [FMIN,FMAX] or such that
%      real(s) > 0.8 * |s|       for Nyquist
%      real(s) > 0.5 * |s|       for other plots
if NNP
   % Discard fast dynamics
   fmax = min(fmax,max([1e5 lowestMax]));
   if integ
      % Discard integrators
      lb = min([10^(-2-(~NYQ)) , nf/100]);
      fmin = max(fmin,min([lb highestMin]));
   end
end
zp = zp(fzp>=0.5*fmin & fzp<=2*fmax & abs(real(zp))<dampfact*fzp);


% Initialize W
if isempty(zp),
   % Default grid (loop below will be skipped)
   w = logspace(log10(fmin),log10(fmax),30*(1+2*NNP));
else
   % FMIN = 1st grid point
   w = fmin;

   % Discard redundant modes (such that dfzp/fzp < damping(zp)^2)
   if length(zp)>1,
      [fzp,isort] = sort(abs(zp));
      zp = zp(isort);
      fdamp = abs(real(zp))./(dampfact*fzp);        % damping coeff.
      fgap = [1 ; diff(fzp)./fzp(2:end)];           % relative gap between freqs
      zp = zp(fgap > fdamp.^2);
   end
end


% Generate grid W
for t=zp.',    % loop over zeros and pole
   % Generate finer grid around resonant frequency FT=ABS(T)
   addw = resgrid(t,Ts,dnpts,PlotType);
   addw = addw(addw>fmin & addw<fmax);

   % Merge additional points ADDW with W
   if isempty(addw) | w(end)<addw(1),
      % No overlap: fill gap using DNPTS pts/decade
      l1 = log10(w(end));
      l2 = log10(max([w(end) addw(1:min(1,end))]));
      fill = logspace(l1,l2,2+floor(dnpts*(l2-l1)));
      w = [w , fill(2:end-1) , addw];
   else
      % Extract part of W overlapping with ADDW
      ixo = (w>=0.9*addw(1)); 
      wo = w(ixo);    % overlapping part of W

      % Form [WO ADDW] and flag entries belonging to ADDW with a zero
      mflags = [ones(size(wo)) , zeros(size(addw))];
      [addw,isort] = sort([wo , addw]); 
      mflags = mflags(isort);  % membership flags

      % Look for 101 and 010 patterns in MFLAGS and discard middle frequency
      % RE: Must be performed in two steps, otherwise discards all of 1010101..
      idel = 1+find(~mflags(2:end-1) & mflags(1:end-2) & mflags(3:end));
      addw(idel) = [];   mflags(idel) = [];
      idel = 1+find(mflags(2:end-1) & ~mflags(1:end-2) & ~mflags(3:end));
      addw(idel) = [];
      w = [w(~ixo) , addw];
   end
end  %for t


% Extend grid up to upper frequency FMAX
wmax = max(w);
lwmax = log10(wmax);
lfmax = log10(fmax);
h = max(fmin,nf/2);
if Ts==0 | fmax<h,
   % fill gap with DNPTS/dec.
   if lwmax<lfmax,
      extra = logspace(lwmax,lfmax,2+floor(dnpts*(lfmax-lwmax)));
   else
      extra = fmax;
   end
   w = [w(1:end-1) , extra];
else
   % Discrete system with FMAX > h = 0.2{or 0.5}pi/Ts: add extra 
   % points near Nyquist freq. 
   lh = log10(h);
   if lh>lwmax,
      w = [w(1:end-1) , logspace(lwmax,lh,2+floor(dnpts*(lh-lwmax)))];
   end
   if NNP, 
      extra = linspace(h,fmax,30*(fmax-h)/(nf-h));
   else
      extra = logspace(lh,lfmax,2+floor(3*dnpts*(lfmax-lh)));
   end
   w = sort([w(1:end-1) , extra]);
end


% Reduce density in high freq. for high-order models
maxpts = 50 + round(6e5/(1+SysOrder)^2);
OverSampling = length(w)/maxpts;
if OverSampling>1,
   % Reduce density in high frequencies
   w = [w(1:maxpts-1) w(maxpts:ceil(OverSampling):end)];
end

% Add w=0 for Nyquist/Nichols w/o integrator
if NNP & ~hardBounds & ~integ,
   w = [0 , w];
end

w = w(:);    

% end freqpick


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function wt = resgrid(s,Ts,dnpts,PlotType)
%RESGRID   Generates finer grid around peak frequency for resonant 
%          S-plane mode s.  The grid is determined based on the 
%          response of the second-order system with poles s and conj(s). 


w0 = abs(s);                         % natural frequency 
rs = max(abs(real(s)),1e-5*w0);      % abs. real part
zeta = 2*rs/w0;                      % damping ratio < 1
zeta2 = zeta^2;
jay = sqrt(-1);
 

% Compute frequency WPEAK where gain peaks
if Ts==0,
   % Continuous mode
   wpeak = w0 * sqrt(1-zeta2/2);
else
   % S-plane equivalent to discrete mode: get exact WPEAK by mapping 
   % mode back to Z-plane
   z = exp(Ts*s);
   zmag2 = z'*z;

   % Gain peaks either at 0, pi/Ts, or phi/Ts where
   %      cos(phi) = a(1+a^2+b^2)/2/(a^2+b^2)  ,  z=a+jb
   angs = pi;
   h = real(z)*(1+zmag2)/2/zmag2;
   if abs(h)<=1,  angs = [angs , acos(h)];  end
   zangs = exp(jay*angs);  
   [imod,imax] = min(abs((zangs-z).*(zangs-conj(z))));
   wpeak = angs(imax)/Ts;
end   

% Handle various plot types
if PlotType(1)=='n',
   % Nyquist or Nichols: generate frequencies for which the phase 
   % is evenly spaced
   if strcmp(PlotType,'nyquist'),
      spacing = -pi/45;
      offset = pi/180;
      angles = -offset:spacing:-pi+offset;
   else
      spacing = -pi/60;
      offset = pi/90;
      angles = [-offset:spacing:-pi/6-spacing ,...
                -pi/6:2*spacing:-5*pi/6 , ...
                -5*pi/6+spacing:spacing:-pi+offset];
   end
   ct = -cot(angles);
   wt = (w0/2) * (sqrt(4+zeta2*ct.^2)-zeta*ct);

   % Discard points where spacing exceeds DNPTS/dec.
   dw = diff(log10(wt));
   dw = min([[dw 1] ; [1 dw]]);
   wt = sort([ wt(dw<1/(dnpts-1)) , wpeak]);

else
   % Bode or sigma
   wmin = wpeak/2;    wmax = 2*wpeak;   % limits of grid WT

   % Generate refined grid WT with points accumulating exponentially
   % around WPEAK.  The points are generated by
   %    log(w(k+1)) = log(w(k)) + a * exp(b*k),    w(0) = wpeak
   % where a,b are determined by the constraints:
   %    (1) the log. spacing at WPEAK is of order GAP
   %    (2) the spacing matches the default spacing of DNPTS/decade
   %        at the grid bounds WMIN and WMAX
   dnpts = max(1,dnpts-1);
   delta = 1/dnpts;
   gap = delta/2 * sqrt(max(5e-3,zeta));  % adhoc initial spacing near WPEAK
   a = gap;
   rdg = log(delta/gap);

   % Generate grid to the left of WPEAK
   bmin = log(1+(delta-gap)/log10(wpeak/wmin));
   nmin = round(rdg/bmin);   % number of points left of WPEAK
   lwl = log10(wpeak) - (a/(1-exp(bmin))) * (1-exp(bmin*(nmin:-1:1)));

   % Generate grid to the left of WPEAK
   bmax = log(1+(delta-gap)/log10(wmax/wpeak));
   nmax = round(rdg/bmax);   % number of points right of WPEAK
   lwr = log10(wpeak) + (a/(1-exp(bmax))) * (1-exp(bmax*(1:nmax)));

   % Put grid together
   wt = [10.^lwl , wpeak , 10.^lwr];

end

% end resgrid


