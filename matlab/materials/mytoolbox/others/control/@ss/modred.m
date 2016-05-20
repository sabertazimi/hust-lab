function rsys = modred(sys,elim,option)
%MODRED  Model state reduction.
%
%   RSYS = MODRED(SYS,ELIM) or RSYS = MODRED(SYS,ELIM,'mdc') reduces 
%   the order of the state-space model SYS by eliminating the states 
%   specified in vector ELIM.  The state vector is partitioned into X1, 
%   to be kept, and X2, to be eliminated,
%
%       A = |A11  A12|      B = |B1|    C = |C1 C2|
%           |A21  A22|          |B2|
%       .
%       x = Ax + Bu,   y = Cx + Du  (or discrete time counterpart).
%
%   The derivative of X2 is set to zero, and the resulting equations
%   solved for X1.  The resulting system has LENGTH(ELIM) fewer states
%   and can be envisioned as having set the ELIM states to be infinitely 
%   fast.  The original and reduced models have matching DC gains 
%   (steady-state response).
%
%   RSYS = MODRED(SYS,ELIM,'del') simply deletes the states X2.  This
%   typically produces a better approximation in the frequency domain,
%   but the DC gains are not guaranteed to match.
%
%   If SYS has been balanced with BALREAL and the gramians have M 
%   small diagonal entries, you can reduce the model order by 
%   eliminating the last M states with MODRED.
%
%   See also BALREAL, SS.

%   J.N. Little 9-4-86
%   Revised: P. Gahinet 10-30-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.8 $  $Date: 1998/05/05 14:07:45 $

ni = nargin;
error(nargchk(2,3,ni))
if ni==2,
   option = 'mdc';
elseif ~any(option(1)=='md')
   error('Unknown option.')
end
rsys = sys;

% Form keep vector:
[a,b,c,d,Ts] = ssdata(sys);
ns = size(a,1);
if ns==0,
   return
elseif ndims(a)>2,
   error('MODRED is not applicable to arrays of state-space models.')
elseif max(elim)>ns,
   error('Some index in ELIM is out of range.')
end
keep = 1:ns;
keep(elim) = [];


% Handle two cases
switch option(1)
case 'm'
   % Matched DC gains: partition into x1, to be kept, and x2, to be eliminated:
   a11 = a(keep,keep);
   a12 = a(keep,elim);
   a21 = a(elim,keep);
   a22 = a(elim,elim);
   b1  = b(keep,:);
   b2  = b(elim,:);
   c1  = c(:,keep);
   c2  = c(:,elim);

   % Form final reduced matrices
   if Ts==0,
      % Continuous-time system
      [l,u,p] = lu(a22);
      if rcond(u)<100*eps,
         error('A22 is nearly singular.')
      end
   else
      % Discrete-time system
      [l,u,p] = lu(a22 - eye(size(a22)));
      if rcond(u)<100*eps,
         error('I-A22 is nearly singular.')
      end
   end
   A21 = (u\(l\(p*a21)));
   B2 = (u\(l\(p*b2)));
   ab = a11 - a12 * A21;
   bb = b1 - a12 * B2;
   cb = c1 - c2 * A21;
   db = d - c2 * B2;

otherwise
   % Simply delete specified states
   ab = a(keep,keep);
   bb = b(keep,:);
   cb = c(:,keep);
   db = d;
   
end

% Build output
rsys.a = ab;
rsys.b = bb;
rsys.c = cb;
rsys.d = db;
rsys.Nx = size(ab,1);
rsys.StateName = sys.StateName(keep);

% end ss/modred
