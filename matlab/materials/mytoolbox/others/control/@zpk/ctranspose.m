function tsys = ctranspose(sys)
%CTRANSPOSE  Pertransposition of zero-pole-gain models.
%
%   TSYS = CTRANSPOSE(SYS) is invoked by TSYS = SYS'
%
%   If SYS represents the continuous-time transfer function
%   H(s), TSYS represents its pertranspose H(-s).' .   In 
%   discrete time, TSYS represents H(1/z).' if SYS represents 
%   H(z).
%
%   See also TRANSPOSE, ZPK, LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/04/14 21:11:41 $

% Extract data
[z,p,k,Ts] = zpkdata(sys);
if isempty(k),
   tsys = sys.';  
   return
end

sizes = size(k);
sizes([1 2]) = sizes([2 1]);

if Ts==0,
   % Continuous-time case: replace s by -s
   for j=1:prod(sizes),
      z{j} = -z{j};
      p{j} = -p{j};
      dl = length(p{j}) - length(z{j});
      if mod(dl,2),  k(j) = -k(j);  end
   end
else
   % Discrete-time case: replace z by z^-1
   for j=1:prod(sizes),
      zj = z{j};   pj = p{j};
      idz = find(~zj);   zj(idz) = [];
      idp = find(~pj);   pj(idp) = [];
      k(j) = k(j) * prod(-zj) / prod(-pj);
      zj = 1./zj;  
      pj = 1./pj;
      zpow = length(idp) + length(pj) - (length(idz) + length(zj));
      z{j} = [zj ; zeros(zpow,1)];
      p{j} = [pj ; zeros(-zpow,1)];
   end
end

% Create result
tsys = sys;
tsys.z = cell(sizes);
tsys.p = cell(sizes);
tsys.k = zeros(sizes);
for j=1:prod(sizes(3:end)),
   tsys.z(:,:,j) = z(:,:,j)';
   tsys.p(:,:,j) = p(:,:,j)';
   tsys.k(:,:,j) = k(:,:,j)';
end
sys.lti = (sys.lti)';

