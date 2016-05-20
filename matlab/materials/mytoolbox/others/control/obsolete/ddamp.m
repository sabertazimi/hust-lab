function [magout,wn,z] = ddamp(a,Ts)
%DDAMP  Natural frequency and damping factor for discrete systems.
%   [MAG,Wn,Z] = DDAMP(A,Ts) returns vectors MAG, Wn and Z containing
%   the z-plane magnitude, and the equivalent s-plane natural 
%   frequency and damping factors of A.  Ts is the sample time.  The
%   variable A can be in one of several formats:
%       1) If A is square, it is assumed to be the state-space
%          "A" matrix.
%       2) If A is a row vector, it is assumed to be a vector of
%          the polynomial coefficients from a transfer function.
%       3) If A is a column vector, it is assumed to contain
%          root locations.
%
%   Without the sample time, DDAMP(A) returns the magnitude only.  
%   When invoked without left hand arguments DDAMP prints the 
%   eigenvalues with their magnitude, natural frequency and damping
%   factor in a tabular format on the screen.
%
%   For a discrete system eigenvalue, lambda, the equivalent s-plane
%   natural frequency and damping ratio are
%
%       Wn = abs(log(lamba))/Ts    Z = -cos(angle(log(lamba)))
%
%   See also: EIG and DAMP.

%   Clay M. Thompson  7-23-90
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.6 $  $Date: 1999/01/05 15:21:51 $

error(nargchk(1,2,nargin));

[m,n] = size(a);
if (m == n)
    r = dsort(eig(a));
elseif (m == 1)
    r = dsort(roots(a));
elseif (n == 1)
    r = a;
else
    error('Must be a vector or a square matrix.');
end
mag = abs(r);

if nargin==2,   % If sample time is given solve for equivalent s-plane roots
  s = log(r)/Ts;
  wn = abs(s);
  z = -cos(atan2(imag(s),real(s)));
else
  s = [];
  wn = [];
  z = [];
end

form = '%7.2e';  

if nargout==0,      
   % Print results on the screen. First generate corresponding strings:
   rstr = dprint(r,'Eigenvalue',form);
   rstr(:,1) = [];
   magstr = dprint(mag,'Magnitude',form);
   wnstr = dprint(wn,'Equiv. Freq. (rad/s)',form);
   zstr = dprint(z,'Equiv. Damping',form);
   disp([rstr magstr zstr wnstr])
else
   magout = mag; 
end

% end ddamp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = dprint(v,str,form)
%DPRINT  Prints a column vector V with a centered caption STR on top

if isempty(v), 
   s = [];
   return
end

nv = length(v);
lrpad = char(' '*ones(nv+4,2));  % left and right spacing
lstr = length(str);

% Convert V to string
rev = real(v);
s = [blanks(nv)' num2str(abs(rev),form)];
s(rev<0,1) = '-';
if ~isreal(v),
   % Add complex part
   imv = imag(v);
   imags = num2str(abs(imv),[form 'i']);
   imags(~imv,:) = ' ';
   signs = char(' '*ones(nv,3));
   signs(imv>0,2) = '+';
   signs(imv<0,2) = '-';
   s = [s signs imags];
end

% Dimensions
ls = size(s,2);
lmax = max(ls,lstr);
ldiff = lstr - ls;
ldiff2 = floor(ldiff/2);
str = [blanks(-ldiff2) str blanks(-ldiff+ldiff2)];
s = [char(' '*ones(nv,ldiff2)) s char(' '*ones(nv,ldiff-ldiff2))];

% Put pieces together
s = [blanks(lmax) ; str ; blanks(lmax) ; s ; blanks(lmax)];
s = [lrpad s lrpad];

% end dprint

