function NicRespObj = deletesys(NicRespObj,indDelete);
%DELETESYS Remove systems from the Nichols Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
NicRespObj.StabilityMarginValue(indDelete)=[];

%---Delete Parent Properties
NicRespObj.response= deletesys(NicRespObj.response,indDelete);
UImenu = get(NicRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',NicRespObj);