function [iod,L1,L2] = iodmerge(iostr,iod1,iod2,L1,L2)
%IODMERGE  Merge two sets of input or output delays.
%
%   [IOD,L1,L2] = IODMERGE(IOSTR,IOD1,IOD2,L1,L2) checks
%   if the two sets IOD1 and IOD2 of input or output delays 
%   of the LTI objects L1 and L2 are compatible and absorbs 
%   conflicting delay sets into the I/O delay matrices of
%   L1 and L2.
%
%   See also HORZCAT, VERTCAT, PLUS.

%   Author(s):  P. Gahinet  5-13-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/18 22:33:17 $

if ~any(iod1(:)) & ~any(iod2(:)),
   iod = iod1;
   return
end

% Align array dimensions
sd1 = size(iod1);
sd2 = size(iod2);
iod1 = repmat(iod1,[1 1 sd2(1+length(sd1):end)]);
iod2 = repmat(iod2,[1 1 sd1(1+length(sd2):end)]);
iod = min(iod1,iod2);
sd = size(iod);

% Find model pairs with different input (output) delays
gap = abs(iod1(:,:,:)-iod2(:,:,:));
kgap = find(any(reshape(gap,[sd(1) prod(sd(3:end))])>1e3*eps,1));

if ~isempty(kgap),
   % Absorb offending input delays into corresponding I/O Delay Matrix
   L1.ioDelayMatrix = repmat(L1.ioDelayMatrix,[1 1 sd(1+ndims(L1.ioDelayMatrix):end)]);
   L2.ioDelayMatrix = repmat(L2.ioDelayMatrix,[1 1 sd(1+ndims(L2.ioDelayMatrix):end)]);
   if strcmp(iostr,'i'),
      iod1 = permute(iod1-iod,[2 1 3:length(sd)]);  % transposition
      iod2 = permute(iod2-iod,[2 1 3:length(sd)]);
      L1.ioDelayMatrix(:,:,kgap) = ...
         L1.ioDelayMatrix(:,:,kgap) + repmat(iod1(:,:,kgap),[size(L1.ioDelayMatrix,1) 1]);
      L2.ioDelayMatrix(:,:,kgap) = ...
         L2.ioDelayMatrix(:,:,kgap) + repmat(iod2(:,:,kgap),[size(L2.ioDelayMatrix,1) 1]);
      L1.InputDelay = iod;
      L2.InputDelay = iod;
   else
      iod1 = iod1-iod;
      iod2 = iod2-iod;
      L1.ioDelayMatrix(:,:,kgap) = ...
         L1.ioDelayMatrix(:,:,kgap) + repmat(iod1(:,:,kgap),[1 size(L1.ioDelayMatrix,2)]);
      L2.ioDelayMatrix(:,:,kgap) = ...
         L2.ioDelayMatrix(:,:,kgap) + repmat(iod2(:,:,kgap),[1 size(L2.ioDelayMatrix,2)]);
      % Eliminate offending output delays                 
      L1.OutputDelay = iod;
      L2.OutputDelay = iod;
   end
end

% Eliminate redundant delays
iod = tdcheck(iod);