function p = pole(sys)
%POLE  Compute the poles of LTI models.
%
%   P = POLE(SYS) computes the poles P of the LTI model SYS (P is 
%   a column vector).
%
%   For state-space models, the poles are the eigenvalues of the A 
%   matrix or the generalized eigenvalues of the (A,E) pair in the 
%   descriptor case.
%
%   If SYS is an array of LTI models with sizes [NY NU S1 ... Sp],
%   the array P has as many dimensions as SYS and P(:,1,j1,...,jp) 
%   contains the poles of the LTI model SYS(:,:,j1,...,jp).  The 
%   vectors of poles are padded with NaN values for models with 
%   relatively fewer poles.
%
%   See also DAMP, ESORT, DSORT, PZMAP, ZERO, LTIMODELS.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.8 $  $Date: 1998/05/05 14:07:45 $


% REVISIT: Following should work provided that
%  eig(A,[]) = eig(A)
%  eig(A,E) complex conjugate

s = size(sys);
a = sys.a;
e = sys.e;
Na = size(sys.a,1);
Ne = size(sys.e,1);

% Compute poles
p = zeros([Na 1 s(3:end)]);
for k=1:prod(s(3:end))
   nx = sys.Nx(min(k,end));
   ne = min(nx,Ne);
   p(1:nx,1,k) = qzeig(a(1:nx,1:nx,k),e(1:ne,1:ne,k));
   p(nx+1:Na,1,k) = NaN;
end
