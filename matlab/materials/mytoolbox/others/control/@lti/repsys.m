function L = repsys(L,s)
%REPSYS  Replicate SISO LTI model
%
%   RSYS = REPSYS(SYS,K) forms the block-diagonal model
%   Diag(SYS,...,SYS) with SYS repeated K times.
% 
%   RSYS = REPSYS(SYS,[M N]) replicates and tiles SYS to 
%   produce the M-by-N block model RSYS.
%
%   See also LTIMODELS.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/04/14 21:11:38 $

if length(s)==1,
   % Block diagonal case: use uniform delay
   L.ioDelayMatrix = repmat(L.ioDelayMatrix,[s s]);   
   L.InputDelay = repmat(L.InputDelay,[s 1]);
   L.OutputDelay = repmat(L.OutputDelay,[s 1]);
else
   % Replicate and tile
   L.ioDelayMatrix = repmat(L.ioDelayMatrix,s);
   L.InputDelay = repmat(L.InputDelay,[s(2) 1]);
   L.OutputDelay = repmat(L.OutputDelay,[s(1) 1]);
end

% Discard I/O names and groups
[ny,nu] = size(L.ioDelayMatrix(:,:,1));
L.InputName(1:nu,1) = {''};
L.OutputName(1:ny,1) = {''};
L.InputGroup = cell(0,2);
L.OutputGroup = cell(0,2);