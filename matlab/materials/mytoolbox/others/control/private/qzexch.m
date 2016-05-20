function [A,B,Z] = qzexch(A,B,Z,p)
%QZEXCH	 QZ exchange.
%
%   [A,B,Z] = QZEXCH(A,B,Z,p) performs a unitary equivalence so
%   that the eigenvalues E = diag(A)./diag(B) are reordered as
%   specified by the permutation P.  The transformation matrix Z 
%   is updated accordingly.

%	Ref.:  Van Dooren, P., ``A Generalized Eigenvalue Approach for
%	       Solving Riccati Equations,'' SIAM J. Sci. Stat. Comput.,
%	       2(1981), 121--135.
% 	N.B.: This version only interchanges adjacent pairs of 1-by-1 blocks.

%       Authors: Alan J. Laub and Cleve Moler
%       Revised: 96-01-09
%       Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%       $Revision: 1.5 $

n2 = length(p);
p(p) = 1:n2;     % inverse permutation
for jj = n2:-1:2
   ii = find(p==jj);
   for k = ii:jj-1

      % Column transformation

      i = 1:k+1;
      j = k:k+1;
      altb = abs(A(k+1,k+1)) < abs(B(k+1,k+1));
      s = (A(k+1,k+1)*B(k,j)-B(k+1,k+1)*A(k,j)).';
      if s(1) ~= 0
         s = s/s(1);
         G = flipud(planerot(s));
         A(i,j) = A(i,j)*G;
         B(i,j) = B(i,j)*G;
         Z(:,j) = Z(:,j)*G;
      end

      % Row transformation

      n = size(A,2);
      i = k:k+1;
      j = k:n;
      if altb
         G = planerot(B(i,k));
      else
         G = planerot(A(i,k));
      end
      A(i,j) = G*A(i,j);
      B(i,j) = G*B(i,j);

      % The transformations have been designed so that
      % both of the following elements are negligible:

      A(k+1,k) = 0;
      B(k+1,k) = 0;

   end
   p(ii) = [];
end

% *** last line of qzexch.m ***

