function [a,b,c,d] = sioreal(zero,pole,gain)
%SIOREAL  State-space realization of SIMO or MISO ZPK model.

%   Author: P. Gahinet, 5-1-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/18 22:34:10 $

[ny,nu] = size(gain);
d = gain;

% Compute realization for subset of non-static entries
dyn = (gain~=0 & cellfun('length',pole)~=0);
idyn = find(dyn);

if length(idyn)==0,
   % Static gain
   a = [];
   b = zeros(0,nu);
   c = zeros(ny,0);
   return
   
elseif length(idyn)<2 | isequal(pole{idyn}),
   % Common denominator for entries with dynamics
   [a,bdyn,cdyn,ddyn] = comden(gain(idyn),zero(idyn),pole{idyn(1)});
   
else
   % Entry-by-entry realization
   a = [];   bdyn = [];   cdyn = [];   ddyn = [];
   if nu==1,
      catop = 'vcat';
   else
      catop = 'hcat';
   end
   
   for k=idyn(:)',
      [ak,bk,ck,dk] = comden(gain(k),zero(k),pole{k});
      [a,bdyn,cdyn,ddyn] = ...
         ssops(catop,a,bdyn,cdyn,ddyn,[],[],ak,bk,ck,dk,[],[]);
   end
end

% Expand realization to include entries w/o dynamics
na = size(a,1);
if nu==1,
   c = zeros(ny,na);
   c(dyn,:) = cdyn;
   b = bdyn;
else
   b = zeros(na,nu);
   b(:,dyn) = bdyn;
   c = cdyn;
end
d(dyn) = ddyn;

