function [f,g] = latcfilt(k,v,x)
%LATCFILT Lattice and lattice-ladder filter implementation.
%   [F,G] = LATCFILT(K,X) filters X with the FIR lattice coefficients
%   in vector K.  F is the forward lattice filter result, and G is the
%   backward filter result.
%
%   If K and X are vectors, the result is a (signal) vector.
%   Matrix arguments are permitted under the following rules:
%   - If X is a matrix and K is a vector, each column of X is processed
%     through the lattice filter specified by K.
%   - If X is a vector and K is a matrix, each column of K is used to
%     filter X, and a signal matrix is returned.
%   - If X and K are both matrices with the same # of columns, then the
%     i-th column of K is used to filter the i-th column of X.  A
%     signal matrix is returned.
%
%   [F,G] = LATCFILT(K,V,X) filters X with the IIR lattice
%   coefficients K and ladder coefficients V.  K and V must be
%   vectors, while X may be a signal matrix.
%
%   [F,G] = LATCFILT(K,1,X) filters X with the IIR all-pole lattice
%   specified by K.  K and X may be vectors or matrices according to
%   the rules given for the FIR lattice.
%
%   See also FILTER, TF2LATC, LATC2TF.

% Author(s): Don Orofino, May 1996
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%       $Revision: 1.1 $
% $Revision: 1.1 $ $Date: 1998/06/03 14:43:09 $

error('MEX file not found.');
