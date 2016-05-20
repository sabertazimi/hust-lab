function [wnout,z,r] = damp(sys)
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

%   J.N. Little 10-11-85
%   Revised 3-12-87 JNL
%   Revised 7-23-90 Clay M. Thompson
%   Revised 6-25-96 Pascal Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/07/16 20:04:15 $

% Compute the pole characteristics
[wn,z,r] = locdamp(pole(sys),sys.Ts);


if nargout==0,      
   % Print results on the screen. First generate corresponding strings:
   if ndims(r)>2,
      error('Cannot display when SYS is an array of LTI models.') 
   end
   
   % Derive magnitude
   mag = [];
   if sys.Ts~=0,
      mag = abs(r);
   end
   
   % Print result
   form = '%7.2e';  
   rstr = dprint(r,'Eigenvalue',form);
   rstr(:,1:min(1,end)) = [];
   magstr = dprint(mag,'Magnitude',form);
   if sys.Ts==0,
      wnstr = dprint(wn,'Freq. (rad/s)',form);
      zstr = dprint(z,'Damping',form);
   else
      wnstr = dprint(wn,'Equiv. Freq. (rad/s)',form);
      zstr = dprint(z,'Equiv. Damping',form);
   end
   disp([rstr magstr zstr wnstr])
else
   wnout = wn; 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [wn,z,r] = locdamp(r,Ts)

sr = size(r);

if Ts<0,
   % Discrete system with unspecified sample time
   wn = [];
   z = [];
   for k=1:prod(sr(3:end)),
      ifin = isfinite(r(:,k));
      r(ifin,k) = dsort(r(ifin,k));
   end
   
else
   % Compute equivalent 
   if Ts==0,
      s = r;
   else
      s = log(r)/Ts;
   end
   wn = abs(s);
   z = zeros(sr);
   
   % Sort by natural frequency
   for k=1:prod(sr(3:end)),
      [wn(:,k),perm] = sort(wn(:,k));
      r(:,k) = r(perm,k);
      z(:,k) = -cos(atan2(imag(s(perm,k)),real(s(perm,k))));
   end
   
   % Wn and Z are NaN's for infinite poles
   iinf = isinf(r);
   wn(iinf) = NaN;
   z(iinf) = NaN;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = dprint(v,str,form)
%DPRINT  Prints a column vector V with a centered caption STR on top

if isempty(v), 
   s = [];  return
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
