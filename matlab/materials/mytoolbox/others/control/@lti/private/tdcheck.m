function Td = tdcheck(Td)
%TDCHECK  Collapses the I/O delay matrix TD into 2D array
%         when all model have identical delays

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/03/16 21:13:31 $

if ndims(Td)>2,
   dvar = diff(Td(:,:,:),1,3);
   if ~any(dvar(:)),
      Td = Td(:,:,1);
   end
end
