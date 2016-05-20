function IcRespObj = deletesys(IcRespObj,indDelete);
%DELETESYS Remove systems from the Initial Condition Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
IcRespObj.PeakResponseValue(indDelete)=[];

%---Delete Parent Properties
IcRespObj.response = deletesys(IcRespObj.response,indDelete);
UImenu = get(IcRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',IcRespObj);