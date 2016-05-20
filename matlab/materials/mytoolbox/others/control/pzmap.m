function [pout,z] = pzmap(a,b,c,d)
%PZMAP  Pole-zero map of LTI models.
%
%   PZMAP(SYS) computes the poles and (transmission) zeros of the
%   LTI model SYS and plots them in the complex plane.  The poles 
%   are plotted as x's and the zeros are plotted as o's.  
%
%   When invoked with left-hand arguments,
%      [P,Z] = PZMAP(SYS)
%   returns the poles and zeros of the system in the column vectors 
%   P and Z.  No plot is drawn on the screen.  
%
%   The functions SGRID or ZGRID can be used to plot lines of constant
%   damping ratio and natural frequency in the s or z plane.
%
%   For arrays SYS of LTI models, PZMAP plots the poles and zeros of
%   each model in the array on the same diagram.
%
%   See also POLE, ZERO, RLOCUS, SGRID, ZGRID, LTIMODELS.

%       Old syntax.
%warning(['This calling syntax for ' mfilename ' will not be supported in the future.'])
%	PZMAP(A,B,C,D) computes the eigenvalues and transmission zeros of
%	the state-space system (A,B,C,D).
%
%	PZMAP(NUM,DEN) computes the poles and zeros of the SISO polynomial
%	transfer function G(s) = NUM(s)/DEN(s) where NUM and DEN contain 
%	the polynomial coefficients in descending powers of s.  If the 
%	system has more than one output, then the transmission zeros are 
%	computed.
%
%	PZMAP(P,Z) plots the poles, P, and the zeros, Z, in the complex 
%	plane.  P and Z must be column vectors.

%	Clay M. Thompson  7-12-90
%	Revised ACWG 6-21-92, AFP 12-1-95
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.6 $  $Date: 1999/01/05 12:09:08 $

ni = nargin;
error(nargchk(2,4,ni))

switch ni
case 2
   [nd,md] = size(b);
   if (md<=1),
      % Assume Pole-Zero form
      p = a;
      z = b;
   else
      % Transfer function form
      [p,z] = pzmap(tf(a,b));
   end
case 3
   error('Wrong number of input arguments.');
case 4
   % State space system 
   [p,z] = pzmap(ss(a,b,c,d));
end

% If no output arguments then plot graph
if nargout==0,
   plot(real(p),imag(p),'x',real(z),imag(z),'o')
   
   xlabel('Real Axis')
   ylabel('Imag Axis')
   title('Pole zero map')

   % Draw real and imag axis
   ax = gca;
   ylim = get(ax,'YLim');
   ymax = max(abs(ylim));
   ylim = [-ymax ymax];
   Color = get(ax,'XColor');
   line([0 0],ylim,'LineStyle',':','Color',Color)
   xlim = get(ax,'XLim');
   xmax = max(abs(xlim));
   set(ax,'XLim',xlim,'YLim',get(ax,'YLim'))
   line([-xmax xmax],[0 0],'LineStyle',':','Color',Color)

else
   % Return output
   pout = p;   
end

% end pzmap
