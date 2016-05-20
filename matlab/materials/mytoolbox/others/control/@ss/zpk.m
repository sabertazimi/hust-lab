function ZPKsys = zpk(varargin)
%ZPK  Create zero-pole-gain models or convert to zero-pole-gain format.
%
%  Creation:
%    SYS = ZPK(Z,P,K) creates a continuous-time zero-pole-gain (ZPK) 
%    model SYS with zeros Z, poles P, and gains K.  The output SYS is 
%    a ZPK object.  
%
%    SYS = ZPK(Z,P,K,Ts) creates a discrete-time ZPK model with sample
%    time Ts (set Ts=-1 if the sample time is undetermined).
%
%    S = ZPK('s') specifies H(s) = s (Laplace variable).
%    Z = ZPK('z',TS) specifies H(z) = z with sample time TS.
%    You can then specify ZPK models as rational expressions in 
%    S or Z, e.g.,
%       z = zpk('z',0.1);  H = (z+.1)*(z+.2)/(z^2+.6*z+.09)
%
%    SYS = ZPK creates an empty zero-pole-gain model.
%    SYS = ZPK(D) specifies a static gain matrix D.
%
%    In all syntax above, the input list can be followed by pairs
%       'PropertyName1', PropertyValue1, ...
%    that set the various properties of ZPK models (see LTIPROPS for 
%    details).  To make SYS inherit all its LTI properties from an 
%    existing LTI model REFSYS, use the syntax SYS = ZPK(Z,P,K,REFSYS).
%
%  Data format:
%    For SISO models, Z and P are the vectors of zeros and poles (set  
%    Z=[] if no zeros) and K is the scalar gain.
%
%    For MIMO systems with NY outputs and NU inputs, 
%      * Z and P are NY-by-NU cell arrays where Z{i,j} and P{i,j}  
%        specify the zeros and poles of the transfer function from
%        input j to output i
%      * K is the 2D matrix of gains for each I/O channel.  
%    For example,
%       H = ZPK( {[];[2 3]} , {1;[0 -1]} , [-5;1] )
%    specifies the two-output, one-input ZPK model
%       [    -5 /(s-1)      ]
%       [ (s-2)(s-3)/s(s+1) ] 
%
%  Arrays of zero-pole-gain models:
%    You can create arrays of ZPK models by using ND cell arrays for Z,P 
%    above, and an ND array for K.  For example, if Z,P,K are 3D arrays 
%    of size [NY NU 5], then 
%       SYS = ZPK(Z,P,K) 
%    creates the 5-by-1 array of ZPK models
%       SYS(:,:,m) = ZPK(Z(:,:,m),P(:,:,m),K(:,:,m)),   m=1:5.
%    Each of these models has NY outputs and NU inputs.
%
%    To pre-allocate an array of zero ZPK models with NY outputs and NU 
%    inputs, use the syntax
%       SYS = ZPK(ZEROS([NY NU k1 k2...])) .
%
%  Conversion:
%    SYS = ZPK(SYS) converts an arbitrary LTI model SYS to the ZPK 
%    representation. The result is a ZPK object.  
%
%    SYS = ZPK(SYS,'inv') uses a fast algorithm for conversion from state
%    space to ZPK, but is typically less accurate for high-order systems.
%
%  See also LTIMODELS, SET, GET, ZPKDATA, SUBSREF, SUBSASGN, LTIPROPS, TF, SS.

% Note:
%      SYSOUT = ZPK(SYS,method)  allows users to supply their own conversion 
%      algorithm METHOD.  For instance,
%            zpk(sys,'myway')
%      executes
%            [z,p,k] = myway(sys.a,sys.b,sys.c,sys.d,sys.e)
%      to perform the conversion to ZPK.  User-specified functions 
%      should follow this syntax.

%       Author(s): A. Potvin, 3-1-94, P. Gahinet, 4-5-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.16 $  $Date: 1998/10/01 20:12:35 $

% Effect on other properties
% Keep all LTI parent fields

sys = varargin{1};

% Handle syntax zpk(z,p,k,sys) with sys of class SS
if ~isa(sys,'ss'),  
  nlti = 0;
  for i=1:length(varargin),
     if isa(varargin{i},'lti'), 
        nlti = nlti + 1;   ilti = i;
     end
  end

  if nlti>1, 
     error('Cannot call ZPK with several LTI arguments.');
  else
     % Replace sys by sys.lti and call constructor zpk/zpk.m
     varargin{ilti} = varargin{ilti}.lti;
     ZPKsys = zpk(varargin{:});
     return
  end
end


% Error checking
ni = nargin;
if ni>2,
   error('Conversion from SS to ZPK: too many input arguments.');
elseif ni==2 & ~isstr(varargin{2}),
   error('Conversion from SS to ZPK: second argument must be a string.');
elseif ni==1,
   method = 'tzero';
else
   method = varargin{2};
end

% Extract data
a = sys.a;
b = sys.b;
c = sys.c;
d = sys.d;
e = sys.e;
sizes = size(d);
Ne = size(e,1);

% Check for simple cases
if any(sizes==0),
   % Empty system
   ZPKsys = zpk(cell(sizes),cell(sizes),zeros(sizes),sys.lti);
   return
elseif ~strcmp(method,'inv') & ~strcmp(method,'tzero'),
   % User-specified conversion method
   [z,p,k] = feval(method,a,b,c,d,e);
   ZPKsys = zpk(z,p,k,sys.lti);
   return
end


% Conversion starts
Zeros = cell(sizes);
Poles = cell(sizes);
Gain = zeros(sizes);

if isempty(a) | ~any(b(:)) | ~any(c(:)),
   % Static gain
   Gain = d;
else
   % Loop over each SISO entry
   ny = sizes(1);
   nu = sizes(2);
   for k=1:prod(sizes(3:end)),
      nx = sys.Nx(min(k,end));
      ne = min(nx,Ne);
      ak = a(1:nx,1:nx,k);
      ek = e(1:ne,1:ne,k);
      PoleList = struct('states',cell(1,0),'poles',cell(1,0));
      
      % Compute each entry of the transfer function
      for l=1:ny*nu,
         j = 1+floor((l-1)/ny);
         i = 1+rem(l-1,ny);
         bjk = b(1:nx,j,k);
         cik = c(i,1:nx,k);
         
         % Eliminate structurally nonminimal dynamics in sys(i,j,k)
         [ar,br,cr,er,ixr] = smreal(ak,bjk,cik,ek,(1:nx)');
         
         % Compute the poles
         [Poles{i,j,k},PoleList] = getpoles(ar,er,ixr,PoleList);
          
         % Compute the zeros
         if strcmp(method,'tzero'),
            % REVISIT : update tzero (GETZER in tests/lti more accurate) + 
            %           make it handle descriptor [z,k] = tzero(a,b,c,d,e);
            % Use TZERO to compute the roots of the numerator of sys(i,j)
            if ~isempty(er),
               ar = er\ar;   br = er\br; 
            end
            [Zeros{i,j,k},Gain(i,j,k)] = tzero(ar,br,cr,d(i,j,k));
            % REVISIT : this approach is not guaranteed to get the right num. order
            %           less reliable than the cb,cAb,etc test. Anything we can do?
         else
            % Use GETZK to compute the numerator of ZPKsys(i,j)
            [Zeros{i,j,k},Gain(i,j,k)] = getzk(ar,br,cr,d(i,j,k),er,Poles{i,j,k});
         end
      end
   end
end

ZPKsys = zpk(Zeros,Poles,Gain,sys.lti);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [p,PoleList] = getpoles(ar,er,ixr,PoleList)
%GETPOLES  Derives the poles of (Ar,Er) where Ar=A(IXR,IXR) by
%            * first looking up in the POLELIST table for a state 
%              combination that matches IXR
%            * computing the gen. eigenvalues of (Ar,Er) if IXR is 
%              a new state combination
%          POLELIST keeps track of previously computed poles 
%          (along with the corresponding state vector portion IXR)

if isempty(ixr),
   p = zeros(0,1);
   return
else
   ldl = length(PoleList);
   for j=1:ldl,
      if isequal(ixr,PoleList(j).states),
         p = PoleList(j).poles;
         return
      end
   end
end

% P is not tabulated yet (IXR is a new portion of the state vector)
p = qzeig(ar,er);
PoleList(1,ldl+1).states = ixr;
PoleList(1,ldl+1).poles = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Zeros,k] = getzk(a,b,c,d,e,Poles)
%GETZK    Computes the zeros ZEROS and gain K such that Zeros,Poles,K
%         is the ZPK representation of the SISO system with state-space 
%         data (A,B,C,D,E).

% Shift D away from zero
dshft = 0;  
if abs(d) < sqrt(eps),
   dshft = pow2(nextpow2(1e-4*norm(b)*norm(c)/(1+norm(a,1))));
   if d<0,  dshft = -dshft;  end
end
dd = d + dshft;


% Compute the zeros of H(s) = DD + C * inv(sE-A) * B as the
% poles of the inverse system
ainv = a - b * c / dd;
Zeros = qzeig(ainv,e);

if dshft,
   % Undo shifting of D to get true numerator
   num = dd * poly(Zeros) - dshft * poly(Poles);

   % In strictly proper case, remove small parasitic entries in NUM
   % by computing cb,cAb,...  
   if d==0,
      nzcoef = 1;
      Ab = b;
      while nzcoef<length(num)-1 & c*Ab==0,
         nzcoef = nzcoef + 1;
         Ab = a * Ab;
      end
      num(1:nzcoef) = [];
   end

   Zeros = roots(num);
   k = num(length(num)-length(Zeros));
else
   k = dd;
end

