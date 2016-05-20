function g = dgram(a,b)
%DGRAM  Discrete controllability and observability gramians.
%   DGRAM(A,B) returns the discrete controllability gramian.
%   DGRAM(A',C') returns the observability gramian.
%   See also GRAM.

%   J.N. Little 9-6-86
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:21:59 $

%   Kailath, T. "Linear Systems", Prentice-Hall, 1980.
%   Laub, A., "Computation of Balancing Transformations", Proc. JACC
%     Vol.1, paper FA8-E, 1980.

g = gram(ss(a,b,[],[],-1),'c');
