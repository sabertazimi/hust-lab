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
%            with key suggestions from I. Kollar
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/09/18 17:55:30 $

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

% Quick exits for matched method and for static gains 
% (to avoid errors when sample time=0)
if strcmp(method,'m'),
   % Call @zpk/d2c if method='matched'
   sysc = ss(d2c(zpk(sys),'matched'));
   sysc.lti = mindelay(d2c(sys.lti));   
   return
elseif isstatic(sys),
   sysc = sys;
   sysc.lti = d2c(sys.lti);
   return
end

% Dimension parameters
sizes = size(sys.d);
Nsys = prod(sizes(3:end));
Nx = nxarray(sys);
Ts = getst(sys.lti);

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
case 'z'
   % Zero order hold approximation
   Nx0 = Nx;
   
   for k=1:Nsys,
      [a,b,c] = SingleD2C(subsref(sys,substruct('()',{':' ':' k})),Ts);
      ns = size(a,1);
      % Store conversion of k-th model
      sysc.a(1:ns,1:ns,k) = a;
      sysc.b(1:ns,:,k) = b;
      sysc.c(:,1:ns,k) = c;
      Nx(k) = ns;
   end
   
   if any(Nx(:)>Nx0(:)),
      warning('Model order was increased to handle real negative poles.')
      sysc.Nx = nxcheck(Nx);
      gap = size(sysc.a,1)-size(sys.a,1);
      sysc.StateName(end+1:end+gap,1) = {''};
   end
   
   % E matrix is identity
   sysc.e = zeros([0 0 sizes(3:end)]);
      
case 'f'
   % First order hold (triangle) approximation
   error('Conversion to continuous time with ''foh'' is not available.')

case {'t' , 'p'}
   % Tustin approximations   
   % Handle prewarp
   if method(1)=='t',
      r = 2/Ts;
   elseif ni<3,
      error('The critical frequency Wc must be specified when using prewarp method.')
   else
      r = w/tan(w*Ts/2); 
   end
   
   if isempty(sys.e),
      % Explicit SS
      for k=1:Nsys,
         nx = Nx(k);
         a = sys.a(1:nx,1:nx,k);
         c = sys.c(:,1:nx,k);
         I = eye(nx);
         [l,u,p] = lu(I + a);
         if rcond(u)<eps,
            error('Tustin approximation: cannot handle discrete systems with pole near z=-1.')
         end
         
         b = u\(l\(p*sys.b(1:nx,:,k))); 
         sysc.a(1:nx,1:nx,k) = r * (u\(l\(p*(a-I))));
         sysc.b(1:nx,:,k) = 2*b;
         sysc.c(:,1:nx,k) = r*(((c/u)/l)*p);
         sysc.d(:,:,k) = sys.d(:,:,k) - c*b;
      end
      
   else
      % Descriptor SS
      for k=1:Nsys,
         nx = Nx(k);
         a = sys.a(1:nx,1:nx,k);
         b = sys.b(1:nx,:,k);
         e = sys.e(1:nx,1:nx,k);
         [l,u,p] = lu(e + a);
         if rcond(u)<eps,
            error('Tustin approximation: cannot handle discrete systems with pole at z=-1.')
         end
         
         c = ((sys.c(:,1:nx,k)/u)/l)*p;
         sysc.a(1:nx,1:nx,k) = r * (a-e);
         sysc.b(1:nx,:,k) = 2 * b;
         sysc.c(:,1:nx,k) = r * c * e;
         sysc.d(:,:,k) = sys.d(:,:,k) - c * b;
         sysc.e(1:nx,1:nx,k) = e + a;
      end
   end
   
otherwise
   error('Unknown METHOD.')

end


% Update LTI properties
sysc.lti = d2c(sys.lti);

% For models with I/O delays, minimize resulting number of 
% continuous I/O delays and of input vs output delays
% Note: state time shift is immaterial in the presence of I/O delays
sysc.lti = mindelay(sysc.lti);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ac,bc,cc] = SingleD2C(sys,Ts)
%SINGLED2C  Single-model conversion 

% Balance realization to improve LOGM conditioning
[sysb,Tbal] = ssbal(sys);    
Tbal = diag(Tbal);
[a,b,c,d,Ts] = ssdata(sysb);
[Ny,Nu] = size(d);
Nx = size(a,1);

% Compute Schur form of A(:,:,k)
[u,t] = schur(a);
v = eig(t,'nobalance');

% Cannot handle poles at z=0
% REVISIT: when ordered Real Schur form is available, could map these
% to input delays
if any(abs(v)<sqrt(eps)),
   error('D2C with ZOH: cannot handle models with poles near z=0.')
end

% Detect real negative poles -r and replace each of them by a 
% pair of poles -r+j*pert, -r-j*pert and a zero near -r 
inr = find(imag(v)==0 & real(v)<0);
lnr = length(inr);
if lnr>0,
   % Implicitly augment the state matrix A to create pairs of eigenvalues
   % -r+j*pert, -r-j*pert for each -r<0
   %       [T1  *  * ]        [T1   *   *    0   ]  
   %   T = [ 0 -r  * ]  -->   [ 0  -r   *  -pert ]
   %       [ 0  0 T2 ]        [ 0   0  T2    0   ]
   %                          [ 0 pert  0   -r   ]
   % where pert is a small perturbation
   vnr = v(inr);
   pert = 10 * sqrt(eps) * abs(vnr);
   apert = zeros(lnr,Nx);
   apert(:,inr) = diag(pert);
   apert = apert * u'; 
   a = [a  -apert' ; apert diag(vnr)];
   
   % Update b, c, and Tbal
   b = [b ; zeros(lnr,Nu)];
   c = [c ,  zeros(Ny,lnr)];
   Tbal = [Tbal ; Tbal(inr)];
   Nx = Nx + lnr;
end

[M,esterr] = logm([a b;zeros(Nu,Nx) eye(Nu)]);
M = real(M)/Ts;
if max(esterr)>sqrt(eps)
   warning('Accuracy of D2C conversion may be poor.')
end

% Undo balancing transformation and store continuous matrices
ac = repmat(1./Tbal,1,Nx) .* M(1:Nx,1:Nx) .* repmat(Tbal.',Nx,1);
bc = diag(1./Tbal) * M(1:Nx,Nx+1:Nx+Nu);
cc = c * diag(Tbal);
