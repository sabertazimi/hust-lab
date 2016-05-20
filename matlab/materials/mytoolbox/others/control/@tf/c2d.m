function sysd = c2d(sys,Ts,method,varargin)
%C2D  Conversion of continuous-time models to discrete time.
%
%   SYSD = C2D(SYSC,TS,METHOD) converts the continuous-time LTI 
%   model SYSC to a discrete-time model SYSD with sample time TS.  
%   The string METHOD selects the discretization method among the 
%   following:
%      'zoh'       Zero-order hold on the inputs.
%      'foh'       Linear interpolation of inputs (triangle appx.)
%      'tustin'    Bilinear (Tustin) approximation.
%      'prewarp'   Tustin approximation with frequency prewarping.  
%                  The critical frequency Wc is specified as fourth 
%                  input by C2D(SYSC,TS,'prewarp',Wc).
%      'matched'   Matched pole-zero method (for SISO systems only).
%   The default is 'zoh' when METHOD is omitted.
%
%   For state-space models SYS and the 'zoh' or 'foh' methods,
%      [SYSD,G] = C2D(SYSC,TS,METHOD)
%   also returns a matrix G that maps continuous initial conditions
%   into discrete initial conditions.  Specifically, if x0,u0 are
%   initial states and inputs for SYSC, then equivalent initial
%   conditions for SYSD are given by
%      xd0 = G * [x0;u0],     ud0 = u0 .
%
%   See also D2C, D2D, LTIMODELS.

%	Clay M. Thompson  7-19-90, A.Potvin 12-5-95
%       P. Gahinet  7-18-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.14 $  $Date: 1998/09/18 17:55:29 $


ni = nargin;
no = nargout;
tolint = 1e4*eps;

% Error handling
error(nargchk(2,4,ni))
if ~isa(Ts,'double') | length(Ts)~=1 | Ts<=0,
   error('Sampling time TS must be a positive scalar')
elseif ni==2,  
   method = 'zoh';  
elseif ~ischar(method) | length(method)==0,
   error('METHOD must be a nonempty string.')
elseif isempty(findstr(lower(method(1)),'mzftp'))
   error(sprintf('Unknown discretization method "%s".',method'))
end
method = lower(method);

% Process various methods
switch method(1),
case {'m' 'p' 't'}
  % Handle matched and Tustin through zpk/c2d
   sysd = tf(c2d(zpk(sys),Ts,method,varargin{:}));
   
otherwise
   % Other methods (ZOH or FOH)
   [num,den,ts] = tfdata(sys);
   sizes = size(num);
   if ts~=0,  
      error('System is already discrete. Use D2D to resample.')
   end
   
   % Extract delays, pull out discrete input and output delays,
   % absorb fractional input and output delays into delay matrix
   DelayData = get(sys.lti,{'inputdelay','outputdelay','iodelaymatrix'});
   [Tdin,Tdout,Tdio] = deal(DelayData{:});
   did = floor(Tdin/Ts+tolint);  % Discrete input delays
   Tdin = max(0,Tdin-Ts*did);    % Fractional input delays
   dod = floor(Tdout/Ts+tolint); % Discrete output delays
   Tdout = max(0,Tdout-Ts*dod);  % Fractional output delays
   Tdio = Tdio + repmat(Tdin',[sizes(1) 1]) + repmat(Tdout,[1 sizes(2)]);
   if ndims(Tdio)<length(sizes),
      Tdio = repmat(Tdio,[1 1 sizes(3:end)]);
   end
   
   % Convert each SISO entry to state-space and discretize
   sysd = sys;
   h = tf(0);
   for k=1:prod(size(num)),
      % Form SISO model TF(NUM{K},DEN{k})
      h.num = num(k);
      h.den = den(k);
      h.lti = set(h.lti,'inputdelay',Tdio(k));
      hd = tf(c2d(ss(h),Ts,method));
      sysd.num(k) = hd.num;
      sysd.den(k) = hd.den;
      Tdio(k) = totaldelay(hd.lti);  % discrete I/O delay
   end
   
   % Set variable to z
   sysd.Variable = 'z';
   
   % Update LTI properties
   sysd.lti = c2d(sys.lti,Ts,did,dod,Tdio);
end

