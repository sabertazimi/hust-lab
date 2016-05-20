function NyqRespObj = deletesys(NyqRespObj,indDelete);
%DELETESYS Remove systems from the Nyquist Response Objects

%   Karen D. Gondoly: 4-7-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%---Remove all the Systems' data
NyqRespObj.StabilityMarginValue(indDelete)=[];

%---Delete Parent Properties
NyqRespObj.response= deletesys(NyqRespObj.response,indDelete);
UImenu = get(NyqRespObj.response,'UIContextMenu');
set(UImenu.Main,'UserData',NyqRespObj);