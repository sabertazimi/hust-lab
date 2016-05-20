function sys = dss(varargin)
%DSS  Create descriptor state-space (DSS) models
%          .
%        E x = A x + B u            E x[n+1] = A x[n] + B u[n]
%                             or 
%          y = C x + D u                y[n] = C x[n] + D u[n]  
%         
%   SYS = DSS(A,B,C,D,E) creates a continuous-time DSS model SYS
%   with matrices A,B,C,D,E.  The output SYS is a SS object.  You 
%   can set D=0 to mean the zero matrix of appropriate dimensions.
%
%   SYS = DSS(A,B,C,D,E,Ts) creates a discrete-time DSS model with 
%   sample time Ts (set Ts=-1 if the sample time is undetermined).
%
%   In both syntax, the input list can be followed by pairs
%      'PropertyName1', PropertyValue1, ...
%   that set the various properties of SS models (see LTIPROPS for 
%   details).  To make SYS inherit all its LTI properties from an  
%   existing LTI model REFSYS, use the syntax 
%      SYS = DSS(A,B,C,D,E,REFSYS).
%
%   You can create arrays of DSS models by using ND arrays for 
%   A,B,C,D,E.  See help for SS for more details.
%
%   See also SS, DSSDATA.

%   Author(s): P. Gahinet, 4-1-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.8.1.2 $  $Date: 1999/01/05 12:08:41 $


ni = nargin;

% Dissect input list
DoubleInputs = 0;
while DoubleInputs < ni,
  if isa(varargin{DoubleInputs+1},'double'),
     DoubleInputs = DoubleInputs+1;
  else
     break;
  end
end

% error check
if DoubleInputs<5,
  error('All five A,B,C,D,E matrices must be specified.');
elseif DoubleInputs>6,
  error('Two many numerical inputs.')
else
  a = varargin{1};
  e = varargin{5};
  sys = ss(varargin{1:4},varargin{6:ni},'e',e);
end

