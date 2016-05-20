function NyRespObj = newunits(NyRespObj,type,OldUnit);
%NEWUNITS rescales the units on a Nyquist diagram
%   NEWUNITS(NyRespObj,type) rescales the units on a Nyquist Diagram
%   response located on a figure window or in the LTI Viewer. NEWUNITS
%   should only be called from the SET command for Nyquist diagram objects.
%
%   "type" may be: 1) 'frequency', 2) 'phase', or 3) 'magnitude'
%
%   For 'magnitude' a third input argument must be entered which states
%   the last units the magnitude was plotted in.
% $Revision: 1.3 $

%   Karen Gondoly, 3-27-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

switch type
   
case 'frequency'
   Freq = NyRespObj.Frequency;
   if strncmpi(NyRespObj.FrequencyUnits,'h',1);
      FreqFac = 1/(2*pi);
   else
      FreqFac = 2*pi;
   end
   for ct=1:length(Freq),
      for ctArray = 1:length(Freq{ct});
	   Freq{ct}{ctArray} = Freq{ct}{ctArray}.*FreqFac;
      end % for ctArray
   end % for ct
   NyRespObj.Frequency = Freq;
   
   StabMarg = NyRespObj.StabilityMarginValue;
   if ~isempty(StabMarg(1).GMFrequency),
      for ctSM=1:length(StabMarg),
         StabMarg(ctSM).GMFrequency= StabMarg(ctSM).GMFrequency*FreqFac;
         StabMarg(ctSM).PMFrequency= StabMarg(ctSM).PMFrequency*FreqFac;
      end
      NyRespObj.StabilityMarginValue = StabMarg;
   end

case 'magnitude'
   WarnState = warning;
   warning off;

   %---Store any plot options
   StabMarg = NyRespObj.StabilityMarginValue;

   if strcmpi(NyRespObj.MagnitudeUnits,'decibels'), % Changing to dB
      if ~isempty(StabMarg(1).GainMargin),
         for ctSM=1:length(StabMarg),
            StabMarg(ctSM).GainMargin = 20.*log10(StabMarg(ctSM).GainMargin);
         end
         NyRespObj.StabilityMarginValue= StabMarg;
      end

   else, % Changing to Abs or Log
      if strcmpi(OldUnit,'decibels'), % Changing from Db
         if ~isempty(StabMarg(1).GainMargin),
            for ctSM=1:length(StabMarg),
               StabMarg(ctSM).GainMargin = 10.^(StabMarg(ctSM).GainMargin./20);
            end
            NyRespObj.StabilityMarginValue= StabMarg;
	   end
      end
   end
   
   warning(WarnState)

case 'phase',
   if strcmpi(NyRespObj.PhaseUnits,'radians');
      PhFac = pi/180;
   else
      PhFac = 180/pi;
   end

   %---Convert any plot options
   StabMarg = NyRespObj.StabilityMarginValue;
   if ~isempty(StabMarg(1).PhaseMargin),
      for ctSM=1:length(StabMarg),
         StabMarg(ctSM).PhaseMargin = StabMarg(ctSM).PhaseMargin*PhFac;
      end
      NyRespObj.StabilityMarginValue = StabMarg;
   end
   
end % switch type

%---Check if Plot Options need to be redrawn
if strcmp(NyRespObj.StabilityMargin,'on'),
   set(NyRespObj,'StabilityMargin','off')
   set(NyRespObj,'StabilityMargin','on')
end

% end ../@nyplot/newunits