function sysd = c2d(sys,Ts,method,varargin)
%C2D  Conversion of continuous-time models to discrete time.
%
%   SYSD = C2D(SYSC,TS,METHOD) converts the continuous-time LTI 
%   model SYSC to a discrete-time model SYSD with sample time TS.  
%   The string METHOD selects the discretization method among the 
%   following:
%      'zoh'       Zero-order hold on the inputs.
%      'foh'       Linear interpolation of inputs (triangle appx.)
%      'tustin'    Bilinear (Tustin) approximation.
%      'prewarp'   Tustin approximation with frequency prewarping.  
%                  The critical frequency Wc is specified as fourth 
%                  input by C2D(SYSC,TS,'prewarp',Wc).
%      'matched'   Matched pole-zero method (for SISO systems only).
%   The default is 'zoh' when METHOD is omitted.
%
%   For state-space models SYS and the 'zoh' or 'foh' methods,
%      [SYSD,G] = C2D(SYSC,TS,METHOD)
%   also returns a matrix G that maps continuous initial conditions
%   into discrete initial conditions.  Specifically, if x0,u0 are
%   initial states and inputs for SYSC, then equivalent initial
%   conditions for SYSD are given by
%      xd0 = G * [x0;u0],     ud0 = u0 .
%
%   See also D2C, D2D, LTIMODELS.

%	Clay M. Thompson  7-19-90, A.Potvin 12-5-95
%       P. Gahinet  7-18-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 1998/08/26 16:42:31 $


error('C2D is not supported for FRD models.')
