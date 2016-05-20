function ViewerObj = plotapply(varargin);
%PLOTAPPLY Apply Linestyle Preference settings to the associated LTI Viewer
% $Revision: 1.4 $

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly, 3-23-98

error(nargchk(1,2,nargin));
ViewerObj = varargin{1};

if nargin>1,
   NumConfigs = varargin{2};   
else
   NumConfigs = 1:ViewerObj.Configuration;
end

PlotPrefFig = get(ViewerObj.FigureMenu.ToolsMenu.Linestyle,'UserData');
if ishandle(PlotPrefFig) & ~isequal(PlotPrefFig,0),
   udPlot=get(PlotPrefFig ,'UserData');
   
   ViewerObj.ColorOrder = udPlot.Revert.ColorList;
   NumC = length(ViewerObj.ColorOrder);
   ViewerObj.LineStyleOrder = udPlot.Revert.LineList;
   NumL=length(ViewerObj.LineStyleOrder);
   ViewerObj.MarkerOrder = udPlot.Revert.MarkerList;   
   NumM=length(ViewerObj.MarkerOrder);
   
   %---Need to update Response Object Orders, as well...but, only if we intend
   %----to keep the Orders as Response Object Properties. I vote for removing them
   
   strs = {'color';'marker';'linestyle';'none'};
   %---Find SysInd
   AllSysInd=[udPlot.Revert.ColorSystem;
      udPlot.Revert.MarkSystem;
      udPlot.Revert.LineSystem;
      udPlot.Revert.NoSystem];
   ViewerObj.SystemPlotVariable = strs{find(AllSysInd)};
   
   %---Find InInd	
   AllInInd=[udPlot.Revert.ColorInput;
      udPlot.Revert.MarkInput;
      udPlot.Revert.LineInput;
      udPlot.Revert.NoInput];
   ViewerObj.InputPlotVariable = strs{find(AllInInd)};
   
   %---Find OutInd
   AllOutInd=[udPlot.Revert.ColorOutput;
      udPlot.Revert.MarkOutput;
      udPlot.Revert.LineOutput;
      udPlot.Revert.NoOutput];
   ViewerObj.OutputPlotVariable = strs{find(AllOutInd)};
   
   %---Find ChInd
   AllChInd=[udPlot.Revert.ColorChannel;
      udPlot.Revert.MarkChannel;
      udPlot.Revert.LineChannel;
      udPlot.Revert.NoChannel];
   ViewerObj.ChannelPlotVariable = strs{find(AllChInd)};
   
   Inds=[find(AllInInd),find(AllOutInd),find(AllChInd),find(AllSysInd)];
   Cind=find(Inds==1);
   Mind=find(Inds==2);
   Lind=find(Inds==3);
   
   if ~isempty(ViewerObj.Systems),
      %---Determine the new System legends
      SysNames = ViewerObj.SystemNames;
      legendStr = cell(size(SysNames));
      OpenParen = cell(size(SysNames));    OpenParen(:) = {' ('};
      CloseParen = cell(size(SysNames));   CloseParen(:) = {')'};
      NumSys = 1:length(SysNames);
      switch ViewerObj.SystemPlotVariable
      case 'color',
         NumSys = NumSys-((ceil(NumSys/NumC)-1)*NumC);
         legendStr = ViewerObj.ColorOrder(NumSys);
      case 'marker'
         NumSys = NumSys-((ceil(NumSys/NumM)-1)*NumM);
         legendStr = ViewerObj.MarkerOrder(NumSys);
      case 'linestyle',
         LineStrs = get(udPlot.Handles.LineList,'String');
         NumSys = NumSys-((ceil(NumSys/NumL)-1)*NumL);
         legendStr = LineStrs(NumSys);
      case 'none',
         legendStr(:) = {['N/A']};
      end
      legendStr = strcat(SysNames,OpenParen,legendStr,CloseParen);
      
      RespObjs = get(ViewerObj.UIContextMenu,{'UserData'});
      AllSysInd=1:length(ViewerObj.Systems);
      for ctConfig = NumConfigs,
         plottype = get(RespObjs{ctConfig},'ResponseType'); 
         if any(strcmpi(plottype,{'bode';'sigma';'nyquist';'nichols'}))
            SysInd = AllSysInd;
         else
            SysInd=AllSysInd; SysInd(ViewerObj.FrequencyData)=[];
         end
         %---Update the system legend
         ContextMenu = get(RespObjs{ctConfig},'UIContextMenu');
         set(ContextMenu.Systems.Names,{'label'},legendStr(SysInd));
         
         ResponseHandles = get(RespObjs{ctConfig},'ResponseHandles');
         [numout,numin]=size(ResponseHandles{1});
         inH=cat(1,ResponseHandles{:});
         outH=cat(2,ResponseHandles{:});
         switch plottype,
         case {'bode','sigma'},
            valMult=1; valMult2=2;
            numout=numout/2;
         otherwise,
            valMult=0; valMult2=1;
         end
         AllH = cat(1,inH{:});
         AllH = cat(1,AllH{:});
         Rlines = [findobj(AllH,'Tag','LTIresponseLines');
            findobj(AllH,'Tag','NyquistArrow')];
         AllPlotOpts = [findobj(AllH,'Tag','SteadyStateMarker','Marker','o');
            findobj(AllH,'Tag','StabilityMarginMarker','Marker','o');
            findobj(AllH,'Tag','SettlingTimeMarker','Marker','o');
            findobj(AllH,'Tag','RiseTimeMarker','Marker','o');
            findobj(AllH,'Tag','PeakResponseMarker','Marker','o')];
         
         switch plottype
         case 'pzmap',
            % If PZ diagrams...default to colors
            for ct=1:length(ResponseHandles)
               CC = ViewerObj.ColorOrder{ct-(NumC*floor((ct-1)/NumC))};
               SysHandles = cat(1,ResponseHandles{ct}{:});
               SysHandles = cat(1,SysHandles{:});
               set(findobj(SysHandles,'Tag','LTIresponseLines'),'Color',CC);
            end
         otherwise
            %---Group handles in inputs/outputs/channels
            
            %---Set Color Variable
            if ~isempty(Cind)
               switch Cind, 
                  
               case 1, % Designate different inputs
                  for ctIn=1:numin,
                     CC = ViewerObj.ColorOrder{ctIn-(NumC*floor((ctIn-1)/NumC))};
                     inH2=cat(1,inH{:,ctIn}); inH2 = cat(1,inH2{:});
                     inHL = [findobj(inH2,'Tag','LTIresponseLines');findobj(inH2,'Tag','NyquistArrow')];
                     set(inHL,'Color',CC)
                     PlotOpts = [findobj(inH2,'Tag','SteadyStateMarker','Marker','o');
                        findobj(inH2,'Tag','StabilityMarginMarker','Marker','o');
                        findobj(inH2,'Tag','SettlingTimeMarker','Marker','o');
                        findobj(inH2,'Tag','RiseTimeMarker','Marker','o');
                        findobj(inH2,'Tag','PeakResponseMarker','Marker','o')];
                     if ~isempty(PlotOpts),
                        set(PlotOpts,'MarkerFaceColor',CC,'MarkerEdgeColor',CC);
                     end
                  end
                  
               case 2, % Designate different outputs
                  for ctOut=1:numout,
                     CC = ViewerObj.ColorOrder{ctOut-(NumC*floor((ctOut-1)/NumC))};
                     outH2=cat(1,outH{ctOut+((ctOut-1)*valMult):ctOut*valMult2,:});
                     outH2=cat(1,outH2{:});
                     outHL = [findobj(outH2,'Tag','LTIresponseLines');findobj(outH2,'Tag','NyquistArrow')];
                     set(outHL,'Color',CC)
                     PlotOpts = [findobj(outH2,'Tag','SteadyStateMarker','Marker','o');
                        findobj(outH2,'Tag','StabilityMarginMarker','Marker','o');
                        findobj(outH2,'Tag','SettlingTimeMarker','Marker','o');
                        findobj(outH2,'Tag','RiseTimeMarker','Marker','o');
                        findobj(outH2,'Tag','PeakResponseMarker','Marker','o')];
                     if ~isempty(PlotOpts),
                        set(PlotOpts,'MarkerFaceColor',CC,'MarkerEdgeColor',CC);
                     end
                  end
                  
               case 3, % Designate different channels
                  ChCt=0;
                  for ctIn=1:numin,
                     for ctOut=1:numout,
                        ChCt=ChCt+1;
                        CC = ViewerObj.ColorOrder{ChCt-(NumC*floor((ChCt-1)/NumC))};
                        chH2=cat(1,inH{ctOut+((ctOut-1)*valMult):ctOut*valMult2,ctIn});
                        chH2=cat(1,chH2{:});
                        chHL = [findobj(chH2,'Tag','LTIresponseLines');
                           findobj(chH2,'Tag','NyquistArrow')];
                        set(chHL,'Color',CC)
                        PlotOpts = [findobj(chH2,'Tag','SteadyStateMarker','Marker','o');
                           findobj(chH2,'Tag','StabilityMarginMarker','Marker','o');
                           findobj(chH2,'Tag','SettlingTimeMarker','Marker','o');
                           findobj(chH2,'Tag','RiseTimeMarker','Marker','o');
                           findobj(chH2,'Tag','PeakResponseMarker','Marker','o')];
                        if ~isempty(PlotOpts),
                           set(PlotOpts,'MarkerFaceColor',CC,'MarkerEdgeColor',CC);
                        end
                     end
                  end
                  
               case 4, % Designate different systems
                  Corder = ViewerObj.ColorOrder;
                  Corder = Corder(SysInd);
                  for ct=1:length(ResponseHandles)
                     CC = Corder{ct-(length(Corder)*floor((ct-1)/length(Corder)))};
                     SysHandles = cat(1,ResponseHandles{ct}{:});
                     SysHandles = cat(1,SysHandles{:});
                     SysH= [findobj(SysHandles,'Tag','LTIresponseLines');findobj(SysHandles,'Tag','NyquistArrow')];
                     set(SysH,'Color',CC);
                     PlotOpts = [findobj(SysHandles,'Tag','SteadyStateMarker','Marker','o');
                        findobj(SysHandles,'Tag','StabilityMarginMarker','Marker','o');
                        findobj(SysHandles,'Tag','SettlingTimeMarker','Marker','o');
                        findobj(SysHandles,'Tag','RiseTimeMarker','Marker','o');
                        findobj(SysHandles,'Tag','PeakResponseMarker','Marker','o')];
                     if ~isempty(PlotOpts),
                        set(PlotOpts,'MarkerFaceColor',CC,'MarkerEdgeColor',CC);
                     end
                  end
               end % switch Cind
               
            else, % No color designation
               set(Rlines,'Color',ViewerObj.ColorOrder{1});
               set(AllPlotOpts,'MarkerFaceColor',ViewerObj.ColorOrder{1},...
                  'MarkerEdgeColor',ViewerObj.ColorOrder{1});
            end % if/else ~isempty(Cind)
            
            
            %---Set Linestyle Variable
            if ~isempty(Lind)
               switch Lind, 
                  
               case 1, % Designate different inputs
                  for ctIn=1:numin,
                     LL = ViewerObj.LineStyleOrder{ctIn-(NumL*floor((ctIn-1)/NumL))};
                     inH2=cat(1,inH{:,ctIn}); inH2 = cat(1,inH2{:});
                     inH2 = findobj(inH2,'Tag','LTIresponseLines');
                     set(inH2,'Linestyle',LL)
                  end
                  
               case 2, % Designate different outputs
                  for ctOut=1:numout,
                     LL = ViewerObj.LineStyleOrder{ctOut-(NumL*floor((ctOut-1)/NumL))};
                     outH2=cat(1,outH{ctOut+((ctOut-1)*valMult):ctOut*valMult2,:});
                     outH2=cat(1,outH2{:});
                     outH2 = findobj(outH2,'Tag','LTIresponseLines');
                     set(outH2,'Linestyle',LL)
                  end
                  
               case 3, % Designate different channels
                  ChCt=0;
                  for ctIn=1:numin,
                     for ctOut=1:numout,
                        ChCt=ChCt+1;
                        LL = ViewerObj.LineStyleOrder{ChCt-(NumL*floor((ChCt-1)/NumL))};
                        chH=cat(1,inH{ctOut+((ctOut-1)*valMult):ctOut*valMult2,ctIn});
                        chH2=cat(1,chH{:});
                        chH2 = findobj(chH2,'Tag','LTIresponseLines');
                        set(chH2,'Linestyle',LL)
                     end
                  end
                  
               case 4, % Designate different systems
                  for ct=1:length(ResponseHandles)
                     LL = ViewerObj.LineStyleOrder{ct-(NumL*floor((ct-1)/NumL))};
                     SysHandles = cat(1,ResponseHandles{ct}{:});
                     SysHandles = cat(1,SysHandles{:});
                     SysH= findobj(SysHandles,'Tag','LTIresponseLines');
                     set(SysH,'Linestyle',LL);
                  end
               end % switch Lind
               
            else, % No linestyle designation
               set(Rlines,'Linestyle',ViewerObj.LineStyleOrder{1});
            end % if/else ~isempty(Lind)
            
            %---Set Marker Variable
            if ~isempty(Mind),
               switch Mind, 
                  
               case 1, % Designate different inputs
                  for ctIn=1:numin,
                     MM = ViewerObj.MarkerOrder{ctIn-(NumM*floor((ctIn-1)/NumM))};
                     inH2=cat(1,inH{:,ctIn}); inH2 = cat(1,inH2{:});
                     inH2 = findobj(inH2,'Tag','LTIresponseLines');
                     set(inH2,'Marker',MM)
                  end
                  
               case 2, % Designate different outputs
                  for ctOut=1:numout,
                     MM = ViewerObj.MarkerOrder{ctOut-(NumM*floor((ctOut-1)/NumM))};
                     outH2=cat(1,outH{ctOut+((ctOut-1)*valMult):ctOut*valMult2,:});
                     outH2=cat(1,outH2{:});
                     outH2 = findobj(outH2,'Tag','LTIresponseLines');
                     set(outH2,'Marker',MM)
                  end
                  
               case 3, % Designate different channels
                  ChCt=0;
                  for ctIn=1:numin,
                     for ctOut=1:numout,
                        ChCt=ChCt+1;
                        MM = ViewerObj.MarkerOrder{ChCt-(NumM*floor((ChCt-1)/NumM))};
                        chH=cat(1,inH{ctOut+((ctOut-1)*valMult):ctOut*valMult2,ctIn});
                        chH2=cat(1,chH{:});
                        chH2 = findobj(chH2,'Tag','LTIresponseLines');
                        set(chH2,'Marker',MM)
                     end
                  end
                  
               case 4, % Designate different systems
                  for ct=1:length(ResponseHandles)
                     MM = ViewerObj.MarkerOrder{ct-(NumM*floor((ct-1)/NumM))};
                     SysHandles = cat(1,ResponseHandles{ct}{:});
                     SysHandles = cat(1,SysHandles{:});
                     SysH= findobj(SysHandles,'Tag','LTIresponseLines');
                     set(SysH,'Marker',MM);
                  end
               end % switch Mind
               
            else, % No marker designation
               set(Rlines,'Marker',ViewerObj.MarkerOrder{1});
            end % if/else ~isempty(Mind)
         end % switch plottype
         
      end % for ctConfig
   end % if ~isempty(ViewerObj.Systems)   
end % ishandle(PlotPref)