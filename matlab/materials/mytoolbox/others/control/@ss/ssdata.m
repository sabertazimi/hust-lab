function [a,b,c,d,Ts,Td] = ssdata(sys,cellflag)
%SSDATA  Quick access to state-space data.
%
%   [A,B,C,D] = SSDATA(SYS) retrieves the matrix data A,B,C,D
%   for the state-space model SYS.  If SYS is not a state-space 
%   model, it is first converted to the state-space representation.
%
%   [A,B,C,D,TS] = SSDATA(SYS) also returns the sample time TS.
%   Other properties of SYS can be accessed with GET or by direct 
%   structure-like referencing (e.g., SYS.Ts).
%
%   For arrays of LTI models with the same order (number of states),
%   A,B,C,D are multi-dimensional arrays where A(:,:,k), B(:,:,k), 
%   C(:,:,k), D(:,:,k) give the state-space matrices of the 
%   k-th model SYS(:,:,k).
%
%   For arrays of LTI models with variable order, use the syntax
%      [A,B,C,D] = SSDATA(SYS,'cell')
%   to return the variable-size A,B,C matrices into cell arrays. 
%
%   See also SS, GET, DSSDATA, TFDATA, ZPKDATA, LTIMODELS, LTIPROPS.

%   Author(s): P. Gahinet, 4-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.12 $

% Factor in the E matrix
sizes = size(sys.d);
if ~isempty(sys.e),
   for i=1:prod(sizes(3:end)),
      nx = sys.Nx(min(i,end));
      [l,u,p] = lu(sys.e(1:nx,1:nx,i));
      sys.a(1:nx,1:nx,i) = u\(l\(p*sys.a(1:nx,1:nx,i)));  % a = e\a
      sys.b(1:nx,:,i) = u\(l\(p*sys.b(1:nx,:,i)));        % b = e\b
   end
end

% Build A,B,C,D outputs
d = sys.d;
if nargin>1,
   % Return A,B,C as cell arrays
   if ~ischar(cellflag),
      error('Second input argument must be the string ''cell''.')
   end
   a = cell([sizes(3:end) 1 1]);
   b = cell([sizes(3:end) 1 1]);
   c = cell([sizes(3:end) 1 1]);
   for i=1:prod(sizes(3:end)),
      nx = sys.Nx(min(i,end));
      a{i} = sys.a(1:nx,1:nx,i);
      b{i} = sys.b(1:nx,:,i);
      c{i} = sys.c(:,1:nx,i);
   end
elseif length(sys.Nx)>1,
   % Can't represent A,B,C as ND arrays
   error('Use [A,B,C,D] = ssdata(sys,''cell'') for arrays of LTI models with variable order.')
else
   % Extract A,B,C data
   a = sys.a;
   b = sys.b;
   c = sys.c;
end


% Sample time
Ts = getst(sys.lti);

% Obsolete TD output
if nargout>5,
   warning('Obsolete syntax. Use the property InputDelay to access input delays.')
   Td = get(sys.lti,'InputDelay')';
end

