function [Xlims,Ylims] = axeslims(NyqRespObj,RespObj);
%AXESLIMS sets the axes limits for Nyquist Response Objects

%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/05/21 19:38:03 $
%   Karen Gondoly 5-14-98.

AllRespProps = get(RespObj);
DispAx = AllRespProps.PlotAxes;  
Xlims = AllRespProps.Xlims;
Ylims = AllRespProps.Ylims;

if strcmp(AllRespProps.YlimMode,'auto')
   set(DispAx,'YlimMode','auto');
end

if strcmp(AllRespProps.XlimMode,'auto')
   set(DispAx,'XlimMode','auto');
end

if strcmp(AllRespProps.YlimMode,'manual')
   for ctAx = 1:size(DispAx,1),
      set(DispAx(ctAx,:),'Ylim',Ylims{ctAx})
   end
end

if strcmp(AllRespProps.XlimMode,'manual')
   for ctAx = 1:size(DispAx,2),
      set(DispAx(:,ctAx),'Xlim',Xlims{ctAx})
   end
end

if strcmp(AllRespProps.YlimMode,'auto')
   %---Set Uniform Y-axis limits across each row
   for ctax=1:size(DispAx,1),
      Lims = findlims(DispAx(ctax,:),'Ylim');
      
      %---Make sure no data is butted up against an axes-limit.
      %    If so, enforce a 2% gap between the data and axes-limit
      Lines = findall(DispAx(ctax,:),'Tag','LTIresponseLines');
      Ydata = get(Lines,{'Ydata'});
      if ~isempty(Ydata),
         Ydata = cat(2,Ydata{:});
         Ymin = min(Ydata(:));
         Ymax = max(Ydata(:));
         TestLims = Lims;
         if (Lims(2)-Ymax) <= 0.02*(TestLims(2)-TestLims(1)),
            Lims(2) = TestLims(2) + 0.02*(TestLims(2)-TestLims(1));
         end
         if (Ymin-Lims(1)) <= 0.02*(TestLims(2)-TestLims(1)),
            Lims(1) = TestLims(1) - 0.02*(TestLims(2)-TestLims(1));
         end
      end, % If ~isempty(Ydata)
      
      set(DispAx(ctax,:),'Ylim',Lims);
   end % for ctax
   
   %---Make sure current axes limits are stored
   Ylims = get(DispAx(:,1),{'Ylim'});
end % if/else strcmp(YlimMode...
%----end Y-axis scaling

if strcmp(AllRespProps.XlimMode,'auto')
   %---Set Uniform X-axis limits across each column
   for ctax=1:size(DispAx,2),
      Lims = findlims(DispAx(:,ctax),'Xlim');
      
      %---Make sure to include the critical point
      Lims(1) = min([-1 Lims(1)]);
      
      %---Make sure no data is butted up against an axes-limit.
      %    If so, enforce a 2% gap between the data and axes-limit
      Lines = findall(DispAx(:,ctax),'Tag','LTIresponseLines');
      Xdata = get(Lines,{'Xdata'});
      if ~isempty(Xdata),
         Xdata = cat(2,Xdata{:});
         Xmin = min(Xdata(:));
         Xmax = max(Xdata(:));
         TestLims = Lims;
         if (Lims(2)-Xmax) <= 0.02*(TestLims(2)-TestLims(1)),
            Lims(2) = TestLims(2) + 0.02*(TestLims(2)-TestLims(1));
         end
         if (Xmin-Lims(1)) <= 0.02*(TestLims(2)-TestLims(1)),
            Lims(1) = TestLims(1) - 0.02*(TestLims(2)-TestLims(1));
         end
      end % If ~isempty(Xdata)
      set(DispAx(:,ctax),'Xlim',Lims)
   end % for ctax
   
   %---Make sure current axes limits are stored
   Xlims = get(DispAx(1,:),{'Xlim'});
   
end % if/else strcmp(XlimMode...

   


