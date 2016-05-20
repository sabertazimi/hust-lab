function BodeRespObj = newunits(BodeRespObj,type,OldUnit);
%NEWUNITS Rescale the units on a Bode diagram
%   NEWUNITS(BodeRespObj,type) rescales the units on a Bode Diagram
%   response located on a figure window or in the LTI Viewer. NEWUNITS
%   should only be called from the SET command for Bode Response objects.
%
%   "type" may be: 1) 'frequency', 2) 'phase', or 3) 'magnitude'
%
%   For 'magnitude' a third input argument must be entered which states
%   the last units the magnitude was plotted in.
% $Revision: 1.3 $

%   Karen Gondoly, 3-27-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

allProps = get(BodeRespObj.response);
LTIdisplayAxes = allProps.PlotAxes;

switch type
   
case 'frequency'
   XlabelH = get(BodeRespObj.response,'Xlabel');
   AllLines = [findobj(LTIdisplayAxes,'Tag','LTIresponseLines');
            findobj(LTIdisplayAxes,'Tag','NyquistLines')];
   AllXdata = get(AllLines,{'Xdata'});
   if strncmpi(BodeRespObj.FrequencyUnits,'h',1);
      Xlabel = 'Frequency (Hz)';
      FreqFac = 1/(2*pi);
   else
      Xlabel = 'Frequency (rad/sec)';
      FreqFac = 2*pi;
   end
   for ctLines = 1:length(AllXdata),
      AllXdata{ctLines} = AllXdata{ctLines}.*FreqFac;
   end
   set(AllLines,{'Xdata'},AllXdata);
   set(XlabelH,'String',Xlabel);
   
   %---Convert the X-axis limits
   allProps.Xlims = num2cell(cat(1,allProps.Xlims{:})*FreqFac,2);
   
   %---Convert any plot options
   PeakResp = BodeRespObj.PeakResponseValue;
   if ~isempty(PeakResp(1).Frequency),
      for ctPR=1:length(PeakResp),
         PeakResp(ctPR).Frequency = PeakResp(ctPR).Frequency*FreqFac;
      end
      BodeRespObj.PeakResponseValue = PeakResp;
   end

   StabMarg = BodeRespObj.StabilityMarginValue;
   if ~isempty(StabMarg(1).GMFrequency),
      for ctSM=1:length(StabMarg),
         StabMarg(ctSM).GMFrequency= StabMarg(ctSM).GMFrequency*FreqFac;
         StabMarg(ctSM).PMFrequency= StabMarg(ctSM).PMFrequency*FreqFac;
      end
      BodeRespObj.StabilityMarginValue = StabMarg;
   end

case 'magnitude'
   WarnState = warning;
   warning off;
   YlabelH = get(BodeRespObj.response,'Ylabel');
   AllLines = [findobj(LTIdisplayAxes(1:2:end,:),'Tag','LTIresponseLines');
            findobj(LTIdisplayAxes(1:2:end,:),'Tag','NyquistLines')];
   AllYdata = get(AllLines,{'Ydata'});
   Ystr = get(YlabelH,'String');
   indColon = findstr(';',Ystr);

   %---Store any plot options
   PeakResp = BodeRespObj.PeakResponseValue;
   StabMarg = BodeRespObj.StabilityMarginValue;

   if strcmpi(BodeRespObj.MagnitudeUnits,'decibels'), % Changing to dB
      for ctLines=1:length(AllYdata),
         AllYdata{ctLines} = 20.*log10(AllYdata{ctLines});
      end
      if ~isempty(PeakResp(1).Peak),
         for ctPR=1:length(PeakResp),
            PeakResp(ctPR).Peak = 20.*log10(PeakResp(ctPR).Peak);
         end
         BodeRespObj.PeakResponseValue = PeakResp;
      end
      if ~isempty(StabMarg(1).GainMargin),
         for ctSM=1:length(StabMarg),
            StabMarg(ctSM).GainMargin = 20.*log10(StabMarg(ctSM).GainMargin);
         end
         BodeRespObj.StabilityMarginValue= StabMarg;
      end
      %---Convert the Y-axis limits
      allProps.Ylims(1:2:end) = num2cell(20.*log10(cat(1,allProps.Ylims{1:2:end})),2);
      
      MagScale = 'linear';
      MagLabel = 'Magnitude (dB)';

   else, % Changing to Abs or Log
      Yscale = get(LTIdisplayAxes(1,1),'Yscale');
      if strcmpi(OldUnit,'decibels'), % Changing from Db
         for ctLines=1:length(AllYdata),
            AllYdata{ctLines} = 10.^(AllYdata{ctLines}./20);
         end
         %---Convert the Y-axis limits
         allProps.Ylims(1:2:end) = num2cell(10.^(cat(1,allProps.Ylims{1:2:end})./20),2);
         
         if ~isempty(PeakResp(1).Peak),
            for ctPR=1:length(PeakResp),
               PeakResp(ctPR).Peak = 10.^(PeakResp(ctPR).Peak./20);
            end
            BodeRespObj.PeakResponseValue = PeakResp;
         end
         if ~isempty(StabMarg(1).GainMargin),
            for ctSM=1:length(StabMarg),
               StabMarg(ctSM).GainMargin = 10.^(StabMarg(ctSM).GainMargin./20);
            end
            BodeRespObj.StabilityMarginValue= StabMarg;
	  		end
      end
      if strcmpi(BodeRespObj.MagnitudeUnits,'absolute'), % Changing to Absolute
         MagScale='linear';
         MagLabel = 'Magnitude (Absolute)';
      elseif strcmpi(BodeRespObj.MagnitudeUnits,'logrithmic'), % Changing to Log
         MagScale = 'log';
         MagLabel ='Magnitude (Log10)';
      end	
   end
   set(AllLines,{'Ydata'},AllYdata);
   set(LTIdisplayAxes(1:2:end,:),'Yscale',MagScale)
   set(YlabelH,'String',[Ystr(1:indColon+1),MagLabel]);
   
   warning(WarnState)

case 'phase',
   AllLines = [findobj(LTIdisplayAxes(2:2:end,:),'Tag','LTIresponseLines');
            findobj(LTIdisplayAxes(2:2:end,:),'Tag','NyquistLines')];
   AllYdata = get(AllLines,{'Ydata'});
   YlabelH = get(BodeRespObj.response,'Ylabel');
   Ystr = get(YlabelH,'String');
   indColon = findstr(';',Ystr);
   if strcmpi(BodeRespObj.PhaseUnits,'radians');
      PhLabel = 'Phase (rad)';
      PhFac = pi/180;
   else
      PhLabel = 'Phase (deg)';
      PhFac = 180/pi;
   end
   for ctLines=1:length(AllYdata),
      AllYdata{ctLines} = AllYdata{ctLines}.*PhFac;
   end
   set(AllLines,{'Ydata'},AllYdata);
   set(YlabelH,'String',[PhLabel,Ystr(indColon:end)]);
   
   %---Convert the Y-axis limits
   allProps.Ylims(2:2:end) = num2cell(cat(1,allProps.Ylims{2:2:end})*PhFac,2);
   
   %---Convert any plot options
   StabMarg = BodeRespObj.StabilityMarginValue;
   if ~isempty(StabMarg(1).PhaseMargin),
      for ctSM=1:length(StabMarg),
         StabMarg(ctSM).PhaseMargin = StabMarg(ctSM).PhaseMargin*PhFac;
      end
      BodeRespObj.StabilityMarginValue = StabMarg;
   end
   
end % switch type

%---Rescale the axes
set(BodeRespObj,'Xlims',allProps.Xlims,'Ylims',allProps.Ylims,...
   'XlimMode',allProps.XlimMode,'YlimMode',allProps.YlimMode);

%---Check if Plot Options need to be redrawn
if strcmp(BodeRespObj.StabilityMargin,'on'),
   set(BodeRespObj,'StabilityMargin','off')
   set(BodeRespObj,'StabilityMargin','on')
end

if strcmp(BodeRespObj.PeakResponse,'on'),
   set(BodeRespObj,'PeakResponse','off')
   set(BodeRespObj,'PeakResponse','on')
end
