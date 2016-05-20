function [PhaseOut,gain] = ngrid(s)
%NGRID  Generates grid lines for a Nichols chart.
%   NGRID plots the Nichols chart grid over an existing Nichols plot
%   generated with NICHOLS.	Lines of constant mag(H/(1+H)) and 
%   angle(H/(1+H)) are drawn in the region covered by the 
%   Nichols frequency response. 
%
%   NGRID generates a grid over the region -40 db to 40 db in 
%   magnitude and -360 degrees to 0 degrees in phase when no plot
%   is contained in the current axis. HOLD ON is then set so that 
%   the Nichols response can be plotted over the grid using
%		ngrid
%		nichols(sys)
%
%   Note that the Nichols chart relates the complex number H/(1+H) 
%   to H, where H is any complex number and may only be used for SISO systems.
%
%   See also  NICHOLS

% Old help
%warning(['This calling syntax for ' mfilename ' will not be supported in the future.'])%NGRID	Generates grid lines for a Nichols chart. 
%
%	NGRID generates a grid over the region -40 db to 40 db in 
%	magnitude and -360 degrees to 0 degrees in phase with lines of 
%	constant mag(H/(1+H)) and angle(H/(1+H)) drawn in.  NGRID plots 
%	the Nichols chart grid over an existing Nichols plot such as one
%	generated with NICHOLS.
%
%	NGRID('new') clears the graphics screen before plotting the grid
%	and sets HOLD ON so that the Nichols response can be plotted over
%	the grid using
%		ngrid('new')
%		nichols(sys)
%
%       Note that the Nichols chart relates the complex number H/(1+H) 
%	to H, where H is any complex number.
%
%	See also  NICHOLS

%	J.N. Little 2-23-88
%	Revised: CMT 7-12-90, ACWG 6-21-92, Wes W 8-17-92, AFP 6-1-94, PG/KDG 10-23-96.
%	Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%	$Revision: 1.9 $  $Date: 1999/01/05 15:21:39 $

ni = nargin;
no = nargout;

%---Set up Ngrid defaults
Pmin=-360;
Pmax=0;
Gmin=10.^(-40/20);    % -40 dB

if no==0,
   ax=get(gcf,'CurrentAxes');
   %---See if the existing axes is a RespObj BackgroundAxes by checking
   % the kids' tags for 'BackgroundResponseObjectLine'
   % If so, change the "ax" to the PlotAxes
   kids = get(ax,'children');
   KidTags = get(kids,{'tag'});
   BackgroundFlag = find(strcmp(KidTags,'BackgroundResponseObjectLine'));
   if ~isempty(BackgroundFlag),
      try
         %---Wrap in a try. If there's an error, just use the previous axes
         ContextMenu = get(kids(BackgroundFlag),'UserData');
         RespObj = get(ContextMenu,'UserData');
         NewAx = get(RespObj,'PlotAxes');
      end
      %---Check that this is a valid axes handle
      if ishandle(NewAx)
         ax=NewAx;
      end
   end
   
   if ( ~strcmp(get(ax,'Tag'),'LTIdisplayAxes') & isempty(get(ax,'children')) ) | ( isempty(ax) ),
      ni=1;
      % Clear the current axes
      cla;
      ax=gca;
      Color = get(ax,'XColor');
   else,
      UIcontextMenu = get(ax,'UIcontextMenu');
      errflag=0;
      if isempty(ax)  
         errflag=1;
      elseif length(ax)~=1,
         disp('ngrid is not available for MIMO systems.')
         return
      else
         RespObj = get(UIcontextMenu,'UserData');
         if ~strcmp(get(RespObj,'ResponseType'),'nichols'),
            errflag=1;
         elseif ~strcmp(get(RespObj,'Grid'),'on'),
            set(RespObj,'Grid','on');
            return
         else
            return
         end
      end
      
      if errflag,
         disp('There is no Nichols Chart available on the current figure.');
         disp('Use ngrid(''new'') to clear the figure before plotting the Nichols Chart grid.');
         return
      end

      Color = get(ax,'XColor');
      kids=get(ax,'children');
      LineKids=findobj(kids,'Tag','LTIresponseLines');
      Pminall=zeros(size(LineKids));
      Pmaxall=zeros(size(LineKids));
      Gminall=zeros(size(LineKids));
      Gmaxall=zeros(size(LineKids));
      Gendall=zeros(size(LineKids));
      for ctlines=1:length(LineKids),
         Xdata=get(LineKids(ctlines),'Xdata');
         Ydata=get(LineKids(ctlines),'Ydata');
         Pminall(ctlines)=min(Xdata);
         Pmaxall(ctlines)=max(Xdata);
         Gminall(ctlines)=min(Ydata);
         Gmaxall(ctlines)=max(Ydata);
         Gendall(ctlines)=Ydata(end);
      end
      Pmin=min(Pminall);
      Pmax=max(Pmaxall);
      Gmin=10.^(min(Gminall/20));
      Gmax=max(Gmaxall);
      Gend=min(Gendall);
   end % if/else is axis empty or not
end % if/else no

[phase,gain,pH,gH,mmdB]=LocalCalcNgrid(Pmin,Pmax,Gmin);

if no~=0,
   PhaseOut = phase;
   return
end

% Plot standard phase and magnitude
line(phase,gain,'LineStyle',':','Color',Color,'parent',ax,'Tag','CSTgridLines');
 
%---Values for magnitude labels
np = size(pH,1);
ng = size(gH,1);
nm = length(mmdB);
for i=1:nm,
   T(i)=text(pH(np-1,i),gH(ng-1,i),sprintf('%.3g dB',mmdB(i)),'parent',ax,...
      'Tag','CSTgridLines','FontWeight','bold');
end

if isempty(ax) | ni==1,
   %---ngrid('new')
   set(gca,'xlim',[-360, 0],'ylim',[-40, 40]);
   set(gca,'Nextplot','add');
   xlabel('Open-Loop Phase (deg)')
   ylabel('Open-Loop Gain (dB)')
else, 
   %---Set the axis limits
   Ymin=min([-40,20*floor(log10(Gmin))]);
   Ymax=20*(ceil(max([max(gain),Gmax])/20));
   Xmin=min(phase);
   Xmax=max(phase);
   set(ax,'Xlim',[Xmin,Xmax],'Ylim',[Ymin,Ymax]);
   
end
   
% end ngrid

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalCalcNgrid %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
function [phase,gain,pH,gH,g2]=LocalCalcNgrid(pmin,pmax,gmin);

j = sqrt(-1);
NanMat = NaN;

% (1) Generate isophase lines for following phase values:
p1 = [1 5 10 20 30 50 90 120 150 180];

% Gain points
g1 = [6 3 2 1 .75 .5 .4 .3 .25 .2 .15 .1 .05 0 -.05 -.1 ...
      -.15 -.2 -.25 -.3 -.4 -.5 -.75 -1 -2 -3 -4 -5 -6 -9 ...
      -12 -16 -20 -30 -40];
if gmin<0.01, 
   g1 = [g1 , 20*floor(log10(gmin))];  
end

% Compute gains GH and phases PH in H plane
[p,g] = meshgrid((pi/180)*p1,10.^(g1/20)); % in H/(1+H) plane
z = g .* exp(j*p);
H = z./(1-z);
gH = 20*log10(abs(H));
pH = rem((180/pi)*angle(H)+360,360);

% Add phase lines for angle between 180 and 360 (using symmetry)
gH = [gH , gH];
pH = [pH , 360-pH];

% Each column of GH/PH corresponds to one phase line
% Pad with NaN's and convert to vector
m = size(gH,2);
gH = [gH ; NanMat(1,ones(1,m))];
pH = [pH ; NanMat(1,ones(1,m))];
gain = gH(:);   phase = pH(:);
% (2) Generate isogain lines for following gain values:
g2 = [6 3 1 .5 .25 0 -1 -3 -6 -12 -20 -40];
if gmin<0.01, 
   g2 = [g2 , -60:-20:20*floor(log10(gmin))];  
end

% Phase points
p2 = [1 2 3 4 5 7.5 10 15 20 25 30 45 60 75 90 105 ...
      120 135 150 175 180];
p2 = [p2 , fliplr(360-p2(1:end-1))];

[g,p] = meshgrid(10.^(g2/20),(pi/180)*p2);  % mesh in H/(1+H) plane
z = g .* exp(j*p);
H = z./(1-z);
gH = 20*log10(abs(H));
pH = rem((180/pi)*angle(H)+360,360);

% Each column of GH/PH describes one gain line
% Pad with NaN's and convert to vector
m = size(gH,2);
gH = [gH ; NanMat(1,ones(1,m))];
pH = [pH ; NanMat(1,ones(1,m))];
gain = [gain ; gH(:)];
phase = [phase ; pH(:)];

% Determine adequate phase range 
nmax = ceil(pmax/360);
nmin = min(floor(pmin/360),nmax-1);
dn = nmax-nmin;  % number of 360 degree windups
lp = length(phase);

% Replicate Nichols chart if necessary
gain = repmat(gain,dn,1);
phase = repmat(phase,dn,1);
shift = kron(360*(nmin:nmax-1)',ones(lp,1));
ix = find(~isnan(phase));
phase(ix) = phase(ix) + shift(ix);

pH = pH + shift(end);

% Eliminate empty half charts
if dn>1,
   pmin = 180*floor(pmin/180);
   pmax = 180*ceil(pmax/180);
   idel = find(phase<=pmin | phase>=pmax);
   %-Return only the indices of the right-most full ngrid
   if ~isempty(find(phase>=pmax)),
      pH = pH - (shift(end)-shift(1));
   end
   phase(idel)=[];  gain(idel)=[];
end
