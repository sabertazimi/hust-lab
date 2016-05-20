function zps = zpinfo(sys,Ts,PlotType)
%ZPINFO  Computes the poles and zeros needed to generate
%        the frequency grid in frequency-response plots.
%        The cell array ZP contains the vectors of poles
%        and zeros for each model.
%
%    LOW-LEVEL FUNCTION. Called by FGRID.

%   Author(s): P. Gahinet  5-22-97
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/03/16 21:04:22 $

   
[num,den] = tfdata(sys);
sizes = size(num);
ny = sizes(1);
nu = sizes(2);
zps = cell([sizes(3:end) 1 1]);

% Loop over each model
for k=1:prod(sizes(3:end)),  
   % Form vector of poles and zeros
   nk = num(:,:,k);
   dk = den(:,:,k);
   zp = zeros(0,1);
   for i=1:ny*nu,
      zp = [zp ; roots(nk{i}) ; roots(dk{i});];
   end
   
   % Keep only one root for each complex pair
   zp = zp(imag(zp)>=0,:);
   
   % Map to S plane if system is discrete
   if Ts~=0,
      zp(~zp,:) = [];
      zp = log(zp)/Ts;
      % Discard modes with equivalent frequency > Nyquist freq.
      zp(abs(zp)>1.1*pi/Ts,:) = [];  
   end
   
   zps{k} = zp;
end