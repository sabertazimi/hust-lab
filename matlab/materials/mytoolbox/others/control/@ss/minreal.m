function [varargout] = minreal(sys,tol,dispflag)
%MINREAL  Minimal realization and pole-zero cancellation.
%
%   MSYS = MINREAL(SYS) produces, for a given LTI model SYS, an
%   equivalent model MSYS where all cancelling pole/zero pairs
%   or non minimal state dynamics are eliminated.  For state-space 
%   models, MINREAL produces a minimal realization MSYS of SYS where 
%   all uncontrollable or unobservable modes have been removed.
%
%   MSYS = MINREAL(SYS,TOL) further specifies the tolerance TOL
%   used for pole-zero cancellation or state dynamics elimination. 
%   The default value is TOL=SQRT(EPS) and increasing this tolerance
%   forces additional cancellations.
%
%   For a state-space model SYS=SS(A,B,C,D),
%      [MSYS,U] = MINREAL(SYS)
%   also returns an orthogonal matrix U such that (U*A*U',U*B,C*U') 
%   is a Kalman decomposition of (A,B,C). 
%
%   See also SMINREAL, BALREAL, MODRED.

%   J.N. Little 7-17-86
%   Revised A.C.W.Grace 12-1-89
%   Rewritten P. Gahinet 4-20-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.10 $  $Date: 1998/10/01 20:12:41 $

% Note: no balancing since nearness to non-minimal is not
% invariant under ill-conditioned transf.
% Take for instance A = [1 100;1e-14 1], B = [1;0], C=[1 1]

ni = nargin;
no = nargout;
error(nargchk(1,3,ni))
sizes = size(sys.d);
Nx0 = sys.Nx;

if length(sizes)>2 & no==2,
   error('Syntax [MSYS,U]=MINREAL(SYS) is not available for arrays of state-space models.')
elseif ni<2 | isempty(tol),
   tol = sqrt(eps);
elseif ~isa(tol,'double')
   error('Tolerance TOL must be real valued.')
end

% Loop over each model
wng = warning;  
warning off
if length(sizes)==2,
   [varargout{1:max(1,no)}] = SingleMinReal(sys,tol);
   sys = varargout{1};
else
   for k=1:prod(sizes(3:end)),
      subs = substruct('()',{':' ':' k});
      sys = subsasgn(sys,subs,SingleMinReal(subsref(sys,subs),tol));
   end
end
warning(wng);

% Postprocessing when order has been reduced
if any(sys.Nx(:)<Nx0(:)),
   % Blow away state names
   sys.StateName(:) = {''};
   % Display warnings or order reduction info
   if length(sizes)>2,
      warning('Using different change of state coordinates for each model.')
   elseif ni<3 | dispflag,
      % Display order reduction
      disp([int2str(Nx0-sys.Nx),' state(s) removed.'])
   end
end

varargout{1} = sys;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sysr,u] = SingleMinReal(sys,tol)
% Minimal realization for single model

% Remove structurally non-minimal states
nx = size(sys.a,1);
[sys,xsm] = sminreal(sys);
xnsm = (1:nx)';
xnsm(xsm) = [];

% Extract data
[a,b,c,d,e] = dssdata(sys);
[ny,nu] = size(d);

% Unobservable poles are invariant under feedback.  Initialize 
% search for non minimal modes by computing vector FIXEDPOLES 
% of poles common to (A,E) and (A+B*K*C,E)
randn('seed',0);
roundoff = norm(a,1)*eps;
Poles = mroots(qzeig(a,e),'roots',tol,roundoff);
K = (max([1;abs(Poles)])/(1+norm(b,1)+norm(c,1))) * randn(nu,ny); 
FixedPoles = FindCommonPoles(Poles,qzeig(a+b*K*c,e),1e-1);
FixedPoles = sort(FixedPoles(imag(FixedPoles)>=0));

% REVISIT: won't work with E matrix until ghess available
if ~isequal(e,eye(size(a))),
   a = e\a;  b = e\b;  e = eye(size(a));
end

% Eliminate the uncontrollable modes
[ac,bc,cc,ec,uc,FixedPoles] = minobs(a',c',b',e',FixedPoles,tol);

% Eliminate the unobservable modes
[am,bm,cm,em,uo] = minobs(ac',cc',bc',ec',FixedPoles,tol);

% Form reduced model
if size(am,1)<size(a,1),
   sysr = ss(am,bm,cm,d,sys);
else
   sysr = sys;
end

% Compute similarity transformation u
if nargout>1,
   % Permutation for MINSTRUCT reduction
   u = eye(nx);
   u = u([xsm ; xnsm],:);
   % Product Uc*Uo
   nc = size(ac,1);
   uc(:,1:nc) = uc(:,1:nc) * uo;
   % Product (Uc*Uo)'* U
   nsm = length(xsm);
   u(1:nsm,:) = uc' * u(1:nsm,:);
end
   

%%%%%%%%%%%% SUBFUNCTION: MINOBS  %%%%%%%%%%%%%%%

function [a,b,c,e,u,ObsFixedPoles] = minobs(a,b,c,e,FixedPoles,tol)
%MINOBS  Removes unobservable modes
%
%  [Ao,Bo,Co,Eo,U] = MINOBS(A,B,C,E,FIXEDPOLES,TOL)  computes 
%  an orthogonal similarity U such that
%
%                    [ Ao-sEo   0  ]             [ Bo ]
%     U' (A-sE) U  = [   *      *  ]      U' B = [  * ]
%
%             C U  = [ Co , 0]
%
%  The vector FIXEDPOLES contains the poles invariant under feedback.

% Tolerances
tolround = max(eps,1e3*tol^2);  % relative round-off level

% Dimensions
[ny,nx] = size(c);
nu = size(b,2);
magb = norm(b,1);
magc = norm(c,1);

% Initialization
PoleList = [];
ObsFixedPoles = [];
u = eye(nx);

% Quick exit if B=0 or C=0
if magb==0 | magc==0,
   a = [];  e = [];  b = zeros(0,nu);  c = zeros(ny,0);
   return
end
   
% Main loop: iterative model reduction algorithm
while ~isempty(PoleList) | ~isempty(FixedPoles),
   
   % Initialize new reduction cycle if POLELIST=[]
   if isempty(PoleList),
      PoleList = FixedPoles;
      FixedPoles = zeros(0,1);
      % Hessenberg reduction to speed up inverse power iterations
      [Ph,ah] = hess(a);  
      bh = Ph' * b;
      ch = c  * Ph;
      Wred = [];  % orthogonal similarity for obs./unobs. decomposition
      R = [];
      Ncancel = 0;
   end
   
   % Process first pole: determine whether it is unobservable and can 
   % be cancelled
   p = PoleList(1);
   [Pcancel,Wred,R] = CheckObs(p,Wred,R,ah,bh,ch,tol,tolround);
   switch Pcancel,
   case 0,
      % P is observable: delete it
      ip = find(PoleList==p);
      ObsFixedPoles = [ObsFixedPoles ; PoleList(ip)];
      PoleList(ip) = [];
   case -1,
      % P can be cancelled, but corresponding unobs. direction does
      % not contribute to Wno (Multiple pole/Jordan block case).  
      % Move remaining copies of P to FIXEDPOLES for further processing
      % in next reduction cycle
      ip = find(PoleList==p);
      FixedPoles = [FixedPoles ; PoleList(ip)];
      PoleList(ip) = [];
   case 1/2
      % (P,CONJ(P)) close to a pair of real roots in a Jordan block
      % Cancel one copy and keep REAL(P) for processing in next cycle
      PoleList(1) = [];
      FixedPoles = [FixedPoles ; real(p)];
      Ncancel = Ncancel + 1;
   otherwise
      % P can be cancelled: delete one copy
      PoleList(1) = [];
      Ncancel = Ncancel + Pcancel;
   end
   
   % If cycle completed, delete unoservable subspace generated 
   % during this cycle
   if isempty(PoleList) & Ncancel,
      Wred = Ph * Wred;
      % Wo = orth. complement of unobs. subspace
      Wo = Wred(:,Ncancel+1:end); 
      % Update overall orthogonal similarity U
      u(:,1:nx) = u(:,1:nx) * Wred(:,[Ncancel+1:nx,1:Ncancel]);
      b = Wo' * b;  
      c = c * Wo;  
       
      if norm(b,1)<tolround*magb | norm(c,1)<tolround*magc,
         % B=0 or C=0 after reduction
         a = [];   e = [];  
         b = zeros(0,nu);  
         c = zeros(ny,0);
         ObsFixedPoles = [];
         FixedPoles = [];  % force termination
      else
         a = Wo' * a * Wo;  
         e = Wo' * e * Wo;  
         nx = size(a,1);  
      end
   end     
   
end % while 
      

%%%%%%%% SUBFUNCTION CHECKOBS %%%%%%%%%%%%%%

function [Pcancel,W,R] = CheckObs(p,W,R,ah,bh,ch,tol,tolround)

% Tolerances
tolpbh = tol;        % for min. SV in PBH test
tolsub = 1e-5;       % for growing unobservable subspace
tolerr = min(0.1,1e3*tol);  % acceptable rel. error on freq. response

% Norms and sizes
maga = 1+norm(ah,1);
magc = norm(ch,1);  % Note: can't be zero at this point
nx = size(ah,1);

% Compute triangular matrix Rip for inverse power iterations
% Note: Putting slightly more weight on |(A-pI)*v|<<1 reduces
%       the norm of Wo'*A*Wno
[junk,T] = qr([1e-2*(maga/magc)*ch ; ah-p*eye(nx)],0);
idiag = 1+(0:nx+1:(nx+1)*(nx-1));   
T(idiag(~T(idiag))) = eps;  % to avoid divide by zero

% Inverse power iterations to estimate min svd([C;A-pI])
% REVISIT: refine this test (risk when ||A||/rho(A)>>1 that all SV except 
% s(1) are below TOL??
v = randn(nx,1);
v = T\(T'\v);  
v = v/norm(v);
v = T\(T'\v);  
is2 = norm(v);  % sqrt(1/is2) estimates min svd([C;A-pE])
RankDef = (is2 * (tolpbh*maga)^2 >= 1);  % 1 if [C;A-pE] nearly rank-def.

% If [C;A-pI] is nearly rank-deficient, compute the error in the
% freq. response at w=|p| incurred by cancelling p
if RankDef,
   jw = j * max(1e-4,abs(p)*(1+1e-3*rand));  % guard against p=0 or p = 10j...
   v = v/is2;  % normalized unobs. direction
   Av = (jw*eye(nx)-ah)\v;
   Ab = (jw*eye(nx)-ah)\bh;
   FrespMag = abs(ch*Ab);  % ABS(C*inv(jwI-A)*B)
   FrespGap = abs((ch*Av)*(v'*Ab)/(v'*Av));  % Error when cancelling
   RoundOffLevel = tolround * max(abs(ch)*abs(Ab),max(FrespMag(:)));
   OKgap = (FrespGap < max(RoundOffLevel,tolerr*FrespMag));
end

% Set PCANCEL and update unobs. subspace data (W,R)
if ~RankDef | any(OKgap(:)==0),
   Pcancel = 0;
else
   % Cancellable real pole or pair of complex poles
   if norm(real(v))<norm(imag(v)),
      v = j*v;
   end
   vr = real(v);   
   vi = imag(v);
   
   % Add VR to unobservable subspace
   [NewDir,Wup,Rup] = qrup(W,R,vr/norm(vr),tolsub);
   nc = size(Rup,2);
   if ~NewDir,
      % VR nearly parallel to current subspace 
      Pcancel = -1;
   elseif isreal(p),
      % Cancel real pole
      Pcancel = 1;  W = Wup;  R = Rup;
   elseif vi'*vi-(vi'*vr)^2/(vr'*vr)<tolsub^2,
      % Complex pole with (vr,vi) nearly collinear
      % (P,CONJ(P)) close to double real pole in Jordan block
      Pcancel = 1/2;  W = Wup;  R = Rup;
   else
      % Add VI to unobservable subspace
      [NewDir,Wup,Rup] = qrup(Wup,Rup,vi/norm(vi),tolsub);   
      nc = size(Rup,2);
      if NewDir,
         % Cancel pair of complex poles
         Pcancel = 2;  W = Wup;  R = Rup;
      else
         Pcancel = -1;
      end
   end
end


%%%%%%% SUBFUNCTION FINDCOMMONPOLES  %%%%%%%%%%%%%%%

function [NewDir,Q,R] = qrup(Q,R,x,tol)
%QRUP  Update QR factorization when adding a column X
%      to the original matrix. Q,R are the QR factors 
%      and iR keeps track of the inverse of R.

NewDir = 1; % 1 if x contributes a new direction to unobs. subspace

% Quick exit for initial step
if isempty(R),
   [Q,R] = qr(x);
   R = R(1,1);
   return
end

%  Q' [U,x] = [R x1;0 x2]
ncr = size(R,2);
lx = size(Q,2);
x = Q'*x;
x1 = x(1:ncr);
x2 = x(ncr+1:lx);

% Compute Householder reflection H = I-t*h*h'  s.t. H*x2 = -s*e1
s = norm(x2) * (sign(x2(1)) + (x2(1)==0));  % Modification for sign(0)=1.
h = x2;
if abs(s)<tol*min(1,norm(R\x1)),
   % x is in range(Q(:,1:nc)) and should be discarded
   % Note inv(R) -> [inv(R) (R\x1)/s ; 0 -1/s] so growth in ||inv(R)||
   % essentially determined by (1+norm(R\x1))/s
   NewDir = 0;
else
   h(1) = h(1) + s;
   t = 1/(s'*h(1));
   R = [R x1 ; zeros(1,ncr) -s];
   Q(:,ncr+1:lx) = Q(:,ncr+1:lx) - t * (Q(:,ncr+1:lx) * h) * h';
end



%%%%%%% SUBFUNCTION FINDCOMMONPOLES  %%%%%%%%%%%%%%%

function r = FindCommonPoles(r1,r2,tolsep)
% Note: r2 should be the smallest set of the two.

lr1 = length(r1);
lr2 = length(r2);
rep1 = r1(:,ones(1,lr2));
rep2 = r2(:,ones(1,lr1));
sepmat = abs(rep1-rep2.')./(1+min(abs(rep1),abs(rep2)'));
[mingap,minrow] = min(sepmat,[],1);
r = r1(minrow(mingap<tolsep),:);

