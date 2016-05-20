function L = mindelay(L,flag)
%MINDELAY  Minimizes overall number of delays.
%
%   SYS.LTI = MINDELAY(SYS.LTI) minimizes the total number of
%   delays in SS models with I/O delays by
%     * mapping I/O delays into input and output delays
%       to minimize the sum of the I/O delay matrix entries
%     * balancing input vs. output delays to minimize the 
%       number of channel delays
%
%   SYS.LTI = MINDELAY(SYS.LTI,'ALLDELAY') applies the same 
%   scheme to all models with delays.
%
%   Used in TF/SS, ZPK/SS, SS/C2D, SS/D2C, and +,*,[].

%   Author(s):  P. Gahinet  5-13-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/09/18 17:55:27 $

tolzero = 1e4*eps;
alld = totaldelay(L);
sd = size(alld);

% Determine model with required delay properties 
if nargin==1,
   % Optimize delay distribution only for models with I/O delays
   siod = size(L.ioDelayMatrix);
   nzd = any(reshape(L.ioDelayMatrix,[siod(1)*siod(2) prod(siod(3:end))]),1); 
   if length(siod)==2,
      nzd = repmat(nzd,[1 prod(sd(3:end))]);
   end
else
   % Optimize delay distribution for all models with delays
   nzd = any(reshape(alld,[sd(1)*sd(2) prod(sd(3:end))]),1);
end

% Process delays for NZ-selected models
if any(nzd),
   % Align dimensions of input, output, and I/O delays
   id = repmat(L.InputDelay,[1 1 sd(ndims(L.InputDelay)+1:end)]);
   od = repmat(L.OutputDelay,[1 1 sd(ndims(L.OutputDelay)+1:end)]);
   iod = repmat(L.ioDelayMatrix,[1 1 sd(ndims(L.ioDelayMatrix)+1:end)]);
   
   % Loop over models with I/O delays
   for k=find(nzd),
      alldelays = alld(:,:,k);
      maxdelay = max(alldelays(:));
      % Extract maximal input+output delay combination
      % and minimize total number of input+output delays
      if sd(1)<sd(2),
         outdelays = min(alldelays,[],2);
         alldelays = alldelays - outdelays(:,ones(1,sd(2)));
         indelays = min(alldelays,[],1);
         alldelays = alldelays - indelays(ones(1,sd(1)),:);
      else
         indelays = min(alldelays,[],1);
         alldelays = alldelays - indelays(ones(1,sd(1)),:);
         outdelays = min(alldelays,[],2);
         alldelays = alldelays - outdelays(:,ones(1,sd(2)));
      end
      % Zero out small residual delays
      alldelays(alldelays<tolzero*maxdelay) = 0;
      indelays(indelays<tolzero*maxdelay) = 0;
      outdelays(outdelays<tolzero*maxdelay) = 0;
      % Update input, output, and I/O delays
      id(:,:,k) = indelays';
      od(:,:,k) = outdelays;
      iod(:,:,k) = alldelays;
   end
   
   % Update delay properties
   L.InputDelay = tdcheck(id);
   L.OutputDelay = tdcheck(od);
   L.ioDelayMatrix = tdcheck(iod);
end

