function dispdelay(L,k,offset)
%DISPDELAY  Displays time delays

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/07/16 20:07:54 $

if ~hasdelay(L),
   return
end

% Input delays
id = L.InputDelay(:,:,min(k,end));
if any(id),
   disp([offset 'Input delays (listed by channel): ' sprintf('%0.3g  ',id')])
end

% Output delays
od = L.OutputDelay(:,:,min(k,end));
if any(od),
   disp([offset 'Output delays (listed by channel): ' sprintf('%0.3g  ',od')])
end

% I/O delays
iod = L.ioDelayMatrix(:,:,min(k,end));
if any(iod(:)),
   if all(iod(:)==iod(1))
      disp(sprintf('%sI/O delay time (for all I/O pairs): %0.5g',offset,iod(1)))
   else
      disp([offset 'I/O delays:'])
      siod = evalc('disp(iod)');
      disp(siod(1:end-2))
   end
end

disp(' ')