function [wnout,z] = damp(a)
%DAMP  Natural frequency and damping of LTI model poles.
%
%    [Wn,Z] = DAMP(SYS) returns vectors Wn and Z containing the
%    natural frequencies and damping factors of the LTI model SYS.
%    For discrete-time models, the equivalent s-plane natural 
%    frequency and damping ratio of an eigenvalue lambda are:
%               
%       Wn = abs(log(lambda))/Ts ,   Z = -cos(angle(log(lambda))) .
%
%    Wn and Z are empty vectors if the sample time Ts is undefined.
%
%    [Wn,Z,P] = DAMP(SYS) also returns the poles P of SYS.
%
%    When invoked without left-hand arguments, DAMP prints the poles
%    with their natural frequency and damping factor in a tabular format 
%    on the screen.  The poles are sorted by increasing frequency.
%
%    See also POLE, ESORT, DSORT, PZMAP, ZERO.

% Old help
%warning(['This calling syntax for ' mfilename ' will not be supported in the future.'])
%DAMP   Natural frequency and damping factor for continuous systems.
%   [Wn,Z] = DAMP(A) returns vectors Wn and Z containing the
%   natural frequencies and damping factors of A.   The variable A
%   can be in one of several formats:
%
%       1) If A is square, it is assumed to be the state-space
%          "A" matrix.
%       2) If A is a row vector, it is assumed to be a vector of
%          the polynomial coefficients from a transfer function.
%       3) If A is a column vector, it is assumed to contain
%          root locations.
%
%   When invoked without left hand arguments DAMP prints the 
%   eigenvalues with their natural frequency and damping factor in a
%   tabular format on the screen.
%
%   See also: EIG and DDAMP.

%   J.N. Little 10-11-85
%   Revised 3-12-87 JNL
%   Revised 7-23-90 Clay M. Thompson
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.9 $  $Date: 1999/01/05 12:08:37 $

[m,n] = size(a);
if (m == n)
    r = esort(eig(a));
elseif (m == 1)
    r = esort(roots(a));
elseif (n == 1)
    r = a;
else
    error('Must be a vector or a square matrix.');
end
wn = abs(r);
z = -cos(atan2(imag(r),real(r)));

form = '%7.2e';  

if nargout==0,      
   % Print results on the screen. First generate corresponding strings:
   rstr = dprint(r,'Eigenvalue',form);
   rstr(:,1) = [];
   wnstr = dprint(wn,'Freq. (rad/s)',form);
   zstr = dprint(z,'Damping',form);
   disp([rstr zstr wnstr])
else
   wnout = wn; 
end

% end damp


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

