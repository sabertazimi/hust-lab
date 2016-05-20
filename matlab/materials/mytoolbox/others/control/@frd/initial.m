function [yout,t,x] = initial(varargin)
%INITIAL  Initial condition response of State Space systems.
%
%   INITIAL(SYS,X0) plots the undriven response of the state-space 
%   system SYS with initial condition X0 on the states.  This 
%   response is characterized by the equations
%                        .
%     Continuous time:   x = A x ,  y = C x ,  x(0) = x0 
%
%     Discrete time:  x[k+1] = A x[k],  y[k] = C x[k],  x[0] = x0 .
%
%   The time range and number of points are chosen automatically.  
%
%   INITIAL(SYS,X0,TFINAL)  simulates the time response from t = 0 
%   to the final time t = TFINAL.  For discrete-time systems with 
%   unspecified sample time, TFINAL should be the number of samples.
%
%   INITIAL(SYS,X0,T)  specifies a time vector T to be used for 
%   simulation.  For discrete systems, T should be of the form  
%   0:Ts:Tf where Ts is the sample time of the system.  For continuous 
%   systems, T should be of the form 0:dt:Tf where dt will become the
%   sample time of a discrete approximation of the continuous system.
%
%   INITIAL(SYS1,SYS2,...,X0,T)  plots the response of multiple LTI 
%   systems SYS1,SYS2,... on a single plot.  The time vector T is 
%   optional.  You can also specify a color, line style, and marker 
%   for each system, as in  initial(sys1,'r',sys2,'y--',sys3,'gx',x0).
%
%   When invoked with left hand arguments,
%       [Y,T,X] = INITIAL(SYS,X0,...)
%   returns the output response Y, the time vector T used for simulation, 
%   and the state trajectories X.  No plot is drawn on the screen.  The
%   matrix Y has LENGTH(T) rows and as many columns as outputs in SYS.
%   Similarly, X has LENGTH(T) rows and as many columns as states.
%	
%   See also  IMPULSE, STEP, LSIM.

%   Author(s): S. Almy
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/04/14 21:40:46 $

error('INITIAL unsupported for FRD systems.  Remove FRDs from system list.');