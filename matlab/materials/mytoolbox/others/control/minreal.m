function [am,bm,cm,dm] = minreal(a,b,c,d,tol)
%MINREAL  Minimal realization and pole-zero cancellation.
%
%   MSYS = MINREAL(SYS) produces, for a given LTI model SYS, an
%   equivalent model MSYS where all cancelling pole/zero pairs
%   or non minimal state dynamics are eliminated.  For state-space 
%   models, MINREAL produces a minimal realization MSYS of SYS where 
%   all uncontrollable or unobservable modes have been removed.
%
%   MSYS = MINREAL(SYS,TOL) further specifies the tolerance TOL
%   used for pole-zero cancellation or state dynamics elimination. 
%   The default value is TOL=SQRT(EPS) and increasing this tolerance
%   forces additional cancellations.
%
%   For a state-space model SYS=SS(A,B,C,D),
%      [MSYS,U] = MINREAL(SYS)
%   also returns an orthogonal matrix U such that (U*A*U',U*B,C*U') 
%   is a Kalman decomposition of (A,B,C). 
%
%   See also SMINREAL, BALREAL, MODRED.

%Old help
%MINREAL Minimal realization and pole-zero cancellation.
%   [Am,Bm,Cm,Dm] = MINREAL(A,B,C,D) returns a minimal realization
%   of the state-space system {A,B,C,D}.  A message is displayed 
%   indicating the number of states removed.
%   [Am,Bm,Cm,Dm] = MINREAL(A,B,C,D,TOL) uses the tolerance TOL
%   in deciding which states to eliminate.
%
%   [Zm,Pm] = MINREAL(Z,P), where Z and P are column vectors
%   containing poles and zeros, cancels the common roots that
%   are within TOL = 10*SQRT(EPS)*ABS(Z(i)) of each other.
%   [Zm,Pm] = MINREAL(Z,P,TOL) uses tolerance TOL.
%
%   For transfer functions, [NUMm,DENm] = MINREAL(NUM,DEN), where
%   NUM and DEN are row vectors of polynomial coefficients, cancels
%   the common roots in the polynomials.
%   [NUMm,DENm] = MINREAL(NUM,DEN,TOL) uses tolerance TOL.

%   J.N. Little 7-17-86
%   Revised A.C.W.Grace 12-1-89
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.7 $  $Date: 1999/01/05 12:08:53 $

%disp(' ')

if nargin == 2 | nargin == 3
    z = a;
    p = b;
    [mz,nz] = size(z);
    [mp,np] = size(p);
    if (mz == 1) & (mp == 1)
        % If transfer function, convert to zero-pole:
        [z,p,k] = tf2zp(z,p);
    end

    % Strip infinities from zeros and throw away.
    z = z(finite(z));

    mz = length(z);
    mp = length(p);
    iz = ones(mz,1);

    % Loop through zeros, looking for matching poles:
    for i=1:mz
        zi = z(i);
        if (nargin == 2)
            tol = 10*abs(zi)*sqrt(eps);
        else
            tol=c;
        end
        kk = find(abs(p-zi) <= tol);
        if all(size(kk))
            p(kk(1)) = [];
            iz(i) = 0;
        end
    end

    % Eliminate matches in zeros:
    z = z(logical(iz));

    % If transfer function, convert back.
    if (nz > 1) | (np > 1)
        [z,p] = zp2tf(z,p,k);
    end
    am = z;
    bm = p;
    disp([int2str(mz-sum(iz)),' pole-zero(s) cancelled'])
    return
end

% Do state-space case
[ns,nu] = size(b);
if nargin == 4
    tol = 10*ns*norm(a,1)*eps;
end
[am,bm,cm,t,k] = ctrbf(a,b,c,tol);
kk = sum(k);
nu = ns - kk;
nn = nu;
am = am(nu+1:ns,nu+1:ns);
bm = bm(nu+1:ns,:);
cm = cm(:,nu+1:ns);
ns = ns - nu;
if ns
    [am,bm,cm,t,k] = obsvf(am,bm,cm,tol);
    kk = sum(k);
    nu = ns - kk;
    nn = nn + nu;
    am = am(nu+1:ns,nu+1:ns);
    bm = bm(nu+1:ns,:);
    cm = cm(:,nu+1:ns);
end
disp([int2str(nn),' state(s) removed'])
dm = d;
