% Control System Toolbox.
% Version 4.2 (R11)  15-Jul-1998
%
% What's new.
%   Readme      - New features and enhancements in this version.
%
% Creation of LTI models.
%   tf          - Create a transfer function model.
%   zpk         - Create a zero/pole/gain model.
%   ss          - Create a state-space model.
%   dss         - Create a descriptor state-space model.
%   frd         - Create a frequency response data model.
%   filt        - Specify a digital filter.
%   set         - Set/modify properties of LTI models.
%   ltimodels   - Detailed help on various types of LTI models.
%   ltiprops    - Detailed help on available LTI properties.
%   
% Data extraction.
%   tfdata      - Extract numerator(s) and denominator(s).
%   zpkdata     - Extract zero/pole/gain data.
%   ssdata      - Extract state-space matrices.
%   dssdata     - Descriptor version of SSDATA.
%   frdata      - Extract frequency response data.
%   get         - Access values of LTI model properties.
%
% Model dimensions and characteristics.
%   class       - Model type ('tf', 'zpk', 'ss', or 'frd').
%   isa         - Test if LTI model is of given type.
%   size        - Model sizes and order.
%   ndims       - Number of dimensions.
%   isempty     - True for empty LTI models.
%   isct        - True for continuous-time models.
%   isdt        - True for discrete-time models.
%   isproper    - True for proper LTI models.
%   issiso      - True for single-input/single-output models.
%   reshape     - Reshape array of LTI models.
%
% Conversions.
%   tf          - Conversion to transfer function.
%   zpk         - Conversion to zero/pole/gain.
%   ss          - Conversion to state space.
%   frd         - Conversion to frequency data.
%   chgunits    - Change units of FRD model frequency points.
%   c2d         - Continuous to discrete conversion.
%   d2c         - Discrete to continuous conversion.
%   d2d         - Resample discrete-time model.
%
% Overloaded arithmetic operations.
%   + and -     - Add and subtract LTI systems (parallel connection).
%   *           - Multiply LTI systems (series connection).
%   \           - Left divide -- sys1\sys2 means inv(sys1)*sys2.
%   /           - Right divide -- sys1/sys2 means sys1*inv(sys2).
%   ^           - LTI model powers.
%   '           - Pertransposition.
%   .'          - Transposition of input/output map.
%   [..]        - Concatenate LTI models along inputs or outputs.
%   stack       - Stack LTI models/arrays along some array dimension.
%   inv         - Inverse of an LTI system.
%
% Model dynamics.
%   pole, eig   - System poles.
%   zero        - System (transmission) zeros.
%   pzmap       - Pole-zero map.
%   dcgain      - D.C. (low frequency) gain.
%   norm        - Norms of LTI systems.
%   covar       - Covariance of response to white noise.
%   damp        - Natural frequency and damping of system poles.
%   esort       - Sort continuous poles by real part.
%   dsort       - Sort discrete poles by magnitude.
%
% Time delays.
%   hasdelay    - True for models with time delays.
%   totaldelay  - Total delay between each input/output pair.
%   delay2z     - Replace delays by poles at z=0 or FRD phase shift.
%   pade        - Pade approximation of time delays.
%
% State-space models.
%   rss,drss    - Random stable state-space models.
%   ss2ss       - State coordinate transformation.
%   canon       - State-space canonical forms.
%   ctrb, obsv  - Controllability and observability matrices.
%   gram        - Controllability and observability gramians.
%   ssbal       - Diagonal balancing of state-space realizations.  
%   balreal     - Gramian-based input/output balancing.
%   modred      - Model state reduction.
%   minreal     - Minimal realization and pole/zero cancellation.
%   sminreal    - Structurally minimal realization.
%
% Time response.
%   ltiview     - Response analysis GUI (LTI Viewer).
%   step        - Step response.
%   impulse     - Impulse response.
%   initial     - Response of state-space system with given initial state.
%   lsim        - Response to arbitrary inputs.
%   gensig      - Generate input signal for LSIM.
%   stepfun     - Generate unit-step input.
%
% Frequency response.
%   ltiview     - Response analysis GUI (LTI Viewer).
%   bode        - Bode plot of the frequency response.
%   sigma       - Singular value frequency plot.
%   nyquist     - Nyquist plot.
%   nichols     - Nichols chart.
%   margin      - Gain and phase margins.
%   freqresp    - Frequency response over a frequency grid.
%   evalfr      - Evaluate frequency response at given frequency.
%
% System interconnections.
%   append      - Group LTI systems by appending inputs and outputs.
%   parallel    - Generalized parallel connection (see also overloaded +).
%   series      - Generalized series connection (see also overloaded *).
%   feedback    - Feedback connection of two systems.
%   lft         - Generalized feedback interconnection (Redheffer star product).
%   connect     - Derive state-space model from block diagram description.
%
% Classical design tools.
%   rltool      - Root locus design GUI
%   rlocus      - Evans root locus.
%   rlocfind    - Interactive root locus gain determination.
%   acker       - SISO pole placement.
%   place       - MIMO pole placement.
%   estim       - Form estimator given estimator gain.
%   reg         - Form regulator given state-feedback and estimator gains.
%
% LQG design tools.
%   lqr,dlqr    - Linear-quadratic (LQ) state-feedback regulator.
%   lqry        - LQ regulator with output weighting.
%   lqrd        - Discrete LQ regulator for continuous plant.
%   kalman      - Kalman estimator.
%   kalmd       - Discrete Kalman estimator for continuous plant.
%   lqgreg      - Form LQG regulator given LQ gain and Kalman estimator.
%   augstate    - Augment output by appending states.
%
% Matrix equation solvers.
%   lyap        - Solve continuous Lyapunov equations.
%   dlyap       - Solve discrete Lyapunov equations.
%   care        - Solve continuous algebraic Riccati equations.
%   dare        - Solve discrete algebraic Riccati equations.
%
% Demonstrations.
%   ctrldemo   - Introduction to the Control System Toolbox.
%   jetdemo    - Classical design of jet transport yaw damper.
%   diskdemo   - Digital design of hard-disk-drive controller.
%   milldemo   - SISO and MIMO LQG control of steel rolling mill.
%   kalmdemo   - Kalman filter design and simulation.


%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.34 $  $Date: 1999/01/05 12:08:20 $
