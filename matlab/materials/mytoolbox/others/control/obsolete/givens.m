function g = givens(x,y)
%GIVENS Givens rotation matrix.
%   G = GIVENS(x,y) returns the complex Givens rotation matrix
%
%       | c       s |                  | x |     | r | 
%   G = |           |   such that  G * |   |  =  |   |
%           |-conj(s) c |                  | y |     | 0 |
%                                   
%   where c is real, s is complex, and c^2 + |s|^2 = 1. 
 
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:22:26 $

absx = abs(x);
if absx == 0.0
    c = 0.0; s = 1.0;
else
    nrm = norm([x y]);
    c = absx/nrm;
    s = x/absx*(conj(y)/nrm);
end
g = [c s;-conj(s) c];
