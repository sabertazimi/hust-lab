function g = dcgain(sys)
%DCGAIN  DC gain of LTI models.
%
%   K = DCGAIN(SYS) computes the steady-state (D.C. or low frequency)
%   gain of the LTI model SYS.
%
%   If SYS is an array of LTI models with dimensions [NY NU S1 ... Sp],
%   DCGAIN returns an array K with the same dimensions such that
%      K(:,:,j1,...,jp) = DCGAIN(SYS(:,:,j1,...,jp)) .  
%
%   See also NORM, EVALFR, FREQRESP, LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.8 $  $Date: 1998/03/16 21:13:20 $


tol = sqrt(eps);
[num,den,Ts] = tfdata(sys);
sizes = size(num);
g = zeros(sizes);

if Ts==0,
   % Continuous-time: evaluate at s = 0
   for i=1:prod(sizes),
      d = den{i};
      ld = length(d);
      if d(ld),
         g(i) = num{i}(end)/d(ld);
      else
         % s = 0 is a pole: look for 1/0 and 0/0
         ind = find(d);
         mult = ld - ind(end);
         n = num{i};
         ln = length(n);
         if any(n(1+ln-min(ln,mult):ln)),
            g(i) = Inf;
         elseif ln<=mult            
            g(i) = 0;
         else
            g(i) = n(ln-mult)/d(ld-mult);
         end
      end
   end  % end for

else
   % Discrete-time: evaluate at z = 1
   for i=1:prod(sizes),
      n = num{i};    
      d = den{i};
      while all(abs(sum(n))<tol*max(abs(n))) & ...
            all(abs(sum(d))<tol*max(abs(d))),
         % z=1 is a root of both N and D: simplify it
         n = fliplr(filter(-1,[1 -1],fliplr(n(2:end))));
         d = fliplr(filter(-1,[1 -1],fliplr(d(2:end))));
      end
      sn = sum(n);   sd = sum(d);
      if abs(sn)<=tol*max(abs(n)),
         g(i) = 0;
      elseif abs(sd)<=tol*max(abs(d)),
         g(i) = Inf;
      else
         g(i) = sn/sd;
      end
   end

end


% end @tf/dcgain
