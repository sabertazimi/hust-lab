function h = freqresp(sys,w)
%FREQRESP  Frequency response of LTI models.
%
%   H = FREQRESP(SYS,W) computes the frequency response H of the 
%   LTI model SYS at the frequencies specified by the vector W.
%   These frequencies should be real and in radians/second.  
%
%   If SYS has NY outputs and NU inputs, and W contains NW frequencies, 
%   the output H is a NY-by-NU-by-NW array such that H(:,:,k) gives 
%   the response at the frequency W(k).
%
%   If SYS is a S1-by-...-Sp array of LTI models with NY outputs and 
%   NU inputs, then SIZE(H)=[NY NU NW S1 ... Sp] where NW=LENGTH(W).
%
%   See also EVALFR, BODE, SIGMA, NYQUIST, NICHOLS, LTIMODELS.

%	 Clay M. Thompson 7-10-90
%   Revised: AFP 9-10-95, P.Gahinet 5-2-96
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.21 $  $Date: 1998/09/18 17:57:55 $

%       Reference:
%       Alan J. Laub, "Efficient Multivariable Frequency Response Computations,"
%       IEEE TAC, AC-26 (April 1981), 407-8.


error(nargchk(2,2,nargin));
if ~isa(w,'double') | ndims(w)>2 | min(size(w))>1,
   error('W must be a vector of real frequencies.')
end
w = w(:);

% Loop over each model:
sizes = size(sys.d);
h = zeros([sizes(1:2) , length(w) , sizes(3:end)]);

for k=1:prod(sizes(3:end)),
   h(:,:,:,k) = fr2d(subsref(sys,substruct('()',{':' ':' k})),w);
end


%%%%%%%%%%%%%% Local function %%%%%%%%%%%%%%%%%%%%%%%%

%FR2D  Frequency response of single model
function h = fr2d(sys,w)

% Note: Performs balancing, descriptor systems allowed
[a,b,c,d,e,Ts] = dssdata(ssbal(sys));
[ny,nu] = size(d);
nx = size(a,1);
dess = ~isequal(e,eye(nx));

% Form vector s of complex frequencies
if Ts==0,
   % Watch for case where W contains complex frequencies (old syntax)
   if isreal(w),
      w = sqrt(-1)*w;
   end
   s = w;
elseif isreal(w),
   % Discrete with real freqs
   w = sqrt(-1)*w*abs(Ts);
   s = exp(w);  % z = exp(j*w*Ts)
else
   % Discrete with complex frequencies (old syntax)
   s = w;
   w = log(s);
end

% Compute I/O delay contribution
Td = totaldelay(sys);
isdelayed = any(Td(:));
if isdelayed,
   hTd = delayfr(Td,w);
end

% Quick exit if empty system or static gain
if ny*nu==0,
   h = zeros(ny,nu,length(w));  
   return
elseif nx==0,
   h = d(:,:,ones(1,length(w)));
   if isdelayed,
      h = hTd .* h;
   end
   return
end

% Compute the frequency response over grid W
lw = length(w);
lwOnes = ones(1,lw);
h = zeros(ny,nu,lw);

if dess,
   % Descriptor system: use QZ form for fast computation of (s*E-A)\B
   [a,e,q,z] = qz(a,e);
   b = q*b;   c = c*z;
   for i=1:lw,
      h(:,:,i) = c*((s(i)*e-a)\b);
   end

else
   % Assess if diagonal form is numerically stable
   [Va,Da] = eig(a);

   if norm(a*Va-Va*Da,1)<sqrt(eps)*(1+norm(a,1)) & rcond(Va)>sqrt(eps),      
      % A is accurately diagonalized with relatively well-conditioned Va
      % RE: with multiple poles, Va may look well conditioned but fail
      %     to accurately determine the eigenvectors
      poles = diag(Da); 
      b = Va\b;   c = c*Va;
      s = reshape(s,1,lw);
      s = s(ones(nx,1),:) - poles(:,lwOnes);

      wng = warning;
      if any(s(:)==0),
        warning('Singularity in freq. response due to jw-axis or unit circle pole.')
        warning off
      end

      s = 1./s;
      for i=1:nu,
         biu = b(:,i);
         h(:,i,:) = c*(s.*biu(:,lwOnes));
      end

      warning(wng)

   else
      % Diagonal form is unstable: use numerically stable Hessenberg form
      [p,a] = hess(a);
      b = p'*b;   c = c*p;

      % Use LTIFR to evaluate frequency response
      wng = warning;
      warning off
      
      for i=1:nu,
         h(:,i,:) = c * ltifr(a,b(:,i),s);
      end
      
      warning(wng)

   end
end


% Add D matrix and delay contributions
h = h + d(:,:,lwOnes);
if isdelayed,
   h = hTd .* h;
end

