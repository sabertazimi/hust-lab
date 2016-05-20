function fresp = evalfr(sys,s)
%EVALFR  Evaluate frequency response at a single (complex) frequency.
%
%   FRESP = EVALFR(SYS,X) evaluates the transfer function of the 
%   continuous- or discrete-time LTI model SYS at the complex 
%   number S=X or Z=X.  For state-space models, the result is
%                                   -1
%       FRESP =  D + C * (X * E - A)  * B   .
%
%   EVALFR is a simplified version of FREQRESP meant for quick 
%   evaluation of the response at a single point.  Use FREQRESP 
%   to compute the frequency response over a grid of frequencies.
%
%   See also FREQRESP, BODE, SIGMA, LTIMODELS.

%   Author(s): S. Almy
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.1 $  $Date: 1998/08/26 16:42:28 $

error(sprintf('%s\n%s','EVALFR is not supported for FRD models.', ...
   'Use FREQRESP instead.'));
