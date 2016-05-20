function [ys,ts,xs] = lsim(varargin)
%LSIM  Simulates time response of LTI systems to arbitrary inputs.
%
%   LSIM(SYS,U,T)  plots the time response of the LTI model SYS to the
%   input signal described by U and T.  The time vector T consists of 
%   regularly spaced time samples and U is a matrix with as many columns 
%   as inputs and whose i-th row specifies the input value at time T(i).
%   For example, 
%           t = 0:0.01:5;   u = sin(t);   lsim(sys,u,t)  
%   simulates the response of a single-input model SYS to the input 
%   u(t)=sin(t) during 5 seconds.
%
%   In discrete time, U should be sampled at the same rate as the system
%   (T is then redundant and can be omitted or set to the empty matrix).
%   In continuous time, choose the sampling period T(2)-T(1) small enough 
%   to accurately describe the input U.  LSIM checks for intersample 
%   oscillations and resamples U if necessary.
%         
%   LSIM(SYS,U,T,X0)  specifies an additional nonzero initial state X0
%   (for state-space systems only).
%
%   LSIM(SYS1,SYS2,...,U,T,X0)  simulates the response of multiple LTI
%   systems SYS1,SYS2,... on a single plot.  The initial condition X0 
%   is optional.  You can also specify a color, line style, and marker 
%   for each system, as in  lsim(sys1,'r',sys2,'y--',sys3,'gx',u,t).
%
%   When invoked with left-hand arguments,
%        [YS,TS] = LSIM(SYS,U,T,...)
%   returns the output history YS and time vector TS used for simulation.
%   No plot is drawn on the screen.  The matrix YS has LENGTH(TS) rows 
%   and as many columns as outputs in SYS.
%   WARNING: TS contains more points than T when U is resampled to reveal
%   intersample oscillations.  To get the response at the samples T only,
%   extract YS(1:d:end,:) where d=round(length(TS)/length(T)).
%
%   For state-space systems, 
%        [YS,TS,XS] = LSIM(SYS,U,T,...) 
%   also returns the state trajectory XS, a matrix with LENGTH(TS) rows
%   and as many columns as states.
%
%   See also  GENSIG, STEP, IMPULSE, INITIAL.

%   To compute the time response of continuous-time systems, LSIM uses linear 
%   interpolation of the input between samples for smooth signals, and 
%   zero-order hold for rapidly changing signals like steps or square waves. 
%   When the system dynamics are likely to cause intersample oscillations, 
%   LSIM first resamples the input using linear interpolation where the signal
%   is smooth and zero-order hold near pulses or steps. Since poorly sampled
%   periodic signals may look discontinuous, the sampling rate should always
%   be high enough to reflect the nature of the signal.

%   Author(s): S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/08/26 21:48:34 $

error('LSIM unsupported for FRD systems.  Remove FRDs from system list.');