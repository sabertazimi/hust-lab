function sys = append(varargin)
%APPEND  Group LTI models by appending their inputs and outputs.
%
%   SYS = APPEND(SYS1,SYS2, ...) produces the aggregate system
% 
%                 [ SYS1  0       ]
%           SYS = [  0   SYS2     ]
%                 [           .   ]
%                 [             . ]
%
%   APPEND concatenates the input and output vectors of the LTI
%   models SYS1, SYS2,... to produce the resulting model SYS.
%
%   If SYS1,SYS2,... are arrays of LTI models, APPEND returns an LTI
%   array SYS of the same size where 
%      SYS(:,:,k) = APPEND(SYS1(:,:,k),SYS2(:,:,k),...) .
%
%   See also SERIES, PARALLEL, FEEDBACK, LTIMODELS.

%   Author(s): S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/07/16 20:50:18 $

nsys = nargin;
sysList = varargin;


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

sflag = isstatic(sys);  % 1 if static gain
slti = sys.lti;
response = sys.ResponseData;
sizeSys = size(response);
indices = repmat({':'},[1 length(sizeSys)]);

% build responseData field
for sysIndex = 2:nargin
   sysi = sysList{sysIndex};
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
   
   sysiResponse = sysi.ResponseData;
   
   response = cat(1,cat(2,response,zeros([size(response,1),size(sysiResponse,2),sizeSys(3:end)])), ...
      cat(2,zeros([size(sysiResponse,1),size(response,2),sizeSys(3:end)]),sysiResponse(indices{:})));
   
   % LTI property management   
   sflagi = isstatic(sysi);
   if sflag | sflagi,
      % Adjust sample time of static gains to prevent clashes
      % RE: static gains are regarded as sample-time free
      [slti,sysi.lti] = sgcheck(slti,sysi.lti,[sflag sflagi]);
   end
   sflag = sflag & sflagi;
   try
      slti = append(slti,sysi.lti);
   catch
      error(lasterr)
   end
   
end

% Create output
sys = frd(response,freq,'units',units);
sys.lti = slti;
