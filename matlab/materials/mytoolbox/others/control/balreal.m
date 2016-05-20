function [ab,bb,cb,g,T,Ti] = balreal(a,b,c)
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

% Old help
%warning(['This calling syntax for ' mfilename ' will not be supported in the future.'])
%BALREAL  Balanced state-space realization and model reduction.
%   [Ab,Bb,Cb] = BALREAL(A,B,C) returns a balanced state-space 
%   realization of the system (A,B,C).
%
%   [Ab,Bb,Cb,G,T] = BALREAL(A,B,C) also returns a vector G containing
%   the diagonal of the gramian of the balanced realization, and 
%   matrix T, the similarity transformation used to convert (A,B,C) 
%   to (Ab,Bb,Cb).  If the system (A,B,C) is normalized properly, 
%   small elements in gramian G indicate states that can be removed to
%   reduce the model to lower order.

%	J.N. Little 3-6-86
%	Revised 12-30-88
%       Alan J. Laub 10-30-94
%       P. Gahinet 6-27-96
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.6 $  $Date: 1999/01/05 12:08:24 $

%       Reference:
%       [1] Laub, A.J., M.T. Heath, C.C. Paige, and R.C. Ward,
%           ``Computation of System Balancing Transformations and Other
%           Applications of Simultaneous Diagonalization Algorithms,''
%           IEEE Trans. Automatic Control, AC-32(1987), 115--122.
%
%       The old balreal used an eigenvalue algorithm described in
%	 1) Moore, B., Principal Component Analysis in Linear Systems:
%	    Controllability, Observability, and Model Reduction, IEEE 
%	    Transactions on Automatic Control, 26-1, Feb. 1981.
%	 2) Laub, A., "Computation of Balancing Transformations", Proc. JACC
%	    Vol.1, paper FA8-E, 1980.

error(nargchk(3,3,nargin));
[sys,g,Ti,T] = balreal(ss(a,b,c,zeros(size(c,1),size(b,2))));
[ab,bb,cb] = ssdata(sys);

% end balreal
