function v = pole(sys)
%POLE  Compute the poles of LTI models.
%
%   P = POLE(SYS) computes the poles P of the LTI model SYS (P is 
%   a column vector).
%
%   For state-space models, the poles are the eigenvalues of the A 
%   matrix or the generalized eigenvalues of the (A,E) pair in the 
%   descriptor case.
%
%   If SYS is an array of LTI models with sizes [NY NU S1 ... Sp],
%   the array P has as many dimensions as SYS and P(:,1,j1,...,jp) 
%   contains the poles of the LTI model SYS(:,:,j1,...,jp).  The 
%   vectors of poles are padded with NaN values for models with 
%   relatively fewer poles.
%
%   See also DAMP, ESORT, DSORT, PZMAP, ZERO, LTIMODELS.

%   Author(s): P. Gahinet, 4-9-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/08/26 16:42:32 $

error('POLE is not supported for FRD models.')
