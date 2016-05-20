function [sys,xkeep] = sminreal(sys)
%SMINREAL  Compute a structurally minimal realization.
%
%   MSYS = SMINREAL(SYS) eliminates the states of the state-space
%   model SYS that are not connected to any input or output.  The
%   resulting state-space model MSYS is equivalent to SYS and is 
%   structurally minimal, i.e., minimal when all nonzero entries 
%   of SYS.A, SYS.B, SYS.C, and SYS.E are set to 1.
%
%   See also MINREAL.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/18 22:39:33 $

error(nargchk(1,1,nargin))

sizes = size(sys.d);
Na = size(sys.a,1);
Ne = size(sys.e,1);
Nx = nxarray(sys);   % state dimension for each model
Xnames = sys.StateName;

% Loop over each model
for k=1:prod(sizes(3:end)),
   na = Nx(k);
   ne = min(na,Ne);
   [a,b,c,e,xkeep] = smreal(sys.a(1:na,1:na,k),sys.b(1:na,:,k),...
                            sys.c(:,1:na,k),sys.e(1:ne,1:ne,k),(1:na)');
   nar = size(a,1);
   
   if nar<na,
      % Order is reduced
      Nx(k) = nar;
      % Zero out existing data and replace by reduced-order data
      sys.a(:,:,k) = 0;   sys.a(1:nar,1:nar,k) = a;
      sys.b(:,:,k) = 0;   sys.b(1:nar,:,k) = b;
      sys.c(:,:,k) = 0;   sys.c(:,1:nar,k) = c;
      if Ne,
         sys.e(:,:,k) = 0;   sys.e(1:nar,1:nar,k) = e;
      end
   end
end

% Check NX 
sys.Nx = Nx;
sys = xclip(sys);
if length(sys.Nx)>1,
   sys.StateName(:) = {''};
else
   sys.StateName = Xnames(xkeep);
end


