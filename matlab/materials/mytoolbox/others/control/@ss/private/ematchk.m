function [e1,e2] = ematchk(e1,nx1,e2,nx2)
%EMATCHK  E matrix formatting for descriptor state space
%
%   E = EMATCHK(E,Nx) returns [] if E=I, and E otherwise.
%
%   [E1,E2] = EMATCHK(E1,NA1,E2,NA2) enforces consistency
%   of E1 and E2.  The output is either two empty matrices
%   or two matrices with row sizes NA1 and NA2, respectively.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/05/18 22:41:42 $

s1 = size(e1);

if nargin==2,
   % E = EMATCHK(E,Nx)
   if s1(1),
      % E is non empty. Determine if E=I for all models
      explicit = 1;
      for k=1:prod(s1(3:end)),
         nxk = nx1(min(k,end));
         explicit = explicit & isequal(e1(1:nxk,1:nxk,k),eye(nxk));
      end
      if explicit
         e1 = zeros([0 0 s1(3:end)]);
      end
   end
   
else
   % [E1,E2] = EMATCHK(E1,E2)
   s2 = size(e2);
   if s1(1) | s2(1),
      if s1(1)==0,
         % E1 is empty
         e1 = repmat(eye(nx1),[1 1 s1(3:end)]);
      elseif s2(1)==0,
         % E2 is empty
         e2 = repmat(eye(nx2),[1 1 s2(3:end)]);
      end
   end
   
end


   