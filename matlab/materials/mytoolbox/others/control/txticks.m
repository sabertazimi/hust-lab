function [xticks,pow10] = txticks(Tf,Nu)
%TXTICKS  Generate x-axis tick marks for time response plots
%
%   [XTICKS,POW10] = TXTICKS(TF,NU) generates ticks marks
%   for the time axis given the final time TF and the number 
%   NU of displayed input channels.  The tick mark data
%   consists of:
%     * values XTICKS to be printed on the time axis
%       (start at 0, ends at Tf)
%     * scale factor POW10 (to be displayed as "x 10^POW10"
%       when POW10 is a nonzero value)

%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.5 $

% Assumes that TF was formatted by TCHOP

% Retrieve factors Tf = x * 10^y with 10<x<=100
y = ceil(log10(Tf))-2;  
y10 = 10^y;
x = round(Tf/y10);

% Determine ticks based on number of inputs
switch Nu,
case 1
   if x<=50 & rem(x,5)==0,
      xticks = 0:5:x;
   elseif rem(x,6)==0,
      xticks = (x/6)*(0:1:6);
   elseif rem(x,5)==0,
      xticks = (x/5)*(0:1:5);
   else
      xticks = (x/4)*(0:1:4);
   end

case 2
   % Max number of intervals = 4
   if rem(x,3)==0,
      xticks = (x/3)*(0:1:3);
   else
      % Round to closest multiple of 2 (from below)
      x = 2*floor(x/2);
      xticks = (x/4)*(0:1:4);
   end

case 3
   % Max number of intervals = 3
   if rem(x,3)==0,
      xticks = (x/3)*(0:1:3);
   else
      % Round to closest multiple of 2 (from below)
      x = 2*floor(x/2);
      if rem(x,3)==0,
         xticks = (x/3)*(0:1:3);
      else
         xticks = (x/2)*(0:1:2);
      end
   end
  
otherwise
   % Two or one interval
   if Nu<8,
      % Round to closest multiple of 2
      x = 2*floor(x/2);
      xticks = [0 x/2 x];
   else
      xticks = [0 x];
   end

end

% Use scale factor when at least one tick mark has more than
% four digits, e.g., 12000 or 0.0125
abst = xticks * y10;  % absolute tick values
if abst(end)>=1e4 | any(mod(abst,0.001)),
   % Use power-of-10 scale factor and force tick marks to
   % integer values
   if any(mod(xticks,1)), 
      xticks = 10 * xticks;   pow10 = y-1;
   else
      pow10 = y;
   end

else
   xticks = abst;
   pow10 = 0;

end

% end txticks
