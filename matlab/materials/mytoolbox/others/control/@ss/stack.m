function sys = stack(arraydim,varargin)
%STACK  Stack LTI models into LTI array.
%
%   SYS = STACK(ARRAYDIM,SYS1,SYS2,...) produces an array of LTI
%   models SYS by stacking the LTI models SYS1,SYS2,... along
%   the array dimension ARRAYDIM.  All models must have the same 
%   number of inputs and outputs, and the I/O dimensions are not
%   counted as array dimensions.
%
%   For example, if SYS1 and SYS2 are two LTI models with the 
%   same I/O dimensions,
%     * STACK(1,SYS1,SYS2) produces a 2-by-1 LTI array
%     * STACK(2,SYS1,SYS2) produces a 1-by-2 LTI array
%     * STACK(3,SYS1,SYS2) produces a 1-by-1-by-2 LTI array.
%
%   You can also use STACK to concatenate LTI arrays SYS1,SYS2,...
%   along some array dimension ARRAYDIM.
%
%   See also HORZCAT, VERTCAT, APPEND, LTIMODELS.

%   Author(s): P. Gahinet, 1-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/06/19 20:20:19 $


% Offset by the two I/O dimensions
if ~isa(arraydim,'double') | ~isequal(size(arraydim),[1 1]) | arraydim<=0,
   error('First argument DIM must be a positive integer.')
end
catdim = arraydim+2;

% Initialize output SYS to first input system
sys = ss(varargin{1});
Nx = nxarray(sys);
sflag = isstatic(sys);  % 1 if SYS is a static gain

% Concatenate remaining input systems
for j=2:length(varargin),
   sysj = ss(varargin{j});
   
   % Pad with unit sizes up to dimension DIM
   sizes = size(sys.d);
   sizes = [sizes , ones(1,catdim-length(sizes))];
   sj = size(sysj.d);
   sj = [sj , ones(1,catdim-length(sj))];
   
   % Check consistency
   sizes(catdim) = [];    
   sj(catdim) = [];
   if ~isequal(sizes(1:2),sj(1:2)),
      error('I/O dimension mismatch.')
   elseif ~isequal(sizes(3:end),sj(3:end)),
      error(sprintf('Array sizes can only differ along dimension #%d.',arraydim))
   end
   
   % LTI property management   
   sfj = isstatic(sysj);
   if sflag | sfj,
      % Adjust sample time of static gains to prevent clashes
      % RE: static gains are regarded as sample-time free
      [sys.lti,sysj.lti] = sgcheck(sys.lti,sysj.lti,[sflag sfj]);
   end
   sflag = sflag & sfj;
   sys.lti = stack(arraydim,sys.lti,sysj.lti,size(sys.d),size(sysj.d));
   
   % Align the number of states
   [sys.e,sysj.e] = ematchk(sys.e,size(sys.a,1),sysj.e,size(sysj.a,1));
   Nx = cat(arraydim,Nx,nxarray(sysj));
   Nxmax = max(Nx(:));
   if Nxmax>size(sys.a,1),
      sys = xpad(sys,Nxmax);
   end
   if Nxmax>size(sysj.a,1),
      sysj = xpad(sysj,Nxmax);
   end
   
   % Perfom concatenation
   sys.a = cat(catdim,sys.a,sysj.a);
   sys.b = cat(catdim,sys.b,sysj.b);
   sys.c = cat(catdim,sys.c,sysj.c);
   sys.d = cat(catdim,sys.d,sysj.d);
   sys.e = cat(catdim,sys.e,sysj.e);  
   
   % Merge state names
   sys.StateName = xmerge(sys.StateName,sysj.StateName);
end

% Exit checks
sys.e = ematchk(sys.e,Nx);
sys.Nx = nxcheck(Nx);
if length(sys.Nx)>1,
   % Uneven number of states: delete state names
   sys.StateName(:) = {''};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sys = xpad(sys,nxmax)

Ones = num2cell(ones(1,ndims(sys.d)-2));
sys.a(nxmax,nxmax,Ones{:}) = 0;
sys.b(nxmax,end,Ones{:}) = 0;
sys.c(end,nxmax,Ones{:}) = 0;
sys.StateName(end+1:nxmax,1) = {''};

if ~isempty(sys.e),
   sys.e(nxmax,nxmax,Ones{:}) = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Xname = xmerge(Xname1,Xname2)

if isequal(Xname1,Xname2) | all(strcmp(Xname2,'')),
   Xname = Xname1;
elseif all(strcmp(Xname1,'')),
   Xname = Xname2;
else
   % Clash: delete state names
   Xname = Xname1;
   Xname(:) = {''};
end
