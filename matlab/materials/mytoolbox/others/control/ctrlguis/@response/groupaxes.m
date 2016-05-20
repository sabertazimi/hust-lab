function RespObj = groupaxes(RespObj);
%GROUPAXES configures the correct number of visible axes for Response Objects
%---Generate the correct Grid of LTIdisplayAxes and reparent the ResponseHandles
% $Revision: 1.1 $

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   Karen Gondoly 3-18-98.

LTIdisplayAxes = RespObj.PlotAxes;
BackgroundAxes = RespObj.BackgroundAxes;
ResponseHandles = RespObj.ResponseHandles;
OnChannels = RespObj.SelectedChannels;
AxesGrouping = RespObj.AxesGrouping;
ResponseType = RespObj.ResponseType;

%---Get number of needed LTIdisplayAxes based on I/O selection
[tempy,tempu] = find(OnChannels);
OnPatch=[tempy,tempu];

%---Hide the current axes
Y = get(LTIdisplayAxes,{'Ylabel'});
T = get(LTIdisplayAxes,{'Title'});
set(cat(1,Y{:}),'visible','off');
set(cat(1,T{:}),'visible','off');
set(LTIdisplayAxes,'visible','off',...
   'XticklabelMode','manual',...
   'YticklabelMode','manual')

if ~isempty(OnPatch)
   OnY = unique(tempy);
   OnU = unique(tempu);
   
   %---Modify number of axes needed (and visibility of axes titles/ylabels)
   %----based on AxesGrouping
   switch AxesGrouping
   case 'none', % No grouping
      TitleVis = 'on';
      YlabelVis = 'on';
      Ny=length(OnY); Nu=length(OnU);
   case 'all', % Group all
      if length(OnU)>1,
         TitleVis = 'off';
         OnU=1;
      else 
         TitleVis = 'on';
      end
      if length(OnY)>1
         YlabelVis = 'off';
         OnY=1;
      else
         YlabelVis = 'on';
      end
      Ny=1; Nu=1;  
   case 'inputs', % Group inputs
      if length(OnU)>1,
         TitleVis = 'off';
         OnU=1;
      else 
         TitleVis = 'on';
      end
      YlabelVis = 'on';
      Ny=length(OnY); Nu=1; 
   case 'outputs', % Group outputs
      TitleVis = 'on';
      if length(OnY)>1
         YlabelVis = 'off';
         OnY=1;
      else
         YlabelVis = 'on';
      end
      Ny=1; Nu=length(OnU); 
   end % switch AxesGrouping
   
   %---Change the number of axes for various response types
   switch ResponseType,
   case {'bode','margin'}
      OnY=sort([(2*OnY)-1; 2*OnY]);
      Ny=Ny*2;
   case {'lsim','initial'},
      Nu=1;
      OnU=1;
   end
   
   %---Get axes positions based on number of axes
   AxesPos = LocalGetAxesPosition(Ny,Nu,BackgroundAxes);
   
   %---Resize the necessary LTIdisplayAxes
   ResizeAxes=LTIdisplayAxes(OnY,:);
   ResizeAxes=ResizeAxes(:,OnU);
   set(ResizeAxes(:),'Unit','pixel');
   set(ResizeAxes(:),{'Position'},AxesPos)
   set(ResizeAxes(:),'Unit','norm');
   
   %---Re-parent the ResponseHandles
   for ctOn=1:size(OnPatch,1),
      for ctSys=1:length(ResponseHandles),
         switch ResponseType
         case {'bode','margin'};,
            RHrow=(2*OnPatch(ctOn,1))-1;
         otherwise
            RHrow = OnPatch(ctOn,1);
         end
         switch AxesGrouping
         case 'none', % No grouping
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',...
               ResizeAxes(find(RHrow==OnY),find(OnPatch(ctOn,2)==OnU)));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',...
                  ResizeAxes(find(2*OnPatch(ctOn,1)==OnY),find(OnPatch(ctOn,2)==OnU)));
            end
            
         case 'all', % Group all
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',ResizeAxes(1,1));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',ResizeAxes(2,1));
            end
            
         case 'inputs', % Group inputs
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',ResizeAxes(find(RHrow==OnY),1));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',ResizeAxes(2*find(OnPatch(ctOn,1)==OnY),1));
            end
            
         case 'outputs', % Group outputs
            RH=ResponseHandles{ctSys}{RHrow,OnPatch(ctOn,2)};
            set(cat(1,RH{:}),'Parent',ResizeAxes(1,find(OnPatch(ctOn,2)==OnU)));
            if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
               RH=ResponseHandles{ctSys}{2*OnPatch(ctOn,1),OnPatch(ctOn,2)};
               set(cat(1,RH{:}),'Parent',ResizeAxes(2,find(OnPatch(ctOn,2)==OnU)));
            end
            
         end % switch AxesGrouping
      end % for ctSys
   end % for ctOn
   
   %---Turn Axes visibility on
   set(ResizeAxes(:,1),'YtickLabelMode','auto')
   if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
      Y=get(ResizeAxes(2:2:end,1),{'Ylabel'});
   else
      Y=get(ResizeAxes(:,1),{'Ylabel'});
   end
   set(cat(1,Y{:}),'visible',YlabelVis);
   set(ResizeAxes(end,:),'XtickLabelMode','auto');
   T=get(ResizeAxes(1,:),{'Title'});
   set(cat(1,T{:}),'visible',TitleVis);
   set(ResizeAxes(1:end-1,:),'xticklabel',[]);
   set(ResizeAxes(:,2:end),'yticklabel',[])
   
   set(ResizeAxes,'visible','on')
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalGetAxesPosition %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AxesPos =LocalGetAxesPosition(Ny,Nu,Parent);

%---AxesPos is a cell array of size (Ny*Nu,1)
%---Each element in the array is a valid row vector axis position 

AxesUnit=get(Parent,'Unit');
set(Parent,'units','pixel');
position=get(Parent,'Position');
set(Parent,'unit',AxesUnit);
AxesPos=cell(Ny*Nu,1);

position(1)=position(1)+25;
position(3)=position(3)-25;
position(2)=position(2)+5;
position(4)=position(4)-17;

SWH = position(3:4)./[Nu Ny];
offset=[0.01, 0.05];
if Ny==1,
   offset(2)=0;
end
if Nu==1,
   offset(1)=0;
end
inset=offset.*SWH;
AWH = (1-3*offset).*SWH;

for ctU=1:Nu,
   for ctY=1:Ny,
      AxesPos{sub2ind([Ny,Nu],ctY,ctU)} = [(position(1:2)+[ctU-1 Ny-ctY].*SWH+inset), AWH];
   end % for ctY
end % for ctU
