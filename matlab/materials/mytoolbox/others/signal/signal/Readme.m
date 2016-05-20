% README file for the Signal Processing Toolbox.
% Version 4.2   (R11) 10-Jul-1998
%
%
% List of changes:
%
% NOTE: Items marked with '*' have changed in a way which might affect 
%       your code.
%
% FIXES
% ~~~~~
%    latc2tf
%    tf2latc
%       - Now convert back and forth correctly.
%    pburg
%       - Now works correctly in the complex case.
%    sos2zp
%       - Now handles delays in filters correctly. For example:
%         sos=[0 1 0 1 2 0]; [z,p,k]=sos2zp(sos); previously returned:
%         z=0, p=[0;-2], k=0; and now returns z=[], p=-2, k=1.
%    xcorr
%       - Now no longer returns a small imaginary part for the zero lag
%         autocorrelation of complex data. 
%    zp2sos
%       - Now handles delays in filters correctly. For example:
%         b=[0 2]; a=[1 1/2]; [z,p,k]=tf2zp(b,a); sos=zp2sos(z,p,k);
%         previously returned: [2.0000 0 0 1.0000 0.5000 0] and now
%         returns: [0 2.0000 0 1.0000 0.5000 0].
% 
%
% ENHANCEMENTS
% ~~~~~~~~~~~~
%    detrend
%         Now ships with MATLAB; in the toolbox/matlab/datafun directory.
%    firrcos
%       - Now allows you to specify either a bandwidth or a roll-off factor.
%       - Now allows the design of either a normal or a square root raised 
%         cosine filter.
%       - Now allows a user setable variable delay of the impulse response.
%       - Now accepts a window parameter in the filter design. 
%    levinson 
%       - Now is a CMEX function.
%    pburg
%    pmtm
%    pmusic
%    pyulear
%       * Now, when no Fs is specified, these functions return the PSD estimate,
%         Pxx(w), as a function of normalized angular frequency, 
%         w=2*pi*f/Fs[rads/samp].  If Fs is specified, they return the psd 
%         estimate as a function of physical frequency, f [Hz]. Fs defaults to 
%         1 Hz.  These functions now correctly scale the psd by the sampling 
%         frequency, for linear frequency, or 2*Pi, for normalized, angular 
%         frequency.  In addition they now return the single-sided PSD for real 
%         signals and the double-sided PSD for complex signals.
%         
%         NOTE: The old versions of these files (pburg, pmtm, pmusic, and pyulear)
%               are available from the MathWorks's ftp site (ftp.mathworks.com)in
%               the Technical Support area.
%
%         Note that the new functions pcov, pmcov and pwelch also adhere to
%         the specifications listed above.
%    poly2rc
%       - Now also returns the zero lag autocorrelation, when called with an
%         optional second input argument, the final prediction error.
%    rc2poly
%       * Now returns a column vector.
%       - Now also returns the final prediction error, when called with an 
%         optional second input argument, the zero lag autocorrelation.
%    sos2ss
%    sos2tf
%    sos2zp
%       - Now allow for a optional second input argument, the gain returned
%         by the functions that convert to SOS (ss2sos, tf2sos and zp2sos).
%    ss2sos
%    zp2sos
%       * Now have an extra output argument corresponding to the gain of the
%         second-order sections structure. Furthermore, an extra input
%         argument can be given to specify the desired scaling of the 
%         structure. Scaling choices are: infinity-norm, 2-norm and none.
%
% NEW FUNCTIONS
% ~~~~~~~~~~~~~
%    ac2poly    
%       - Autocorrelation sequence to prediction polynomial conversion.
%    ac2rc
%       - Autocorrelation sequence to reflection coefficients conversion. 
%    arburg
%       - AR parametric modeling via Burg's method.
%    arcov
%       - AR parametric modeling via covariance method.
%    armcov
%       - AR parametric modeling via modified covariance method.
%    aryule
%       - AR parametric modeling via the Yule-Walker method.
%    buffer
%       - Buffer a signal vector into a matrix of data frames.
%    is2rc
%       - Inverse sine parameters to reflection coefficients conversion.
%    lar2rc
%       - Log area ratios to reflection coefficients conversion.
%    lsf2poly
%       - Line spectral frequencies to prediction polynomial conversion.
%    pcov
%       - Power Spectrum estimate via Covariance method.
%    peig
%       - Power Spectrum estimate via the Eigenvector method.
%    pmcov
%       - Power Spectrum estimate via the Modified Covariance method.
%    poly2ac
%       - Prediction polynomial to autocorrelation sequence conversion.
%    poly2lsf
%       - Prediction polynomial to line spectral frequencies conversion.
%    pwelch
%       - Power Spectrum estimate via the Welch's modified periodogram method.
%    rc2ac
%       - Reflection coefficients to autocorrelation sequence conversion.
%    rc2is
%       - Reflection coefficients to inverse sine parameters conversion.
%    rc2lar
%       - Reflection coefficients to log area ratios conversion.
%    rlevinson
%       - Reverse Levinson-Durbin Recursion.
%    seqperiod
%       - Find minimum-length repeating sequence in a vector.
%    sgolay
%       - Design a Savitzky-Golay smoothing filter.
%    sgolaydemo
%       - Demonstrates Savitzky-Golay filtering.
%    sgolayfilt
%       - Filter a signal with a Savitzky-Golay smoothing filter.
%    sosfilt
%       - Filter a signal using second-order sections (biquad).
%    tf2sos
%       - Transfer Function to second-order sections conversion.
%    wavplay
%       - Play sound using Windows audio output device.
%    wavrecord
%       - Record sound using Windows audio input device.
%
% GRAPHICAL USER INTERFACE
% ~~~~~~~~~~~~~~~~~~~~~~~~
%   SPTOOL          - Now loads a default session upon starting.  Loading a default
%                     session is an option that is set via SPTool's preferences.
%   SIGNAL BROWSER  - Printing with preview is now possible.
%   FILTER DESIGNER - Added a Pole/Zero Editor as a new filter design method.
%   SPECTRUM VIEWER - Added the Covariance Method and the Modified Covariance Method.
%                   * Removed the Maximum Entropy Method (MEM).
%                   * Welch's method now calls PWELCH instead of PSD.  Since PWELCH 
%                     does not provide a detrending option and it scales the PSD
%                     magnitude by 1/Fs, the scale by 1/Fs option has been
%                     removed along with the detrending option.
%                   * The BURG and YULE AR methods now scale the PSD magnitude by 1/Fs.
%                   * The option to specify an autocorrelation matrix to the Yule AR 
%                     method has been removed since it's not part of the Yule AR 
%                     method definition.
%                   - Printing with preview is now possible.

% -----------------------------------------------------------------------------
% README file for the Signal Processing Toolbox.
% Version 4.1   21-Nov-1997
%
% List of changes:
%
% * NOTE: Items marked with * have changed in a way which might affect your 
%         code!
%
% FIXES
% ~~~~~
%   cremez
%       * Results structure fixes:  RES.H is now the actual frequency
%         response on the frequency grid returned by RES.fgrid.  RES.fextr
%         was wrong and has been corrected.  RES.fgrid and RES.fextr are
%         now normalized correctly with 1 corresponding to half the
%         sampling frequency.
%       - The problem where cremez would return a complex filter when it
%         was supposed to return a real filter has been fixed.
%
%  invfreqz
%  invfreqs
%       - Now both work for complex filters.
%
%  levinson
%  lpc
%  xcorr
%       * Incorrectly returned conjugate for complex cases.
%
%
% ENHANCEMENTS
% ~~~~~~~~~~~~
%    hamming
%    hanning
%    blackman
%       - now accept two new parameters to describe window sampling:
%         'symmetric' or 'periodic'; passing in an empty matrix now returns
%         an empty matrix; passing in one point returns unity.
%
%
% NEW FUNCTIONS
% ~~~~~~~~~~~~~
%    pburg   
%       - power spectrum estimate using Burg's method.
%    pyulear 
%       - power spectrum estimate using Yule-Walker AR method.
%
% GRAPHICAL USER INTERFACE
% ~~~~~~~~~~~~~~~~~~~~~~~~
%   SPTOOL          - Support for importing component structures from the
%                     MATLAB command line was added.
%   FILTER DESIGNER - The Filter Designer was completely redesigned.  It has
%                     a better interface and now it's extensible.
%                     Measurements of the filter design can be viewed as
%                     the filter is designed.  It also allows the overlay
%                     of spectra.  
%   FILTER VIEWER   - Now supports the viewing (overlaying) of multiple
%                     filters. Measurement rulers were added.
%   SPECTRUM VIEWER - The following new PSD methods were added: Burg, FFT
%                     and Yule-Walker AR.
%

% -----------------------------------------------------------------------------
% README file for the Signal Processing Toolbox.
% Version 4.0.1   04-Apr-1997
%
% This version contains fixes to bugs and a few enhancements in the GUI and 
% functions.  The full Readme file for version 4.0 is included below.
%
% List of changes:
%
% * NOTE: Items marked with * have changed in a way which might affect your 
%         code!
%
%   chebwin 
%       - Supports even length windows.
%       - Gives more accurate side-lobe heights especially when R is small 
%         (< ~20 dB).
%       * This improvement will cause your results to change where you use the 
%         Chebyshev window (especially when R is small).
%   cremez 
%       - Allows for LGRID grid density input to improve exactness of the
%         filter design in some cases.
%       - Returns a few more results in the RES structure output.
%   dpss 
%       * Always computes Slepian sequences directly, returning more accurate 
%         (and slightly different) results for large N.
%       - Uses MEX-file based algorithm which is much faster than in ver 4.0.  
%       - Can return any range of the N sequences, not just the first 2*NW. 
%   impinvar
%       - Now works for multiple poles. 
%   lpc
%       * Now calculates the correct gain G based on a biased autocorrelation.
%        The gain factor is now 1/sqrt(length(X)) times the previous gain
%        factor.
%   pmem
%       - The default for Fs is changed to 2, to be consistent with other 
%         spectral estimation routines.  
%       * This change will affect your plots if you use the second output 
%         argument to this function without specifying Fs on input.
%   prony
%       * Now works correctly for complex inputs.
%   remez
%       - Is now a "function-function", which allows you to write a function 
%         that defines the desired frequency response.  This feature is 
%         completely backwards compatible but allows greater flexibility in 
%         designing filters with arbitrary frequency responses.  See the 
%         remez.m M-file for details about how to do this.  
%       - Now takes an LGRID grid density input to improve exactness of the 
%         filter design.  By increasing this parameter your filter may be more 
%         exactly equiripple but will take longer to design.  
%       - A bug in filters which have very short bands in relation to the 
%         filter length is fixed.
%       - Now optionally returns the maximum error, extremal frequencies, 
%         frequency grid, and other results in a RES structure (like cremez).
%   resample
%       - For all combinations of signal length, P, Q, and filter length, the 
%         output length is now exactly ceil(N*P/Q) where N is the input signal
%         length.  For some short signals and filters the length was too 
%         small.
%   sptool
%       - Now works with 0 and 1 length signals and filters.
%       - Allows for non-evenly spaced power spectrum data (imported only).
%       - Minor appearance / layout improvements to buttons, popupmenus, etc.
%       - Now remembers last location of save, export, and import from disk 
%         operations.
%       - Fills in '.mat' when you type in a MAT-file name with no extension
%         when importing from disk into SPTool.
%       - Limits the number of popupmenu items to 24 in the "Selection" area of
%         Signal Browser and Spectrum Viewer.
%       - Saves Preferences on disk only at end of SPTool session.
%
% ----------------------------------------------------------------------------
% README file for the Signal Processing Toolbox.
% Version 4.0  15-Nov-1996
% 
% The README FILE
% This file contains a list of bug fixes, enhancements, and new features in
% the Signal Processing Toolbox since version 3.0.  There is also an important 
% section highlighting changes which might affect the behavior of any m-files
% that you have which use the Toolbox.
% 
% Use help on any of these files for more information.
% 
% BUG FIXES
%   butter, cheby1 - Exact zeros and numerator polynomials for analog case.
%   buttord, cheb1ord, cheb2ord, ellipord - The minimum filter order was 
%     incorrectly overestimated for some bandstop filters.  This has been
%     corrected. 
%   decimate - Uses a lower order Chebyshev anti-aliasing filter in case
%     the default 8th order filter is bogus.  Prevents problems when using
%     very high decimation factors.  See the help for more information.
%   impinvar - The filter is now scaled by 1/Fs.  This causes the magnitude
%     response of the discrete filter to match that of the analog filter.
%   rc2poly - Modified to correctly deal with complex inputs.
%   remez, firls - The coefficients in the differentiator case are now correct
%     so that when applied to a signal the output is the correct sign.
%   remez - The maximum number of iterations was increased from 25 to 250 to 
%     prevent the design of non-equiripple filters.  Also seg faults are now
%     avoided in the case of a large number of bands and a short filter.
% 
% ENHANCEMENTS TO OLD FUNCTIONS
%   cceps - New output parameter for keeping track of rotation applied before
%     FFT, useful in inversion.
%   fftfilt - Support for multiple filters.
%   fir1 - Now works for multiple band filters (in addition to low, high, 
%     band-pass and band-stop filters).  New 'noscale' option to prevent 
%     scaling of response after windowing.
%   firls - No matrix inversion when full band is specified.  This makes the
%     design of these filters much more efficient.
%   levinson - Support has been added for complex inputs, and multiple column 
%     input.
%   lpc - Support has been added for complex and multiple column inputs.  Also, 
%     the gain is now output for the AR estimates.
%   remezord - Cell array output with 'cell' option for convenience.
%   resample - Uses upfirdn and is MUCH faster when q (the decimation factor) 
%     is larger than one.  Also, resample is now vectorized to work on the
%     columns of a signal matrix.
%   specgram - Works on a set of specified frequencies using either czt or 
%     upfirdn.
%   strips - New scaling parameter allows control of the vertical height of
%     the strips. 
%   psd, csd - Chi-squared confidence intervals have been added.
%   xcorr, xcov - Option for computing the correlation at a specified number 
%     of lags.
% 
% NEW FUNCTIONS
%   SIGNAL GENERATION
%     chirp      - Swept-frequency cosine generator.
%     gauspuls   - Gaussian pulse generator.
%     pulstran   - Pulse train generator.
%     rectpuls   - Sampled aperiodic rectangle generator.
%     tripuls    - Sampled aperiodic triangle generator.
%     
%   FILTER DESIGN
%     cremez - FIR filter design which minimizes the complex Chebyshev error
%       to design arbitrary, including non-linear phase and complex, FIR
%       filters.
%     fircls, fircls1 - Constrained Least-Squares algorithm for minimizing
%       LS error subject to maximum ripple constraints. 
%     firrcos - Raised cosine FIR filter design from frequency domain 
%       specifications for communications applications.
%     kaiserord - Order estimation formula for finding the minimum
%       order FIR Kaiser windowed filter to meet a set of frequency
%       domain specifications.
%     maxflat - Maximally flat IIR and symmetric FIR lowpass filter design.
%       Also known as generalized Butterworth filters.  
%   
%   MULTIRATE FILTER BANKS
%     upfirdn - MEX-file implementing upsampling, FIR filtering, and 
%       downsampling using an efficient multirate implementation.
%       Algorithm supports multiple signals and/or multiple filters.
%   
%   LATTICE FILTER SUPPORT
%     latc2tf, tf2latc  - Conversion of lattice (or lattice/ladder) 
%       coefficients to and from transfer function form.
%     latcfilt - Fast MEX implementation of lattice and lattice/ladder filters.
%     
%   SPECTRAL ANALYSIS
%     pmem - PSD estimate using Maximum Entropy method.
%     pmusic - PSD estimate using MUSIC algorithm.
%     pmtm - PSD and confidence intervals using Multiple-taper method.
%     dpss - Discrete Prolate Spheroidal sequences (Slepian sequences).
%     dpsssave, dpssload, dpssdir, dpssclear - DPSS data base for storing
%       long sequences.
% 
%   OTHER
%     icceps - inverse Complex Cepstrum.
%     
% NEW - GRAPHICAL USER INTERFACE (GUI) TOOLS
% 
%   SPTOOL - graphical environment for analyzing and manipulating Signals, 
%     Filters, and Spectra.  You manage and keep track of these objects in 
%     the SPTool figure, and bring up client tools for more detailed 
%     analysis.  The client tools are:
%
%     SIGNAL BROWSER  - Interactive signal browsing allows display, measurement,
%                       and analysis of signals.
%     FILTER VIEWER   - Graphical tool for viewing the magnitude & phase 
%                       response, group delay, zeros & poles, impulse response, 
%                       and step response of a digital filter.
%     FILTER DESIGNER - filter design tool for designing lowpass, highpass, 
%                       bandpass and bandstop filters to meet a frequency 
%                       domain attenuation criterion.
%     SPECTRUM VIEWER - Graphical analysis of frequency domain data using 
%                       different methods of spectral estimation. 
%   
%  ************************************************************************
%  *** WARNING !!! ***
%  The following functions have been fixed or enhanced in a way that might
%  affect your existing code.  
%
%     csd      - default detrending mode changed to 'none'.
%              - confidence intervals have changed.
%     cohere   - default detrending mode changed to 'none'.
%     psd      - default detrending mode changed to 'none'
%              - confidence intervals have changed.
%     tfe      - default detrending mode changed to 'none'.
%     resample - uses upfirdn for efficiency.  The output of this function
%        will differ from previous versions in two cases:
%        i) Zero-order hold.   
%           Previously the output was purely causal, now returns the nearest 
%           sample.
%        ii) Input filter with even filter length.
%           Sometimes would error out.  Now will always work accurately, 
%           but give slightly different output.
%     impinvar - filter now scaled by 1/Fs for correct scaling of magnitude
%                response.
%     remez, firls - differentiators have changed sign - need to remove
%       minus sign from your code where you use this filter.
%
% Use HELP on these files or TYPE them for more information.

%  Copyright (c) 1988-98 by The MathWorks, Inc.
%  $Revision: 1.18.1.2 $  $Date: 1999/01/22 03:42:30 $


  
