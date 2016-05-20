function [sysd,gic] = c2d(sys,Ts,method,w)
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

%   Clay M. Thompson  7-19-90, A.Potvin 12-5-95
%   P. Gahinet  7-18-96, 3-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.22 $  $Date: 1998/10/01 20:12:34 $

%RE: do not perform SS balancing here: the coordinate transformation
%    would be lost in LSIM, resulting in wrong response with nonzero x0

ni = nargin;
tolint = 1e4*eps;  % tolerance for fractional delays

% Input error handling
error(nargchk(2,4,ni))
if ~isa(Ts,'double') | length(Ts)~=1 | Ts<=0,
   error('Second input argument TS must be a positive scalar')
elseif ni==2,  
   method = 'zoh';  
elseif ~ischar(method) | length(method)==0,
   error('METHOD must be a nonempty string.')
end
method = lower(method(1));
gic = [];   % continuous to discrete initial conditions

% Further error checking
if ~any(method=='mzftp')
   error(sprintf('Unknown discretization method "%s".',method'))
elseif getst(sys)~=0,
   error('System is already discrete. Use D2D.')
end

% Dimension info
sizes = size(sys.d);
ny = sizes(1);
nu = sizes(2);
nsys = prod(sizes(3:end));
Nx = nxarray(sys);

% Handle various methods
sysd = sys;
switch method,
case 'm'
   % Call @zpk/c2d for 'matched' method
   sysd = ss(c2d(zpk(sys),Ts,'matched'));
   
   % Set LTI properties
   % RE: Needed because SS conversion may have shuffled the 
   %     input and output delays
   sysd.lti = c2d(sys.lti,Ts,tolint);

case {'z','f'}
   % Zero-order or first-order hold (triangle approximation)
   % Get delay data and normalize it by sampling period
   DelayData = get(sys.lti,{'inputdelay','outputdelay','iodelay'});
   [Tdin,Tdout,Tdio] = deal(DelayData{:});
   Tdin = Tdin/Ts;  Tdout = Tdout/Ts;  Tdio = Tdio/Ts;
   Did = zeros([nu,1,sizes(3:end)]);   % Discrete input delays
   Dod = zeros([ny,1,sizes(3:end)]);   % Discrete output delays
   Diod = zeros(size(Tdio));   
   
   % Loop over each model
   for k=1:nsys,
      % Extract data for k-th model
      % RE: use SSDATA to eliminate E matrix
      [a,b,c,d] = ssdata(subsref(sys,substruct('()',{':' ':' k})));
      tdio = Tdio(:,:,min(k,end));
      
      if any(tdio(:)),
         % Partition TDIO (= I/O delays + fractional input and output delays)
         % into blocks TDk satisfying DIFF(DIFF(TDk,1,1),1,2)=0, and discretize 
         % each of these blocks
         tdio = tdio + Tdin(:,ones(1,ny),min(k,end))' + ...
                       Tdout(:,ones(1,nu),min(k,end));
         [ad,bd,cd,dd,Diod(:,:,min(k,end)),xnames,gic] = c2dzf(method,...
                                     a,b,c,d,Ts,tdio,tdpart(tdio),sys.StateName);
      else
         % No I/O delays: extract integer part of input and output delays
         % RE: Do not transfer delays from input to output or vice versa
         %     to ensure synchonization of continuous and discretized 
         %     states: x[k] = x(k*Ts)
         Did(:,:,k) = floor(Tdin(:,:,min(k,end))+tolint);
         fid = max(0,Tdin(:,:,min(k,end))-Did(:,:,k));  % Fractional input delays
         Dod(:,:,k) = floor(Tdout(:,:,min(k,end))+tolint);
         fod = max(0,Tdout(:,:,min(k,end))-Dod(:,:,k)); % Fractional output delays
         
         if strcmp(method,'z')
            % ZOH with no internal I/O delays: use ZOHCONV 
            [ad,bd,cd,dd,xnames,gic] = zohconv(a,b,c,d,Ts,fid,fod,sys.StateName);
         else
            % FOH with no internal I/O delays: use FOHCONV 
            [ad,bd,cd,dd,xnames,gic] = fohconv(a,b,c,d,Ts,fid,fod,sys.StateName);  
         end
      end
                                    
      nx = size(ad,1);
      Nx(k) = nx;
      sysd.a(1:nx,1:nx,k) = ad;
      sysd.b(1:nx,:,k) = bd;
      sysd.c(:,1:nx,k) = cd;
      sysd.d(:,:,k) = dd;      
   end
   
   sysd.e = zeros([0 0 sizes(3:end)]);
   sysd.Nx = Nx;
   sysd.StateName = repmat({''},[size(sysd.a,1) 1]);
   sysd = xclip(sysd);
   if length(sysd.Nx)==1,
      % Uneven number of states
      sysd.StateName = xnames;
   end
   
   % Check for overflow in ZOH 
   if ~all(isfinite(sysd.a(:))),
      warning('Overflow in matrix exponential due to unstable poles with large real part.')
   end 
   
   % Update LTI properties
   sysd.lti = c2d(sys.lti,Ts,Did,Dod,Diod);
   
otherwise
   % Tustin approximations
   % Handle prewarping
   if method(1)=='t',
      T = Ts;
   elseif ni<4,
      error('The critical frequency must be specified when using prewarp method.')
   else
      T = 2*tan(w*Ts/2)/w;
   end
   
   if isempty(sys.e),
      % Explicit SS
      for k=1:nsys,
         nx = Nx(k);
         a = sys.a(1:nx,1:nx,k);
         b = sys.b(1:nx,:,k);
         I = eye(nx);
         [l,u,p] = lu(I - a*T/2);
         if rcond(u)<eps,
            error('Bad choice of sample time Ts: (I-A*Ts/2) is nearly singular.')
         end
         
         sysd.a(1:nx,1:nx,k) = u\(l\(p*(I + a*T/2))); % (I - a*T/2)\(I + a*T/2)
         sysd.b(1:nx,:,k) = u\(l\(p*b));              % (I - a*T/2)\b
         c = T*((sys.c(:,1:nx,k)/u)/l)*p;
         sysd.c(:,1:nx,k) = c;                        % T*c/(I - a*T/2)
         sysd.d(:,:,k) = c*b/2 + sys.d(:,:,k);        % (T/2)*c*(I - a*T/2)\b
      end
      
   else
      % Descriptor SS
      for k=1:nsys,
         nx = Nx(k);
         a = sys.a(1:nx,1:nx,k);
         b = sys.b(1:nx,:,k);
         e = sys.e(1:nx,1:nx,k);
         [l,u,p] = lu(e - a*T/2);
         if rcond(u)<eps,
            error('Bad choice of sample time Ts: (E-A*Ts/2) is nearly singular.')
         end
         
         c = T*((sys.c(:,1:nx,k)/u)/l)*p;
         sysd.a(1:nx,1:nx,k) = e + a*T/2;       % E + a*T/2
         sysd.b(1:nx,:,k) = b;                  % b
         sysd.c(:,1:nx,k) = c*e;                % T*c/(e - a*T/2)*e
         sysd.d(:,:,k) = c*b/2 + sys.d(:,:,k);  % (T/2)*c/(e - a*T/2)*b
         sysd.e(1:nx,1:nx,k) = e - a*T/2;       % E - a*T/2
      end
   end
   
   % Update LTI properties
   sysd.lti = c2d(sys.lti,Ts,tolint);
    
end

% For models with I/O delays, minimize resulting number of discrete
% I/O delays and of input vs output delays
% Note: state time shift is immaterial in the presence of I/O delays
sysd.lti = mindelay(sysd.lti);

% Checks for second output
if nargout==2 & any(method=='zf') & length(sys.Nx)>1,
   warning('Matrix G not available for SS arrays with uneven number of states.')
   gic = [];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ad,bd,cd,dd,Td,sn,gic] = c2dzf(method,a,b,c,d,Ts,Td,dpart,sn)
%C2DZF  Recursive computation of the ZOH/FOH discretization of
%       a single state-space model with internal I/O delays.
%
%   [AD,BD,CD,DD,TD,SN] = C2DZF(METHOD,A,B,C,D,TS,TDIO,DPART,SN) 
%   discretizes the state-space model (A,B,C,D) with (normalized) 
%   I/O delays TDIO.  The recursive block partition DPART of TDIO 
%   is the output of TDPART and consists of subblocks TDk of TDIO 
%   satisfying
%      DIFF(DIFF(TDk,1,1),1,2)=0 .
%   Each of these blocks defines a subsystem with delayed inputs and
%   outputs which can be discretized by piecewise integration of the 
%   delayed state equations.
%
%   C2DZF returns the state-space matrices of the discretized model, 
%   along with the integer part of TDIO (as an array), and the updated 
%   list SN of state names.
%
%   Note: TDIO is assumed to be normalized to TS=1

gic = [];

if ~isempty(dpart),
   % DPART is a partition of the I/O delay matrix TD. Build the ZOH
   % recursively by calling C2DZF on the two subblocks.
   % RE: Run subsystems through SMREAL to get right order when SYS
   %     is derived by concatenation of smaller state-space models
   r1 = 1:dpart{1}(1);   
   r2 = r1(end)+1:r1(end)+dpart{1}(2);
   na = size(a,1);
   
   if size(dpart,1)>1,
      % Vertical concatenation
      [a1,b1,c1,junk,ix1] = smreal(a,b,c(r1,:),[],(1:na)');   
      d1 = d(r1,:);   Td1 = Td(r1,:);
      [a2,b2,c2,junk,ix2] = smreal(a,b,c(r2,:),[],(1:na)');   
      d2 = d(r2,:);   Td2 = Td(r2,:);
      concat = 'vcat';   dim = 1;
   else
      % Horizontal concatenation
      [a1,b1,c1,junk,ix1] = smreal(a,b(:,r1),c,[],(1:na)');   
      d1 = d(:,r1);  Td1 = Td(:,r1);
      [a2,b2,c2,junk,ix2] = smreal(a,b(:,r2),c,[],(1:na)');   
      d2 = d(:,r2);  Td2 = Td(:,r2);
      concat = 'hcat';   dim = 2;
   end
   
   % Discretize each subsystem   
   [ad1,bd1,cd1,dd1,Td1,sn1,gic1] = ...
      c2dzf(method,a1,b1,c1,d1,Ts,Td1,dpart{2},sn(ix1,1));
   [ad2,bd2,cd2,dd2,Td2,sn2,gic2] = ...
      c2dzf(method,a2,b2,c2,d2,Ts,Td2,dpart{3},sn(ix2,1));
   
   % Put pieces together
   [ad,bd,cd,dd] = ssops(concat,ad1,bd1,cd1,dd1,[],[],ad2,bd2,cd2,dd2,[],[]);
   Td = cat(dim,Td1,Td2);
   sn = [sn1 ; sn2];   
   
   % Assemble GIC for FOH method
   if strcmp(method,'f'),
      nu1 = size(dd1,2);
      nu2 = size(dd2,2);
      if dim==1,
         % Same inputs
         gic1(:,[ix1' na+1:na+nu1]) = gic1;
         gic2(:,[ix2' na+1:na+nu1]) = gic2;
      else
         gic2(:,[ix2' na+nu1+1:na+nu1+nu2]) = gic2;
         gic1(:,[ix1' na+1:na+nu1]) = gic1;
         gic1(end,na+nu1+nu2) = 0;
      end
      gic = [gic1 ; gic2];
   end

   return
   
end

% Below TD is a 2D or 3D array satisfying DIFF(DIFF(TD,1,1),1,2)=0
%
% Decompose TD into input and output delays (ID and OD), and 
% compute the fractional delays FID and FOD.  Choose a 
% decomposition that maximizes the overall number of zero 
% fractional delays (i.e., necessary number of delay blocks)
% Note: In the multi-model case, "zero fract. delay" means 
%       zero for all models (necessary for all discretized 
%       models to share the same state vector)
% TOLINT = threshold for labeling TD(i,j) as integer multiple of TS
tolint = 1e4*eps;     
[fid,fod,Td] = iodec(Td,tolint);

% Discretize with ZOHCONV or FOHCONV
if strcmp(method,'z'),
   [ad,bd,cd,dd,sn] = zohconv(a,b,c,d,Ts,fid,fod,sn);
   gic = [];
else
   [ad,bd,cd,dd,sn,gic] = fohconv(a,b,c,d,Ts,fid,fod,sn);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fid,fod,Td] = iodec(Tds,tol)
%IODEC  Extract fractional input and output delays.
%
%   [FID,FOD,TDD] = IODEC(TDS,TOL) decomposes the normalized 
%   I/O delay matrix TDS = TD/TS into input delays ID and 
%   output delays OD, and returns
%     * the fractional delays FID and FOD contained 
%       in ID and OD
%     * the matrix TDD of residual (integer) delays
%   The decomposition seeks to maximize the number of zeros
%   in FID and FOD, and further minimize the number of 
%   poles at z=0 needed to represent TDD.

[ny,nu] = size(Tds);
id = min(Tds,[],1)';            % NUx1
od = Tds(:,1)-id(ones(1,ny),1); % NYx1

% Get fractional input and output delays
fid = rem(id+tol,1)-tol;  fid(fid<=tol) = 0; 
fod = rem(od+tol,1)-tol;  fod(fod<=tol) = 0;
if ~any(fid) & ~any(fod),
   Td = round(Tds);
   return
end

% For each model, the decomposition ID/OD is unique up to a scalar,
% i.e., any decomposition ID-THETA/OD+THETA is valid provided that
%      -MIN(OD) <= THETA <= MIN(ID)  
% (Note: here MIN(OD)=0 since ID=MIN(TDS,[],1)).  Use this degree 
% of freedom to maximize the cumulative number of zero rows in
% FID and FOD.  
thetas = [rem(1-fod,1) ; fid]';  % candidates for zeroing entries of FID/FOD
thetas = thetas(thetas>=0 & thetas<=min(id));
nth = length(thetas);
fth = [fid(:,ones(1,nth)) - thetas(ones(1,nu),:) ; ...
       rem(fod(:,ones(1,nth)) + thetas(ones(1,ny),:),1)];

% Find FID/FOD pairs with max. number of zero entries.
% Add one to entries of FID in (-1,-tol)
nz = sum(abs(fth)<=tol,1);
fth = fth(:,nz==max(nz));
fid = fth(1:nu,:);   
fod = fth(nu+1:nu+ny,:);
neg = (fid<-tol);  
fid(neg) = fid(neg)+1;
fid(fid<=tol) = 0;
fod(fod<=tol) = 0;   

% Further minimize order of D2D representation of TDD
ndec = size(fid,2);
if ndec>1,
   idd = id(:,ones(1,ndec)) - fid;
   odd = od(:,ones(1,ndec)) - fod;
   if ny<nu,
      s = min(idd,[],1);
   else
      s = -min(odd,[],1);
   end
   % Optimal I/O delay decomposition of TDD
   idopt = idd - s(ones(1,nu),:);  
   odopt = odd + s(ones(1,ny),:);
   [npmin,jmin] = min(sum(idopt,1)+sum(odopt,1));
   fid = fid(:,jmin);
   fod = fod(:,jmin);
end

% Matrix TDD of residual (integer-valued) I/O delays
Td = round(Tds-fod(:,ones(1,nu))-fid(:,ones(1,ny))');

