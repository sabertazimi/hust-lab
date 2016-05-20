function sys = mtimes(sys1,sys2)
%MTIMES  Multiplication of LTI models.
%
%   SYS = MTIMES(SYS1,SYS2) performs SYS = SYS1 * SYS2.
%   Multiplying two LTI models is equivalent to 
%   connecting them in series as shown below:
%
%         u ----> SYS2 ----> SYS1 ----> y 
%
%   If SYS1 and SYS2 are two arrays of LTI models, their
%   product is an LTI array SYS with the same number of
%   models where the k-th model is obtained by
%      SYS(:,:,k) = SYS1(:,:,k) * SYS2(:,:,k) .
%
%   See also SERIES, MLDIVIDE, MRDIVIDE, INV, LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.15 $  $Date: 1998/09/18 17:55:31 $

% Effect on other properties
% InputName is from sys2, OutputName from sys1
% UserData and Notes are deleted.

% Ensure both operands are SS
sys1 = ss(sys1);
sys2 = ss(sys2);

% Check dimensions and detect scalar multiplication
sizes1 = size(sys1.d);
sizes2 = size(sys2.d);
ScalarMult = 0;
if all(sizes1(1:2)==1) & sizes2(1)~=1,
   % SYS1 is SISO (scalar multiplication)
   if any(sizes2==0),
      % Scalar * Empty = Empty
      sys = sys2;   return
   elseif sizes2(1)<=sizes2(2),
      % Evaluate as (sys1 * eye(ny2)) * SYS2
      sys1 = repss(sys1,sizes2(1));
      sizes1 = size(sys1.d);
      ScalarMult = 1;
   else
      % Evaluate as SYS2 * (sys1 * eye(nu2))
      tmp = sys2;
      sys2 = repss(sys1,sizes2(2));   
      sys1 = tmp;
      sizes1 = sizes2;        
      sizes2 = size(sys2.d);
      ScalarMult = 2;
   end
   
elseif all(sizes2(1:2)==1) & sizes1(2)~=1,
   % SYS2 is SISO (scalar multiplication)
   if any(sizes1==0),
      % Scalar * Empty = Empty
      sys = sys1;   return
   elseif sizes1(1)>=sizes1(2),
      % Evaluate as SYS1 * (sys2 * eye(m1))
      sys2 = repss(sys2,sizes1(2));
      sizes2 = size(sys2.d);
      ScalarMult = 2;
   else
      % Evaluate as (sys2 * eye(p1)) * SYS1
      tmp = sys1;
      sys1 = repss(sys2,sizes1(1));
      sys2 = tmp;                   
      sizes2 = sizes1;
      sizes1 = size(sys1.d);
      ScalarMult = 1;
   end
   
end

% Check dimension consistency
if sizes1(2)~=sizes2(1),
   error('In SYS1*SYS2, systems must have compatible dimensions.');
elseif length(sizes1)>2 & length(sizes2)>2 & ...
           ~isequal(sizes1(3:end),sizes2(3:end)),
   error('In SYS1*SYS2, arrays SYS1 and SYS2 must have compatible dimensions.')
end

% LTI property management
sflags = [isstatic(sys1) , isstatic(sys2)];
if any(sflags),
   % Adjust sample time of static gains to avoid unwarranted clashes
   % RE: static gains are regarded as sample-time free
   [sys1.lti,sys2.lti] = sgcheck(sys1.lti,sys2.lti,sflags);
end

% Use try/catch to keep errors at top level
sys = ss;
try
   [sys.lti,sys1,sys2] = ltimult(sys1.lti,sys2.lti,sys1,sys2,ScalarMult);
catch
   error(lasterr)
end

% Perform multiplication
[e1,e2] = ematchk(sys1.e,size(sys1.a,1),sys2.e,size(sys2.a,1));
[sys.a,sys.b,sys.c,sys.d,e,sys.Nx] = ...
   ssops('mult',sys1.a,sys1.b,sys1.c,sys1.d,e1,sys1.Nx,...
                sys2.a,sys2.b,sys2.c,sys2.d,e2,sys2.Nx);
sys.e = ematchk(e,sys.Nx);
sys.StateName = [sys1.StateName ; sys2.StateName];

% Post processing
sys = xclip(sys);
if length(sys.Nx)>1,
   % Discard state names if uneven number of states
   sys.StateName(:) = {''};
end

% If result has I/O delays, minimize number of I/O delays and of 
% input vs output delays
% Note: state time shift is immaterial in the presence of I/O delays
sys.lti = mindelay(sys.lti);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function sys = repss(sys,s)
%REP  Forms Diag(SYS,...,SYS) w/o updating the LTI properties

sizes = size(sys.d);
Na = size(sys.a,1);
Ne = size(sys.e,1);

% Preallocate
A = zeros([s*Na s*Na sizes(3:end)]);
B = zeros([s*Na s*sizes(2) sizes(3:end)]);
C = zeros([s*sizes(1) s*Na sizes(3:end)]);
D = zeros([s*sizes(1:2) sizes(3:end)]);
E = zeros([s*Ne s*Ne sizes(3:end)]);

% Loop over each model
I = eye(s);
for k=1:prod(sizes(3:end)),
   % Use KRON to replicate A,B,C,D (thanks greg ;-)
   na = sys.Nx(min(k,end));
   ne = min(na,Ne);
   A(1:s*na,1:s*na,k) = kron(I,sys.a(1:na,1:na,k));
   B(1:s*na,:,k) = kron(I,sys.b(1:na,:,k));
   C(:,1:s*na,k) = kron(I,sys.c(:,1:na,k));
   D(:,:,k) = kron(I,sys.d(:,:,k));
   E(1:s*ne,1:s*ne,k) = kron(I,sys.e(1:ne,1:ne,k));
end

% Update data of SYS
sys.a = A;
sys.b = B;
sys.c = C;
sys.d = D;
sys.e = E;
sys.StateName = repmat(sys.StateName,[s 1]);
sys.Nx = s * sys.Nx;
