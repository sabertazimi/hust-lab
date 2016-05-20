function MargRespObj = deletesys(MargRespObj,indDelete);
%DELETESYS Remove systems from the Margin Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
MargRespObj.StabilityMarginValue(indDelete)=[];

%---Delete Parent Properties
MargRespObj.response = deletesys(MargRespObj.response,indDelete);
UImenu = get(MargRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',MargRespObj);