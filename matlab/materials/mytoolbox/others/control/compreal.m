function [a,b,c,d] = compreal(num,den)
%COMPREAL  Companion realization of SIMO transfer functions
%
%   [A,B,C,D] = COMPREAL(NUM,DEN)  produces a state-space realization
%   (A,B,C,D) of the SIMO transfer function NUM/DEN with common 
%   denominator DEN (a row vector).  The numerator NUM should be a
%   PxL matrix where P is the number of outputs and L=LENGTH(DEN).
%
%   See also  TF/SS, COMPBAL.

%   Author: P. Gahinet, 5-1-96
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.5 $  $Date: 1999/01/05 15:20:35 $

% RE: This is a low-level function. No error checking!

p = size(num,1);
r = length(den);

if r==1,
   % Simple gain
   a = [];
   b = zeros(0,1);
   c = zeros(p,0);
   d = num;
else
   % Assemble the companion realization (in controller form)
   den = den(2:r);
   c = num;
   d = c(:,1);

   if ~any(c(:)), 
      % Case NUM = 0
      a = [];
      b = zeros(0,1);
      c = zeros(p,0);
   else
      a = [-den ; eye(r-2,r-1)];
      b = eye(r-1,1);
      c = c(:,2:r) - d * den;
   end

   % Balance companion form with COMPBAL
   [a,b,c] = compbal(a,b,c);
end

% end compreal

