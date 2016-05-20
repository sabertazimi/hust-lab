function Tdio = totaldelay(sys)
%TOTALDELAY  Total time delays between inputs and outputs.
%
%   TD = TOTALDELAY(SYS) returns the total I/O delays TD for the 
%   LTI model SYS.  The matrix TD combines contributions from
%   the INPUTDELAY, OUTPUTDELAY, and IODELAYMATRIX properties, 
%   (see LTIPROPS for details on these properties).
%
%   Delays are expressed in seconds for continuous-time models, 
%   and as integer multiples of the sample period for discrete-time 
%   models (to obtain the delay times in seconds, multiply TD by 
%   the sample time SYS.TS).
%
%   See also HASDELAY, DELAY2Z, LTIPROPS.

%   Author(s):  P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/18 22:33:16 $

% REVISIT: when ND add ready, uncomment following code and delete
% what's after
%[ny,nu] = size(sys.ioDelayMatrix(:,:,1));
%Tdio = sys.ioDelayMatrix + ...
%           repmat(sys.InputDelay,[1 ny])' + ...
%           repmat(sys.OutputDelay,[1 nu]);

Tdio = sys.ioDelayMatrix;
std = size(Tdio);
id = permute(sys.InputDelay,[2 1 3:ndims(sys.InputDelay)]);
od = sys.OutputDelay;
[junk,i] = max([ndims(Tdio),ndims(id),ndims(od)]);
switch i
case 1
   sizes = size(Tdio);
case 2
   sizes = size(id);
case 3
   sizes = size(od);
end

Tdio = repmat(Tdio,[1 1 sizes(1+ndims(Tdio):end)]) + ...
   repmat(id,[std(1) 1 sizes(1+ndims(id):end)]) + ...
   repmat(od,[1 std(2) sizes(1+ndims(od):end)]);
