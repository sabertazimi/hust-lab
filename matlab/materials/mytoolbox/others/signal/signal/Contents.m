% Signal Processing Toolbox.
% Version 4.2   (R11) 10-Jul-1998
%
% What's new.
%   Readme     - New features, bug fixes, and changes in this version.
%
% Filter analysis and implementation.
%   abs        - Magnitude.
%   angle      - Phase angle.
%   conv       - Convolution.
%   fftfilt    - Overlap-add filter implementation.
%   filter     - Filter implementation.
%   filtfilt   - Zero-phase version of filter.
%   filtic     - Determine filter initial conditions.
%   freqs      - Laplace transform frequency response.
%   freqspace  - Frequency spacing for frequency response.
%   freqz      - Z-transform frequency response.
%   grpdelay   - Group delay.
%   impz       - Impulse response (discrete).
%   latcfilt   - Lattice filter implementation.
%   sgolayfilt - Savitzky-Golay filter implementation.
%   sosfilt    - Second-order sections (biquad) filter implementation.
%   unwrap     - Unwrap phase.
%   upfirdn    - Up sample, FIR filter, down sample.
%   zplane     - Discrete pole-zero plot.
%
% FIR filter design.
%   convmtx    - Convolution matrix.
%   cremez     - Complex and nonlinear phase equiripple FIR filter design.
%   fir1       - Window based FIR filter design - low, high, band, stop, multi.
%   fir2       - Window based FIR filter design - arbitrary response.
%   fircls     - Constrained Least Squares filter design - arbitrary response.
%   fircls1    - Constrained Least Squares FIR filter design - low and highpass.
%   firls      - FIR filter design - arbitrary response with transition bands.
%   firrcos    - Raised cosine FIR filter design.
%   intfilt    - Interpolation FIR filter design.
%   kaiserord  - Window based filter order selection using Kaiser window.
%   remez      - Parks-McClellan optimal FIR filter design.
%   remezord   - Parks-McClellan filter order selection.
%   sgolay     - Savitzky-Golay FIR smoothing filter design.
%
% IIR digital filter design.
%   butter     - Butterworth filter design.
%   cheby1     - Chebyshev type I filter design.
%   cheby2     - Chebyshev type II filter design.
%   ellip      - Elliptic filter design.
%   maxflat    - Generalized Butterworth lowpass filter design.
%   yulewalk   - Yule-Walker filter design.
%
% IIR filter order selection.
%   buttord    - Butterworth filter order selection.
%   cheb1ord   - Chebyshev type I filter order selection.
%   cheb2ord   - Chebyshev type II filter order selection.
%   ellipord   - Elliptic filter order selection.
%
% Analog lowpass filter prototypes.
%   besselap   - Bessel filter prototype.
%   buttap     - Butterworth filter prototype.
%   cheb1ap    - Chebyshev type I filter prototype (passband ripple).
%   cheb2ap    - Chebyshev type II filter prototype (stopband ripple).
%   ellipap    - Elliptic filter prototype.
%
% Frequency translation.
%   lp2bp      - Lowpass to bandpass analog filter transformation.
%   lp2bs      - Lowpass to bandstop analog filter transformation.
%   lp2hp      - Lowpass to highpass analog filter transformation.
%   lp2lp      - Lowpass to lowpass analog filter transformation.
%
% Filter discretization.
%   bilinear   - Bilinear transformation with optional prewarping.
%   impinvar   - Impulse invariance analog to digital conversion.
%
% Linear system transformations.
%   latc2tf    - Lattice or lattice ladder to transfer function conversion.
%   residuez   - Z-transform partial fraction expansion.
%   sos2ss     - Second-order sections to state-space conversion.
%   sos2tf     - Second-order sections to transfer function conversion.
%   sos2zp     - Second-order sections to zero-pole conversion.
%   ss2sos     - State-space to second-order sections conversion.
%   ss2tf      - State-space to transfer function conversion.
%   ss2zp      - State-space to zero-pole conversion.
%   tf2latc    - Transfer function to lattice or lattice ladder conversion.
%   tf2sos     - Transfer Function to second-order sections conversion.
%   tf2ss      - Transfer function to state-space conversion.
%   tf2zp      - Transfer function to zero-pole conversion.
%   zp2sos     - Zero-pole to second-order sections conversion.
%   zp2ss      - Zero-pole to state-space conversion.
%   zp2tf      - Zero-pole to transfer function conversion.
%
% Windows.
%   bartlett   - Bartlett window.
%   blackman   - Blackman window.
%   boxcar     - Rectangular window.
%   chebwin    - Chebyshev window.
%   hamming    - Hamming window.
%   hanning    - Hanning window.
%   kaiser     - Kaiser window.
%   triang     - Triangular window.
%
% Transforms.
%   czt        - Chirp-z transform.
%   dct        - Discrete cosine transform.
%   dftmtx     - Discrete Fourier transform matrix.
%   fft        - Fast Fourier transform.
%   fftshift   - Swap vector halves.
%   hilbert    - Hilbert transform.
%   idct       - Inverse discrete cosine transform.
%   ifft       - Inverse fast Fourier transform.
%
% Statistical signal processing and spectral analysis.
%   cohere     - Coherence function estimate.
%   corrcoef   - Correlation coefficients.
%   cov        - Covariance matrix.
%   csd        - Cross Spectral Density.
%   pcov       - Power Spectrum estimate via Covariance method.
%   peig       - Power Spectrum estimate via the Eigenvector method.
%   pmcov      - Power Spectrum estimate via the Modified Covariance method.
%   pburg      - Power Spectrum estimate via Burg's method.
%   pmtm       - Power Spectrum estimate via the Thomson multitaper method.
%   pmusic     - Power Spectrum estimate via MUSIC method.
%   pyulear    - Power Spectrum estimate via the Yule-Walker AR Method.
%   pwelch     - Power Spectrum estimate via Welch's method.
%   spectrum   - psd, csd, cohere and tfe combined.
%   tfe        - Transfer function estimate.
%   xcorr      - Cross-correlation function.
%   xcov       - Covariance function.
%
% Parametric modeling.
%   arburg     - AR parametric modeling via Burg's method.
%   arcov      - AR parametric modeling via covariance method.
%   armcov     - AR parametric modeling via modified covariance method.
%   aryule     - AR parametric modeling via the Yule-Walker method.
%   ident      - See the System Identification Toolbox.
%   invfreqs   - Analog filter fit to frequency response.
%   invfreqz   - Discrete filter fit to frequency response.
%   prony      - Prony's discrete filter fit to time response.
%   stmcb      - Steiglitz-McBride iteration for ARMA modeling.
%
% Linear Prediction.
%   ac2rc      - Autocorrelation sequence to reflection coefficients conversion. 
%   ac2poly    - Autocorrelation sequence to prediction polynomial conversion.
%   is2rc      - Inverse sine parameters to reflection coefficients conversion.
%   lar2rc     - Log area ratios to reflection coefficients conversion.
%   levinson   - Levinson-Durbin recursion.
%   lpc        - Linear Predictive Coefficients using autocorrelation method.
%   lsf2poly   - Line spectral frequencies to prediction polynomial conversion.
%   poly2ac    - Prediction polynomial to autocorrelation sequence conversion. 
%   poly2lsf   - Prediction polynomial to line spectral frequencies conversion.
%   poly2rc    - Prediction polynomial to reflection coefficients conversion.
%   rc2ac      - Reflection coefficients to autocorrelation sequence conversion.
%   rc2is      - Reflection coefficients to inverse sine parameters conversion.
%   rc2lar     - Reflection coefficients to log area ratios conversion.
%   rc2poly    - Reflection coefficients to prediction polynomial conversion.
%   rlevinson  - Reverse Levinson-Durbin recursion.
%
% Waveform generation.
%   chirp      - Swept-frequency cosine generator.
%   diric      - Dirichlet (periodic sinc) function.
%   gauspuls   - Gaussian pulse generator.
%   pulstran   - Pulse train generator.
%   rectpuls   - Sampled aperiodic rectangle generator.
%   sawtooth   - Sawtooth function.
%   sinc       - Sinc or sin(pi*x)/(pi*x) function
%   square     - Square wave function.
%   tripuls    - Sampled aperiodic triangle generator.
%
% Audio support.
%   auread     - Read NeXT/SUN (".au") sound file.
%   auwrite    - Write NeXT/SUN (".au") sound file.
%   sound      - Play vector as sound.
%   soundsc    - Autoscale and play vector as sound.
%   wavplay    - Play sound using Windows audio output device.
%   wavread    - Read Microsoft WAVE (".wav") sound file.
%   wavrecord  - Record sound using Windows audio input device.
%   wavwrite   - Write Microsoft WAVE (".wav") sound file.
%
% Specialized operations.
%   cceps      - Complex cepstrum.
%   decimate   - Resample data at a lower sample rate.
%   deconv     - Deconvolution.
%   demod      - Demodulation for communications simulation.
%   dpss       - Discrete prolate spheroidal sequences (Slepian sequences). 
%   dpssclear  - Remove discrete prolate spheroidal sequences from database.
%   dpssdir    - Discrete prolate spheroidal sequence database directory.
%   dpssload   - Load discrete prolate spheroidal sequences from database.
%   dpsssave   - Save discrete prolate spheroidal sequences in database.
%   interp     - Resample data at a higher sample rate.
%   interp1    - General 1-D interpolation. (MATLAB Toolbox)
%   medfilt1   - 1-Dimensional median filtering.
%   modulate   - Modulation for communications simulation.
%   rceps      - Real cepstrum and minimum phase reconstruction.
%   resample   - Resample sequence with new sampling rate.
%   specgram   - Spectrogram, for speech signals.
%   spline     - Cubic spline interpolation.
%   vco        - Voltage controlled oscillator.
%
% Other.
%   besself    - Bessel analog filter design.
%   buffer     - Buffer a signal vector into a matrix of data frames.
%   conv2      - 2-D convolution.
%   cplxpair   - Order vector into complex conjugate pairs.
%   fft2       - 2-D fast Fourier transform.
%   ifft2      - Inverse 2-D fast Fourier transform.
%   polystab   - Polynomial stabilization.
%   seqperiod  - Find minimum-length repeating sequence in a vector.
%   stem       - Plot discrete data sequence.
%   strips     - Strip plot.
%   xcorr2     - 2-D cross-correlation.
%
% See also SIGGUI, SIGDEMOS.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.13 $ $Date: 1998/09/21 02:23:06 $

