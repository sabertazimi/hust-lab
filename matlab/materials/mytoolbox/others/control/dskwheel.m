function dskwheel(x0,y0,R);
%DSKWHEEL  Draw a car wheel for the ACC Benchmark schematic.
%   Subroutine called by DRAWACC.
%   Wheel is centered about (x0,y0) and has radius R.

%   Denise L. Chen, Aug. 1993.
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1999/01/05 15:21:19 $

n = 55;

% Calculate the top half arc of the circle.
x = x0-R: (2*R)/n : x0+R;
s = ones(size(x));
t = sqrt( R*R*s - (x-x0*s).^2);
y = t + y0*s;
y = real(y);    % get rid the extraneous complex part

x = [x' flipud(x')];
y = [y' flipud((2*y0-y)')];
fill(x,y,[0 0 0],'EdgeColor',[0 0 0]);
