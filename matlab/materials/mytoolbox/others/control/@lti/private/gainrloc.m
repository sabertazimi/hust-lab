function [k,r] = gainrloc(sys,Zeros,Poles,Gain)
%GAINRLOC Adaptively generates root locus gain for system.
%
%   [K,R] = GAINRLOC(SYS,Zeros,Poles,Gain) adaptively picks 
%   root locus gains to produce a smooth and accurate plot.
%   The matrix R of poles has length(K) columns and K is
%   a row vector.
%
%   See also  RLOCUS, RLOCSYN.

%   Author(s): A. Potvin, 12-1-93
%              K. Gondoly and P. Gahinet 7-29-97
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.12 $  $Date: 1998/12/15 21:46:10 $

% Definitions
InfMat = Inf;
Gabs = abs(Gain);

% Number of poles and zeros
np = length(Poles);
nz = length(Zeros);
nr = max(nz,np);  % number of closed-loop poles
m = np-nz;        % asymptote index

% Get preliminary limit setting to use in GAINRLOC and set
% tolerance used to determine if poles are close enough to zeros
[xlim,ylim] = axesrloc([Poles; Zeros]);
ax = max(diff(xlim),diff(ylim));

% Find all positive gains that produce multiple roots by
% solving D'(s)*N(s)-D(s)*N'(s)=0 and looking for roots 
% such that D(s)/N(s)<0
Den = poly(Poles);
Num = Gain*poly(Zeros);
DpN = conv(polyder(Den),Num);
DNp = conv(Den,polyder(Num));
l = length(DpN)-length(DNp);
MultRoots = roots([zeros(1,-l),DpN]-[zeros(1,l),DNp]).';

AllNum = polyval(Num,MultRoots);
AllDen = polyval(Den,MultRoots);
% Discard roots for which Num=0 (multiple poles for k=Inf)
ikeep = find(AllNum);
kmult = -(AllDen(:,ikeep)./AllNum(:,ikeep));
kmult = real(kmult(:,abs(imag(kmult))<=1e-2*abs(kmult) & real(kmult)>0));

% Estimate appropriate K0 such that poles(K=K0) are close to poles(K=0)
p = length(find(abs(Poles)<1e-5));
Dpert = (p>0)*0.1^p + 0.1*abs(Den(end));  % max. mag. of K * NUM(Poles)
k0 = max(1e-10,Dpert / (1+max(abs(polyval(Num,Poles)))));

% Estimate appropriate KINF such that poles(K=1/KINF) are close to poles(K=INF)
p = length(find(abs(Zeros)<1e-5));
Npert = Gabs*(p>0)*0.1^p + 0.1*abs(Num(end));  % max. mag. of 1/K * DEN(ZEROS)
kinf = max(1e-10,Npert / (1+max(abs(polyval(Den,Zeros)))));


% Handle various cases
if m | Gain>0,
   % No poles escape to Inf for k in (0,Inf)
   % Estimate value KAX for which asymptotes leave axis limits XLIM,YLIM
   kax = (ax/2)^m / Gabs;

   % Generate initial vector of gains K
   if m>0,
      % Asymptotes at K=Inf
      kmax = 1.1 * max([kax kmult]);   kmin = min(k0,kmax/10);   
      npts = min(10,3*ceil(log10(kmax/kmin)));
      kinit = [0 logspace(log10(kmin),log10(kmax),npts)];
      klim = Inf;   rlim = [InfMat(ones(1,m),1) ; Zeros];
   elseif m<0,
      % Asymptotes at K=0
      kmin = 0.9 * min([kax kmult]);   kmax = max(1/kinf,10*kmin);
      npts = min(10,3*ceil(log10(kmax/kmin)));
      kinit = [Inf logspace(log10(kmax),log10(kmin),npts)];
      klim = 0;     rlim = [InfMat(ones(1,-m),1) ; Poles];
   else
      kmin = k0;   kmax = max(1/kinf,10*k0);
      npts = min(10,3*ceil(log10(kmax/kmin)));
      kinit = [0 logspace(log10(kmin),log10(kmax),npts)];
      klim = Inf;   rlim = Zeros;
   end

   % Refine this initial K-grid and make sure asymptotes are reached
   [k,r] = smoothloc(sys,Zeros,Poles,kinit,klim,rlim,kmult,ax,(Gain>=0));

else
   % Some poles escape to Inf for 0<KSING<Inf
   ksing = -1/Gain;
   psing = Den + ksing * Num;
   inz = find(abs(psing)>sqrt(eps)*(abs(Num)+abs(Den)));
   m = inz(1)-1;   % Number of asymptotes
   rsing = [InfMat(ones(m,1),1) ; roots(psing(m+1:end))];

   % Estimate value DKAX s.t. asymptotes leave axis limits XLIM,YLIM at 
   % KSING +/- DKAX 
   theta = psing(m+1);
   dkax = min(0.2*ksing , abs(theta)*ksing/(ax/2)^m);

   % Process [0,ksing]
   kmin = min(k0,ksing/10);    kmax = ksing - dkax;
   npts = min(10,3*ceil(log10(kmax/kmin)));
   kinit = [0 logspace(log10(kmin),log10(kmax),npts)];
   
   [kl,rl] = smoothloc(sys,Zeros,Poles,kinit,ksing,rsing,kmult,ax,(theta>=0));

   % Process [ksing,Inf]
   kmin = ksing + dkax;   kmax = max(1/kinf,10*kmin);
   npts = min(10,3*ceil(log10(kmax/kmin)));
   kinit = [Inf logspace(log10(kmax),log10(kmin),npts)];
   
   [kr,rr] = smoothloc(sys,Zeros,Poles,kinit,ksing,rsing,kmult,ax,(theta<0));

   % Put result together
   k = [kl kr(2:end)];
   r = [rl matchlsq(rl(:,end),rr(:,2:end))];

end


%--------------------Internal Functions----------------------
%%%%%%%%%%%%%%%%%
%%% smoothloc %%% 
%%%%%%%%%%%%%%%%%

function [k,r] = smoothloc(sys,Zeros,Poles,kinit,klim,rlim,kmult,ax,asyfac)
%SMOOTHLOC  Generates a smooth locus given some initial vector KINIT
%
%  [K,R] = SMOOTHLOC(SYS,Z,P,KINIT,KLIM,RLIM,KMULT,AX,ASYFAC)
%  generates a set of gains K and poles R that produce a smooth
%  locus.  SYS is the model and Z,P its zeros and poles.  KINIT
%  is the initial set of gain values.  KLIM and RLIM are the 
%  limit gain and poles for the considered gain interval. 
%  KMULT is the set of gain producing multiple poles. Finally,
%  AX is the axes extent and ASYFAC is a boolean related to the 
%  asymptote computation.


AsyTol = pi/60;   % 3 degree tolerance for asymptote tracking

% Insert gain values KMULT yielding multiple roots
km = [0.99*kmult , kmult , 1.01*kmult];
if kinit(1)<kinit(2),
   kinit = sort([kinit , km(km<klim)]);
else
   kinit = -sort(-[kinit , km(km>klim)]);
end
kinit(abs(diff(kinit))<=1e-4*abs(kinit(2:end)))=[];

% Get roots at initial gain points KINIT
rinit = genrloc(sys,Zeros,Poles,kinit);

% Get asymptote directions
m = length(find(isinf(rlim)));
AngleAsy = (2*(0:m-1)'+asyfac) * (pi/max(1,m));

% Pre-allocate space for K,R and initialize loop
nr = size(rinit,1);
k = zeros(1,50);
r = zeros(nr,50);
k(1:2) = kinit(1:2);   
kinit(:,1:2) = [];  
r(:,1) = rinit(:,1);
r(:,2) = matchlsq(r(:,1),rinit(:,2));
rinit(:,1:2) = [];
rho = 1+max(abs(r(:,1)));  % spectral radius at k(1) (poles for k=0 or k=Inf)
i = 3;

% Main refinement loop
Done = 0;      % Termination flag
Checklim = 0;  % When 1, check if reached limit poles and asymptotes

while ~Done,
   % Sort roots for next gain KINIT(1)
   knext = kinit(1);
   rinit(:,1) = matchlsq(r(:,i-1),rinit(:,1));
   
   % Check if next point smoothly links to last two points
   % RE: The values KMULT are skipped since multiple roots 
   %     give rise to kinks
   if any(k(i-1)==kmult) | issmooth(r(:,i-2),r(:,i-1),rinit(:,1),ax),
      % Add next point to K,R and move to next point
      k(i) = knext;          kinit(1) = [];
      r(:,i) = rinit(:,1);   rinit(:,1) = [];
      
      % Check for termination. Test automatically triggered when 
      % pole envelope exceeds 100 times initial envelope (protects
      % against bad numerics when KINIT contains very large values)
      Checklim = Checklim | max(abs(r(:,i)))>1e2*rho | isempty(kinit);
      if Checklim,
         % Close enough to limit poles for K->KLIM ?
         rlim = matchlsq(r(:,i),rlim);
         ifin = isfinite(rlim);
         Done = issmooth(r(ifin,i-1),r(ifin,i),rlim(ifin),ax);
         
         % Reached asymptotes for K->KLIM ?
         CurDirect = mod(angle(r(~ifin,i)-r(~ifin,i-1)),2*pi);
         DirGap = abs(sort(CurDirect)-AngleAsy);
         Done = Done & ~any(DirGap > AsyTol);
      end
      i = i+1;
   else
      % Replace next point by average of K(end) and KINIT(1)
      if knext>10*k(i-1),
         % RE: Requires KNEXT>0, and K(i-1)>0 since i-1>=2
         midK = sqrt(k(i-1)*knext);
      else
         midK = (k(i-1)+knext)/2;
      end
      kinit = [midK , kinit];
      rinit = [genrloc(sys,Zeros,Poles,midK) , rinit];
   end
   
   % Generate more points if KINIT=[] and ~DONE
   if isempty(kinit) & ~Done,
      lk = log10(k(i-1));
      switch klim,
      case Inf
         kinit = logspace(lk+.1,lk+1.1,3);
      case 0
         kinit = logspace(lk-.1,lk-1.1,3);
      otherwise
         dk = klim - k(i-1);
         ldk = log10(.9*abs(dk));
         kinit = klim - sign(dk) * logspace(ldk,ldk-1,3);
      end
      rinit = genrloc(sys,Zeros,Poles,kinit);
   end

end % while ~Done


% Add k=KLIM and delete extra entries in K,R
k(i) = klim;
r(:,i) = rlim;
k(:,i+1:end) = [];
r(:,i+1:end) = [];

% Flip K,R if K decreasing
if k(2)<k(1),
   k = fliplr(k);   r = fliplr(r);
end
   
% end smoothloc


%%%%%%%%%%%%%%%%%
%%% issmooth  %%% 
%%%%%%%%%%%%%%%%%
function boo = issmooth(v1,v2,v3,ax);
% Check if the curves joining the three sets of roots v1,v2,v3
% are smooth enough

%---Set tolerance so RLOCUS achieves a smooth plot
stol = (0.02 * ax)^2;

if isempty(v1) | isempty(v2),
   boo = 1;
   return
end

v12 = v2-v1;  
v23 = v3-v2; 
sd12 = real(v12).^2 + imag(v12).^2;
sd23 = real(v23).^2 + imag(v23).^2;
rho = real(v12).*real(v23) + imag(v12).*imag(v23);

% The plot at (v1,v2,v3) is considered smooth if either
%    * The angle (v2-v1,v3-v2) is < 90 degrees and the distance 
%      from v3 to the line joining (v1,v2) does not exceed 
%      TOLAXIS, i.e., some fixed fraction of the axis dimensions
%    * d(v1,v2) nearly zero (will happen for nonminimal poles!)
%    * d(v2,v3) falls below some fraction of TOLAXIS (prevents 
%      bisection to go on forever when angle is >90)

boo = all( sd23<stol/100 | (rho>0 & sd12.*sd23-rho.^2 <= stol*sd12) );

% end issmooth
