function [gpeak,fpeak] = norminf(a,b,c,d,e,tol)
%NORMINF  Compute the peak gain GPEAK of the continuous-time frequency 
%   response
%                                   -1
%             G (s) = D + C (sE - A)  B .
%
%   The norm is finite if and only if (A,E) has no eigenvalue on the 
%   imaginary axis.  TOL is the desired relative accuracy on GPEAK, 
%   and FPEAK is the frequency such that:
%
%                 || G ( j * PEAKF ) ||  =  GPEAK .
%
%   See  NORM.

%    Based on the algorithm described in
%        Bruisma, N.A., and M. Steinbuch, ``A Fast Algorithm to Compute
%        the Hinfinity-Norm of a Transfer Function Matrix,'' Syst. Contr. 
%        Letters, 14 (1990), pp. 287-293.

%       Author(s):  P. Gahinet, 5-13-95.
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 1998/02/12 22:28:21 $


% Tolerance for jw-axis mode detection
toljw = sqrt(eps);

% Problem dimensions
[ny,nu] = size(d);
ZeroD = ~any(d(:));
nx = size(a,1);
desc = isempty(e);
if desc, 
   e = eye(nx);
end

% Quick exit in limit cases
if nx==0 | norm(b,1)==0 | norm(c,1)==0,
   gpeak = norm(d);  fpeak = 0;
   return
end

% Reduce (A,E) to (generalized) upper-Hessenberg form for
% fast frequency response computation and compute the poles
% Revisit: need generalized Hessenberg form
if desc,
   % Descriptor case
   [aa,ee,q,z] = qz(a,e);
   bb = q*b;     
   cc = c*z;
   r = diag(aa)./diag(ee);
else
   [u,aa] = hess(a);   ee = e;
   bb = u'*b;    
   cc = c*u;
   r = eig(a);
end

% Look for jw-axis modes (infinite norm)
ar2 = abs(real(r));  % mag. of real part
w0 = abs(r);         % fundamental frequency
[rmin,i] = min(ar2);
if rmin < eps*(1000 + max(w0)),
   gpeak = Inf;  fpeak = abs(imag(r(i)));
   return
end


% Build a vector TESTFRQ of test frequencies containing the peaking 
% frequency for each mode (or an appx thereof for non-resonant modes).
% Add frequency w=0 and set GMIN = || D || and FPEAK to infinity 
ikeep = find(imag(r)>=0 & w0>0);
offset2 = max(0.25,1-2*(ar2(ikeep)./w0(ikeep)).^2);
testfrq = [0; w0(ikeep).*sqrt(offset2)];  % test frequencies
gmin = norm(d);
fpeak = Inf;


% Compute lower estimate GMIN as max. gain over selected frequencies
j = sqrt(-1);
for w=testfrq',
   gw = norm(d+cc*(((j*w)*ee-aa)\bb));
   if gw > gmin,
      gmin = gw;   fpeak = w;
   end
end
if gmin==0,
   gpeak = 0; fpeak = 0; 
   return
end


% Set up Hamiltonian pencil for Bruisma-Steinbuch algorithm 
nb = norm(b,1);
h11 = [a zeros(nx) ; zeros(nx) -a'];
h12 = [zeros(nx,ny) b ; c' zeros(nx,nu)]/nb;
h21 = [c zeros(ny,nx) ; zeros(nu,nx) -b']*nb;
if desc, 
   j11 = [e zeros(nx) ; zeros(nx) e'];
else
   j11 = 1;
end


% Modified gamma iterations start:
Rtol = eps^(1/4);
OK = 1;

while OK,
   % Test if G = (1+TOL)*GMIN qualifies as upper bound
   g = (1+tol) * gmin;
   h22 = [eye(ny) , d/g ; d'/g , eye(nu)];

   UsePencil = (desc==1);
   if ~(UsePencil | ZeroD),
       % Factorize H22 component and check condition of inverse
       [R,p] = chol(h22);
       UsePencil = p | (rcond(R) < Rtol);
   end

   if UsePencil,
      % Use QZ algorithm with preliminary deflation to compute Hamiltonian eigs
      [q,junk]=qr([h12 ; h22]);
      q = q(:,nu+ny+(1:2*nx));
      heigs = qzeig(q'*[h11 ; h21/g] , q(1:2*nx,:)'*j11);
   elseif ZeroD,
      % Form Hamiltonian matrix explicitly
      h11(1:nx,nx+1:2*nx) = b*b'/g;
      h11(nx+1:2*nx,1:nx) = -c'*c/g;
      heigs = eig(h11);
   else
      % Compute explicit Hamiltonian matrix as H11-H12*inv(H22)*H21
      heigs = eig(h11 - ((h12/R) * (R'\h21))/g);
   end

   % Detect jw-axis modes.  Test is based on a round-off level of 
   % eps*rho(H) (after balancing) resulting in worst-case 
   % perturbations of order sqrt(eps*rho(H)) on the real part
   % of poles of multiplicity two (typical as g->norm(sys,inf))
   jweig = heigs(abs(real(heigs)) <= toljw*sqrt(100+max(abs(heigs))));
   if isempty(jweig),   
      % No jw-axis eigenvalues for G = GMIN*(1+TOL): we're done
      gpeak = gmin;
      return
   end
   
   % Compute frequencies where gain G is attained and 
   % generate new test frequencies
   ws = imag(jweig).';
   ws = unique(max(eps,ws(ws>0)));
   lws = length(ws);
   if lws==1,
      gpeak = gmin;
      return
   end

   % Form the vector of mid-points and compute
   % gain at new test frequencies
   gmin0 = gmin;   % save current lower bound
   ws = sqrt(ws(1:lws-1).*ws(2:lws));
   for w=ws,
      gw = norm(d+cc/((j*w)*ee-aa)*bb);
      if gw > gmin,
         gmin = gw;  fpeak = w;
      end
   end

   % If lower bound has not improved, exit (safeguard against undetected 
   % jw-axis modes of Hamiltonian matrix)
   if gmin < gmin0 * (1+tol/10), 
      gpeak = gmin;
      return
   end

end %while


% end norminf.m
