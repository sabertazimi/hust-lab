function sys = horzcat(varargin)
%VERTCAT  Vertical concatenation of LTI models.
%
%   SYS = VERTCAT(SYS1,SYS2,...) performs the concatenation 
%   operation:
%         SYS = [SYS1 ; SYS2 ; ...]
% 
%   This amounts to appending the outputs of the LTI models 
%   SYS1, SYS2,... and feeding all these models with the 
%   same input vector.
%
%   See also HORZCAT, LTICAT, LTIMODELS.

%   Author(s): S. Almy, A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/07/16 20:50:17 $

% Effect on other properties
% UserData and Notes are deleted

% Remove all empty arguments
ni = nargin;
EmptyModels = logical(zeros(1,ni));
for i=1:ni,
   sizes = size(varargin{i});
   EmptyModels(i) = ~any(sizes(1:2));
end
varargin(EmptyModels) = [];

% Get number of non empty model
nsys = length(varargin);
if nsys==0,
   sys = frd;  return
end

% find first FRD in list
sysIndex = 1;
while ~isa(varargin{sysIndex},'frd')
   sysIndex= sysIndex + 1;
end
freq = varargin{sysIndex}.Frequency;
units = varargin{sysIndex}.Units;

% Initialize output SYS to first input system
sysi = varargin{1};
if isa(sysi,'double') & ndims(sysi) < 3
   sysi = repmat(sysi,[1 1 length(freq)]);
else
   % give priority to units of rad/s
   try
      [freq,units] = freqcheck(freq,units,sysi.Frequency,sysi.Units);
   catch
   end
end
try
   sys = frd(sysi,freq,'units',units);
catch
   error(sprintf('Error converting SYS%d to FRD format.\n%s',1,lasterr));
end

response = sys.ResponseData;
sizeSys = size(response);
sizeSys(3) = []; % remove freq dimension
sflag = isstatic(sys);  % 1 if SYS is a static gain
slti = sys.lti;

% Concatenate remaining input systems
for sysIndex = 2:nsys
   sysi = varargin{sysIndex};
   if isa(sysi,'double') & ndims(sysi) < 3
      sysi = repmat(sysi,[1 1 length(freq)]);
   end
   % give priority to units of rad/s
   try
      [freq,units] = freqcheck(freq,units,sysi.Frequency,sysi.Units);
   catch
   end
   try
      sysi = frd(sysi,freq,'units',units);
   catch
      error(sprintf('Error converting SYS%d to FRD format.\n%s',sysIndex,lasterr));
   end
   
   sysResponse = sysi.ResponseData;
   
   % Check dimension compatibility
   sizeSysi = size(sysResponse);
   sizeSysi(3) = []; % remove freq dimension
   if sizeSys(2) ~= sizeSysi(2)
      error('In [SYS1 ; SYS2], SYS1 and SYS2 must have the same number of inputs.')
   elseif ~isequal(sizeSysi(3:end),sizeSys(3:end))
      if length(sizeSysi)>2 & length(sizeSys)>2
         error('In [SYS1 ; SYS2], arrays SYS1 and SYS2 must have compatible dimensions.')
      elseif length(sizeSysi)>2,
         % ND expansion of SYS
         response = repmat(response,[1 1 sizeSysi(3:end)]);
      else
         % ND expansion of SYSj
         sysResponse = repmat(sysResponse,[1 1 sizeSys(3:end)]);
      end
   end
   
   % LTI property management   
   sflagi = isstatic(sysi);
   if sflag | sflagi,
      % Adjust sample time of static gains to prevent clashes
      % RE: static gains are regarded as sample-time free
      [slti,sysi.lti] = sgcheck(slti,sysi.lti,[sflag sflagi]);
   end
   sflag = sflag & sflagi;
   try
      slti = [slti ; sysi.lti];
   catch
      error(lasterr)
   end
   
   % Update response data
   response = [response ; sysResponse];
   
end

% Create output
sys = frd([],[]);
sys.ResponseData = response;
sys.Frequency = freq;
sys.Units = units;
sys.lti = slti;
