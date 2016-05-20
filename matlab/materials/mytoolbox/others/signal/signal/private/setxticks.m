function setxticks(h_axis,range,xtickFlag)
% SETXTICKS Sets the X-axis tick labels to increments of [0,pi] or [0,2pi],
%           depending on the input parameters, RANGE and XTICKFLAG.
%
%           If the XTICKFLAG is anything but 'normang' (normalized angular)
%           and HOLD ON is set, then the XTick and XTickLabel modes are set
%           back to auto.  This is necessary in case hold-on is being used
%           between calls to the functions that call this function and the 
%           new axis has greater x-axis limits.

% Inputs:
%   h_axis    - handle(s) to the axis to modify the xtick labels.
%   range     - frequency range, 'whole' or 'half', which corresponds to 
%               [0,Fs) or [0,Fs/2) respectively.
%   xtickFlag - specifies the frequency units (angular, normalized angular,
%               linear, etc.); currently only "normang" is used.

%   Author(s): P. Pacheco
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.11 $  $Date: 1998/08/25 20:28:03 $

% Tick label strings; for [0:pi], use only the first 6 strings.
labelStr = {'0';'0.2';'0.4';'0.6';'0.8';'1';...
     '1.2';'1.4';'1.6';'1.8';'2'};

% Loop thru the vector of axis handles (e.g. subplot handles).
for naxis = 1:length(h_axis),
   % Make the axis current; necessary for figures with subplots.
   ax = h_axis(naxis);
   axes(ax);

   if strcmp(xtickFlag,'normang'),
      % Normalized angular units specified for the X-axis. So, use pi
      % increments for the XTick labels and use the range [0,pi] or [0,2pi].
   
      % Set up the [0,pi] frequency range
      XTickValues    = [0 0.2*pi 0.4*pi 0.6*pi 0.8*pi pi];
      XTickLabelsStr = labelStr(1:6);
      
      if ishold,
         % Cache the x-limits of the currently held plot.
         xlim = get(ax,'xlim');
      else
         xlim = [0 pi];  
      end
      ylim = get(ax,'ylim');  % Needed for y pos of xtick labels
      
      % If the old axis limits are not within the new range [0,pi]
      % or [0,2pi] then don't set the xticklabels manually.
      changeLabFlag = 0;
      if strmatch(lower(range),'half') & (xlim(1)>=0) & (xlim(2)<=pi),
         changeLabFlag = 1;
      elseif strmatch(lower(range),'whole') & (xlim(1)>=0) & (xlim(2)<=2*pi),
         % Append (pi:2pi] xtick label information
         XTickValues = [XTickValues 1.2*pi 1.4*pi 1.6*pi 1.8*pi 2*pi];
         XTickLabelsStr = labelStr;
         changeLabFlag = 1;
      end 
      
      if changeLabFlag,
         % Set the xtick labels.
         set(ax,'XTick',XTickValues,'XTickLabel',XTickLabelsStr);
      end
   elseif ishold,
      % Assuming this function has already been called once, before the 
      % HOLD ON, and it contains XTick labels placed manually.  At this  
      % point we know that the x-axis units are not normalized angular, 
      % hence, we should set the xtickmode and xticklabelmode back to auto 
      % and delete the old XTick labels.
      set(ax,'XTickMode','auto','XTickLabelMode','auto');      
   end 
end

% [EOF] setxticks.m