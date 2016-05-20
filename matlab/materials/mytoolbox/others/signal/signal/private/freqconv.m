function [w,xlab,xtickflag,xlim] = freqconv(w,fs,frequency,...
   normfreq,range,convflag,return_nyquist)
%   FREQCONV Converts the input frequency vector from specified units to digital 
%            frequency or from digital frequency to desired units; depending on
%            the CONVFLAG parameter.
%  Inputs:
%    w         - frequency vector
%    fs        - sampling frequency (Hz)
%    frequency - units such as angular, linear or Hz
%    normfreq  - flag indicating whether or not the frequency vector is normalized
%    range     - string indicating whether the whole Nyquist interval is wanted or just half
%    convflag  - flag indicating which conversion should be done
%                If CONVFLAG = 'dig2freq'... FREQCONV will convert the digital 
%                frequency w = 2*pi*f/Fs, measured in [radians/sample], to the 
%                desired units as specified in the FREQUENCY parameter.
%                If CONVFLAG = 'freq2dig'... FREQCONV will convert the frequency 
%                units specified in the FREQUENCY parameter to digital frequency.
%  Outputs:
%    w         - digital frequency vector (rad/sample)
%    xlab      - X-axis label specific to the frequency units
%    xtickflag - flag used for plotting in freqz and pwelch. If this flag is
%                set to 'normang', the xticks of the plot will be multiples
%                and/or submultiples of pi.
%    xlim -    - limits of the X-axis according to the freq. units

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.15.1.2 $  $Date: 1999/01/22 03:42:29 $

% Default values
xlab = 'Normalized Angular Frequency  (rads/sample)';
xtickflag = 'normang'; % used for plotting in freqz and pwelch 
xlim = [0 1]; % Half the Nyquist interval when units are rads/sample 

% If no frequency vector is specified...
% Calculate a default digital frequency vector in rads/sample and
% then convert it to the appropriate units if necessary down below.
if length(w) == 1, % NFFT specified
   nfft = w;
   if return_nyquist,
      if strmatch(lower(range),'half'),
         w = 0:pi./(nfft-1):pi;
      elseif strmatch(lower(range),'whole'),
         w = 0:2*pi./nfft:2*pi-2*pi./nfft;
      end      
   else
      if strmatch(lower(range),'half'),
         w = 0:pi./nfft:pi-pi./nfft;
      elseif strmatch(lower(range),'whole'),
         w = 0:2*pi./nfft:2*pi-2*pi./nfft;
      end
   end
   
   xlab = 'Normalized Angular Frequency  (\times\pi rads/sample)';
end


if strmatch(lower(frequency),'linear'),
   if strmatch(lower(normfreq),'no'),
      xtickflag = 'linear'; % Not used for now
      xlim = [0 fs/2]; % Half the Nyquist interval when units are Hz
      if strmatch(convflag,'freq2dig'),
         w = 2*pi.*w./fs;       % freqvector was in Hz, convert to [rad/sample]
      elseif strmatch(convflag,'dig2freq'),
         w = w.*fs./(2*pi);    % freqvector wanted in Hz
      end   
      xlab = 'Frequency (Hz)'; % Label the x-axis correctly
   elseif strmatch(lower(normfreq),'yes'),
      xtickflag = 'normlinear'; % Not used for now
      xlim = [0 1/2]; % Half the Nyquist interval when units are cycles/sample
      if strmatch(convflag,'freq2dig'),
         w = 2*pi.*w;    % freqvector was in [cycles/sample], convert to [rad/sample]
      elseif strmatch(convflag,'dig2freq'),
         w = w./(2*pi); % freqvector wanted in [cycles/sample]
      end     
      xlab = 'Normalized Frequency (cycles/sample)'; % Label the x-axis correctly
   end
elseif strmatch(lower(frequency),'angular'),
   if strmatch(lower(normfreq),'no'),
      xtickflag = 'angular'; % Not used for now
      xlim = [0 pi*fs]; % Half the Nyquist interval when units are rads/sec
      if strmatch(convflag,'freq2dig'),
         w = w./fs; % freqvector was in [rad/sec] convert to [rad/sample]
      elseif strmatch(convflag,'dig2freq'),
         w = w.*fs; % freqvector wanted in [rad/sec]
      end 
      xlab = 'Angular Frequency (rads/sec)'; % Label the x-axis correctly
   end
end

if strmatch(lower(range),'whole'),
   xlim = 2*xlim; % Change the X-axis limits when the whole Nyquist Interval is wanted
end

% [EOF] freqconv.m
