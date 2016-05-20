function [sys,t] = ssbal(sys,condt)
%SSBAL  Balancing of state-space model using diagonal similarity.
%
%   [SYS,T] = SSBAL(SYS) uses BALANCE to compute a diagonal similarity 
%   transformation T such that [T*A/T , T*B ; C/T 0] has approximately 
%   equal row and column norms.  
%
%   [SYS,T] = SSBAL(SYS,CONDT) specifies an upper bound CONDT on the 
%   condition number of T.  Since balancing with ill-conditioned T 
%   can inadvertly magnify round-off errors, CONDT gives control over
%   the worst-case round-off amplification.  The default value is 
%   CONDT = 1/eps.
%
%   For arrays of state-space models, SSBAL computes a single 
%   transformation T that equalizes the maximum row and column norms 
%   across the entire array.
%
%   See also BALREAL, COMPBAL, SS.

%   Authors: P. Gahinet and C. Moler, 4-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%	 $Revision: 1.1 $  $Date: 1998/07/16 20:50:26 $

error('Only meaningful for State-Space models.')
