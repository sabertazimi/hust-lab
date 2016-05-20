function varargout = systemtog(varargin);
% SYSTEMTOG toggles the visibility of response plots for entire systems
%
%	See also: MODELTOG
% $Revision: 1.2 $

%   Karen Gondoly, 3-18-98
%   Copyright (c) 1986-98 by The MathWorks, Inc.

%---Make sure a Response Object was entered
error(nargchk(1,1,nargin));
RespObj = varargin{1};
if ~isa(RespObj,'response');
   error('Attempt to toggle models of an invalid Response Object.');
end

%---Toggle the visibility of a system's response plots 
SysVis = RespObj.SystemVisibility;
ResponseHandles = RespObj.ResponseHandles;
ResponseType = RespObj.ResponseType;
ContextMenu = RespObj.UIContextMenu;
OnChannels = RespObj.SelectedChannels;
OnModels = RespObj.SelectedModels;

if strcmp(ResponseType,'bode') | strcmp(ResponseType,'margin'),
   Q=[];
   for ct=1:size(OnChannels,1);
      Q=[Q;OnChannels(ct,:);OnChannels(ct,:)];
   end
   OnChannels=Q;
end

for ctV=1:length(SysVis)
   OM=OnModels{ctV};
   if ctV<=length(ResponseHandles),
      if strcmp(SysVis{ctV},'off'),
         RH = cat(2,ResponseHandles{ctV});
         RH = cat(1,RH{:});
         set(cat(1,RH{:}),'Visible','off');
      else
         %---Only turn SelectedModels on
         for ctOC=1:prod(size(OnChannels)),
            if OnChannels(ctOC),
               RH = cat(2,ResponseHandles{ctV}{ctOC});
               for ctOM=1:prod(size(OM)),
                  if OM(ctOM),
                     set(cat(1,RH{ctOM}),'Visible','on')
                  end % if OM
               end % for ctOM
            end % if OnChannels
         end % for ctOC
      end % if/else strcmp(SysVis...
      set(ContextMenu.Systems.Names(ctV),'Checked',SysVis{ctV})
   end 
end % for ctV

%---Rescale the axes
[Xlims,Ylims] = axeslims(get(RespObj.UIContextMenu.Main,'UserData'),RespObj);
RespObj.Ylims = Ylims;
RespObj.Xlims = Xlims;

if nargout,
   varargout{1}=RespObj;
end