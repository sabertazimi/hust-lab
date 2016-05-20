function [a,b,c,d,e,Ts,Td] = dssdata(sys,cellflag)
%DSSDATA  Quick access to descriptor state-space data.
%
%   [A,B,C,D,E] = DSSDATA(SYS) returns the values of the A,B,C,D,E
%   matrices for the descriptor state-space model SYS (see DSS).  
%   DSSDATA is equivalent to SSDATA for regular state-space models
%   (i.e., when E=I).
%
%   [A,B,C,D,E,TS] = DSSDATA(SYS) also returns the sample time TS.
%   Other properties of SYS can be accessed with GET or by direct 
%   structure-like referencing (e.g., SYS.Ts).
%
%   For arrays of LTI models with variable order, use the syntax
%      [A,B,C,D,E] = DSSDATA(SYS,'cell')
%   to return the variable-size A,B,C,E matrices into cell arrays. 
%
%   See also GET, SSDATA, DSS, LTIMODELS, LTIPROPS.

%    Author(s): P. Gahinet, 4-1-96
%    Copyright (c) 1986-98 by The MathWorks, Inc.
%    $Revision: 1.10 $  $Date: 1998/10/01 20:12:32 $

sizes = size(sys.d);
if isempty(sys.e), 
   sys.e = repmat(eye(size(sys.a,1)),[1 1 sizes(3:end)]);
end

% Build A,B,C,D,E outputs
d = sys.d;
if nargin>1,
   % Return A,B,C,E as cell arrays
   a = cell([sizes(3:end) 1 1]);
   b = cell([sizes(3:end) 1 1]);
   c = cell([sizes(3:end) 1 1]);
   e = cell([sizes(3:end) 1 1]);
   for i=1:prod(sizes(3:end)),
      nx = sys.Nx(min(i,end));
      a{i} = sys.a(1:nx,1:nx,i);
      e{i} = sys.e(1:nx,1:nx,i);
      b{i} = sys.b(1:nx,:,i);
      c{i} = sys.c(:,1:nx,i);
   end
elseif length(sys.Nx)>1,
   % Can't represent A,B,C as ND arrays
   error('Use [A,B,C,D,E] = dssdata(sys,''cell'') for arrays of LTI models with variable order.')
else
   % Extract A,B,C data
   a = sys.a;
   b = sys.b;
   c = sys.c;
   e = sys.e;
end

% Sample time
Ts = getst(sys.lti);

% Obsolete TD output
if nargout>6,
   warning('Obsolete syntax. Use the property InputDelay to access input delays.')
   Td = get(sys.lti,'InputDelay')';
end

