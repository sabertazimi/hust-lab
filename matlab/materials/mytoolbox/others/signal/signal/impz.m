function [h,t]=impz(b,a,N,Fs)
%IMPZ Impulse response of digital filter
%   [H,T] = IMPZ(B,A) computes the impulse response of the filter B/A 
%   choosing the number of samples for you, and returns the response in 
%   column vector H and a vector of times (or sample intervals) in T 
%   (T = [0 1 2 ...]').
%
%   [H,T] = IMPZ(B,A,N) computes N samples of the impulse response.
%   If N is a vector of integers, the impulse response is computed
%   only at those integer values (0 is the origin).
%
%   [H,T] = IMPZ(B,A,N,Fs) computes N samples and scales T so that
%   samples are spaced 1/Fs units apart.  Fs is 1 by default.
%
%   [H,T] = IMPZ(B,A,[],Fs) chooses the number of samples for you and scales
%   T so that samples are spaced 1/Fs units apart.
%
%   IMPZ with no output arguments plots the impulse response using
%   STEM(T,H) in the current figure window.
%
%   See also IMPULSE in the Controls Toolbox for continuous systems.

%   Author(s): T. Krauss, 7-27-93
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:58 $

error(nargchk(1,4,nargin))

if nargin<2
    a = 1; 
end
if nargin<4
    Fs = 1;
end
M = 0;  NN = [];
if nargin<=4
    if nargin<3, N=[]; end
    if isempty(N)       % pick length
        if length(a)==1     % FIR case
            N = length(b);
        else
            bb = b; delay = 0;
            while bb(1)==0, bb(1)=[]; delay = delay + 1; end
            p = roots(a);
            if any(abs(p)>1.0001)
                ind = find(abs(p)>1);
                N = 6/log10(max(abs(p(ind))));% 1000000 times original amplitude
            else
                %minimum height is .00005 original amplitude:
                mh = .00005;
                ind = find(abs(p-1)<1e-5);
                p(ind) = -p(ind);    % treat constant as Nyquist
                ind = find(abs(abs(p)-1)<1e-5);       
                periods = 5*max(2*pi./abs(angle(p(ind)))); % five periods
                p(ind) = [];   % get rid of unit circle poles
                [maxp,maxind] = max(abs(p));
                if isempty(p)   % pure oscillator
                    N = periods;
                elseif isempty(ind)   % no oscillation
                    N = mltplcty(p,maxind)*log10(mh)/log10(maxp) + delay;
                else    % some of both
                    N = max(periods, ...
                        mltplcty(p,maxind)*log10(mh)/log10(maxp) ) + delay;
                end
            end
            N = max(length(a)+length(b)-1,N);
        end
    elseif length(N)>1    % vector of indices
        NN = round(N);
        N = max(NN)+1;
        M = min(min(NN),0);
    end
end

tt = (M:(N-1))';
hh = filter(b,a,tt==0);
if ~isempty(NN),
    hh = hh(NN-M+1);
    tt = tt(NN-M+1);
end
tt = tt/Fs;

if nargout==0
    stem(tt,hh,'filled')
    set(gca,'xlim',[tt(1) tt(length(tt))]);
end
if nargout==1
    h = hh;
end
if nargout==2
    h = hh;  t = tt;
end

function m = mltplcty( p, ind, tol)
%MLTPLCTY  Multiplicity of a pole
%   MLTPLCTY(P,IND,TOL) finds the multiplicity of P(IND) in the vector P
%   with a tolerance of TOL.  TOL defaults to .001.
%
%   Uses MPOLES in the Signal Processing Toolbox.
%
%   Used by IMPZ.

%   Author(s): T. Krauss, 7-27-93

    if nargin<3
        tol = .001;
    end

    [mults,indx]=mpoles(p,tol);

    m = mults(indx(ind));
    for i=indx(ind)+1:length(mults)
        if mults(i)>m
            m = m + 1;
        else
            break;
        end
    end

