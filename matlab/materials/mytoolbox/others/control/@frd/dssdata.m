function [a,b,c,d,e,Ts,Td] = dssdata(sys)
%DSSDATA  Quick access to descriptor state-space data.
%
%   [A,B,C,D,E] = DSSDATA(SYS) returns the values of the A,B,C,D,E
%   matrices for the descriptor state-space model SYS (see DSS).  
%   DSSDATA is equivalent to SSDATA for regular state-space models
%   (i.e., when E=I).
%
%   [A,B,C,D,E,TS] = DSSDATA(SYS) also returns the sample time TS.
%   Other properties of SYS can be accessed with GET or by direct 
%   structure-like referencing (e.g., SYS.Ts).
%
%   For arrays of LTI models with variable order, use the syntax
%      [A,B,C,D,E] = DSSDATA(SYS,'cell')
%   to return the variable-size A,B,C,E matrices into cell arrays. 
%
%   See also GET, SSDATA, DSS, LTIMODELS, LTIPROPS.

%    Author(s): P. Gahinet, 4-1-96
%    Copyright (c) 1986-98 by The MathWorks, Inc.
%    $Revision: 1.2 $  $Date: 1998/10/01 20:12:33 $

error('DSSDATA is not supported for FRD models.')

