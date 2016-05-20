function L = lticheck(L,sizes)
%LTICHECK   Validity check for LTI properties.
%
%   LTICHECK is used by SET and makes sure that 
%     * the I/O Name and I/O Group properties are correctly 
%       dimensioned
%     * the I/O delay matrix is consistent with the system dimensions
%       and sample time
%           
%   See also SET.

%   Author: P. Gahinet, 7-11-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/04/14 21:10:20 $
  

% RE: the input L is an LTI object and [P M] are the system dimensions.

EmptyStr = {''};
Ny = sizes(1);
Nu = sizes(2);

% Check InputName length
Iname = L.InputName;
if length(Iname)~=Nu,
   if isempty(Iname) | all(strcmp(Iname,'')),
      L.InputName = EmptyStr(ones(Nu,1),1);
   else 
      error('Invalid model: length of InputName does not match number of inputs.')
   end
end

% Check OutputName length
Oname = L.OutputName;
if length(Oname)~=Ny,
   if isempty(Oname) | all(strcmp(Oname,'')),
      L.OutputName = EmptyStr(ones(Ny,1),1);
   else
      error('Invalid model: length of OutputName does not match number of outputs.')
   end
end

% Check InputGroup 
for i=1:size(L.InputGroup,1),   
   channels = L.InputGroup{i,1};
   if ~isa(channels,'numeric') | ndims(channels)>2 | size(channels,1)~=1,
      error(sprintf(['Invalid model (InputGroup): channel groups must be specified\n' ...
                  '                            as row vectors of indices.']))
   elseif ~isreal(channels) | any(channels<=0) | any(channels>Nu),
      error('Invalid model (InputGroup): channel indices are out of range.')
   end
   L.InputGroup{i,1} = sort(channels);
end

% Check OutputGroup 
for i=1:size(L.OutputGroup,1),   
   channels = L.OutputGroup{i,1};
   if ~isa(channels,'numeric') | ndims(channels)>2 | size(channels,1)~=1,
      error(sprintf(['Invalid model (OutputGroup): channel groups must be specified\n' ...
                  '                             as row vectors of indices.']))
   elseif ~isreal(channels) | any(channels<=0) | any(channels>Ny),
      error('Invalid model (OutputGroup): channel indices are out of range.')
   end
   L.OutputGroup{i,1} = sort(channels);
end

   
% Check Delay Matrix
dsizes = size(L.ioDelayMatrix);
if ~any(L.ioDelayMatrix(:)),
   % All zero delays: ignore initial size and set to proper size
   % (needed when a model with zero delays is resized)
   L.ioDelayMatrix = zeros([Ny Nu]);
elseif isequal(dsizes(1:2),[1 1]),
   % Scalar expansion
   L.ioDelayMatrix = repmat(L.ioDelayMatrix,[Ny Nu]);
end
   
% Check I/O delay values for discrete models
if L.Ts,
   % Discrete-time case: all entries of DelayMat should be integer
   Td = round(L.ioDelayMatrix);
   if any(abs(L.ioDelayMatrix(:)-Td(:))>1e3*eps*Td(:)),
      error('I/O delays must be integers for discrete-time models.')
   end
   L.ioDelayMatrix = Td;
end

% Check dimensions of DelayMat
dsizes = size(L.ioDelayMatrix);
if ~isequal(dsizes(1:2),[Ny Nu]),
   error('Size of I/O Delay Matrix does not match I/O dimensions.')
elseif length(dsizes)>2 & ~isequal(dsizes(3:end),sizes(3:end)),
   error('Size of I/O Delay Matrix does not match LTI array sizes.')
end
  
% Keep only one copy if DelayMat is the same for all models
L.ioDelayMatrix = tdcheck(L.ioDelayMatrix);



% Check InputDelay data
sid = size(L.InputDelay);
if ~any(L.InputDelay(:)),
   % All zero delays: ignore initial size and set to proper size
   % (needed when a model with zero delays is resized)
   L.InputDelay = zeros(Nu,1);
elseif isequal(sid(1:2),[1 1]),
   % Scalar expansion
   L.InputDelay = repmat(L.InputDelay,[Nu 1]);
elseif isequal(sid(1:2),[1 Nu]),
   % Row vector
   L.InputDelay = reshape(L.InputDelay,[Nu 1 sid(3:end)]);
end

% Check delay values for discrete models
if L.Ts,
   % Discrete-time case: all entries of InputDelay should be integer
   id = round(L.InputDelay);
   if any(abs(L.InputDelay(:)-id(:))>1e3*eps*id(:)),
      error('Input delays must be integers for discrete-time models.')
   end
   L.InputDelay = id;
end

% Check InputDelay dimensions 
sid = size(L.InputDelay);
if ~isequal(sid(1:2),[Nu 1]),
   error('Length of InputDelay vector does not match number of inputs.')
elseif length(sid)>2 & ~isequal(sid(3:end),sizes(3:end)),
   error('InputDelay data is not properly dimensioned.')
end

% Keep only one copy if input delays are the same for all models
L.InputDelay = tdcheck(L.InputDelay);



% Check OutputDelay data
sod = size(L.OutputDelay);
if ~any(L.OutputDelay(:)),
   % All zero delays: ignore initial size and set to proper size
   % (needed when a model with zero delays is resized)
   L.OutputDelay = zeros(Ny,1);
elseif isequal(sod(1:2),[1 1]),
   % Scalar expansion
   L.OutputDelay = repmat(L.OutputDelay,[Ny 1]);
elseif isequal(sod(1:2),[1 Ny]),
   % Row vector
   L.OutputDelay = reshape(L.OutputDelay,[Ny 1 sod(3:end)]);
end

% Check delay values for discrete models
if L.Ts,
   % Discrete-time case: all entries of InputDelay should be integer
   od = round(L.OutputDelay);
   if any(abs(L.OutputDelay(:)-od(:))>1e3*eps*od(:)),
      error('Output delays must be integers for discrete-time models.')
   end
   L.OutputDelay = od;
end

% Check OutputDelay dimensions 
sod = size(L.OutputDelay);
if ~isequal(sod(1:2),[Ny 1]),
   error('Length of OutputDelay vector does not match number of outputs.')
elseif length(sod)>2 & ~isequal(sod(3:end),sizes(3:end)),
   error('OutputDelay data is not properly dimensioned.')
end

% Keep only one copy if DelayMat is the same for all models
L.OutputDelay = tdcheck(L.OutputDelay);






