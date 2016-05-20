function W = gram(sys,type)
%GRAM  Controllability and observability gramians.
%
%   Wc = GRAM(SYS,'c') computes the controllability gramian of 
%   the state-space model SYS.  
%
%   Wo = GRAM(SYS,'o') computes its observability gramian.
%
%   In both cases, the state-space model SYS should be stable.
%   The gramians are computed by solving the Lyapunov equations:
%
%     *  A*Wc + Wc*A' + BB' = 0  and   A'*Wo + Wo*A + C'C = 0 
%        for continuous-time systems        
%               dx/dt = A x + B u  ,   y = C x + D u
%
%     *  A*Wc*A' - Wc + BB' = 0  and   A'*Wo*A - Wo + C'C = 0 
%        for discrete-time systems   
%           x[n+1] = A x[n] + B u[n] ,  y[n] = C x[n] + D u[n].
%
%   For ND arrays of LTI models SYS, Wc and Wo are arrays with N+2 
%   dimensions such that 
%      Wc(:,:,j1,...,jN) = GRAM(SYS(:,:,j1,...,jN),'c') .  
%      Wo(:,:,j1,...,jN) = GRAM(SYS(:,:,j1,...,jN),'o') .  
%
%   See also SS, BALREAL, CTRB, OBSV.

%   J.N. Little 3-6-86
%   P. Gahinet  6-27-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/10/01 20:12:33 $

%   Laub, A., "Computation of Balancing Transformations", Proc. JACC
%     Vol.1, paper FA8-E, 1980.

if nargin~=2,
   error('GRAM requires two input arguments.')
elseif ~isa(sys,'ss'),
   error('SYS must be a state-space model.')
elseif ~isstr(type),
   error('Second input must be either ''c'' or ''o''.');
end

% Extract data
try
   [a,b,c,d] = ssdata(sys);
catch
   error('Not applicable to arrays of models with variable number of states.')
end
sizes = size(d);
Nx = size(a,1);
W = zeros([Nx Nx sizes(3:end)]);

% Handle various cases
if sys.Ts==0,
   % Continuous system
   for k=1:prod(sizes(3:end)),
      ak = a(:,:,k);
      if max(real(eig(ak)))>=0,
         error('System SYS must be stable.')
      end
      
      switch lower(type(1))
      case 'c'
         W(:,:,k) = lyap(ak,b(:,:,k)*b(:,:,k)');
      case 'o'
         W(:,:,k) = lyap(ak',c(:,:,k)'*c(:,:,k));
      otherwise
         error('Second input must be either ''c'' or ''o''.');
      end
   end
   

else
  % Discrete system
  for k=1:prod(sizes(3:end)),
     ak = a(:,:,k);
     if max(abs(eig(ak)))>=1,
        error('System SYS must be stable.')
     end
     
     switch lower(type(1))
     case 'c'
        W(:,:,k) = dlyap(ak,b(:,:,k)*b(:,:,k)');
     case 'o'
        W(:,:,k) = dlyap(ak',c(:,:,k)'*c(:,:,k));
     otherwise
        error('Second input must be either ''c'' or ''o''.');
     end
  end
  
end

