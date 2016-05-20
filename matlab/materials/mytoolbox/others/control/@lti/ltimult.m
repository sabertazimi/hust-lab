function [L,sys1,sys2] = ltimult(L1,L2,sys1,sys2,ScalarMult)
%LTIMULT  LTI property management for LTI model product.
% 
%   [SYS.LTI,SYS1,SYS2] = LTIMULT(SYS1.LTI,SYS2.LTI,SYS1,SYS2,SCALARMULT)
%   sets the LTI properties of the model SYS = SYS1 * SYS2.
%   In discrete time, conflicting delays are removed using DELAY2Z 
%   (SYS1 and SYS2 are then updated accordingly).
%
%   See also TF/MTIMES.

%   Author(s):  P. Gahinet, 5-23-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/10/01 20:12:26 $

% Sample time management
% RE: Assumes that the sample time of static gains 
%     has already been adjusted
%
if (L1.Ts==-1 & L2.Ts>0) | (L2.Ts==-1 & L1.Ts>0),
   % Discrete/discrete with one unspecified sample time
   Ts = max(L1.Ts,L2.Ts);
elseif L1.Ts~=L2.Ts,
   error('In SYS1*SYS2, both models must have the same sample time.')
else
   Ts = L1.Ts;
end

% Other LTI properties: handle various types of multiplication
switch ScalarMult
case 1
   % Scalar multiplication sys1 * SYS2 (Keep Notes and UserData)
   L = L2;
   
   % Multiply all entries of SYS2 by time delay in SYS1
   L.InputDelay = L.InputDelay + L1.InputDelay;
   L.OutputDelay = L.OutputDelay + L1.OutputDelay;
   L.ioDelayMatrix = L.ioDelayMatrix + L1.ioDelayMatrix;
      
case 2
   % Scalar multiplication SYS1 * sys2 (Keep Notes and UserData)
   L = L1;
   
   % Multiply all entries of SYS1 by time delay in SYS2
   L.InputDelay = L.InputDelay + L2.InputDelay;
   L.OutputDelay = L.OutputDelay + L2.OutputDelay;
   L.ioDelayMatrix = L.ioDelayMatrix + L2.ioDelayMatrix;
   
otherwise
   % Regular multiplication
   L = L2;  % Takes care of InputName,Group,Delay
   L.Notes = {};
   L.UserData = [];
   
   % Output names, groups, delays
   L.OutputName = L1.OutputName; 
   L.OutputGroup = L1.OutputGroup;
   L.OutputDelay = L1.OutputDelay;
   
   % I/O delays
   Dm1 = L1.ioDelayMatrix + repmat(L1.InputDelay',[size(L1.ioDelayMatrix,1) 1]);
   sd1 = size(Dm1);
   Dm2 = L2.ioDelayMatrix + repmat(L2.OutputDelay,[1 size(L2.ioDelayMatrix,2)]);  
   sd2 = size(Dm2);
   if length(sd1)<length(sd2),
      Dm1 = repmat(Dm1,[1 1 sd2(3:end)]);
      sd1 = size(Dm1);
   elseif length(sd2)<length(sd1),
      Dm2 = repmat(Dm2,[1 1 sd1(3:end)]);
      sd2 = size(Dm2);
   end
   
   % SYS1*SYS2 is representable as a delay system if DxDy([Dm1;-Dm2'])=0
   Dm1 = Dm1(:,:,:);
   Dm2 = Dm2(:,:,:);
   % REVISIT: permute->transpose
   Dm12 = cat(1,Dm1,-permute(Dm2,[2 1 3]));
   d = diff(diff(Dm12,1,1),1,2);
   psizes = sd1;   psizes(2) = sd2(2);
   
   if sd1(2)==0,
      Dm = zeros(sd1(1),sd2(2));
   elseif all(abs(d(:))<=1e3*eps*max(Dm12(:))),
      Dm = reshape(Dm1(:,ones(1,sd2(2)),:) + Dm2(ones(1,sd1(1)),:,:),psizes);
   elseif Ts | isa(sys1,'frd')
      % Discrete-time case: extract parts of Dm1,Dm2 satisfying DxDy([Dm1;-Dm2'])=0. 
      % Other delays mapped to z=0
      % RE: Blows away LTI properties of sys1 and sys2 (no longer used in MTIMES)
      a = min(Dm1,[],2); 
      b = min(Dm2,[],1);
      Dm = reshape(a(:,ones(1,sd2(2)),:) + b(ones(1,sd1(1)),:,:),psizes);
      sys1.InputDelay = zeros(sd1(2),1);
      sys1.OutputDelay = zeros(sd1(1),1);
      sys1.ioDelayMatrix = reshape(Dm1 - reshape(a(:,ones(1,sd1(2)),:),sd1),sd1);
      sys1 = delay2z(sys1);
      sys2.InputDelay = zeros(sd2(2),1);
      sys2.OutputDelay = zeros(sd2(1),1);
      sys2.ioDelayMatrix = reshape(Dm2 - reshape(b(ones(1,sd2(1)),:,:),sd2),sd2);
      sys2 = delay2z(sys2);
   else
      error('Product SYS1*SYS2 cannot be represented using a single delay for each I/O pair.')
   end
      
   % Set I/O delays to DM
   L.ioDelayMatrix = tdcheck(Dm);
   
end


% Set sample time field
L.Ts = Ts;

