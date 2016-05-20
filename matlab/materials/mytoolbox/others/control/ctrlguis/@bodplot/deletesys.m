function BodRespObj = deletesys(BodRespObj,indDelete);
%DELETESYS Remove systems from the Bode Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
BodRespObj.PeakResponseValue(indDelete)=[];
BodRespObj.StabilityMarginValue(indDelete)=[];

%---Delete Parent Properties
BodRespObj.response = deletesys(BodRespObj.response,indDelete);
UImenu = get(BodRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',BodRespObj);