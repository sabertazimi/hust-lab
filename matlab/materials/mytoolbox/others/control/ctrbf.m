function [abar,bbar,cbar,t,k] = ctrbf(a, b, c, tol)
%CTRBF  Controllability staircase form.
%
%   [ABAR,BBAR,CBAR,T,K] = CTRBF(A,B,C) returns a decomposition
%   into the controllable/uncontrollable subspaces.
%
%   [ABAR,BBAR,CBAR,T,K] = CTRBF(A,B,C,TOL) uses tolerance TOL.
%
%   If Co=CTRB(A,B) has rank r <= n, then there is a similarity
%   transformation T such that
%
%   Abar = T * A * T' ,  Bbar = T * B ,  Cbar = C * T'
%
%   and the transformed system has the form
%
%          | Anc    0 |           | 0 |
%   Abar =  ----------  ,  Bbar =  ---  ,  Cbar = [Cnc| Cc].
%          | A21   Ac |           |Bc |
%                                              -1          -1
%   where (Ac,Bc) is controllable, and Cc(sI-Ac)Bc = C(sI-A)B.
%
%   See also  CTRB, OBSVF.

%   Author : R.Y. Chiang  3-21-86
%   Revised 5-27-86 JNL
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.5 $  $Date: 1999/01/05 15:20:40 $

% This M-file implements the Staircase Algorithm of Rosenbrock, 1968.
[ra,ca] = size(a);
[rb,cb] = size(b);
%
% ------ Assign Initial Conditions :
%
ptjn1 = eye(ra);
ajn1 = a;
bjn1 = b;
rojn1 = cb;
deltajn1 = 0;
sigmajn1 = ra;
k = zeros(1,ra);
if nargin == 3
    tol = ra*norm(a,1)*eps;
end
%
% ------ Begin Major Loop :
%
for jj = 1 : ra
    [uj,sj,vj] = svd(bjn1);
    [rsj,csj] = size(sj);
    p = rot90(eye(rsj),1);
    uj = uj*p;
    bb = uj'*bjn1;
    roj = rank(bb,tol);
    [rbb,cbb] = size(bb);
    sigmaj = rbb - roj;
    sigmajn1 = sigmaj;
    k(jj) = roj;
    if roj == 0, break, end
    if sigmaj == 0, break, end
    abxy = uj' * ajn1 * uj;
    aj   = abxy(1:sigmaj,1:sigmaj);
    bj   = abxy(1:sigmaj,sigmaj+1:sigmaj+roj);
    ajn1 = aj;
    bjn1 = bj;
    [ruj,cuj] = size(uj);
    ptj = ptjn1 * ...
          [uj zeros(ruj,deltajn1); ...
           zeros(deltajn1,cuj) eye(deltajn1)];
    ptjn1 = ptj;
    deltaj = deltajn1 + roj;
    deltajn1 = deltaj;
end
%
% ------ Final Transformation :
%
t = ptjn1';
abar = t * a * t';
bbar = t * b;
cbar = c * t';
