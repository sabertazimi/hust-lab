function [K,V]=TF2LATC(num,den)
%TF2LATC Transfer function to lattice filter conversion.
%   [K,V] = TF2LATC(NUM,DEN) finds the lattice parameters K and the ladder
%   parameters V for an IIR (ARMA) lattice-ladder filter, normalized by
%   DEN(1).  Note that an error will be generated if any poles of the
%   transfer function lie on the unit circle.
%
%   K = TF2LATC(1,DEN) finds the lattice parameters K for an IIR
%   all-pole (AR) lattice filter.  [K,V] = TF2LATC(1,DEN) returns
%   a scalar ladder coefficient V.
%
%   K = TF2LATC(NUM) finds the lattice parameters K for an FIR (MA)
%   lattice filter, normalized by NUM(1).
%
%   See also LATC2TF, LATCFILT, POLY2RC and RC2POLY.

% Reference:[1] S. K. Mitra, Digital Signal Processing, A Computer
%           Based Approach, McGraw-Hill, N.Y., 1998, Chapter 6.
%           [2] M. H. Hayes, Statistical Digital Signal Processing
%           and Modeling, John Wiley & Sons, N.Y., 1996, Chapter 6.
%
%   Author(s): R. Losada, 7-14-98
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1998/07/17 17:42:21 $

% Convert an all-pole IIR model to lattice coefficients:
%            DEN = [1 13/24 5/8 1/3];
%            K = tf2latc(1,DEN);  % K will be [1/4 1/2 1/3]'
%

error(nargchk(1,2,nargin));

num = num(:);

switch nargin,
case 1,
   % FIR filter, simply call poly2rc
   K = poly2rc(num);
   V = [];
case 2,
   den = den(:);
   % First make sure leading coefficient of den is 1
   den = den ./ den(1);
   num = num ./ den(1);
   if length(num) == 1,
      % All-pole filter, simply call poly2rc
      K = poly2rc(den);
      V = [num;zeros(size(K))];
   elseif length(den) == 1,
      % FIR filter, simply call poly2rc
      K = poly2rc(num);
      V = [];
   else,
      % IIR filter
      % Make sure num and den are the same length:
      ordiff = length(den)-length(num);
      if ordiff>=0,
         num = [num;zeros(ordiff,1)];
      else
         den = [den;zeros(-ordiff,1)];
      end
      M = length(den);
      
      % We still use poly2rc to compute the K's
      K = poly2rc(den);
      % Compute the V's recursively
      % We compute the following recursion: (see Hayes, pp.306)
      %                     M-1
      % V(m) = num(M-m+1) - sum V(j)* conj(den_j(j-m))
      %                     j=m+1
      % where den_j is the denominator of jth order, the lower
      % order denominators are found using the levdown function.
      
      % We wiil use a matrix with the denominators of lower orders
      % in each column, rlevinson returns this matrix
      [r,tempmatrix] = rlevinson(den,1);
      V = zeros(M,1); % Initialize V with zeros.
      for m = M:-1:1,
         subterm = tempmatrix*V;
         V(m) = num(m) - subterm(m);
      end
   end
end

   
   