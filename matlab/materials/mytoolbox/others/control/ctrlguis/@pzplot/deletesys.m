function PzRespObj = deletesys(PzRespObj,indDelete);
%DELETESYS Remove systems from the Pole-zero map Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data - Currently not storing poles/zeros
%PzRespObj.Poles(indDelete)=[];
%PzRespObj.Zeros(indDelete)=[];

%---Delete Parent Properties
PzRespObj.response = deletesys(PzRespObj.response,indDelete);
UImenu = get(PzRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',PzRespObj);