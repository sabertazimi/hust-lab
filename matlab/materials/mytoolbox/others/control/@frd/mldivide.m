function sys = mldivide(sys1,sys2)
%MLDIVIDE  Left division for LTI models.
%
%   SYS = MLDIVIDE(SYS1,SYS2) is invoked by SYS=SYS1\SYS2
%   and is equivalent to SYS = INV(SYS1)*SYS2.
%
%   See also MRDIVIDE, INV, MTIMES, LTIMODELS.

%   Author(s): S. Almy, A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/09/24 18:06:38 $


% Simplify delays when SYS1 is SISO and delayed
if isa(sys1,'lti') & isa(sys2,'lti')
   [sys1,sys2] = simpdelay(sys1,sys2);
end

% Ensure both operands are FRD
if ~isa(sys1,'frd')
   if isa(sys1,'double') & ndims(sys1) < 3
      sys1 = repmat(sys1,[1 1 length(sys2.Frequency)]);
   end
   sys1 = frd(sys1,sys2.Frequency,'units',sys2.Units);
   freq = sys2.Frequency;
   units = sys2.Units;
elseif ~isa(sys2,'frd')
   if isa(sys2,'double') & ndims(sys2) < 3
      sys2 = repmat(sys2,[1 1 length(sys1.Frequency)]);
   end
   sys2 = frd(sys2,sys1.Frequency,'units',sys1.Units);
   freq = sys1.Frequency;
   units = sys1.Units;
else
   % Check frequency vectors
   try
      % give priority to rad/s if both FRD's
      [freq,units] = freqcheck(sys1.Frequency,sys1.Units,sys2.Frequency,sys2.Units);
   catch
      error(lasterr);
   end
end

%Remove remaining delays from SYS1 before inverting
sys1 = delay2z(sys1);

sizes1 = size(sys1.ResponseData);
sizes2 = size(sys2.ResponseData);

if all(sizes1(1:2)==1) &  sizes2(1)~=1,
   % SYS1 is SISO
   scalarMult = 1;
   ioSizes = sizes2(1:2);
elseif all(sizes2(1:2)==1) & sizes1(2)~=1,
   scalarMult = 2;
   ioSizes = sizes1(1:2);
else
   scalarMult = 0;
   ioSizes = [sizes1(2),sizes2(2)];
end

if sizes1(1)~=sizes1(2)
   error('Cannot invert non-square system.');
elseif ~scalarMult & sizes1(1)~=sizes2(1),
   error('In SYS1\SYS2, systems must have compatible dimensions.');
elseif ~isequal(sizes1(4:end),sizes2(4:end)),
   if length(sizes1)>3 & length(sizes2)>3,
      error('In SYS1\SYS2, arrays SYS1 and SYS2 must have compatible dimensions.')
   elseif length(sizes1)>3,
      % ND expansion of SYS2
      sys2.ResponseData = repmat(sys2.ResponseData,[1 1 1 sizes1(4:end)]);
      sizes2 = size(sys2.ResponseData);
   else
      % ND expansion of SYS1
      sys1.ResponseData = repmat(sys1.ResponseData,[1 1 1 sizes2(4:end)]);
      sizes1 = size(sys1.ResponseData);
   end
end

sys = frd;
sys.ResponseData = zeros([ioSizes,sizes1(3:end)]);

% Invert LTI parent of SYS1
sys1.lti = inv(sys1.lti);
% LTI property management
[sys.lti,sys1,sys2] = ltimult(sys1.lti,sys2.lti,sys1,sys2,scalarMult);

for k = 1:prod(sizes1(3:end))
   [L,U,P] = lu(sys1.ResponseData(:,:,k));
   if rcond(U)<10*eps
      error('Cannot invert FRD model with singular frequency response.');
   else
      sys.ResponseData(:,:,k) = U\(L\(P*sys2.ResponseData(:,:,k)));
   end
end

sys.Frequency = freq;
sys.Units = units;

