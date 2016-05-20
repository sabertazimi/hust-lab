function RespObj = deletesys(RespObj,indDelete);
%DELETESYS Remove systems from the Response Objects

%   Karen D. Gondoly: 4-6-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.3.1.2 $

%---Remove all the Systems' data
OldNames = RespObj.SystemNames;
RespObj.SystemNames(indDelete)=[];
RespObj.SelectedModels(indDelete)=[];
RespObj.SystemVisibility(indDelete)=[];

for ctD=1:length(indDelete);
   RH = RespObj.ResponseHandles{indDelete(ctD)};
   RH=cat(1,RH{:}); RH=cat(1,RH{:});
   set(RH,'DeleteFcn','');
   delete(RH);
end % for ctD

delete(RespObj.UIContextMenu.Systems.Names(indDelete))

RespObj.UIContextMenu.Systems.Names(indDelete)=[];
RespObj.ResponseHandles(indDelete)=[];

if ~strcmp(RespObj.ResponseType,'pzmap')& ~isempty(RespObj.ResponseHandles)
   %---Update the LTIresponseLine Userdata
   RH=RespObj.ResponseHandles;
   RH=cat(1,RH{:}); RH=cat(1,RH{:}); RH=cat(1,RH{:});
   RH=findobj(RH(:),'Tag','LTIresponseLines');
   ud = get(RH,{'UserData'});
   ud = cat(1,ud{:});
   
   SysInd = [ud.System];
   [garb,NewNameInd,OldNameInd]=intersect(RespObj.SystemNames,OldNames);
   NewSysInd = zeros(size(SysInd));
   for ct=1:length(NewNameInd)
      ChangeInd = find(SysInd==OldNameInd(ct));
      if ~isequal(OldNameInd(ct),NewNameInd(ct))
         NewSysInd(ChangeInd)=NewNameInd(ct);
      else
         NewSysInd(ChangeInd)=OldNameInd(ct);
      end
   end
   
   NewSysInd = num2cell(NewSysInd);
   [ud(:).System] = deal(NewSysInd{:});
   ud = num2cell(ud);
   set(RH,{'UserData'},ud)
end