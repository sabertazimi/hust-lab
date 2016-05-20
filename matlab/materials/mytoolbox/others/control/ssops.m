function [a,b,c,d,e,nx]=ssops(op,a1,b1,c1,d1,e1,nx1,a2,b2,c2,d2,e2,nx2)
%SSOPS  Centralized function for basic operations on state-space 
%       models.
%
%   [A,B,C,D,E,NX] =  
%        SSOPS('operation',A1,B1,C1,D1,E1,NX1,A2,B2,C2,D2,E2,NX2)
%
%   LOW-LEVEL UTILITY.

%	Pascal Gahinet  5-9-97
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.5.1.2 $  $Date: 1999/01/05 12:09:15 $

% RE: No dimension checking + assumes empty matrices
%     correctly dimensioned

% Determine resulting array dimensions
s1 = size(d1);
s2 = size(d2);
nsys1 = prod(s1(3:end));
nsys2 = prod(s2(3:end));
if length(s1)>=length(s2),
   ArraySizes = s1(3:end);
else
   ArraySizes = s2(3:end);
end   

% Set state dimensions
if isempty(nx1),
   nx1 = size(a1,1);
end
if isempty(nx2),
   nx2 = size(a2,1);
end
nx = nx1+nx2;
nxmax = max(nx(:));

% Pre-allocate A 
a = zeros([nxmax nxmax ArraySizes]);

% Perform operation
switch op, 
case 'add'
   % Addition (parallel)
   b = zeros([nxmax s1(2) ArraySizes]); 
   c = zeros([s1(1) nxmax ArraySizes]);
   d = zeros([s1(1:2) ArraySizes]);
   
   for k=1:prod(ArraySizes),
      k1 = min(k,nsys1);
      k2 = min(k,nsys2);
      na1 = nx1(min(k,end));
      na2 = nx2(min(k,end));
      na = na1+na2;
      a(1:na,1:na,k) = blkdiag(a1(1:na1,1:na1,k1),a2(1:na2,1:na2,k2));
      b(1:na,:,k) = [b1(1:na1,:,k1) ; b2(1:na2,:,k2)];
      c(:,1:na,k) = [c1(:,1:na1,k1) , c2(:,1:na2,k2)];
      d(:,:,k) = d1(:,:,k1) + d2(:,:,k2);
   end
   
case 'mult'
   % Multiplication (series sys1*sys2)
   %     [ a1  b1*c2 ]       [ b1*d2 ]
   % A = [  0    a2  ]   B = [   b2  ]
   %
   % C = [ c1  d1*c2 ]   D =  d1*d2
   %
   b = zeros([nxmax s2(2) ArraySizes]); 
   c = zeros([s1(1) nxmax ArraySizes]);
   d = zeros([s1(1) s2(2) ArraySizes]);
   
   for k=1:prod(ArraySizes),
      k1 = min(k,nsys1);
      k2 = min(k,nsys2);
      na1 = nx1(min(k,end));
      na2 = nx2(min(k,end));
      na = na1+na2;
      b1k = b1(1:na1,:,k1);
      c2k = c2(:,1:na2,k2);
      d2k = d2(:,:,k2);
      a(1:na,1:na,k) = ...
         [a1(1:na1,1:na1,k1)  ,  b1k * c2k ; ...
            zeros(na2,na1)  ,  a2(1:na2,1:na2,k2)];
      b(1:na,:,k) = [b1k * d2k  ;  b2(1:na2,:,k2)];
      c(:,1:na,k) = [c1(:,1:na1,k1)  ,  d1(:,:,k1) * c2k];
      d(:,:,k) = d1(:,:,k1) * d2k;
   end

case 'append'
   % Appending
   b = zeros([nxmax s1(2)+s2(2) ArraySizes]); 
   c = zeros([s1(1)+s2(1) nxmax ArraySizes]);
   d = zeros([s1(1:2)+s2(1:2) ArraySizes]);
   
   for k=1:prod(ArraySizes),
      k1 = min(k,nsys1);
      k2 = min(k,nsys2);
      na1 = nx1(min(k,end));
      na2 = nx2(min(k,end));
      na = na1+na2;
      a(1:na,1:na,k) = ...
         blkdiag(a1(1:na1,1:na1,k1),a2(1:na2,1:na2,k2));
      b(1:na,:,k) = ...
         blkdiag(b1(1:na1,:,k1),b2(1:na2,:,k2));
      c(:,1:na,k) = ...
         blkdiag(c1(:,1:na1,k1),c2(:,1:na2,k2));
      d(:,:,k) = blkdiag(d1(:,:,k1),d2(:,:,k2));
   end

case 'vcat'
   % Vertical concatenation
   %     [ a1  0 ]       [ b1 ]
   % A = [  0 a2 ]   B = [ b2 ]
   %
   %     [ c1  0 ]       [ d1 ]
   % C = [  0 c2 ]   D = [ d2 ]
   %
   b = zeros([nxmax max(s1(2),s2(2)) ArraySizes]); 
   c = zeros([s1(1)+s2(1) nxmax ArraySizes]);
   d = zeros([s1(1)+s2(1) max(s1(2),s2(2)) ArraySizes]);
   
   for k=1:prod(ArraySizes),
      k1 = min(k,nsys1);
      k2 = min(k,nsys2);
      na1 = nx1(min(k,end));
      na2 = nx2(min(k,end));
      na = na1+na2;
      a(1:na,1:na,k) = ...
         blkdiag(a1(1:na1,1:na1,k1),a2(1:na2,1:na2,k2));
      b(1:na,:,k) = [b1(1:na1,:,k1) ; b2(1:na2,:,k2)];
      c(:,1:na,k) = ...
         blkdiag(c1(:,1:na1,k1),c2(:,1:na2,k2));
      d(:,:,k) = [d1(:,:,k1) ; d2(:,:,k2)];
   end
 
case 'hcat'

   % Horizontal concatenation
   %     [ a1  0 ]       [ b1  0 ]
   % A = [  0 a2 ]   B = [  0 b2 ]
   %
   % C = [ c1 c2 ]   D = [ d1 d2]
   %
   b = zeros([nxmax s1(2)+s2(2) ArraySizes]); 
   c = zeros([max(s1(1),s2(1)) nxmax ArraySizes]);
   d = zeros([max(s1(1),s2(1)) s1(2)+s2(2) ArraySizes]);
   
   for k=1:prod(ArraySizes),
      k1 = min(k,nsys1);
      k2 = min(k,nsys2);
      na1 = nx1(min(k,end));
      na2 = nx2(min(k,end));
      na = na1+na2;
      a(1:na,1:na,k) = ...
         blkdiag(a1(1:na1,1:na1,k1),a2(1:na2,1:na2,k2));
      b(1:na,:,k) = ...
         blkdiag(b1(1:na1,:,k1),b2(1:na2,:,k2));
      c(:,1:na,k) = [c1(:,1:na1,k1) , c2(:,1:na2,k2)];
      d(:,:,k) = [d1(:,:,k1) , d2(:,:,k2)];
   end

end


% Set E matrix
if size(e1,1)+size(e2,1)==0,
   e = zeros([0 0 ArraySizes]);
else
   e = zeros([nxmax nxmax ArraySizes]);
   for k=1:prod(ArraySizes),
      k1 = min(k,nsys1);
      k2 = min(k,nsys2);
      ne1 = nx1(min(k,end));
      ne2 = nx2(min(k,end));
      ne = ne1+ne2;
      e(1:ne,1:ne,k) = ...
         blkdiag(e1(1:ne1,1:ne1,k1),e2(1:ne2,1:ne2,k2));
   end
end


