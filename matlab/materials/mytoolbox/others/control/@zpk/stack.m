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
%   $Revision: 1.2 $  $Date: 1998/06/19 20:20:20 $


% Offset by the two I/O dimensions
if ~isa(arraydim,'double') | ~isequal(size(arraydim),[1 1]) | arraydim<=0,
   error('First argument DIM must be a positive integer.')
end
catdim = arraydim+2;

% Initialize output SYS to first input system
sys = zpk(varargin{1});
z = sys.z;
p = sys.p;
k = sys.k;
var = sys.Variable;
sflag = isstatic(sys);  % 1 if SYS is a static gain
slti = sys.lti;

% Concatenate remaining input systems
for j=2:length(varargin),
   sysj = zpk(varargin{j});
   
   % Pad with unit sizes up to dimension DIM
   sizes = size(k);
   sizes = [sizes , ones(1,catdim-length(sizes))];
   sj = size(sysj.k);
   sj = [sj , ones(1,catdim-length(sj))];
   
   % Check consitency
   sizes(catdim) = [];    sj(catdim) = [];
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
      [slti,sysj.lti] = sgcheck(slti,sysj.lti,[sflag sfj]);
   end
   sflag = sflag & sfj;
   slti = stack(arraydim,slti,sysj.lti,size(k),size(sysj.k));
   
   % Perfom concatenation
   z = cat(catdim,z,sysj.z);
   p = cat(catdim,p,sysj.p);
   k = cat(catdim,k,sysj.k);
   var = varpick(var,sysj.Variable,getst(slti));
end

% Create result
sys.p = p;
sys.z = z;
sys.k = k;
sys.Variable = var;
sys.lti = slti;
