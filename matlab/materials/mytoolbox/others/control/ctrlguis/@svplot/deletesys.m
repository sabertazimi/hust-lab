function SvRespObj = deletesys(SvRespObj,indDelete);
%DELETESYS Remove systems from the Singular Value Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
SvRespObj.PeakResponseValue(indDelete)=[];

%---Delete Parent Properties
SvRespObj.response= deletesys(SvRespObj.response,indDelete);
UImenu = get(SvRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',SvRespObj);