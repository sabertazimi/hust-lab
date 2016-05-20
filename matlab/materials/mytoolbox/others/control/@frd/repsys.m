function sys = repsys(sys,s)
%REPSYS  Replicate SISO LTI model
%
%   RSYS = REPSYS(SYS,K) returns the block-diagonal model
%   Diag(SYS,...,SYS) with SYS repeated K times.
% 
%   RSYS = REPSYS(SYS,[M N]) replicates and tiles SYS to 
%   produce the M-by-N block model RSYS.
%
%   See also LTIMODELS.

%   Author(s): S. Almy, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/06/19 20:20:17 $

sizes = size(sys.ResponseData);
if ~isequal(sizes(1:2),[1 1]),
   error('Only available for SISO models.')
end

if length(s)==1
   % Block diagonal replication
   originalResp = sys.ResponseData;
   resp = zeros([s,s,sizes(3:end)]);
   for j=1:s
      resp(j,j,:) = originalResp;
   end
   sys.ResponseData = resp;
   
else
   % Replication and tiling
   s = [s(1:2),1,s(3:end)];
   sys.ResponseData = repmat(sys.ResponseData,s);
end

sys.lti = repsys(sys.lti,s);
