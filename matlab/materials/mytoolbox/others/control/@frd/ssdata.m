function [a,b,c,d,Ts,Td] = ssdata(sys)
%SSDATA  Quick access to state-space data.
%
%   [A,B,C,D] = SSDATA(SYS) retrieves the matrix data A,B,C,D
%   for the state-space model SYS.  If SYS is not a state-space 
%   model, it is first converted to the state-space representation.
%
%   [A,B,C,D,TS] = SSDATA(SYS) also returns the sample time TS.
%   Other properties of SYS can be accessed with GET or by direct 
%   structure-like referencing (e.g., SYS.Ts).
%
%   For arrays of LTI models with the same order (number of states),
%   A,B,C,D are multi-dimensional arrays where A(:,:,k), B(:,:,k), 
%   C(:,:,k), D(:,:,k) give the state-space matrices of the 
%   k-th model SYS(:,:,k).
%
%   For arrays of LTI models with variable order, use the syntax
%      [A,B,C,D] = SSDATA(SYS,'cell')
%   to return the variable-size A,B,C matrices into cell arrays. 
%
%   See also SS, GET, DSSDATA, TFDATA, ZPKDATA, LTIMODELS, LTIPROPS.

%   Author(s): P. Gahinet, 4-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%    $Revision: 1.2 $  $Date: 1998/10/01 20:12:32 $

error('SSDATA is not supported for FRD models.')
