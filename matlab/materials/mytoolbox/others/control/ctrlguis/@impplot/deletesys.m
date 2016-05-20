function ImpRespObj = deletesys(ImpRespObj,indDelete);
%DELETESYS Remove systems from the Impulse Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
ImpRespObj.PeakResponseValue(indDelete)=[];
ImpRespObj.SettlingTimeValue(indDelete)=[];

%---Delete Parent Properties
ImpRespObj.response = deletesys(ImpRespObj.response,indDelete);
UImenu = get(ImpRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',ImpRespObj);