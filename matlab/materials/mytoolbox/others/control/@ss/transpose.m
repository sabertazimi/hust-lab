function tsys = transpose(sys)
%TRANSPOSE  Transpose operation for state-space models.
%
%   TSYS = TRANSPOSE(SYS) is invoked by TSYS = SYS.'
%
%   Given the state-space model SYS with data (A,B,C,D), 
%   TSYS = SYS.' returns the state-space model with data 
%   (A.',C.',B.',D.').  In terms of the transfer function 
%   H of SYS, the transfer function of resulting model 
%   TSYS is H(s).' (or H(z).' for discrete-time systems).
%
%   See also CTRANSPOSE, SS, LTIMODELS.

%   Author(s): A. Potvin, 3-1-94, P. Gahinet, 4-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/05/18 22:33:15 $

nd = length(size(sys.d));

tsys = sys;
tsys.a = permute(sys.a,[2 1 3:nd]);
tsys.e = permute(sys.e,[2 1 3:nd]);
tsys.b = permute(sys.c,[2 1 3:nd]);
tsys.c = permute(sys.b,[2 1 3:nd]);
tsys.d = permute(sys.d,[2 1 3:nd]);

% Delete state names
tsys.StateName(:) = {''};

% LTI property management
tsys.lti = (sys.lti).';
