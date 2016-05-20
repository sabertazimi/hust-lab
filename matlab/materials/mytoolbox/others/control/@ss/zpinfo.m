function zps = zpinfo(sys,Ts,PlotType)
%ZPINFO  Computes the poles and zeros needed to generate
%        the frequency grid in frequency-response plots.
%        The cell array ZP contains the vectors of poles
%        and zeros for each model.
%
%    LOW-LEVEL FUNCTION. Called by FGRID.

%   Author(s): P. Gahinet  5-22-97
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 1998/10/01 20:12:35 $

sizes = size(sys.d);
ny = sizes(1);
nu = sizes(2);
zps = cell([sizes(3:end) 1 1]);

if ~strcmp(PlotType,'sigma') | (min(nu,ny)==1 & max(nu,ny)>1),
   % Compute zeros for each I/O channel
   for k=1:prod(sizes(3:end)),
      % Loop over each model in LTI array
      [a,b,c,d] = ssdata(subsref(sys,substruct('()',{':' ':' k})));
      zp = eig(a);   % poles
      sprad = max(abs(zp)); % spectral radius
      
      i = 1;  j = 1;  
      while j<=nu,
        % REVISIT: TZERO should perform balancing
        tz = tzero(a,b(:,j),c(i,:),d(i,j));
        zp = [zp ; tz(abs(tz)<max([1e5;1e3*sprad]))];
        i = i+1;
        if i>ny,  i = 1;  j = j+1;  end
      end
      
      % Keep only one root for each complex pair
      zp = zp(imag(zp)>=0,:);
      
      % Map to S plane if system is discrete
      if Ts>0,
         zp(~zp,:) = [];
         zp = log(zp)/Ts;
         % Discard modes with equivalent frequency > Nyquist freq.
         zp(abs(zp)>1.1*pi/Ts,:) = [];  
      end
      zps{k} = zp;
   end
   
else
   % MIMO SV plot: compute transmission zeros
   for k=1:prod(sizes(3:end)),
      % Loop over each model in LTI array
      [a,b,c,d] = ssdata(subsref(sys,substruct('()',{':' ':' k})));
      p = eig(a);    % poles
      sprad = max(abs(p));  % spectral radius
      tz = tzero(a,b,c,d);
      zp = [p ; tz(abs(tz)<max([1e5;1e3*sprad]))];
      
      % Keep only one root for each complex pair
      zp = zp(imag(zp)>=0,:);
      
      % Map to S plane if system is discrete
      if Ts>0,
         zp(~zp,:) = [];
         zp = log(zp)/Ts;
         % Discard modes with equivalent frequency > Nyquist freq.
         zp(abs(zp)>1.1*pi/Ts,:) = [];  
      end
      zps{k} = zp;
   end
   
end
