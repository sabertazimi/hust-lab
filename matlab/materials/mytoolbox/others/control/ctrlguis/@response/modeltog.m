function varargout = modeltog(varargin);
% MODELTOG toggles the visibility of response plots for models in an LTI array
%
%	See also: SYSTEMTOG
% $Revision: 1.4 $

%   Karen Gondoly, 3-18-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.

%---Make sure a Response Object was entered
error(nargchk(1,1,nargin));
RespObj = varargin{1};
if ~isa(RespObj,'response');
   error('Attempt to toggle models of an invalid Response Object.');
end

%---Callback with setting the SelectedModel property
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
end % if strcmp(ResponseType...

OnChannels=logical(OnChannels);
for ctV=1:length(SysVis)
   OM=logical(OnModels{ctV});
   if ctV<=length(ResponseHandles),
      if strcmp(SysVis{ctV},'on'),
         %---Only turn SelectedModels on
         for ctC=1:prod(size(OnChannels)),
            RH = cat(2,ResponseHandles{ctV}{ctC});
            if OnChannels(ctC),
               set(cat(1,RH{OM}),'Visible','on')
            end
            set(cat(1,RH{~OM}),'Visible','off')
         end % for ctC
      end % if strcmp
   end % if ctV
end % for ctV

%---Rescale the axes
[Xlims,Ylims] = axeslims(get(RespObj.UIContextMenu.Main,'UserData'),RespObj);
RespObj.Ylims = Ylims;
RespObj.Xlims = Xlims;

if nargout,
   varargout{1}=RespObj;
end