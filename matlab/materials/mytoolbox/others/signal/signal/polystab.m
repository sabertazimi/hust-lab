function b = polystab(a);
%POLYSTAB Polynomial stabilization.
%   POLYSTAB(A), where A is a vector of polynomial coefficients,
%   stabilizes the polynomial with respect to the unit circle;
%   roots whose magnitudes are greater than one are reflected
%   inside the unit circle.

%   Author(s): J.N. Little,7-25-89, handles roots at zero
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:43:30 $

if length(a) == 1, b = a; return, end
v = roots(a); i = find(v~=0);
vs = 0.5*(sign(abs(v(i))-1)+1);
v(i) = (1-vs).*v(i) + vs./conj(v(i));
ind = find(a~=0);
b = a(ind(1))*poly(v);

% Return only real coefficients if input was real:
if ~any(imag(a))
	b = real(b);
end

