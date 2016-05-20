function sysc = d2c(sys,method,w)
%D2C  Conversion of discrete LTI models to continuous time.
%
%   SYSC = D2C(SYSD,METHOD) produces a continuous-time model SYSC
%   that is equivalent to the discrete-time LTI model SYSD.  
%   The string METHOD selects the conversion method among the 
%   following:
%      'zoh'       Assumes zero-order hold on the inputs.
%      'tustin'    Bilinear (Tustin) approximation.
%      'prewarp'   Tustin approximation with frequency prewarping.  
%                  The critical frequency Wc is specified last as in
%                  D2C(SysD,'prewarp',Wc)
%      'matched'   Matched pole-zero method (for SISO systems only).
%   The default is 'zoh' when METHOD is omitted.
%
%   See also C2D, D2D, LTIMODELS.

%   Clay M. Thompson  7-19-90
%   Revised: P. Gahinet  8-27-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.11 $  $Date: 1998/09/18 17:55:30 $

ni = nargin;
no = nargout;
error(nargchk(1,3,ni))
if ni==1,  
   method = 'zoh';  
elseif ~ischar(method) | length(method)==0,
   error('METHOD must be a nonempty string.')
elseif isempty(findstr(lower(method(1)),'mzftp'))
   error(sprintf('Unknown discretization method "%s".',method'))
end
method = lower(method(1));

% Quick exit for static gains (to avoid errors when sample time=0)
if isstatic(sys),
   sysc = sys;
   sysc.Variable = 's';
   sysc.lti = d2c(sys.lti);
   return
end

% Extract ZPK data
[Zero,Pole,Gain,Ts] = zpkdata(sys);
sizes = size(Gain);

% Error checking
if Ts==0,
   error('System is already continuous.')
elseif Ts<0,
   % Unspecified sample time
   error('Sample time of discrete model SYS is unspecified (Ts=-1).')
end

% Handle various methods
sysc = sys;
switch method,
case 'm'
   % Matched pole-zero
   if ~isequal(sizes(1:2),[1 1]),
      error('Matched pole-zero method only applicable to SISO systems.')
   end
   
   % Loop over each model
   for j=1:prod(sizes),
      [sysc.z{j},sysc.p{j},sysc.k(j)] = d2cm(Zero{j},Pole{j},Gain(j),Ts);
   end
   

case {'t' 'p'},
   % Tustin approximation
   if method(1)=='t',
      c = 2/Ts;
   elseif ni<3,
      error('The critical frequency Wc must be specified when using prewarp method.')
   else
      c = w/tan(w*Ts/2);
   end

   for i=1:prod(sizes),
      z = Zero{i};   p = Pole{i};   k = Gain(i);
      lpmz = length(p) - length(z);

      % Each factor (z-rj) is transformed to
      %             s - c (rj-1)/(rj+1)
      %    -(1+rj)  -------------------
      %                     s - c
      % Handle zeros first
      zp1 = z + 1;
      zm1 = z - 1;
      ix = (zp1==0);
      % Zeros s.t. z+1~=0 mapped to c(z-1)/(z+1), other contribute to gain
      z = c * zm1(~ix,1)./zp1(~ix,1); 
      k = k * prod(c*zm1(ix,1)) * prod(-zp1(~ix,1));
      
      % Then handle poles:
      pp1 = p + 1;
      pm1 = p - 1;
      ix = (pp1==0);
      % Poles s.t. z+1~=0 mapped to c(p-1)/(p+1), other contribute to gain
      p = c * pm1(~ix,1)./pp1(~ix,1); 
      k = k / prod(c*pm1(ix,1)) / prod(-pp1(~ix,1));

      % (s-c) factors may contribute additional poles or zeros
      sysc.z{i} = [z ; c * ones(lpmz,1)];
      sysc.p{i} = [p ; c * ones(-lpmz,1)];
      sysc.k(i) = real(k);
   end
   
otherwise
   % ZOH method
   try
      sysc = sys;
      tmpsys = zpk(0,'ts',Ts);
      for k=1:prod(sizes)
         tmpsys.z = Zero(k); 
         tmpsys.p = Pole(k); 
         tmpsys.k = Gain(k); 
         [sysc.z(k),sysc.p(k),sysc.k(k)] = zpkdata(ssbal(d2c(ss(tmpsys),method)));
      end
   catch 
      error(lasterr)
   end
   
end
 

% Set variable to s
sysc.Variable = 's';

% Update LTI properties
sysc.lti = d2c(sys.lti);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [zc,pc,kc] = d2cm(z,p,k,Ts)
%D2CM  Matched conversion for single SISO mode

z0 = z;  p0 = p;
tol = sqrt(eps);

% Detect zeros and poles at z=0 
if any(abs(z)<tol) | any(abs(p)<tol),
   error('Matched D2C: cannot handle systems with poles or zeros at z=0.')
end

% Delete zeros at -1 (for consistency with c2d)
z(abs(z+1)<tol) = [];

% Negative real zeros can be transformed only if their multiplicity is even
[znr,mult,z] = negreal(z);
if any(rem(mult,2)),
   error('Matched D2C: cannot handle negative real zeros with odd multiplicity.')
else
   zc = [];
   for i = 1:length(znr),
      zci = log(znr(i))/Ts;
      zci = zci(ones(mult(i)/2,1),1);
      zc = [zc ; zci ; conj(zci)];
   end
end

% Negative real poles can be transformed only if their multiplicity is even
[pnr,mult,p] = negreal(p);
if any(rem(mult,2)),
   error('Matched D2C: cannot handle negative real poles with odd multiplicity.')
else
   pc = [];
   for i = 1:length(pnr),
      pci = log(pnr(i))/Ts;
      pci = pci(ones(mult(i)/2,1),1);
      pc = [pc ; pci ; conj(pci)];
   end
end

% Zero/pole r mapped to log(r)/Ts
zcc = log(z(imag(z)>0))/Ts;
zc = [zc ; log(z(imag(z)==0))/Ts ; zcc ; conj(zcc)];
pcc = log(p(imag(p)>0))/Ts;
pc = [pc ; log(p(imag(p)==0))/Ts ; pcc ; conj(pcc)];

%  Match D.C. gain or gain at z=exp(Ts) (s=1) for systems with integrator
if any(abs(p-1)<sqrt(eps)),
   % Match gain at s=1 or z=exp(s*Ts)=exp(Ts)
   dcd = k * prod(exp(Ts)-z0)/prod(exp(Ts)-p0);
   kc = dcd * prod(1-pc)/prod(1-zc);
else
   % Match gain at s=0 (z=1)
   dcd = k * prod(1-z0)/prod(1-p0);
   kc = dcd * prod(-pc)/prod(-zc);
end

% Require that gain be real
kc = real(kc);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [rnr,mult,r] = negreal(r);
%NEGREAL  Finds negative real roots and their multiplicity

mult = [];
rnr = [];

% Get negative real roots
inr = find(imag(r)==0 & real(r)<0);
rnr0 = r(inr);
r(inr) = [];

% Determine multiplicities
while length(rnr0),
   t = rnr0(1);
   ix = find(abs(t-rnr0)<sqrt(eps)*max(1,-t));
   rnr = [rnr t];
   mult = [mult length(ix)];
   rnr0(ix) = [];
end




