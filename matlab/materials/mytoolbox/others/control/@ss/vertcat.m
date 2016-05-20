function sys = vertcat(varargin)
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
%   See also HORZCAT, STACK, LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.12 $  $Date: 1998/09/18 17:55:32 $

% Effect on other properties: Userdata and Notes are deleted

% Delete all 0x0 empty models
% RE: needed for [[] , sys]
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
   sys = ss;  return
end

% Initialize output SYS to first input system
sys = ss(varargin{1});
A = sys.a;   B = sys.b;  
C = sys.c;   D = sys.d;
E = sys.e;
sflag = isstatic(sys);  % 1 if SYS is a static gain

% Concatenate remaining input systems
for j=2:nsys,
   sysj = ss(varargin{j});
   
   % Check dimension compatibility
   sizes = size(D);
   sj = size(sysj.d);
   if sj(2)~=sizes(2),
      error('In [SYS1 ; SYS2], SYS1 and SYS2 must have the same number of inputs')
   elseif length(sj)>2 & length(sizes)>2 & ~isequal(sj(3:end),sizes(3:end)),
      error('In [SYS1 ; SYS2], arrays SYS1 and SYS2 must have compatible dimensions.')
   end
   
   % LTI property management   
   sfj = isstatic(sysj);
   if sflag | sfj,
      % Adjust sample time of static gains to prevent clashes
      % RE: static gains are regarded as sample-time free
      [sys.lti,sysj.lti] = sgcheck(sys.lti,sysj.lti,[sflag sfj]);
   end
   sflag = sflag & sfj;
   try
      sys.lti = [sys.lti ; sysj.lti];
   catch
      error(lasterr)
   end
   
   % Perfom concatenation
   [E,e] = ematchk(E,size(A,1),sysj.e,size(sysj.a,1));
   [A,B,C,D,E,sys.Nx] = ...
      ssops('vcat',A,B,C,D,E,sys.Nx,sysj.a,sysj.b,sysj.c,sysj.d,e,sysj.Nx);
   sys.StateName = [sys.StateName ; sysj.StateName];
end


% Create result
sys.a = A;
sys.b = B;
sys.c = C;
sys.d = D;
sys.e = ematchk(E,sys.Nx);

% Post processing
sys = xclip(sys);
if length(sys.Nx)>1,
   % Discard state names if uneven number of states
   sys.StateName(:) = {''};
end

% If result has I/O delays, minimize number of I/O delays and of 
% input vs output delays
% Note: state time shift is immaterial in the presence of I/O delays
sys.lti = mindelay(sys.lti);

