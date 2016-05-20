function sys = repsys(sys,s)
%REPSYS  Replicate SISO LTI model.
%
%   RSYS = REPSYS(SYS,K) forms the block-diagonal model
%   Diag(SYS,...,SYS) with SYS repeated K times.
% 
%   RSYS = REPSYS(SYS,[M N]) replicates and tiles SYS to 
%   produce the M-by-N block model RSYS.
%
%   See also LTIMODELS.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/05 14:07:43 $

sizes = size(sys.d);
if ~isequal(sizes(1:2),[1 1]),
   error('Only available for SISO models.')
end


if length(s)==1,
   % Block-diagonal replication
   Na = size(sys.a,1);
   Ne = size(sys.e,1);
   Nx = nxarray(sys);
   
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
      na = Nx(k);
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
   
else
   % Replication and tiling
   sys.b = repmat(sys.b,[1 s(2)]);
   sys.c = repmat(sys.c,[s(1) 1]);
   sys.d = repmat(sys.d,s);
   
end

sys.lti = repsys(sys.lti,s);
