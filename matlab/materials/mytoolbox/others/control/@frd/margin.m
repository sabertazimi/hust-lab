function [Gmout,Pm,Wcg,Wcp] = margin(sys)
%MARGIN  Gain and phase margins and crossover frequencies.
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(SYS) computes the gain margin Gm, the
%   phase margin Pm in degrees, and the associated frequencies 
%   Wcg and Wcp, for a SISO open-loop LTI model SYS (continuous or 
%   discrete).  The gain margin Gm is defined as 1/G where G is 
%   the gain at the -180 phase crossing.  The gain margin in dB 
%   is 20*log10(Gm).  By convention, Gm=1 (0 dB) and Pm=0 when 
%   the nominal closed loop is unstable.
%
%   [Gm,Pm,Wcg,Wcp] = MARGIN(MAG,PHASE,W) derives the gain and phase
%   margins from the Bode magnitude, phase, and frequency vectors 
%   MAG, PHASE, and W produced by BODE.  Interpolation is performed 
%   between the frequency points to estimate the values. 
%
%   For a S1-by...-by-Sp array SYS of LTI models, MARGIN returns 
%   arrays of size [S1 ... Sp] such that
%      [Gm(j1,...,jp),Pm(j1,...,jp)] = MARGIN(SYS(:,:,j1,...,jp)) .  
%
%   When invoked without left hand arguments, MARGIN(SYS) plots
%   the open-loop Bode plot with the gain and phase margins marked 
%   with a vertical line.  
%
%   See also BODE, LTIVIEW, LTIMODELS.

%   Note: if there is more than one crossover point, margin will
%   return the worst case gain and phase margins. 

%   Andrew Grace 12-5-91
%   Revised ACWG 6-21-92
%   Revised P.Gahinet 96-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/09/18 17:54:08 $

error('MARGIN is not supported for FRD models.')
