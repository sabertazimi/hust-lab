function sys = xclip(sys)
%XCLIP  Removes extra zero padding in A,B,C,E and
%       compactifies SYS.NX.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/05 14:07:41 $

% Store compact form of Nx if possible
sys.Nx = nxcheck(sys.Nx);

% Discard extra zero padding
Nxmax = max(sys.Nx(:));
if Nxmax<size(sys.a,1),
   ArrayColons = repmat({':'},[1 ndims(sys.d)-2]);
   sys.a = sys.a(1:Nxmax,1:Nxmax,ArrayColons{:});
   sys.b = sys.b(1:Nxmax,:,ArrayColons{:});
   sys.c = sys.c(:,1:Nxmax,ArrayColons{:});
   if ~isempty(sys.e),
      sys.e = sys.e(1:Nxmax,1:Nxmax,ArrayColons{:});
   end
end
sys.StateName = sys.StateName(1:Nxmax,1);