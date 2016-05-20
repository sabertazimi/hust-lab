function [K,prec,message] = place(A,B,P)
%PLACE  Pole placement technique
%
%   K = PLACE(A,B,P)  computes a state-feedback matrix K such that
%   the eigenvalues of  A-B*K  are those specified in vector P.
%   No eigenvalue should have a multiplicity greater than the 
%   number of inputs.
%
%   [K,PREC,MESSAGE] = PLACE(A,B,P)  returns PREC, an estimate of how
%   closely the eigenvalues of A-B*K match the specified locations P
%   (PREC measures the number of accurate decimal digits in the actual
%   closed-loop poles).  If some nonzero closed-loop pole is more than 
%   10% off from the desired location, MESSAGE contains a warning 
%   message. 
%
%   See also  ACKER.

%   M. Wette 10-1-86
%   Revised 9-25-87 JNL
%   Revised 8-4-92 Wes Wang
%   Revised 10-5-93, 6-1-94 Andy Potvin
%
%   Ref:: Kautsky, Nichols, Van Dooren, "Robust Pole Assignment in Linear 
%         State Feedback," Intl. J. Control, 41(1985)5, pp 1129-1155
%

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.6 $  $Date: 1999/01/05 12:09:06 $

no = nargout;
message = '';
prec = 15;

% Number of iterations for optimization
NTRY=5;

[nx,na] = size(A);
[n,m] = size(B);
P = P(:);
P = esort(P);

if na~=nx,
   error('A matrix must be square.')
elseif nx~=n,
   error('B matrix must have as many rows as A.')
elseif length(P)~=nx,
   error('P must have the same number of states as A.')
elseif nx==0,
   K = [];
   return
end

B_old = B;
m_old = m;
M = rank(B);
if M<m,
   % B is not full rank
   [Bu,Bs,Bv] = svd(B,0);
   B = Bu*Bs(:,1:M);
   m = M;
end

nx = 0;
i = 1;
pr = [];
pi = [];
cmplx = [];
while (i<=n),
    if imag(P(i))~=0.0,
        pr = [pr real(P(i))]; pi = [pi imag(P(i))];
        cmplx = [cmplx 1]; i = i+2;
    else
        pr = [pr real(P(i))]; pi = [pi 0.0];
        cmplx = [cmplx 0]; i = i+1;
    end
    nx = nx+1;
end

% Make sure there are more inputs than repeated poles:
ps = sort(P);
for i=1:n-m
   imax = min(n,i+m);
   if all(ps(i:imax) == ps(i))
      error(['Can''t place poles with multiplicity greater than rank(B).'])
   end
end

nmmp1 = n-m+1;
mp1 = m+1;
jj = sqrt(-1);
[Qb,Rb] = qr(B);
q0 = Qb(:,1:m);
q1 = Qb(:,mp1:n);
Rb = Rb(1:m,:);

if (m==n),
   % Special case: (#inputs)==(#states) - efficient, but not clean
   As = A - diag(real(P));
   i=0;
   for j=1:nx,
      i = i+1;
      if cmplx(j),
         As(i,i+1) = As(i,i+1) + pi(j);
         As(i+1,i) = As(i+1,i) - pi(j);
         i = i+1;
      end
   end
   K = Rb\q0'*As;

else
   % Compute bases for eigenvectors
   I = eye(n);
   Bx = [];
   for i=1:nx,
      [Q,R] = qr(((pr(i)+jj*pi(i))*I-A)'*q1);
      Bx = [ Bx Q(:,nmmp1:n) ];
   end

   % Choose basis set -
   %  at each iteration of i pick the eigenvector Xj, j~=i, 
   %  which is "most orthogonal" to the current eigenvector Xi
   %Wes changed the following
   nn=1; 
   for i=1:nx, 
      X(:,i) = Bx(:,(i-1)*m+1); 
      if m>1
         % Check if X is a full rank matrix. If it is not, make it up
         for ii = 2:m
            nnx = nn + cmplx(i);
            Y(:,nnx) = imag(X(:,i)); %if cmplx(i)==1 take imag part, else empty action
            Y(:,nn) = real(X(:,i));
            if rank(Y) >= nnx, 
               break
            end
            X(:,i) = Bx(:,(i-1)*m+ii); 
         end % for ii = 2:m
         nn = nn + 1 + cmplx(i); 
      end % if m>1
   end  %for i=1:nx, 
   % Wes changed the above
   if (m>1),
      for k = 1:NTRY,
         for i = 1:nx,
        S = [ X(:,1:i-1) X(:,i+1:nx) ];
            S = [ S conj(S) ];
        [Us,Ss,Vs] = svd(S);
        Pr = Bx(:,(i-1)*m+1:i*m);
            Pr = Pr*Pr';
        X(:,i) = Pr*Us(:,n);
            X(:,i) = X(:,i)/norm(X(:,i));
         end
      end
   end

   Xf = [];
   for i = 1:nx,
      if cmplx(i),
         Xf = [ Xf X(:,i) conj(X(:,i)) ];
      else,
         Xf = [ Xf X(:,i) ];
      end
   end
   cnd = cond(Xf);
   if (cnd*eps >= 1.0),
       error('Can''t place eigenvalues there.')
   end

   % Compute feedback
   K = Rb\q0'*(A-real(Xf*diag(P,0)/Xf));
end

if m<m_old
   % B was rank-deficient: undo column compression
   K = Bv(:,1:M) * K;
   B = B_old;
end

prec = fix(log10(1.0/eps));
if no<2,
   disp(sprintf('place: ndigits= %g', prec))
end

% Since sort orders by magnitude and doesn't care about the order 
% of complex conjugate pairs, explicitly check use esort instead
% Check results. Start by removing 0.0 pole locations
nz = find(P ~= 0);
P = P(nz);
Pc = esort(eig(A-B*K));
Pc = Pc(nz);
if max(abs(P-Pc)./abs(P)) > .1
   message = 'Warning: Pole locations are more than 10% in error.';
   if no<3,
      disp(message)
   end
end

% end place
