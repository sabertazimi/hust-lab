function [a,g]=lpc(h,N);
%LPC  Linear Predictor Coefficients.
%   A = LPC(X,N) finds the coefficients, A=[ 1 A(2) ... A(N+1) ],
%   of an Nth order forward linear predictor
%
%      Xp(n) = -A(2)*X(n-1) - A(3)*X(n-2) - ... - A(N+1)*X(n-N)
%
%   such that the sum of the squares of the errors
%
%      err(n) = X(n) - Xp(n)
%
%   is minimized.  X can be a vector or a matrix.  If X is a matrix
%   containing a separate signal in each column, LPC returns a model
%   estimate for each column in the rows of A. N specifies the order
%   of the polynomial A(z).
%
%   If you do not specify a value for N, LPC uses a default N = length(X)-1.
%
%   In calculating the linear prediction coefficients the same Yule-Walker
%   equations are solved as in the auto regressive modeling problem via the
%   Yule-Walker method.  Hence, the vector A above contains the same
%   polynomial coefficients as the polynomial coefficients calculated via
%   the Yule-Walker method.
%
%                        const
%       ---------------------------------------
%         1 + A(2)z^(-1) + ... + A(N+1)z^(-N)
%
%   is an auto-regressive model of the moving-average filter
%
%      X(1) + X(2)z^(-1) + ... + X(M)z^(-M+1)
%
%   where M=length(X).
%
%   See also LEVINSON, ARYULE, PRONY, STMCB.

%   R is the auto correlation vector, R(1) = E(conj(h(t))*h(t)), 
%   	R(2) = E(conj(h(t+1))*h(t)),...

%   Author(s): T. Krauss, 9-21-93
%   Modified:  T. Bryan 11-14-97
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 1998/08/07 18:50:57 $

    error(nargchk(1,2,nargin))

    [r,c] = size(h);
    if (c>1)&(r==1)
        h = h(:);
    end
    numsigs = size(h,2);
    if nargin<2, N = size(h,1)-1; end
    if (N>size(h,1)-1),
        % disp('Warning: zero-padding short input sequence')
        h(N+1,:)=zeros(1,numsigs);
    end

    R = flipud(fftfilt(conj(h),flipud(h)));
    % R is the autocorrelation vector.  
    % Equivalent code (for the single signal case):
    %   R = xcorr(h);
    %   M = length(h);
    %   R(1:M-1) = [];

    a = levinson(R,N);
    g = sqrt(real( sum((a').*R(1:N+1,:))));
