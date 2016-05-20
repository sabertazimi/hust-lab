function pxxplot(methodName,P,f,range,xlab,xtickFlag,xlim,magUnits)
% PXXPLOT Plots the PSD, Pxx, for the following functions:
% - PWELCH
% - PMUSIC
% - PMTM
% 
% Inputs:
%   methodName- name of the method used for the PSD estimate.
%   P         - depending on what the user specified, this is either the spectrum
%               or the spectrum and the confidence intervals.
%   f         - frequency vector.
%   range     - frequency range, 'whole' or 'half', which corresponds to 
%               [0,Fs) [0,Fs/2) respectively.
%   xlab      - X-axis label with correct frequency units.
%   xtickFlag - specifies the frequency units.
%   xlim      - limits of the X-axis according to the freq. units
%   magUnits  - specifies the magnitude units.

%   Author(s): P. Pacheco
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.6.1.2 $  $Date: 1999/01/22 03:42:30 $

% Plot the PSD
newplot
ylab = 'Power Spectral Density';

% Determine if passing in Hz or not:
isHz = strcmp(xlab(end-3:end),'(Hz)');

% If it's normalized angular frequency divide by pi 
% because the plot's x domain is 0 to 1.
if strcmp(xtickFlag,'normang'),
   f = f./pi;
end

if strmatch(lower(magUnits),'squared'),
    mag = abs(P);
else
   mag = 10*log10(abs(P));
   if isHz,
      ylab = [ylab ' (dB/Hz)'];
   else
      ylab = [ylab ' (dB / rads/sample)'];
   end
end
h = plot(f,mag); grid on

% Adjust the x-axis limits to match the data (at least make it closer)
ax = get(h(1),'parent');
if ishold, % If hold is on use the smallest/largest x-limits
   currxlim = get(ax,'xlim');
   xlim(1) = min([currxlim(1) xlim(1)]);
   xlim(2) = max([currxlim(2) xlim(2)]);
end
set(ax,'xlim',xlim);

% Set the title, and the x- and y-label
titleStr = [methodName ' PSD Estimate'];
title(titleStr);
xlabel(xlab);
ylabel(ylab);

% [EOF] pxxplot.m
