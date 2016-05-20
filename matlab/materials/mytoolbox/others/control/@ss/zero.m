function [z,gain] = zero(sys)
%ZERO  Transmission zeros of LTI systems.
% 
%   Z = ZERO(SYS) returns the transmission zeros of the LTI 
%   model SYS.
%
%   [Z,GAIN] = ZERO(SYS) also returns the transfer function gain
%   (in the zero-pole-gain sense) for SISO models SYS.
%   
%   If SYS is an array of LTI models with sizes [NY NU S1 ... Sp],
%   Z and K are arrays with as many dimensions as SYS such that 
%   Z(:,1,j1,...,jp) and K(1,1,j1,...,jp) give the zeros and gain 
%   of the LTI model SYS(:,:,j1,...,jp).  The vectors of zeros are 
%   padded with NaN values for models with relatively fewer zeros.
%
%   See also POLE, PZMAP, ZPK, LTIMODELS.

%   Clay M. Thompson  7-23-90, 
%   Revised: P.Gahinet 5-15-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/10/01 20:12:35 $

no = nargout;
if nargin~=1,
   error('ZERO takes only one input when the first input is an LTI system.')
end

% Get data 
sizes = size(sys.d);
nd = length(sizes);
Na = size(sys.a,1);
if no>1 & any(sizes(1:2)>1),
   error('Second output GAIN only defined for SISO systems.')
end

% Create output
if nd==2,
   % Single model
   [a,b,c,d] = ssdata(sys);
   [z,gain] = tzero(a,b,c,d);
else
   % SS array: preallocate Z
   nzmax = 0;
   z = zeros([Na 1 sizes(3:end)]);
   gain = zeros([1 1 sizes(3:end)]);
   
   % Compute zeros
   for k=1:prod(sizes(3:end)),
      [a,b,c,d] = ssdata(subsref(sys,substruct('()',{':' ':' k})));
      [zk,gk] = tzero(a,b,c,d);
      nzk = length(zk);
      nzmax = max(nzmax,nzk);
      z(1:nzk,1,k) = zk;
      z(nzk+1:Na,1,k) = NaN;
      if no>1,
         gain(1,1,k) = gk;
      end
   end
   
   % Delete extra Inf values
   colons = repmat({':'},[1,nd+1]);
   z(nzmax+1:Na,colons{:}) = [];
end


