function StepRespObj = deletesys(StepRespObj,indDelete);
%DELETESYS Remove systems from the Step Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
StepRespObj.PeakResponseValue(indDelete)=[];
StepRespObj.RiseTimeValue(indDelete)=[];
StepRespObj.SteadyStateValue(indDelete)=[];
StepRespObj.SettlingTimeValue(indDelete)=[];

%---Delete Parent Properties
StepRespObj.response = deletesys(StepRespObj.response,indDelete);
UImenu = get(StepRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',StepRespObj);