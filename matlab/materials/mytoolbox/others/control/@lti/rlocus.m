function [rout,kout] = rlocus(sys,k)
%RLOCUS  Evans root locus.
%
%   RLOCUS(SYS) computes and plots the root locus of the single-input,
%   single-output LTI model SYS.  The root locus plot is used to 
%   analyze the negative feedback loop
%
%                     +-----+
%         ---->O----->| SYS |----+---->
%             -|      +-----+    |
%              |                 |
%              |       +---+     |
%              +-------| K |<----+
%                      +---+
%
%   and shows the trajectories of the closed-loop poles when the feedback 
%   gain K varies from 0 to Inf.  RLOCUS automatically generates a set of 
%   positive gain values that produce a smooth plot.  
%
%   RLOCUS(SYS,K) uses a user-specified vector K of gains.
%
%   [R,K] = RLOCUS(SYS) or R = RLOCUS(SYS,K) returns the matrix R
%   of complex root locations for the gains K.  R has LENGTH(K) columns
%   and its j-th column lists the closed-loop roots for the gain K(j).  
%
%   See also RLTOOL, RLOCFIND, POLE, ISSISO, LTIMODELS.

%   J.N. Little 10-11-85
%   Revised A.C.W.Grace 7-8-89, 6-21-92 
%   Revised P. Gahinet 7-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/05/05 14:09:15 $

ni = nargin;
no = nargout;
if ni==0,
   if no~=0,  
      error('Missing input argument(s).'),  
   end
   eval('exresp(''rlocus'');')
   return
elseif ni==1
   k = [];
elseif ni>2,
   error('Too many inputs.')
end

% Look for time delays
if hasdelay(sys),
   if sys.Ts,
      % Map delay times to poles at z=0 in discrete-time case
      sys = delay2z(sys);
   else
      error('Not supported for continuous-time delay systems.')
   end
end

% Extract ZPK data 
[Zeros,Poles,Gain,Ts] = zpkdata(sys,'v');
if prod(size(Gain))>1,
   error('LTI model SYS must be a (single) SISO system.')
end

% Quick exit for empty models
if isempty(Gain),
   % Empty model: exit
   if no~=0,  rout = [];  kout = []; end
   return
end


% For locus computation, convert model to SS if proper 
% and to TF otherwise
if length(Zeros)<=length(Poles),
   sys = ss(sys);
else
   sys = tf(sys);
end


% Generate root locus
kgiven = ~isempty(k);
if kgiven,
   % When k is given: make sure it's a row vector
   k = k(:).';

   % Remember that genrloc returns r which is length(Poles) by length(k)
   r = genrloc(sys,Zeros,Poles,k);
   r = sortrloc(r);

elseif Gain==0,
   warning('System has zero gain')
   r = zeros(0,1);  k = zeros(1,0);

elseif isempty(Zeros) & isempty(Poles),
   warning('System is a static gain')
   r = zeros(0,1);  k = zeros(1,0);

else
   % Adaptively search for values of gain if they are not specified
   [k,r] = gainrloc(sys,Zeros,Poles,Gain);

end


% Draw plot
if no==0,
   % Find the "right" axis,
   ax = newplot;
   OldNextPlot = get(ax,'NextPlot');
   if Gain==0 | (isempty(Zeros) & isempty(Poles))
      pzmap(sys);
      return
   end

   %-Get new xlimits
   newxmin=min([-0.5, min([real(Zeros);real(Poles)])]);
   newxmax=max([0.5, max([real(Zeros);real(Poles)])]);
   
   set(ax,'Box','on','Nextplot','add')

   % Make X and Y axes, Poles, and Zeros
   PlantPoleH = plot(real(Poles),imag(Poles),'x');
   PlantZeroH = plot(real(Zeros),imag(Zeros),'o');
   
   % Plot root locus data in "right" axis
   rplot=r.';
   LocusH = line(real(rplot),imag(rplot));
   
   % Shrink axis limits, if necessary
   [valmin,indmin]=min(real(rplot));
   [valmax,indmax]=max(real(rplot));
   [rr,rc] = size(r);
   belowXmin=find(valmin<newxmin);
   belowflag=0;
   aboveXmax=find(valmax>newxmax);
   aboveflag=0;
   xminnew=newxmin;
   xmaxnew=newxmax;
   
   MaxPole=max([1;real(Zeros);real(Poles)]);
   tol=1e7;
   
   for ctmin = 1:length(belowXmin),
      if indmin(belowXmin(ctmin)) < rc & ( ~(valmin(belowXmin(ctmin)) < -MaxPole*tol ) ),
         onedown = max([1,indmin(belowXmin(ctmin))-1]);
         oneup = min([rc,indmin(belowXmin(ctmin))+1]);
         if ( ~(rplot(onedown,belowXmin(ctmin)) > MaxPole*tol) ) & ...
               ( ~(rplot(oneup,belowXmin(ctmin)) > MaxPole*tol) ),;
            xminnew=min([xminnew, valmin(belowXmin(ctmin))]);
         else
            belowflag=1;
         end
      else
         belowflag=1;
      end
   end
   if belowflag
      xminnew = (xminnew+newxmax)/2 - (1.5*((newxmax-xminnew)/2));
   else
      xminnew = xminnew*1.05;
   end
      
   for ctmax = 1:length(aboveXmax),
      if indmax(aboveXmax(ctmax)) < (rc-1) & ( ~(valmax(aboveXmax(ctmax)) > MaxPole*tol ) ),
         xmaxnew = max([xmaxnew, valmax(aboveXmax(ctmax))]);
      else
         aboveflag=1;
      end
   end
   
   if aboveflag
      xmaxnew = (xmaxnew+newxmin)/2 + (1.5*((xmaxnew-newxmin)/2));
   else
      xmaxnew = xmaxnew*1.05;
   end
   
   set(gca,'xlim',[floor(xminnew),ceil(xmaxnew)]);

   % Plot the XY axis, 
   xlim=[floor(xminnew),ceil(xmaxnew)];
   linexlim=[min([xlim(1),-1]); max([xlim(2),1])];
   ylim=get(gca,'Ylim');
   lineylim=[min([ylim(1),-1]); max([ylim(2),1])];
   XYaxisH = line([linexlim [0; 0]],[[0; 0] lineylim],'color','k','linestyle',':');
   
   if kgiven,
      % Remember that when k is given, only plot crosses
      set(LocusH,'LineStyle','none','Marker','x');
   end

   xlabel('Real Axis')
   ylabel('Imag Axis')
   set(ax,'NextPlot',OldNextPlot);
else
   rout = r;
   kout = k;
end

% end @lti/rlocus
