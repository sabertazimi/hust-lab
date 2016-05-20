function tsys = ctranspose(sys)
%CTRANSPOSE  Pertransposition of transfer functions.
%
%   TSYS = CTRANSPOSE(SYS) is invoked by TSYS = SYS'
%
%   If SYS represents the continuous-time transfer function
%   H(s), TSYS represents its pertranspose H(-s).' .   In 
%   discrete time, TSYS represents H(1/z).' if SYS represents 
%   H(z).
%
%   See also TRANSPOSE, TF, LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/02/12 22:28:30 $

% Extract data
num = sys.num;
den = sys.den;
if isempty(num),
   tsys = sys.';  return
end

sizes = size(num);
sizes([1 2]) = sizes([2 1]);
Ts = getst(sys.lti);

% Variable change s->-s or z->1/z
if Ts==0,
   % Continuous-time case: replace s by -s
   for k=1:prod(sizes),
      num{k}(2:2:end) = -num{k}(2:2:end);
      den{k}(2:2:end) = -den{k}(2:2:end);
   end
else
   % Discrete-time case: replace z by z^-1
   for k=1:prod(sizes),
      num{k} = fliplr(num{k});
      den{k} = fliplr(den{k});
   end
end

% Transposition
tsys = sys;
tsys.num = cell(sizes);
tsys.den = cell(sizes);
for k=1:prod(sizes(3:end)),
   tsys.num(:,:,k) = num(:,:,k)';
   tsys.den(:,:,k) = den(:,:,k)';
end
tsys.lti = (sys.lti)';
