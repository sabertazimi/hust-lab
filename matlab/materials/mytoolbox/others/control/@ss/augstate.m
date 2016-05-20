function sys = augstate(sys)
%AUGSTATE  Appends states to the outputs of a state-space model.
%
%   ASYS = AUGSTATE(SYS)  appends the states to the outputs of 
%   the state-space model SYS.  The resulting model is:
%      .                       .
%      x  = A x + B u   (or  E x = A x + B u for descriptor SS)
%
%     |y| = [C] x + [D] u
%     |x|   [I]     [0]
%
%   This command is useful to close the loop on a full-state
%   feedback gain  u = Kx.  After preparing the plant with
%   AUGSTATE,  you can use the FEEDBACK command to derive the 
%   closed-loop model.
%
%   See also FEEDBACK, SS, LTIMODELS.

%       Author(s): A. Potvin, 12-1-95
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.9 $  $Date: 1998/05/05 14:07:44 $

error(nargchk(1,1,nargin))
if length(sys.Nx)>1,
   error('Only applicable to model arrays with uniform number of states.') 
end

nx = size(sys.a,1);
nu = size(sys.d,2);
sys.c = [sys.c ; eye(nx)];
sys.d = [sys.d ; zeros(nx,nu)];

% Update Output Names
sys.lti = augstate(sys.lti,sys.StateName);


