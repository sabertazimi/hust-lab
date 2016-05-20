function w = fgrid(PlotType,hardMin,hardMax,softMin,softMax,npts,varargin)
%FGRID   Generate frequency grids for multiple FRD systems
%
%    W = FGRID(PLOTTYPE,HARDMIN,HARDMAX,SOFTMIN,SOFTMAX,NPTS,SYS1,...,SYSk)
%    generates adequate frequency grids  W = {W1,...,Wk}  for the frequency
%    response plots of the LTI systems SYS1,...,SYSk.  A common frequency
%    range is used for all these grids.  The grids contain at least NPTS
%    points.  HARDMIN (HARDMAX), if non-empty, will force the minimum(maximum)
%    frequency value to match the one specified.  SOFTMIN (SOFTMAX), if
%    non-empty, will force the minimum(maximum) frequency value to be
%    at most(least) the specified value, but is over-ridden by any
%    value of HARDMIN (HARDMAX).
%
%    LOW-LEVEL FUNCTION.

%   Author(s): S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/05/22 19:21:13 $

nsys = nargin-6;             % number of LTI systems
w = cell(1,nsys);            % to store freq. grid for each system

FRDsystems = zeros(1,nsys);
for sysIndex = 1:nsys
   FRDsystems(sysIndex) = isa(varargin{sysIndex},'frd');
end

% Retrieve frequency points for each FRD array
for k=find(FRDsystems),
   sys = varargin{k};
   if strcmpi(sys.Units,'hz')
      sysFreqs = 2*pi*sys.Frequency; % convert to rad/s
   else
      sysFreqs = sys.Frequency;
   end
   sizeSys = [size(sys.ResponseData) 1 1];
   freqs = sysFreqs(sysFreqs >= max([hardMin 0]) & sysFreqs <= min([hardMax inf]));
   softMin = min([softMin,min(freqs)]);
   softMax = max([softMax,max(freqs)]);
   w{k} = repmat({freqs}, sizeSys(4:end)); % same freqs for all elements in array
end

if any(~FRDsystems)
   w(~FRDsystems) = fgrid(PlotType,hardMin,hardMax,softMin,softMax,npts,varargin{~FRDsystems});
end
