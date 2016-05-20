function [Gmout,Pm,Wcg,Wcp] = margin(sys)
%MARGIN  Gain and phase margins and crossover frequencies.
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(SYS) computes the gain margin Gm, the
%   phase margin Pm in degrees, and the associated frequencies 
%   Wcg and Wcp, for a SISO open-loop LTI model SYS (continuous or 
%   discrete).  The gain margin Gm is defined as 1/G where G is 
%   the gain at the -180 phase crossing.  The gain margin in dB 
%   is 20*log10(Gm).  By convention, Gm=1 (0 dB) and Pm=0 when 
%   the nominal closed loop is unstable.
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(MAG,PHASE,W) derives the gain and phase
%   margins from the Bode magnitude, phase, and frequency vectors 
%   MAG, PHASE, and W produced by BODE.  Interpolation is performed 
%   between the frequency points to estimate the values. 
%
%   For a S1-by...-by-Sp array SYS of LTI models, MARGIN returns 
%   arrays of size [S1 ... Sp] such that
%      [Gm(j1,...,jp),Pm(j1,...,jp)] = MARGIN(SYS(:,:,j1,...,jp)) .  
%
%   When invoked without left hand arguments, MARGIN(SYS) plots
%   the open-loop Bode plot with the gain and phase margins marked 
%   with a vertical line.  
%
%   See also BODE, LTIVIEW, LTIMODELS.

%   Note: if there is more than one crossover point, margin will
%   return the worst case gain and phase margins. 

%   Andrew Grace 12-5-91
%   Revised ACWG 6-21-92
%   Revised P.Gahinet 96-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.17 $  $Date: 1998/12/23 19:26:47 $


ni = nargin;
no = nargout;
error(nargchk(0,1,ni));
if ni==0,
   eval('exresp(''margin'')')
   return
elseif hasdelay(sys),
   if sys.Ts==0,
      error('Not supported for delay systems.')
   else
      sys = delay2z(sys);
   end
end

% Get dimensions and check SYS
sizes = size(sys);
if any(sizes(1:2)~=1),
   error('LTI model SYS must be SISO.')
elseif no==0 & length(sizes)>2,
   error('Can only plot margins for a single system.')
end

% Compute margins and related frequencies
outsizes = [sizes(3:end) 1 1];
Gm = zeros(outsizes);
Pm = zeros(outsizes);
Wcg = zeros(outsizes);
Wcp = zeros(outsizes);
for k=1:prod(sizes(3:end)),
   [Gm(k),Pm(k),Wcg(k),Wcp(k)] = GetMargins(sys(:,:,k));
end

% Handle case when called w/o output argument
if no==0,
   % Determine frequency grid for bode plot
   w = fgrid('bode',[],[],[],[],30,sys);
   w = w{1}{1};

   % Adjust frequency range to include WCG and WCP frequencies if possible
   wc = [Wcg , Wcp];
   wcleft = wc(wc<w(1) & wc>=w(1)/100);
   if length(wcleft),
      % Extend grid to include crossing freq. within 2 decades to the left
      w = [logspace(floor(log10(min(wcleft))),0.95*log10(w(1)),10)' ; w];
   end

   nf = pi/max(eps,abs(get(sys,'Ts')));  % Nyquist frequency
   wcright = wc(wc>w(end) & wc<min(nf,100*w(end)));
   if length(wcright),
      % Extend grid to include crossing freq. within 2 decades to the right
      w = [w ; logspace(1.05*log10(w(end)),ceil(log10(max(wcright))),10)'];
   end

   % Compute Bode response
   [mag,phase] = bode(sys,w);

   % Call with graphical output: plot using LTIPLOT
   PlotAxes=get(gcf,'CurrentAxes');
   ltiplot('margin',[],PlotAxes,{mag,phase},w,[Gm,Pm,Wcg,Wcp]);

else
   Gmout = Gm;
   
end


%%%%%%%%%%% Local function GetMargins %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Gm,Pm,Wcg,Wcp] = GetMargins(sys)
%GETMARGINS  Compute the gain/phase margins for a single LTI model

% Extract state-space data 
[a,b,c,d] = ssdata(sys);
Ts = sys.Ts;
nx = size(a,1);
if abs(1+d)<sqrt(eps),
   Gm = 1;  Pm = 0;  Wcg = Inf;  Wcp = Inf;
   warning('Closed loop is non causal (algebraic loop)')
   return
end

% Detect unstable closed loop
clpoles = eig(a-b*c/(1+d));
if (Ts==0 & any(real(clpoles)>=0)) | (Ts~=0 & any(abs(clpoles)>=1)),
   Gm = 1;  Pm = 0;  Wcg = NaN;  Wcp = NaN;
   warning('Closed loop is unstable.')
   return
end


% Phase margin: find crossover frequencies Wcp where gain = 1 
%               using Hinf theory
if abs(1-d)<1e-4,
   d = 1 + 1e-4;   % Shift D to make pencil more regular
end

if Ts==0,
   % Continuous time: form Hamiltonian matrix for gamma = 1
   h11 = [a zeros(nx) ; zeros(nx) -a'];
   h12 = [zeros(nx,1) b ; c' zeros(nx,1)];
   h21 = [c zeros(1,nx) ; zeros(1,nx) -b'];
   h22 = [1 d ; d 1];

   % Compute eigenvalues and get crossover freqs.
   v = eig(h11-h12/h22*h21);
   v = v(imag(v)>=0 & abs(real(v))<1e-5*max(1,abs(v)));
   Wcp = imag(v);   % frequencies at which gain is appx 1

else
   % Discrete time: form symplectic pencil for gamma = 1
   h11 = [a zeros(nx) ; zeros(nx) eye(nx)];   
   j11 = [eye(nx) zeros(nx) ; zeros(nx) a'];
   h12 = [b zeros(nx,1) ; zeros(nx,1) c'];
   h21 = [zeros(1,2*nx) ; c zeros(1,nx)];
   j21 = [zeros(1,nx) b'; zeros(1,2*nx)];
   h22 = [1 d ; d 1];

   % Compute eigenvalues and get crossover freqs.
   v = eig(h11-h12/h22*h21,j11-h12/h22*j21);
   v = v(imag(v)>=0 & abs(1-abs(v))<=1e-5);
   Wcp = imag(log(v)/Ts);   % frequencies at which gain is appx 1
end

% Evaluate response at selected frequencies
% Watch for Wcp=0 for open-loop with integrator
h = freqresp(sys,max(Wcp,sqrt(eps)));
hw = [h(:) Wcp];

% Discard fakes where gain is not close to 1 and compute Pm
hw = hw(abs(1-abs(h))<=1e-3,:);
if isempty(hw),
   Pm = Inf;   Wcp = NaN;
else
   % Set first column of HW to Phase Margin = 180 + phase value in [-2*pi,0]
   hw(1:end,1) = pi + rem(atan2(imag(hw(:,1)),real(hw(:,1)))-2*pi,2*pi);
   [trash,imin] = min(abs(hw(:,1)));
   Pm = (180/pi) * hw(imin,1);   % phase margin Pm
   Wcp = hw(imin,2);             % corresponding frequency
end


% Gain margin: find crossover frequencies Wcg where phase = -180 
%              (i.e., s = jw such that sys(s) - sys'(-s) = 0)
% REVISIT: Remove special processing for discrete time 
%          when zero is extended to descriptor case
if Ts & isa(sys,'ss')
   % guard against poles at z=0 
   systmp = zpk(sys);
   v = zero(systmp - systmp');
else
   v = zero(sys-sys');
end

if Ts==0,
   v = v(imag(v)>=0 & abs(real(v))<1e-5*max(1,abs(v)));
   Wcg = imag(v);
else
   v = v(imag(v)>=0 & abs(1-abs(v))<=1e-5);
   Wcg = imag(log(v)/Ts);   % frequencies at which gain is appx 1
end

% Evaluate response at selected frequencies
h = freqresp(sys,max(Wcg,sqrt(eps)));
hw = [h(:) Wcg];

% Discard fakes where phase is not close to -180
hw = hw(abs(h)>0 & abs(abs(atan2(imag(h),real(h)))-pi)<1e-2,:);
hw(1:end,1) = abs(hw(:,1));   % first column = magnitudes where phase = -180

% Add gain margin at w=Inf for continuous systems with negative feedthrough
if Ts==0 & d<0,
   hw = [hw ; [abs(d) Inf]];
end

% Gain margin = -20*log10(h(jw))
if isempty(hw),
   Gm = Inf;  Wcg = NaN;
else
   [trash,imin] = min(abs(log(hw(:,1))));
   Gm = 1/hw(imin,1);  % gain margin
   Wcg = hw(imin,2);   % corresponding frequency
end


