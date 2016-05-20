function tsys = ctranspose(sys)
%CTRANSPOSE  Pertransposition of state-space models.
%
%   TSYS = CTRANSPOSE(SYS) is invoked by tsys = SYS'
%
%   For a continuous-time model SYS with data (A,B,C,D), 
%   CTRANSPOSE produces the state-space model TSYS with
%   data (-A',-C',B',D').  If H(s) is the transfer function 
%   of SYS, then H(-s).' is the transfer function of TSYS.
%
%   For a discrete-time model SYS with data (A,B,C,D), TSYS
%   is the state-space model with data 
%       (AA, AA*C', -B'*AA, D'-B'*AA*C')  with AA=inv(A').
%   Equivalently, H(z^-1).' is the transfer function of TSYS
%   if H(z) is the transfer function of SYS.
%
%   See also TRANSPOSE, SS, LTIMODELS.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.12 $  $Date: 1998/10/01 20:12:34 $

% Extract data
if isempty(sys.a) & isempty(sys.d),
   tsys = sys.';  
   return
end
sizes = size(sys.d);
nd = length(sizes);
Ts = getst(sys.lti);

% Compute pertranspose
tsys = sys;
if Ts==0,
   % Continuous-time case
   tsys.a = -permute(sys.a,[2 1 3:nd]);
   tsys.e = permute(sys.e,[2 1 3:nd]);
   tsys.b = -permute(sys.c,[2 1 3:nd]);
   tsys.c = permute(sys.b,[2 1 3:nd]);
   tsys.d = permute(sys.d,[2 1 3:nd]);
   
else
   % Discrete time
   tsys = ss(zeros(sizes([2 1 3:nd])));
   for k=1:prod(sizes(3:end)),
      % Compute pertranspose matrices
      nx = sys.Nx(min(k,end));
      if isempty(sys.e),
         e = 1;
      else
         e = sys.e(1:nx,1:nx,k);
      end
      
      % LU factorization of A
      [l,u,p] = lu(sys.a(1:nx,1:nx,k));
      if rcond(u)<eps,
         error('TSYS is improper (the A matrix is singular to working precision).');
      end
      ck = -(u\(l\(p*sys.b(1:nx,:,k))))';
      tsys.a(1:nx,1:nx,k) = (u\(l\(p*e)))';
      tsys.c(:,1:nx,k) = ck;
      tsys.b(1:nx,:,k) = ((((sys.c(:,1:nx,k)/u)/l)*p)*e)';
      tsys.d(:,:,k) = sys.d(:,:,k)' + ck * sys.c(:,1:nx,k)';
   end
   tsys.e = zeros([0 0 sizes(3:end)]);
   tsys.Nx = sys.Nx;
end

% Delete state names
tsys.StateName(1:size(tsys.a,1),:) = {''}; 

% LTI property management
tsys.lti = (sys.lti)';

