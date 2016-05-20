function [xlim,ylim] = axesrloc(vec)
%AXESRLOC Outputs axes limits given a complex vector input.
%       [XLim,YLim] = AXESRLOC(VEC) generates axes limits.
%
%       See also: ROCUS and RLOCFIND.

%       Author(s): A. Potvin, 12-1-93
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1997/12/01 22:05:03 $

if isempty(vec),
   xlim = [-1 1];
   ylim = [-1 1];
   return
end
rvec = real(vec);
ivec = imag(vec);
xlim = [floor(min(rvec)) ceil(max(rvec))];

% Force YLim to be symmetric around zero
ylim = max(abs(ivec));

% Define parameter for extra room on graph
Extra = 0.3;

% Notice: Limits will always be integers
% At very least, xlim and ylim must be as wide as [-1 1]

%---Check if xlim(1)==xlim(2), true if all Poles/zeros have same real part
diffX = diff(xlim);
if ~diffX,
   diffX=abs(xlim(1));
end

xlim = xlim + Extra*[-1 1]*diffX;
xlim = [min(floor(xlim(1)),-1) max(ceil(xlim(2)),1)];
ylim = ceil((1+Extra)*ylim)*[-1 1];
ylim = [min(ylim(1),-1) max(ylim(2),1)];

% end axesrloc
