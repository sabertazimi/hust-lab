function indices = closestfreqs(freqs,w)
%CLOSESTFREQS   Find the frequency points in FREQS nearest to the
%               frequencies in W.

%   Author: S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/08/25 22:08:27 $

% Note: Assumes compatible units + FREQS is pre-sorted
%       Adapted from INTERP1

% Compute vector RELIND(K) of relative indices of W(K) in FREQS(K):
%    RELIND(K) := I + RHO  with I integer and 0<=RHO<1 if 
%       W(K) = FREQS(I) + RHO * (FREQS(I+1)-FREQS(I))
[ws,j] = sort(w);
[dum,i] = sort([freqs;ws]);

% First determine integer part of RELIND 
relind(i,1) = (1:length(i))';
relind = relind(length(freqs)+1:end) - (1:length(w))';
relind(j,1) = relind;
relind(relind<1) = 1;
relind(relind>length(freqs)-1) = length(freqs)-1;

% Add fractional part
relind = relind + (w-freqs(relind))./(freqs(relind+1)-freqs(relind));

% INDICES is round(RELIND)
indices = round(relind);

