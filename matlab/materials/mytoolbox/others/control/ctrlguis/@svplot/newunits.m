function SvRespObj = newunits(SvRespObj,type,OldUnit);
%NEWUNITS Rescale the units on a Singular Value plot
%   NEWUNITS(SvRespObj,type) rescales the units on a Singular Value plot
%   response located on a figure window or in the LTI Viewer. NEWUNITS
%   should only be called from the SET command for Singular Value objects.
%
%   "type" may be: 1) 'frequency' or 2) 'magnitude'
%
%   For 'magnitude' a third input argument must be entered which states
%   the last units the magnitude was plotted in.
% $Revision: 1.3 $

%   Karen Gondoly, 3-27-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

allProps = get(SvRespObj.response);
LTIdisplayAxes = allProps.PlotAxes;

switch type
   
case 'frequency'
   AllLines = [findobj(LTIdisplayAxes,'Tag','LTIresponseLines');
            findobj(LTIdisplayAxes,'Tag','NyquistLines')];
   AllXdata = get(AllLines,{'Xdata'});
   if strncmpi(SvRespObj.FrequencyUnits,'h',1);
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
   set(allProps.Xlabel,'String',Xlabel);
   
   %---Convert any plot options
   PeakResp = SvRespObj.PeakResponseValue;
   if ~isempty(PeakResp(1).Frequency),
      for ctPR=1:length(PeakResp),
         PeakResp(ctPR).Frequency = PeakResp(ctPR).Frequency*FreqFac;
      end
      SvRespObj.PeakResponseValue = PeakResp;
   end
   
   %---Convert the X-axis limits
   allProps.Xlims{1} = allProps.Xlims{1}*FreqFac;
   
case 'magnitude'
   WarnState = warning;
   warning off;
   AllLines = [findobj(LTIdisplayAxes,'Tag','LTIresponseLines');
            findobj(LTIdisplayAxes,'Tag','NyquistLines')];
   AllYdata = get(AllLines,{'Ydata'});

   %---Store any plot options
   PeakResp = SvRespObj.PeakResponseValue;

   if strcmpi(SvRespObj.MagnitudeUnits,'decibels'), % Changing to dB
      for ctLines=1:length(AllYdata),
         AllYdata{ctLines} = 20.*log10(AllYdata{ctLines});
      end
      %---Convert the Y-axis limits
      allProps.Ylims{1} = 20.*log10(allProps.Ylims{1});
      
      if ~isempty(PeakResp(1).Peak),
         for ctPR=1:length(PeakResp),
            PeakResp(ctPR).Peak = 20.*log10(PeakResp(ctPR).Peak);
         end
         SvRespObj.PeakResponseValue = PeakResp;
      end
      MagScale = 'linear';
      MagLabel = 'Singular Values (dB)';

   else, % Changing to Abs or Log
      Yscale = get(LTIdisplayAxes(1,1),'Yscale');
      if strcmpi(OldUnit,'decibels'), % Changing from Db
         for ctLines=1:length(AllYdata),
            AllYdata{ctLines} = 10.^(AllYdata{ctLines}./20);
         end
         %---Convert the Y-axis limits
         allProps.Ylims{1} = 10.^(allProps.Ylims{1}./20);

         if ~isempty(PeakResp(1).Peak),
            for ctPR=1:length(PeakResp),
               PeakResp(ctPR).Peak = 10.^(PeakResp(ctPR).Peak./20);
            end
            SvRespObj.PeakResponseValue = PeakResp;
         end
      end
      if strcmpi(SvRespObj.MagnitudeUnits,'absolute'), % Changing to Absolute
         MagScale='linear';
         MagLabel = 'Singular Values (Absolute)';
      elseif strcmpi(SvRespObj.MagnitudeUnits,'logrithmic'), % Changing to Log
         MagScale = 'log';
         MagLabel ='Singular Values (Log10)';
      end	
   end
   set(AllLines,{'Ydata'},AllYdata);
   set(LTIdisplayAxes,'Yscale',MagScale)
   set(allProps.Ylabel,'String',MagLabel);
   
   warning(WarnState)
   
end % switch type

%---Rescale the axes
set(SvRespObj,'Xlims',allProps.Xlims,'Ylims',allProps.Ylims,...
   'XlimMode',allProps.XlimMode,'YlimMode',allProps.YlimMode);

%---Check if Plot Options need to be redrawn
if strcmp(SvRespObj.PeakResponse,'on'),
   set(SvRespObj,'PeakResponse','off')
   set(SvRespObj,'PeakResponse','on')
end
