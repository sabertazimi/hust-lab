function p = angle1(h)
%ANGLE  Phase angle.
%   ANGLE1(H) returns the phase angles, in radians, of a matrix with
%   complex elements.  
%
%   See also ABS, UNWRAP.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.3 $  $Date: 1997/11/21 23:28:04 $

% Clever way:
% p = imag(log(h));

% Way we'll do it:
a=real(h);
b=imag(h);
tol=1e-5;
if abs(a)<tol
   a=a*0;
end
if abs(b)<tol
   b=b*0;
end
h=complex(a,b);
p = atan2(imag(h), real(h));
