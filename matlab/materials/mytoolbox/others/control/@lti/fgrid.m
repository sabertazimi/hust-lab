function w = fgrid(PlotType,hardMin,hardMax,softMin,softMax,npts,varargin)
%FGRID   Generate frequency grids for multiple LTI systems
%
%    W = FGRID(PLOTTYPE,HARDMIN,HARDMAX,SOFTMIN,SOFTMAX,NPTS,SYS1,...,SYSk)
%    generates adequate frequency grids  W = {W1,...,Wk}  for the frequency
%    response plots of the LTI systems SYS1,...,SYSk.  A common frequency
%    range is used for all these grids.  The grids contain at least NPTS
%    points.  HARDMIN (HARDMAX), if non-empty, will force the minimum(maximum)
%    frequency value to match the one specified.  SOFTMIN (SOFTMAX), if
%    non-empty, will force the minimum(maximum) frequency value to be
%    at most(least) the specified value, but is over-ridden by any
%    value of HARDMIN (HARDMAX).
%
%    LOW-LEVEL FUNCTION.

%   Author(s): P. Gahinet  8-12-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/05/26 12:56:42 $

MaxDecades = 10;             % Max. number of decades for bode/sigma
NNP = (PlotType(1)=='n');    % 1 if Nyquist or Nichols plot


nsys = nargin-6;             % number of LTI systems
w = cell(1,nsys);            % to store freq. grid for each system
zps = cell(1,nsys);          % to store system zeros and poles 
Ts = zeros(1,nsys);          % to store system sample times
SysOrder = zeros(1,nsys);    % stores order of state-space models
SysDims = cell(1,nsys);      % stores system dimensions


% Compute relevant poles and zeros along with model order.
% The model order is used to limit the grid density for 
% high-order models
AllEmptySys = 1;
for k=1:nsys,
   sysk = varargin{k};
   SysDims{k} = size(sysk);
   Ts(k) = abs(sysk.Ts);
   zps{k} = zpinfo(sysk,Ts(k),PlotType);
   SysOrder(k) = size(sysk,length(SysDims{k})+1);
   AllEmptySys = AllEmptySys & any(SysDims{k}(1:2)==0);
end

% Quick exit if all models are empty
if AllEmptySys,
   for k=1:nsys,
      w{k} = cell([SysDims{k}(3:end) 1 1]);
      w{k}(:) = {zeros(0,1)};
   end
   return
end

% Determine frequency range
if ~isempty(hardMin) & ~isempty(hardMax),
   % Fully user-specified frequency range
   % Reset fMin if larger than smallest Nyquist freq.
   fMin = min([hardMin , (0.8*pi)./max(Ts(Ts~=0))]);
   fMax = hardMax;
   softMin = [];
   softMax = [];
   hardBounds = 1;

else
   % If either hard bound empty, ignore hard min/max
   hardBounds = 0;
   fMin = floor(log10(softMin));   fMax = ceil(log10(softMax));
   
   for k=1:nsys,
      for zp=zps{k}(:)',
         % Compute system poles and zeros and corresponding freq. range
         % for each model in k-th LTI array
         [flb,fub] = frange(zp{1},Ts(k));
         fMin = min([fMin flb]);
         fMax = max([fMax fub]);
         % RE: fMin and fMax are integer powers of 10
      end
   end
   
   if isempty(fMin),
      % Use default range if still undetermined
      fMin = -1;   fMax = 2;   % [0.1 , 100] rad/sec
   end
   
   % Customize for various plot types
   if NNP,
      %  Nyquist/Nichols: extend this range to get asymptotes
      fMin = min(fMin,-3);
      fMax = fMax+2;
   else
      % Bode/sigma
      nf = log10(pi./min(Ts(Ts>0)));  % Nyquist freqs
      
      if fMax<fMin+MaxDecades,
         % Include largest Nyquist freq. if near fMax
         nfmax = max(nf);
         if length(nfmax) & nfmax<min(fMax+2,fMin+MaxDecades),
            fMax = ceil(nfmax);
         end
      else
         % Limit range to number of decades MaxDecades
         if any(Ts),
            fMin = min(fMax-MaxDecades,floor(log10(min(nf))));   
         else
            fMin = max(min(-2,fMax-MaxDecades),fMin); 
         end
         fMin = min([softMin fMin]);
         fMax = max([softMax fMin+MaxDecades]);
      end
   end
   
   fMin = 10^fMin;
   fMax = 10^fMax;
end


% Set minimum number of points/decade
dnpts = ceil(npts/log10(fMax/fMin));
if NNP,  
   dnpts = max(10,dnpts);  
end


% Generate frequency grid for each plotted LTI array
for k=1:nsys,
   Order = SysOrder(k);
   w{k} = cell([SysDims{k}(3:end) 1 1]);
   for j=1:prod(size(zps{k})),
      % Loop over each model in k-th LTI array
      w{k}{j} = freqpick(PlotType,zps{k}{j},Ts(k),fMin,fMax,dnpts, ...
         max([hardMin,softMin]),min([hardMax,softMax]),hardBounds,Order);
   end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [flb,fub] = frange(zp,Ts)
%FRANGE  Computes the frequency range given the poles/zeros
%        and sample time.  FLB and FUB are the range extreme 
%        points (powers of 10).  


% Detect integrators and discard very low frequencies
Integ = find(abs(zp)<1e-5);
zp(Integ) = [];

% Get limits from Nyquist frequencies of discrete systems (if any)
nf = pi./Ts(1,Ts~=0);     % Nyquist freq
nflb = floor(log10(nf./(10+40*isempty(zp))));
nfub = ceil(log10(nf));

% Exit if ZP empty
if isempty(zp),
   flb = nflb;   fub = nfub;   return
end

% Get limits from zeros and poles
fz = abs(zp);
zp = zp(fz<8*min(fz) | fz>max(fz)/8);  % look only at end freqs.
fz = abs(zp);               % frequency
dz = abs(real(zp))./fz;     % damping fact.
flb = log10(min(fz./(1+dz)));
fub = log10(max(fz.*(1+dz)));

% Add extra low-freq decade when integrators are present 
flb = flb - (~isempty(Integ));
  
% Round up to nearest decade
flb = floor(flb-0.3);
fub = ceil(fub+0.3);

% Truncate to nearest decade above Nyquist freq. for discrete systems
flb = min([flb nflb]);
fub = min([fub nfub]);


