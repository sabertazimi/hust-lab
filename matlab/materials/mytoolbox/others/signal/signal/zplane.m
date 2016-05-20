function [h1, h2, h3]=zplane(z,p,ax);
%ZPLANE Z-plane zero-pole plot.
%   ZPLANE(Z,P) plots the zeros Z and poles P (in column vectors) with the 
%   unit circle for reference.  Each zero is represented with a 'o' and 
%   each pole with a 'x' on the plot.  Multiple zeros and poles are 
%   indicated by the multiplicity number shown to the upper right of the 
%   zero or pole.  ZPLANE(Z,P) where Z and/or P is a matrix plots the zeros
%   or poles in different columns with different colors.
%
%   ZPLANE(B,A) where B and A are row vectors containing transfer function
%   polynomial coefficients plots the poles and zeros of B(z)/A(z).  Note
%   that if B and A are both scalars they will be interpreted as Z and P.
%
%   [H1,H2,H3]=ZPLANE(Z,P) returns vectors of handles to the lines and 
%   text objects generated.  H1 is a vector of handles to the zeros lines, 
%   H2 is a vector of handles to the poles lines, and H3 is a vector of 
%   handles to the axes / unit circle line and to text objects which are 
%   present when there are multiple zeros or poles.  In case there are no 
%   zeros or no poles, H1 or H2 is set to the empty matrix [].
%
%   ZPLANE(Z,P,AX) puts the plot into axes AX.
%
%   See also FREQZ.

%   Author(s): T. Krauss, 3-19-93
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/12/23 22:37:03 $

error(nargchk(1,3,nargin))

tf = 0; % By default assume inputs are poles and zeros
prodsz = prod(size(z)); 
colsz = size(z,2);
switch nargin,
case 1,   
   % Only Z was specified, check if it is indeed Z or if it is a numerator
   if (prodsz==colsz)&(~(prodsz == 1)),
      % Row vector, num specified
      p = 1;
      tf = 1; % Set TF flag
   else
      % Scalar or column vector, interpret as Z
      p = [];
   end
case 2,
   prodsp = prod(size(p));
   colsp = size(p,2);
   if xor(prodsz == 1,prodsp == 1),
      % One of the inputs is a scalar but not both,
      if (prodsz==colsz)&(prodsp==colsp),
         % The other input is a row, TF specified
         tf = 1; % Set TF flag
      end
   elseif ~((prodsz == 1)&(prodsp == 1)),
      % No scalars specified
      if (prodsz==colsz)&(prodsp==colsp),
         % num and den specified
         tf = 1; % Set TF flag
      elseif (prodsz==colsz)|(prodsp==colsp),
         % A row vector was specified with a column vector, this is not allowed
         error('When specifying polynomials, both vectors must be rows.');
      end
   end
end

if tf == 1,
   % TF was specified, convert to z,p,k
   
   % Catch cases when the num or den are zero.
   if max(abs(p)) == 0,
      % Divide by zero not allowed
      error('Denominator cannot be zero.');
   elseif max(abs(z)) == 0,
      % num is zero, there are no poles
      p = 1;
   end
   
   % Pad A or B with trailing zeros if B and A are of different length
   if length(z) < length(p)
      z = [z zeros(1,length(p)-length(z))];
   elseif length(p) < length(z)
      p = [p zeros(1,length(z)-length(p))];
   end
   
   % Remove trailing zeros if both num and den have them
   while z(end) == 0 & p(end) == 0,
      z(end) = [];
      p(end) = [];
   end
    
   % Find Poles and Zeros
   z = roots(z);
   p = roots(p);
end

if ~any(imag(z)),
   z = z + j*1e-50;
end;
if ~any(imag(p)),
   p = p + j*1e-50;
end;

if nargin < 3
   ax = newplot;
else
   axes(ax)
end

kids = get(ax,'Children');
for i = 1:length(kids)
   delete(kids(i));
end
set(ax,'box','on')
set(ax,'xlimmode','auto','ylimmode','auto')
% equivalent of 'hold on':
set(ax,'nextplot','add')
set(get(ax,'parent'),'nextplot','add')

if ~isempty(z),
   zh = plot(z,'o','markersize',7); 
else
   zh = []; 
end
if ~isempty(p),
   ph = plot(p,'x','markersize',8); 
else
   ph = []; 
end

theta = linspace(0,2*pi,70);
oh = plot(cos(theta),sin(theta),':');

% inline 'axis equal'
units = get(ax,'Units'); set(ax,'Units','Pixels')
apos = get(ax,'Position'); set(ax,'Units',units)
set(ax,'DataAspectRatio',[1 1 1],...
   'PlotBoxAspectRatio',apos([3 4 4]))

%  zoom out ever so slightly (5%)

if apos(3) < apos(4)
   yl=get(ax,'ylim');
   d=diff(yl);
   yl = [yl(1)-.05*d  yl(2)+.05*d]; 
   set(ax,'ylim',yl);
   xl = get(ax,'xlim');
else
   xl=get(ax,'xlim');
   d=diff(xl);
   xl = [xl(1)-.05*d  xl(2)+.05*d]; 
   set(ax,'xlim',xl); 
   yl = get(ax,'ylim');
end

set(oh,'xdat',[get(oh,'xdat') NaN ...
      xl(1)-diff(xl)*100 xl(2)+diff(xl)*100 NaN 0 0]);
set(oh,'ydat',[get(oh,'ydat') NaN 0 0 NaN ...
      yl(1)-diff(yl)*100 yl(2)+diff(yl)*100]);

handle_counter = 2;	
fuzz = diff(xl)/80; % horiz spacing between 'o' or 'x' and number
fuzz=0;
[r,c]=size(z);
if (r>1)&(c>1),  % multiple columns in z
   ZEE=z;
else
   ZEE=z(:); c = min(r,c);
end;
for which_col = 1:c,      % for each column of ZEE ...
   z = ZEE(:,which_col);
   [mz,z_ind]=mpoles(z);
   for i=2:max(mz),
      j=find(mz==i);
      for k=1:length(j),
         x = real(z(z_ind(j(k)))) + fuzz;
         y = imag(z(z_ind(j(k))));
         if (j(k)~=length(z)),
            if (mz(j(k)+1)<mz(j(k))),
               oh(handle_counter) = text(x,y,num2str(i)); 
               handle_counter = handle_counter + 1;
            end
         else
            oh(handle_counter) = text(x,y,num2str(i));
            handle_counter = handle_counter + 1;
         end
      end
   end
end
[r,c]=size(p);
if (r>1)&(c>1),  % multiple columns in z
   PEE=p;
else
   PEE=p(:); c = min(r,c);
end;
for which_col = 1:c,      % for each column of PEE ...
   p = PEE(:,which_col);
   [mp,p_ind]=mpoles(p);
   for i=2:max(mp),
      j=find(mp==i);
      for k=1:length(j),
         x = real(p(p_ind(j(k)))) + fuzz;
         y = imag(p(p_ind(j(k))));
         if (j(k)~=length(p)),
            if (mp(j(k)+1)<mp(j(k))),
               oh(handle_counter) = text(x,y,num2str(i)); 
               handle_counter = handle_counter + 1;
            end
         else
            oh(handle_counter) = text(x,y,num2str(i));
            handle_counter = handle_counter + 1;
         end
      end
   end
end
set(oh(2:length(oh)),'vertical','bottom');

if (nargout==1),
   h1 = zh;
elseif (nargout==2),
   h1 = zh;
   h2 = ph;
elseif (nargout==3),
   h1 = zh;
   h2 = ph;
   h3 = oh;
end

set(get(ax,'xlabel'),'string','Real Part')
set(get(ax,'ylabel'),'string','Imaginary Part')
set(ax,'nextplot','replace')
set(get(ax,'parent'),'nextplot','replace')
