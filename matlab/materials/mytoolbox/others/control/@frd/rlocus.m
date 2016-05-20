function [rout,kout] = rlocus(sys,k)
%RLOCUS  Evans root locus.
%
%   RLOCUS(SYS) computes and plots the root locus of the single-input,
%   single-output LTI model SYS.  The root locus plot is used to 
%   analyze the negative feedback loop
%
%                     +-----+
%         ---->O----->| SYS |----+---->
%             -|      +-----+    |
%              |                 |
%              |       +---+     |
%              +-------| K |<----+
%                      +---+
%
%   and shows the trajectories of the closed-loop poles when the feedback 
%   gain K varies from 0 to Inf.  RLOCUS automatically generates a set of 
%   positive gain values that produce a smooth plot.  
%
%   RLOCUS(SYS,K) uses a user-specified vector K of gains.
%
%   [R,K] = RLOCUS(SYS) or R = RLOCUS(SYS,K) returns the matrix R
%   of complex root locations for the gains K.  R has LENGTH(K) columns
%   and its j-th column lists the closed-loop roots for the gain K(j).  
%
%   See also RLTOOL, RLOCFIND, POLE, ISSISO, LTIMODELS.

%   Author(s): S. Almy
%	 Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.1 $  $Date: 1998/07/16 20:50:22 $

error('RLOCUS is not supported for FRD models.')
