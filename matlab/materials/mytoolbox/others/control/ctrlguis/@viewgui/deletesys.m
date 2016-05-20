function ViewerObj = deletesys(ViewerObj,indDelete);
%DELETESYS Remove systems from the LTI Viewer

%   Karen D. Gondoly: 4-6-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.5 $

%---Remove all the Systems' data
NumOldSys = length(ViewerObj.Systems);
ViewerObj.SystemNames(indDelete)=[];
ViewerObj.Systems(indDelete)=[];
if ~isempty(ViewerObj.PlotStrings)
   ViewerObj.PlotStrings(indDelete)=[];
   %---Reorder the Plot style used to distinquish systems
   switch ViewerObj.SystemPlotVariable,
   case 'color',
      Pval = ViewerObj.ColorOrder;
   case 'linestyle',
      Pval = ViewerObj.LineStyleOrder;
   case 'marker',
      Pval = ViewerObj.MarkerOrder;
   end
   np = length(Pval);
   indMove = indDelete(find(indDelete<=np));
   [UsedPvals,indUsed] = setdiff(Pval,Pval(indMove));
   NewPval = [Pval(sort(indUsed));Pval(indMove)];
   switch ViewerObj.SystemPlotVariable,
   case 'color',
      ViewerObj.ColorOrder = NewPval;
   case 'linestyle',
      ViewerObj.LineStyleOrder = NewPval;
   case 'marker',
      ViewerObj.MarkerOrder = NewPval;
   end
end

OldFRDi = ViewerObj.FrequencyData;
if ~isempty(ViewerObj.FrequencyData),
   tempFRDi = zeros(length(ViewerObj.Systems),1);
   for ct=1:length(ViewerObj.Systems);
      tempFRDi(ct) = isa(ViewerObj.Systems{ct},'frd');
   end
   ViewerObj.FrequencyData =find(tempFRDi);
end

if ~isempty(ViewerObj.UIContextMenu)
   %---Remove data from the Response Objects
   indDeleteOrig = indDelete;
   for ctU=1:length(ViewerObj.UIContextMenu),
      indDelete = indDeleteOrig;
      RespObj = get(ViewerObj.UIContextMenu(ctU),'UserData');
      if isempty(ViewerObj.SystemNames),
         cla(RespObj);
      else
         %---Remove FRD indices if deleting from a time domain response
         if isa(RespObj,'stepplot') | isa(RespObj,'impplot') | ...
               isa(RespObj,'icplot') | isa(RespObj,'lsimplot') | isa(RespObj,'pzplot'),
            tempInd = 1:NumOldSys;
            tempInd(OldFRDi)=[];
            [garb,indFRD,garb1]=intersect(indDelete,OldFRDi);
            indDelete(indFRD)=[];
            [garb,indDelete,garb1]=intersect(tempInd,indDelete);
         end
         if ~isempty(indDelete),
            RespObj = deletesys(RespObj,indDelete);
            %---Update the Array Selector(s)
            ContextMenu=get(ViewerObj,'UIcontextmenu');
            for ct=1:length(ContextMenu);
               RespCMenu = get(RespObj,'UIcontextMenu');
               if isequal(get(RespCMenu.ArrayMenu,'Visible'),'on')
                  paramsel('#delete',RespObj,indDelete)
               end
            end
         end % if ~isempty(indDelete)
      end % if/else isempty(ViewerObj.SystemNames
   end % for ctU
end % if ~isempty(ViewerObj.UIContextMenu

if isempty(ViewerObj.SystemNames),
   ViewerObj.UIContextMenu=[];
end

set(ViewerObj.Handle,'UserData',ViewerObj);