function [sysb,g,T,Ti] = balreal(sys)
%BALREAL  Gramian-based balancing of state-space realizations.
%
%   SYSb = BALREAL(SYS) returns a balanced state-space realization 
%   of the reachable, observable, stable system SYS.
%
%   [SYSb,G,T,Ti] = BALREAL(SYS) also returns a vector G containing
%   the diagonal of the Gramian of the balanced realization.  The
%   matrices T is the state transformation xb = Tx used to convert SYS
%   to SYSb, and Ti is its inverse.  
%
%   If the system is normalized properly, small elements in the balanced
%   Gramian G indicate states that can be removed to reduce the model 
%   to lower order.
%
%   See also MODRED, GRAM, SSBAL, SS.

%	J.N. Little 3-6-86
%	Revised 12-30-88
%       Alan J. Laub 10-30-94
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/08/26 16:42:32 $

error('BALREAL is not supported for FRD models.')
