function [ro,co] = zpkorder(z,p,k)
%ZPKORDER   Computes order of ZPK models
%
%   [RO,CO] = ZPKORDER(Z,P,K) compute the row-wise and
%   column-wise orders RO and CO for the ZPK models 
%   with data Z,P,K.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/18 22:34:11 $

sizes = size(k);
ro = zeros([sizes(3:end) 1 1]);
co = zeros([sizes(3:end) 1 1]);

% Loop over each model
for m=1:prod(size(ro)),
   % Gain and poles of model #m 
   km = k(:,:,m);
   pm = p(:,:,m);
   npoles = cellfun('length',pm);
   
   % Determine row-wise order
   rom = 0;
   for i=1:sizes(1),
      jdyn = find(km(i,:) & npoles(i,:));  % dynamic entries
      if length(jdyn)<2 | ~isequal(pm{i,jdyn}),
         rom = rom + sum(npoles(i,jdyn));
      else
         % Common denominator
         rom = rom + npoles(i,jdyn(1));
      end
   end
   ro(m) = rom;
   
   % Determine column-wise order
   com = 0;
   for j=1:sizes(2),
      idyn = find(km(:,j) & npoles(:,j));   % dynamic entries
      if length(idyn)<2 | ~isequal(pm{idyn,j})
         com = com + sum(npoles(idyn,j));
      else        
         % Common denominator
         com = com + npoles(idyn(1),j);
      end
   end
   co(m) = com;
end
