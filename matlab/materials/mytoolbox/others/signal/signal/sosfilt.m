function y = sosfilt(SOS,X)
%SOSFILT Second order (biquadradic) IIR filtering.
%   SOSFILT(SOS, X) filters the data in vector X with the second-order 
%   section (SOS) filter described by the matrix B.  The coefficients
%   of the SOS matrix must be expressed using an Lx6 second-order 
%   section matrix where L is the number of second-order sections.
%   If X is a matrix, SOSFILT will filter along the columns of X.
%
%   SOSFILT uses a direct form II implementation to perform the filtering.
%
%   The SOS matrix should have the following form:
%
%   SOS = [ b01 b11 b21 a01 a11 a21
%           b02 b12 b22 a02 a12 a22
%           ...
%           b0L b1L b2L a0L a1L a2L ]
%
%   See also LATCFILT, FILTER, TF2SOS, SS2SOS, ZP2SOS, SOS2TF, SOS2SS, SOS2ZP.

%   Author(s): R. Firtion
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1998/09/03 19:44:32 $

[m,n]=size(SOS);
if (m<1) | (n~=6),
	cr=sprintf('\n');
	error(['Size of SOS matrix must be Mx6.' ...
    cr 'See "zp2sos" or "ss2sos" for details.']);
end
      
h = SOS(:,[5 6 1:3]);
for i=1:size(h,1),
	h(i,:)=h(i,:)./SOS(i,4);  % Normalize by a0
    h(i,[1 2]) = -h(i,[1 2]); % [-a1 -a2 b0 b1 b2]
end
h=h.';
y = sosfiltmex(h,X);
