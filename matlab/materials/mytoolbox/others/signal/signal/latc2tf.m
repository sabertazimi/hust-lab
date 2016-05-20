function [num,den]=LATC2TF(K,V)
%LATC2TF Lattice filter to transfer function conversion.
%   [NUM,DEN] = LATC2TF(K,V) finds the transfer function numerator
%   NUM and denominator DEN from the IIR lattice coefficients K and
%   ladder coefficients V.
%
%   [NUM,DEN] = LATC2TF(K,'iir') assumes that K is associated with an
%   all-pole IIR lattice filter.
%
%   NUM = LATC2TF(K,'fir') and NUM = LATC2TF(K) find the transfer
%   function numerators from the FIR lattice coefficients specified by K.
%
%   See also LATCFILT AND TF2LATC.

% Reference:[1] J.G. Proakis, D.G. Manolakis, Digital Signal Processing,
%            3rd ed., Prentice Hall, N.J., 1996, Chapter 7.
%           [2] S. K. Mitra, Digital Signal Processing, A Computer
%           Based Approach, McGraw-Hill, N.Y., 1998, Chapter 6.
%
%   Author(s): D. Orofino, 5-6-93
%   Modified by R. Losada, 7-16-98, changed the code for the IIR case
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/09/03 19:51:27 $

error(nargchk(1,2,nargin));

% Handle empty cases immediately:
if isempty(K) | ( (nargin>1) & ~isstr(V) & isempty(V) ),
  num=[]; den=[]; return
end
% Parse input args:
if nargin>1,
  if isstr(V),
    switch(lower(V))
    case 'iir'
      lattice_type = 1;  % IIR
      V=1;               % Default ladder coeff
    case 'fir'
      lattice_type = 0;  % FIR
    otherwise
      error('Lattice type must be ''fir'' or ''iir''.');
    end
  else
    lattice_type = 1;    % IIR
  end
else
  lattice_type = 0;      % FIR
end

% Handle FIR case:
if lattice_type == 0,
  num = rc2poly(K);
  den = 1;
  return;
end

% Solve for IIR lattice or lattice-ladder coefficients:
K=K(:); V=V(:);

% Make sure V is length(K)+1:
ordiff = length(V)-length(K)-1;
if ordiff>0,
  K = [K; zeros(ordiff,1)];
  % error('length(V) must be <= 1+length(K).');
elseif ordiff<0,
  V = [V; zeros(-ordiff,1)];
end

% We still use rc2poly to compute the den
den = rc2poly(K);

% To compute the num coefficients we solve the equations (see [2] pp. 384):
% num(end)   = V(1)
% num(end-1) = V(2) + conj(den(1))*V(1)
% num(end-2) = V(3) + conj(den(1)#)*V(2) + conj(den(2))*V(1)
% num(end-3) = V(4) + conj(den(1)##)*V(3) + conj(den(2)#)*V(2) + conj(den(3))*V(1)
% etc.
% where den(m)# denotes the mth coefficient of the reduced (using levdown)
% order polynomial; den(m)## denotes the mth coefficient of the 2 step reduced (using levdown twice)
% order polynomial; etc.
% Note that these equations are the same used for finding V in tf2latc, except
% we are solving for den instead of for V. In the present case, no recursive
% solution is needed.

% We will use a matrix with the denominators of lower orders
% in each column, this matrix is the same as the one used in tf2latc
[r,tempmatrix] = rlevinson(den,1);
num = tempmatrix*V;
num = num.'; % it is a polynomial, make it a row



