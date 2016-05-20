function sys = lft(sys1,sys2,nu,ny)
%LFT  Redheffer star product of LTI systems.
%
%   SYS = LFT(SYS1,SYS2,NU,NY) evaluates the star product SYS of
%   the two LTI models SYS1 and SYS2.  The star product or 
%   linear fractional transformation (LFT) corresponds to the 
%   following feedback interconnection of SYS1 and SYS2:
%		
%                        +-------+
%            w1 -------->|       |-------> z1
%                        |  SYS1 |
%                  +---->|       |-----+
%                  |     +-------+     |
%                u |                   | y
%                  |     +-------+     |
%                  +-----|       |<----+
%                        |  SYS2 |
%           z2 <---------|       |-------- w2
%                        +-------+
%
%   The feedback loop connects the first NU outputs of SYS2 to the 
%   last NU inputs of SYS1 (signals u), and the last NY outputs of 
%   SYS1 to the first NY inputs of SYS2 (signals y).  The resulting 
%   LTI model SYS maps the input vector [w1;w2] to the output vector 
%   [z1;z2].
%
%   SYS = LFT(SYS1,SYS2) returns
%     * the lower LFT of SYS1 and SYS2 if SYS2 has fewer inputs and 
%       outputs than SYS1.  This amounts to deleting w2,z2 in the
%       above diagram.
%     * the upper LFT of SYS1 and SYS2 if SYS1 has fewer inputs and 
%       outputs than SYS2.  This amounts to deleting w1,z1 above.
%
%   If SYS1 and SYS2 are arrays of LTI models, LFT returns an LTI
%   array SYS of the same dimensions where 
%      SYS(:,:,k) = LFT(SYS1(:,:,k),SYS2(:,:,k),NU,NY) .
%
%   See also FEEDBACK, CONNECT, LTIMODELS.

%   Author(s): S. Almy, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/07/16 20:04:04 $

ni = nargin;
error(nargchk(2,4,ni))
if ni==3,
   error('Number of inputs must be 2 or 4.')
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

% Extract data
resp = sys1.ResponseData;
respFB = sys2.ResponseData;
sizeResp = size(resp);
sizeRespFB = size(respFB);
numFreqs = size(resp,3);
ny1 = sizeResp(1);
nu1 = sizeResp(2);
ny2 = sizeRespFB(1);
nu2 = sizeRespFB(2);

% Figure out NU and NY if unspecified
if ni==2
   if nu1>=ny2 & ny1>=nu2,
      nu = ny2; 
      ny = nu2;
   elseif ny1<=nu2 & nu1<=ny2,
      nu = nu1; 
      ny = ny1;
   else
      error('Ambiguous configuration: please specify the dimensions of u and y.')
   end
elseif nu>ny2 | nu>nu1,
   error('NU exceeds number of inputs of SYS1 or number of outputs of SYS2.')
elseif ny>nu2 | ny>ny1,
   error('NY exceeds number of inputs of SYS2 or number of outputs of SYS1.')
end

% Check compatibility of higher dimensions
if ~isequal(sizeResp(3:end),sizeRespFB(3:end)) & ...
   ~all(sizeResp(3:end)==1) & ~all(sizeRespFB(3:end)==1),
   error('Arrays SYS1 and SYS2 must have compatible dimensions.')
end

% Determine signal dimensions
lw1 = nu1-nu;  lz1 = ny1-ny;
lw2 = nu2-ny;  lz2 = ny2-nu;

% Append SYS1 and SYS2 and close the positive feedback loop 
%                   [u1 ; u2] = [y2 ; y1]
% in
%                         +-------+
%             w1 -------->|       |-------> z1
%                         |  SYS1 |
%             u1 -------->|       |-------> y1
%                         +-------+     
%                         +-------+
%             u2 -------->|       |-------> y2
%                         |  SYS2 |
%             w2 -------->|       |-------> z2
%                         +-------+     
%

sysFB = frd(repmat([zeros(nu,ny) eye(nu) ; eye(ny) zeros(ny,nu)],[1 1 numFreqs]),freq,'units',units);
sys = feedback(append(sys1,sys2),sysFB,[lw1+1:lw1+nu+ny],[lz1+1:lz1+nu+ny],+1);

% Select inputs [w1;w2] and outputs [z1;z2]
no = ny1+ny2;
ni = nu1+nu2;
indices = {[1:lz1 no-lz2+1:no],[1:lw1 ni-lw2+1:ni]};
indices(3:length(sizeResp)) = {':'};
sys.ResponseData = sys.ResponseData(indices{:});
sys.Frequency = freq;
sys.Units = units;
sys.lti = sys.lti(indices{1:2});