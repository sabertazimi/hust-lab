function LsimRespObj = deletesys(LsimRespObj,indDelete);
%DELETESYS Remove systems from the Linear Simulation Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---No LSIM specific properties to remove

%---Delete Parent Properties
LsimRespObj.response = deletesys(LsimRespObj.response,indDelete);
UImenu = get(LsimRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',LsimRespObj);