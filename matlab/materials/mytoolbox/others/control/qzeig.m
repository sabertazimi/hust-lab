function v = qzeig(a,e)
%QZEIG   Computes the generalized eigenvalues of the pencil (A,E) 
%        and makes sure they are complex conjugate if A and E are 
%        real.
%
%        V = QZEIG(A,E)  returns the column vector of generalized 
%        eigenvalues.
%
%        V = QZEIG(V)  takes the vector of eigenvalues computed by 
%        QZ and enforces symmetry wrt real axis.

%       Author(s): P. Gahinet, 4-8-96
%       Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%       $Revision: 1.5 $

ni = nargin;
error(nargchk(1,2,ni));

if ni==1,
   % Syntax V = QZEIG(V)
   v = a;
elseif isempty(e) | isequal(e,eye(size(a))),
   % Quick exit if E = I
   v = eig(a);   return
else
   % Compute generalized eigenvalues with complex QZ
   v = eig(a,e);
   if ~isreal(a) | ~isreal(e),  return,  end
end


if isequal(sort(v(imag(v)>0)),sort(conj(v(imag(v)<0)))),
   return   % Exit if already conjugate
end

% Do pairwise matching of v and conj(v) by minimizing gap
vv = v;
i = 1;
while ~isempty(vv),
   v1 = vv(1);
   % Find closest match for v1 in conj(v)
   [jk,k] = min(abs(conj(vv)-v1));
   if k==1,   % v1 is self-conjugate, hence real
      v(i) = real(v1);
   else       % v1 is complex
      v1 = (v1 + conj(vv(k)))/2;
      if imag(v1)>0,
         v(i) = v1;   v(i+1) = conj(v1);
      else
         v(i) = conj(v1);   v(i+1) = v1;
      end
   end
   vv([1 k]) = [];
   i = i+1+(k>1);
end
