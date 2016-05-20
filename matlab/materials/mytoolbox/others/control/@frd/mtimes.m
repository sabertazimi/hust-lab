function sys = mtimes(sys1,sys2)
%MTIMES  Multiplication of LTI models.
%
%   SYS = MTIMES(SYS1,SYS2) performs SYS = SYS1 * SYS2.
%   Multiplying two LTI models is equivalent to 
%   connecting them in series as shown below:
%
%         u ----> SYS2 ----> SYS1 ----> y 
%
%   If SYS1 and SYS2 are two arrays of LTI models, their
%   product is an LTI array SYS with the same number of
%   models where the k-th model is obtained by
%      SYS(:,:,k) = SYS1(:,:,k) * SYS2(:,:,k) .
%
%   See also SERIES, MLDIVIDE, MRDIVIDE, INV, LTIMODELS.

%   Author(s): S. Almy, A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/09/18 17:58:05 $

% Effect on other properties
% InputName is from sys2, OutputName from sys1
% UserData and Notes are deleted.

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


% Check dimensions and detect scalar multiplication  
sizes1 = size(sys1.ResponseData);
numFreqs = sizes1(3);
sizes1(3:min(3,end)) = [];  % ignore frequency dimension
sizes2 = size(sys2.ResponseData);
sizes2(3:min(3,end)) = [];  % ignore frequency dimension
if all(sizes1(1:2)==1) &  sizes2(1)~=1,
   % SYS1 is SISO (scalar multiplication)
   sys = sys2;
   if any(sizes2==0),
      % Scalar * Empty = Empty
      return
   else
      ScalarMult = 1;
   end
elseif all(sizes2(1:2)==1) & sizes1(2)~=1,
   % SYS2 is SISO (scalar multiplication)
   sys = sys1;
   if any(sizes1==0),
      % Empty * Scalar = Empty
      return
   else
      ScalarMult = 2;
   end
else
   sys = sys1;
   ScalarMult = 0;
end


% Check dimension consistency
if ~ScalarMult & sizes1(2)~=sizes2(1),
   error('In SYS1*SYS2, systems must have compatible dimensions.');
elseif ~ScalarMult & ~isequal(sizes1(3:end),sizes2(3:end)),
   if length(sizes1)>2 & length(sizes2)>2,
      error('In SYS1*SYS2, arrays SYS1 and SYS2 must have compatible dimensions.')
   elseif length(sizes1)>2,
      % ND expansion of SYS2
      sys2.ResponseData = repmat(sys2.ResponseData,[1 1 1 sizes1(3:end)]);
   else
      % ND expansion of SYS1
      sys1.ResponseData = repmat(sys1.ResponseData,[1 1 1 sizes2(3:end)]);
      sys = sys2; % sys previously set to sys1 above
   end
end   

% LTI property management
sflags = [isstatic(sys1) , isstatic(sys2)];
if any(sflags),
   % Adjust sample time of static gains to avoid unwarranted clashes
   % RE: static gains are regarded as sample-time free
   [sys1.lti,sys2.lti] = sgcheck(sys1.lti,sys2.lti,sflags);
end

% Use try/catch to keep errors at top level
try
   [sys.lti,sys1,sys2] = ltimult(sys1.lti,sys2.lti,sys1,sys2,ScalarMult);
catch
   error(lasterr)
end

resp1 = sys1.ResponseData;
resp2 = sys2.ResponseData;

% Perform multiplication
switch ScalarMult
case 0
   % Regular multiplication
   ny = sizes1(1);   nu = sizes2(2);
   sizeResp = size(sys.ResponseData);
   resp = zeros([ny nu sizeResp(3:end)]);
   
   % Compute each entry
   for k=1:prod([numFreqs sizeResp(4:end)])
      resp(:,:,k) = resp1(:,:,k)*resp2(:,:,k);
   end
   
case 1
   % Scalar multiplication sys1 * SYS2 with sys1 SISO
   sizes2 = [sizes2 1];
   arraySize = prod(sizes2(3:end));
   resp = zeros(size(sys.ResponseData));
   for freqIndex = 1:numFreqs
      scalarResp = resp1(:,:,freqIndex);
      for k=1:arraySize
         resp(:,:,freqIndex,k) = scalarResp * resp2(:,:,freqIndex,k);
      end
   end

case 2
   % Scalar multiplication SYS1 * sys2 with sys2 SISO
   sizes1 = [sizes1 1];
   arraySize = prod(sizes1(3:end));
   resp = zeros(size(sys.ResponseData));
   for freqIndex = 1:numFreqs
      scalarResp = resp2(:,:,freqIndex);
      for k=1:arraySize
         resp(:,:,freqIndex,k) = scalarResp * resp1(:,:,freqIndex,k);
      end
   end

end

sys.ResponseData = resp;
sys.Frequency = freq;
sys.Units = units;
