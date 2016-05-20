function indices = matchfreqs(freqs,w)
%MATCHFREQS  Find nearest matches in FRD frequency vector.
%
%   INDICES = MATCHFREQS(FREQS,W) finds the frequency points 
%   in FREQS nearest to the specified frequencies W.  The  
%   matching frequencies are returned as FREQS(INDICES).  
%
%   Note: 
%     * FREQS and W must be expressed in compatible units
%     * FREQS must be sorted in increasing order
%     * Used by FREQRESP and BODERESP.   

%   Author: S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/08/25 22:08:27 $

reltol = 1e3*eps;

% Use nearest neighbor match
indices = closestfreqs(freqs,w);

% Specified frequencies SUBFREQS should be a subset of FREQS
if any(abs(freqs(indices)-w)>reltol*(1+w)),
   error('Specified frequencies W must be a subset of FRD frequency points.')
end
