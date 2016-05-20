function movefcn(varargin);
%MOVEFCN contains the WindowButtonMotionFcn for the Root Locus Design GUI

%   Karen D. Gondoly
%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $

x = varargin{1};

fig = gcf;
udfig = get(fig,'UserData');
ax=udfig.Handles.LTIdisplayAxes;
udAx = get(ax,'UserData');

CP = get(ax,'CurrentPoint');

if length(udAx.MoveData.MoveHandles)==2,
   newx = [CP(1,1);  CP(1,1)];
   newy = [CP(1,2); -CP(1,2)];
else
   newx = [CP(1,1)];
   newy = [0];
end

set(udAx.MoveData.MoveHandles,{'Xdata'},num2cell(newx),...
   {'Ydata'},num2cell(newy));      

if isempty(udAx.Locus),
   return
end

switch udAx.MoveData.MoveType,
case 'Pole',
   Comp=zpk(udAx.MoveData.LocusSystem.Z, ...
      [udAx.MoveData.LocusSystem.P;[newx+(newy*i)]],1,udfig.Model.Plant.Object.Ts);
case 'Zero',
   Comp=zpk([udAx.MoveData.LocusSystem.Z;[newx+(newy*i)]], ...
      udAx.MoveData.LocusSystem.P,1,udfig.Model.Plant.Object.Ts);
end

RLsys = LocalComputeSystem(udfig);

locus = rlocus(RLsys,[udAx.MoveData.GainVector,udfig.Compensator.Gain]);

if isempty(locus),
   return
end

CLpoles = locus(:,end);
set(udAx.Locus,{'Xdata'},num2cell(real(locus(:,1:end-1)),2), ...
   {'Ydata'},num2cell(imag(locus(:,1:end-1)),2));
set(udAx.ClosedLoopPoles,{'Xdata'},num2cell(real(CLpoles)),...
   {'Ydata'},num2cell(imag(CLpoles)))
udfig.Compensator.Object=Comp;

set(fig,'UserData',udfig);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalComputeSystem %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
function RLsys = LocalComputeSystem(udRL);

persistent Plant Sensor Filter Gain FdbkSign FdbkConfig

Comp = udRL.Compensator.Object;

if isempty(Plant)
   %---Read in persistent variables...this one time read makes 
   %---MOVEFCN more responsive.
   Plant = udRL.Model.Plant.Object;
   Sensor = udRL.Model.Sensor.Object;
   Filter = udRL.Model.Filter.Object;
   Gain = udRL.Compensator.Gain;
   FdbkSign = udRL.Model.FeedbackSign;
   FdbkConfig = udRL.Model.Structure;
   
   %---Protect against improper state space conversions,
   %-----If the compensator is improper and the plant
   %-----is state space, convert the plant ss to a zpk. This traps errors
   %-----resulting when attempting to conver improper systems to ss. 
   if ~isproper(Comp),
      if  isa(Plant,'ss'), 
         Plant=zpk(Plant);
      end
      if isa(Sensor,'ss'),
         Sensor = zpk(Sensor);
      end	
      if isa(Filter,'ss'),
         Filter = zpk(Filter);
      end
   end
end
   
RLsys = -1*FdbkSign*Plant*Sensor*Comp;
