function NicRespObj = newunits(NicRespObj,type,OldUnit);
%NEWUNITS rescales the units on a Nichols chart
%   NEWUNITS(NicRespObj,type) rescales the units on a Nichols chart
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
   Freq = NicRespObj.Frequency;
   if strncmpi(NicRespObj.FrequencyUnits,'h',1);
      FreqFac = 1/(2*pi);
   else
      FreqFac = 2*pi;
   end
   for ct=1:length(Freq),
      for ctArray = 1:length(Freq{ct});
	   Freq{ct}{ctArray} = Freq{ct}{ctArray}.*FreqFac;
      end % for ctArray
   end % for ct
   NicRespObj.Frequency = Freq;
   
   StabMarg = NicRespObj.StabilityMarginValue;
   if ~isempty(StabMarg(1).GMFrequency),
      for ctSM=1:length(StabMarg),
         StabMarg(ctSM).GMFrequency= StabMarg(ctSM).GMFrequency*FreqFac;
         StabMarg(ctSM).PMFrequency= StabMarg(ctSM).PMFrequency*FreqFac;
      end
      NicRespObj.StabilityMarginValue = StabMarg;
   end

case 'magnitude'
   WarnState = warning;
   warning off;

   %---Store any plot options
   StabMarg = NicRespObj.StabilityMarginValue;

   if strcmpi(NicRespObj.MagnitudeUnits,'decibels'), % Changing to dB
      if ~isempty(StabMarg(1).GainMargin),
         for ctSM=1:length(StabMarg),
            StabMarg(ctSM).GainMargin = 20.*log10(StabMarg(ctSM).GainMargin);
         end
         NicRespObj.StabilityMarginValue= StabMarg;
      end

   else, % Changing to Abs or Log
      if strcmpi(OldUnit,'decibels'), % Changing from Db
         if ~isempty(StabMarg(1).GainMargin),
            for ctSM=1:length(StabMarg),
               StabMarg(ctSM).GainMargin = 10.^(StabMarg(ctSM).GainMargin./20);
            end
            NicRespObj.StabilityMarginValue= StabMarg;
	   end
      end
   end
   
   warning(WarnState)

case 'phase',
   if strcmpi(NicRespObj.PhaseUnits,'radians');
      PhFac = pi/180;
   else
      PhFac = 180/pi;
   end

   %---Convert any plot options
   StabMarg = NicRespObj.StabilityMarginValue;
   if ~isempty(StabMarg(1).PhaseMargin),
      for ctSM=1:length(StabMarg),
         StabMarg(ctSM).PhaseMargin = StabMarg(ctSM).PhaseMargin*PhFac;
      end
      NicRespObj.StabilityMarginValue = StabMarg;
   end
   
end % switch type

%---Check if Plot Options need to be redrawn
if strcmp(NicRespObj.StabilityMargin,'on'),
   set(NicRespObj,'StabilityMargin','off')
   set(NicRespObj,'StabilityMargin','on')
end

% end ../@nicplot/newunits