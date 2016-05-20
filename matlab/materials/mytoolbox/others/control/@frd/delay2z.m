function sys = delay2z(sys)
%DELAY2Z  Replace delays by poles at z=0 or FRD phase shift.  
%
%   For discrete-time TF, ZPK, or SS models SYS,
%      SYS = DELAY2Z(SYS) 
%   maps all time delays to poles at z=0.  Specifically, a 
%   delay of k sampling periods is replaced by (1/z)^k.
%
%   For FRD models, DELAY2Z absorbs all time delays into the 
%   frequency response data, and is applicable to both 
%   continuous- and discrete-time FRDs.
%
%   See also HASDELAY, PADE, LTIMODELS.

%	 P. Gahinet, S. Almy
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.2 $  $Date: 1998/09/18 17:57:58 $

error(nargchk(1,1,nargin));

Td = totaldelay(sys);
if ~any(Td(:)),
   return
end

sizeSys = size(sys.ResponseData);
sizeSys(3:min(3,end)) = [];  % ignore frequency dimension

% convert Td to sec for discrete time
L = sys.lti;
Ts = get(L,'Ts');
if Ts ~= 0
   Td = Td * abs(Ts);
end

if strncmpi(sys.Units,'h',1)
   factor = 2*pi;
else
   factor = 1;
end

hTd = delayfr(Td,sqrt(-1)*factor*sys.Frequency);
if ndims(hTd)<length(sizeSys)+1,
   hTd = repmat(hTd,[1 1 1 sizeSys(3:end)]);
end
sys.ResponseData = hTd .* sys.ResponseData;

% Set I/O delays to zero
sys.lti = set(sys.lti,'inputdelay',zeros(sizeSys(2),1),...
                      'outputdelay',zeros(sizeSys(1),1),...
                      'iodelaymatrix',zeros(sizeSys(1:2)));
                   
                   
                   
                   
                   

