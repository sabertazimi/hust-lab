function sys = feedback(sys1,sys2,varargin)
%FEEDBACK  Feedback connection of two LTI models. 
%
%   SYS = FEEDBACK(SYS1,SYS2) computes an LTI model SYS for
%   the closed-loop feedback system
%
%          u --->O---->[ SYS1 ]----+---> y
%                |                 |           y = SYS * u
%                +-----[ SYS2 ]<---+
%
%   Negative feedback is assumed and the resulting system SYS 
%   maps u to y.  To apply positive feedback, use the syntax
%   SYS = FEEDBACK(SYS1,SYS2,+1).
%
%   SYS = FEEDBACK(SYS1,SYS2,FEEDIN,FEEDOUT,SIGN) builds the more
%   general feedback interconnection:
%                      +--------+
%          v --------->|        |--------> z
%                      |  SYS1  |
%          u --->O---->|        |----+---> y
%                |     +--------+    |
%                |                   |
%                +-----[  SYS2  ]<---+
%
%   The vector FEEDIN contains indices into the input vector of SYS1
%   and specifies which inputs u are involved in the feedback loop.
%   Similarly, FEEDOUT specifies which outputs y of SYS1 are used for
%   feedback.  If SIGN=1 then positive feedback is used.  If SIGN=-1 
%   or SIGN is omitted, then negative feedback is used.  In all cases,
%   the resulting LTI model SYS has the same inputs and outputs as SYS1 
%   (with their order preserved).
%
%   If SYS1 and SYS2 are arrays of LTI models, FEEDBACK returns an LTI
%   array SYS of the same dimensions where 
%      SYS(:,:,k) = FEEDBACK(SYS1(:,:,k),SYS2(:,:,k)) .
%
%   See also LFT, PARALLEL, SERIES, CONNECT, LTIMODELS.

%   P. Gahinet  6-26-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/08/26 21:48:32 $

ni = nargin;
error(nargchk(2,5,ni));

% Make sure both arguments are TF
sys1 = tf(sys1);
sys2 = tf(sys2);

% Handle various cases. Use try/catch to keep errors at top level
try
   if issiso(sys1) & issiso(sys2),
      % SISO loop
      % Get SIGN
      switch ni
      case 2
         sign = -1;
      case 3
         sign = varargin{1};
      case 4 
         sign = -1;
      end
      
      % LTI inheritance. 
      sys = sys1;
      sys.lti = feedback(sys1.lti,sys2.lti,[isstatic(sys1) , isstatic(sys2)]);
      
      % Check for time delays
      Ts = getst(sys.lti);
      if hasdelay(sys1) | hasdelay(sys2),
         if Ts, 
            % Discrete-time case: map discrete delays to poles at z=0
            sys1.lti = set(sys1.lti,'ts',Ts);
            sys1 = delay2z(sys1);
            sys2.lti = set(sys2.lti,'ts',Ts);
            sys2 = delay2z(sys2);
         else
            error('FEEDBACK cannot handle time delays.')
         end
      end
      
      % Create output
      for k=1:prod(size(sys.num)),
         sys.num{k} = conv(sys1.num{k},sys2.den{k});
         sys.den{k} = conv(sys1.den{k},sys2.den{k}) - ...
            sign * conv(sys1.num{k},sys2.num{k});
      end
      
   elseif isproper(sys1) & isproper(sys2)
      % MIMO/proper case
      sys = tf(feedback(ss(sys1),ss(sys2),varargin{:}));   
      
   else
      error('FEEDBACK cannot handle improper MIMO transfer functions.')  
   end
   
catch
   error(lasterr)
end


% Variable name 
sys.Variable = varpick(sys1.Variable,sys2.Variable,getst(sys.lti));

