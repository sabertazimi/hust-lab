function  [w,xlab,xtickFlag,xlim] = calcfreqvector(lenSpec,Fs,fsFlag,range)
% CALCFREQVECTOR Caculates the appropriate frequency vector depending on 
%                whether or not the user specified the sampling frequency,
%                Fs, and what frequency range was specified, [0,Fs) vs [0,Fs/2).
%
% Inputs:
%   lenSpec - length of the spectrum
%   Fs      - sampling frequency
%   range   - frequency range, 'whole' or 'half', which corresponds to 
%             [0,Fs) [0,Fs/2) respectively.
% Outputs:
%   w         - frequency vector
%   xlab      - X-axis label with appropriate frequency units
%   xtickFlag - indicates the frequency vector units
%   xlim      - limits of the X-axis according to the freq. units

%   Author(s): P. Pacheco
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3.1.2 $  $Date: 1999/01/22 03:42:29 $

% DEFAULT: Frequency vector is angular and normalized; units are in rad/sample
frequency = 'angular';
normfreq  = 'yes';

if fsFlag % Fs specified by the user
    % Frequency is linear and not normalized; units are in Hz
    frequency = 'linear';
    normfreq  = 'no';
end

% Calculate the frequency vector based on the user specified parameters.
return_nyquist = 1;
[w,xlab,xtickFlag,xlim] = freqconv(lenSpec,Fs,frequency,...
   normfreq,range,'dig2freq',return_nyquist);
w = w(:); 

% [EOF] calcfreqvector.m
