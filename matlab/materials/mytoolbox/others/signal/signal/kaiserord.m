function [N, Wn, beta, typ] = kaiserord(fcuts, mags, devs, fsamp, cellflag)
%KAISERORD FIR order estimator (lowpass, highpass, bandpass, multiband).
%   [N,Wn,BETA,TYPE] = KAISERORD(F,A,DEV,Fs) is the approximate order N, 
%   normalized frequency band edges Wn, Kaiser window parameter BETA and filter
%   type TYPE to be used by the FIR1 function:
%      B = FIR1(N, Wn, TYPE, kaiser( N+1,BETA ), 'noscale' )
%   The resulting filter will approximately meet the specifications given
%   by the input parameters F, A, and DEV.
%   F is a vector of cutoff frequencies in Hz, in ascending order between 0 and 
%   half the sampling frequency Fs.  A is a vector of 0s and 1s specifying the 
%   desired function's amplitude on the bands defined by F. The length of F is 
%   twice the length of A, minus 2 (it must therefore be even).  The first 
%   frequency band is assumed to start at zero, and the last one always ends 
%   at Fs/2.
%   DEV is a vector of maximum deviations or ripples allowable for each band. 
%   Fs is the sampling frequency (which defaults to 2 if you leave it off).
%
%   C = KAISERORD(F,A,DEV,Fs,'cell') is a cell-array whose elements are the
%   parameters to FIR1.
%
%   EXAMPLE
%      Design a lowpass filter with a passband cutoff of 1500Hz, a 
%      stopband cutoff of 2000Hz, passband ripple of 0.01, stopband ripple 
%      of 0.1, and a sampling frequency of 8000Hz:
%
%      [n,Wn,beta,typ] = kaiserord( [1500 2000], [1 0], [0.01 0.1], 8000 );
%      b = fir1(n, Wn, typ, kaiser(n+1,beta), 'noscale');
%   
%      This is equivalent to
%      c = kaiserord( [1500 2000], [1 0], [0.01 0.1], 8000, 'cell' );
%      b = fir1(c{:});
%
%   CAUTION 1: The order N is just an estimate. If the filter does not
%   meet the original specifications, a higher order such as N+1, N+2, etc. 
%   will; if the filter exceeds the specs, a slightly lower order one may work.
%   CAUTION 2: Results are inaccurate if cutoff frequencies are near zero
%   frequency or the Nyquist frequency; or if the devs are large (10%).
%
%   See also FIR1, KAISER, REMEZORD.

%   Author(s): J. H. McClellan, 10-28-91
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:43:05 $

%   References:
%  [1] J.F. Kaiser, ``Nonrecursive Digital Filter Design Using
%       the I_o-sinh Window Function,'' Proc. 1974 IEEE
%       Symp. Circuits and Syst., April 1974, pp. 20--23.
%  [2] IEEE, Digital Signal Processing II, IEEE Press, New York:
%      John Wiley & Sons, 1975, pp. 123--126.

error(nargchk(3,5,nargin))
if nargin == 3,
    fsamp = 2;
end

fcuts = fcuts/fsamp;       %  NORMALIZE to sampling frequency

% Turn vectors into column vectors
fcuts = fcuts(:);
mags = mags(:);
devs = devs(:);

mf = size(fcuts,1);
nbands = size(mags,1);

if size(mags,1) ~= size(devs,1)
    error('Requires M and DEV to be the same length.')
end
if( min(abs(mags)) )
   error('Stopbands must be zero.')
end
dmags = abs(diff(mags));
if( any(dmags~=dmags(1)) )
    error('All passbands must have same height.')
end
if( any(diff(fcuts)<0) )
    error('Bandedges must be strictly increasing.')
end


if mf ~= 2*(nbands-1)
    error('Length of F must be 2*length(M)-2.')
end

zz = mags==0;             % find stopbands
devs = devs./(zz+mags);   % divide delta by mag to get relative deviation

% Determine the smallest width transition zone
% Separate the passband and stopband edges
%
f1 = fcuts(1:2:(mf-1));
f2 = fcuts(2:2:mf);
[df,n] = min(f2-f1);

%=== LOWPASS case: Use formula (ref: Herrmann, Rabiner, Chan)
%
if( nbands==2 )
     [L,beta] = kaislpord( f1(n), f2(n), devs(1), devs(2));

%=== BANDPASS case:
%    - try different lowpasses and take the WORST one that
%        goes thru the BP specs; try both transition widths
%    - will also do the bandreject case
%    - does the multi-band case, one bandpass at a time.
%    
else
  L = 0;  beta = 0;
  for i=2:nbands-1,
    [L1,beta1] = kaislpord( f1(i-1), f2(i-1), devs(i),   devs(i-1) );
    [L2,beta2] = kaislpord( f1(i),   f2(i),   devs(i),   devs(i+1) );
    if( L1>L )
        beta = beta1;  L = L1;   end
    if( L2>L )
        beta = beta2;  L = L2;   end
  end
end

N = ceil( L ) - 1;   % need order, not length, for Filter design

%=== Make the MATLAB compatible specs for FIR1
%
Wn = 2*(f1+f2)/2;    %-- use mid-frequency; multiply by 2 for MATLAB
typ = '';
if( nbands==2 & mags(1)==0 )
  typ='high';
elseif( nbands==3 & mags(2)==0 )
  typ='stop';
elseif( nbands>=3 & mags(1)==0 )  
  typ='DC-0';                    
elseif( nbands>=3 & mags(1)==1 ) 
  typ='DC-1';                   
end

if nargout == 1 & nargin == 5
  N = {N, Wn, typ, kaiser(N+1,beta), 'noscale'};
end

%%%% ---- end of kaiserord

function [L,beta] = kaislpord(freq1, freq2, delta1, delta2 )
%KAISLPORD FIR lowpass filter Length estimator
%
%   [L,beta] = kaislpord(freq1, freq2, dev1, dev2)
%
%   input:
%     freq1: passband cutoff freq (NORMALIZED)
%     freq2: stopband cutoff freq (NORMALIZED)
%      dev1: passband ripple (DESIRED)
%      dev2: stopband attenuation (not in dB)
%
%   outputs:
%      L = filter Length (# of samples)   **NOT the order N, which is N = L-1
%   beta =  parameter for the Kaiser window
%
%   NOTE: Will also work for highpass filters (i.e., f1 > f2)
% 	      Will not work well if transition zone is near f = 0, or
%         near f = fs/2

%
% 	Author(s): J. H. McClellan, 8-28-95
	
%   References:
%     [1] Rabiner & Gold, Theory and Applications of DSP, pp. 156-7.     

delta = min( [delta1,delta2] );
atten = -20*log10( delta );
D = (atten - 7.95)/(2*pi*2.285);   %--- 7.95 was in Kaiser's original paper
%
df = abs(freq2 - freq1);
%
L = D/df + 1;
%
beta = 0.1102*(atten-8.7).*(atten>50) + ...
  (0.5842*(atten-21).^0.4 + 0.07886*(atten-21)).*(atten>=21 & atten<=50);
