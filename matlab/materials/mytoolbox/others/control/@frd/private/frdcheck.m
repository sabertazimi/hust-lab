function sys = frdcheck(sys,valueChange)
%FRDCHECK  Checks the validity and consistency of frequency and 
%          frequency response data values FREQ and RESPONSE.

%   Author: S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/08/26 16:42:29 $

if ~valueChange,
   return
end

% Make sure FREQ is a column vector of finite non-negative doubles
freqVector = sys.Frequency;
freqSize = size(freqVector);
if length(unique(freqVector)) ~= freqSize
   error('Frequency points in FRD must be unique.');
end
if isequal(max(freqVector),inf) | min(freqVector)<0
   error('Only non-negative finite frequencies allowed in FRD.');
end

if length(freqSize)>2 | min(freqSize)>1 | ~isa(freqVector,'double') ...
      | ~isreal(freqVector) | any(isnan(freqVector))
   error('FREQ must be a vector of real frequencies.')
else
   sys.Frequency = sys.Frequency(:);
end

% NaNs not allowed in ResponseData
anyNaNs = isnan(sys.ResponseData);
if any(anyNaNs(:))
   error('NaN not allowed in response data.');
end

% Check dimensions of response data and reshape if necessary

numFreqPoints = size(sys.Frequency,1);
sizes = size(sys.ResponseData);

if ~numFreqPoints & length(sizes)==2,
   % Handle special case FREQ=[] separately
   sys.ResponseData = zeros([sizes 0]);
   return
end

sizes = [sizes 1];  % Make sure LENGTH(SIZES)>=3
freqDims = find( sizes(1:3) == numFreqPoints );

if isempty(freqDims) | ( freqDims(end) ~= 3 & ~all(sizes(1:freqDims(end)-1)==1) )
   errmsg = 'Size mismatch between frequency vector and response data.';
   if valueChange<3,  % only FREQ _or_ RESPONSE modified
      errmsg = sprintf('%s\n%s',errmsg, ...
         'Use SET(SYS,''Frequency'',FREQ,''ResponseData'',RESPONSE) to modify number of frequency points');
   end
   error(errmsg)
else
   sys.ResponseData = reshape( sys.ResponseData, [ones(1,3-freqDims(end)), sizes] );
end

% sort by frequency
[junk,sortIndices] = sort(sys.Frequency);
sys.Frequency = sys.Frequency(sortIndices);
indices = [{':'} {':'} {sortIndices} repmat({':'},[1 ndims(sys.ResponseData)-3])];
sys.ResponseData = sys.ResponseData(indices{:});
