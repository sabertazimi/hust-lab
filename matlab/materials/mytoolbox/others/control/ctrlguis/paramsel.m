function paramsel(varargin);
%PARAMSEL Opens and controls the Model Selector for LTI Arrays

%   Kelly Liu, 5-20-98
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.11 $  $Date: 1999/01/05 15:20:58 $

action = varargin{1};
if nargin>1,
   RespObj = varargin{2};
   %---Get the Handle of the ArrayMenu associated with RespObj
   ContextMenu = get(RespObj,'UIcontextMenu');
   thisHndl = ContextMenu.ArrayMenu;
   figNumber=get(thisHndl, 'Userdata');  
   if ~ishandle(figNumber)
      figNumber=[];
   end
else
   figNumber=gcbf;
end
if nargin>2,
   updataIndex = varargin{3};
end

switch action,
case '#init',
   repHndls=get(RespObj, 'selectedModel');
   dataInfo.obj=RespObj;
   
   if isempty(figNumber)
      %===================================
      % Information for all objects
      frmColor=192/255*[1 1 1];
      btnColor=192/255*[1 1 1];
      popupColor=192/255*[1 1 1];
      editColor=255/255*[1 1 1];
      axColor=128/255*[1 1 1];
      scalex=.8;
      scaley=.6;
      border=.01/scalex;
      spacing=.01/scalex;
      figPos=get(0,'DefaultFigurePosition');
      figPos=figPos.*[1 1 scalex scaley];
      maxRight=1;
      maxTop=1;
      btnWid=.14/scalex;
      btnHt=0.05/scaley;
      
      %====================================
      % The FIGURE
      figNumber=figure( ...
         'Name',['Model Selector for LTI Arrays'], ...
         'NumberTitle','off', ...
         'Color',frmColor, ...
         'IntegerHandle','off',...
         'MenuBar','none', ...
         'Visible','off', ...
         'UserData',dataInfo, ...
         'Position',figPos, ...
         'Tag','ruleedit', ...
         'CloseRequestFcn', 'set(gcf, ''Visible'', ''off'')', ...
         'BackingStore','off');
      %save figure handle in the array menu
      set(thisHndl, 'Userdata', figNumber);   
      %====================================
      % The MENUBAR items
      % First create the menus standard to every GUI
      
      optHndl=uimenu(figNumber,'Label','Options','Tag','optionsmenu', 'Visible', 'off');
      langHndl=uimenu(optHndl,'Label','option1','Tag','language');
      callbackStr='paramsel #langselect';
      uimenu(langHndl,'Label','option11', ...
         'Tag','lang', ...
         'Checked','on', ...
         'Callback',callbackStr);
      uimenu(langHndl,'Label','option12', ...
         'Tag','lang', ...
         'Callback',callbackStr);
      uimenu(langHndl,'Label','option13', ...
         'Tag','lang', ...
         'Callback',callbackStr);
      callbackStr='paramsel #formatselect';
      langHndl=uimenu(optHndl,'Label','option2','Tag','ruleformat');
      callbackStr='paramsel #langselect';
      uimenu(langHndl,'Label','option21', ...
         'Tag','rulefrmt', ...
         'Checked','on', ...
         'Callback',callbackStr);
      uimenu(langHndl,'Label','option22', ...
         'Tag','rulefrmt', ...
         'Callback',callbackStr);
      uimenu(langHndl,'Label','option23', ...
         'Tag','rulefrmt', ...
         'Callback',callbackStr);
      
      %========================================================
      % The MAIN frame 
      right=maxRight-border;
      frmBorder=spacing;
      
      %====================================
      
      bottom=border+4*spacing;
      % The RULES frame 
      top=maxTop-border-spacing;
      right=maxRight-border-spacing;
      left=border+spacing;
      frmBorder=spacing;
      frmPos=[left-frmBorder bottom-4*frmBorder ...
            right-left+frmBorder*2 top-bottom+5*frmBorder];
      ruleFrmHndl=uicontrol( ...
         'Style','frame', ...
         'Units','normal', ...
         'Position',frmPos, ...
         'BackgroundColor',frmColor);
      %------------------------------------
      left=left+border;
      
      %========radio button for and, or=========
      %    frmPos=[left bottom+(top-bottom)*4/5-3*btnHt ...
      %        btnWid*1.5+spacing btnHt*5.6];
      %    clsFrmHndl=uicontrol( ...
      %        'Style','frame', ...
      %        'Units','normal', ...
      %        'Position',frmPos, ...
      %        'BackgroundColor',frmColor);
      bottom= .85;
      pos=[left bottom btnWid*.5 btnHt];
      helpHndl=uicontrol( ...
         'Style','Text', ...
         'Units','normal', ...
         'Position',pos, ...
         'HorizontalAlignment', 'left', ...
         'BackgroundColor',frmColor, ...
         'String','Arrays:');
      pos=[left+10*spacing bottom btnWid*1.1 btnHt];
      modelSize = length(repHndls);
      arrayIndex=[];
      temp=get(RespObj, 'SystemNames');
      repHndls=get(RespObj, 'selectedModel');
      k=1;
      for i=1:modelSize
         if prod(size(repHndls{i}))~=1
            str{k}=temp{i};
            arrayIndex(k)=i;
            dimInfo{k}=size(repHndls{i});  
            k = k+1;
         end
      end
      %---Initialize selarray
      selarray=cell(1,k-1);
      selected=ones(1,k-1)*2; 
      actived=ones(1,k-1);
      for i=1:k-1 
         consInfo{i}={};
         consActive{i}=zeros(1,4);
         selarray{i} = ones(max(dimInfo{i}), length(dimInfo{i}));
      end  
      
      reponseH=size(repHndls{arrayIndex(1)});
      dataInfo.dimInfo=dimInfo;
      
      dataInfo.arrayIndex=arrayIndex;
      helpHndl=uicontrol( ...
         'Style','Popupmenu', ...
         'Units','normal', ...
         'Position',pos, ...
         'BackgroundColor',editColor, ...
         'String',str, ...
         'Tag', 'Array',...
         'Callback','paramsel #array');
      bottom= bottom-.1;
      
      bottom= bottom-.12;
      pos=[left bottom btnWid*1.7 btnHt];
      helpHndl=uicontrol( ...
         'Style','text', ...
         'Units','normal', ...
         'Position',pos, ...
         'BackgroundColor',btnColor, ...
         'String','Selection Criteria', ...
         'Tag', 'criterionlabel');
      bottom= bottom-.34;
      pos=[left bottom btnWid*2 btnHt*4];
      helpHndl=uicontrol( ...
         'Style','listbox', ...
         'Units','normal', ...
         'Position',pos, ...
         'BackgroundColor',btnColor, ...
         'String',{'Index into Dimensions','Bound on Characteristics'}, ...
         'Tag', 'criterion',...
         'Value', 1,...
         'Callback','paramsel #criterion');
      
      
      %====================================
      % The STATUS frame 
      bottom= bottom-.16;
      frmPos=[left bottom ...
            (right-left)-frmBorder btnHt*1.6];
      mainFrmHndl=uicontrol( ...
         'Style','frame', ...
         'Units','normal', ...
         'Position',frmPos, ...
         'BackgroundColor',frmColor);
      
      
      %------------------------------------
      % The STATUS text window
      labelStr=['Show selected plots'];
      name='status';
      pos=[left+spacing bottom+0.5*spacing (right-left)*.95 1.4*btnHt];
      txtHndl=uicontrol( ...
         'Style','text', ...
         'BackgroundColor',frmColor, ...
         'HorizontalAlignment','left', ...
         'Units','normal', ...
         'Position',pos, ...
         'Tag',name, ...
         'String',labelStr);
      %------------------------------------
      %=========apply======================
      bottom= bottom-.1;
      boxDstn=btnWid+spacing;
      boxWidth=(right-left)/6;
      btnWid = .7*btnWid;
      left=left-btnWid/2;
      pos=[left+boxDstn bottom btnWid btnHt];
      helpHndl=uicontrol( ...
         'Style','pushbutton', ...
         'Units','normal', ...
         'Position',pos, ...
         'String','OK',...
         'Callback', 'paramsel #getselection; set(gcbf, ''Visible'', ''off'')',...
         'Tag', 'OK');
      
      %========button for cancle=========
      pos=[left+boxDstn*2 bottom btnWid btnHt];
      helpHndl=uicontrol( ...
         'Style','push', ...
         'Units','normal', ...
         'Position',pos, ...
         'BackgroundColor',btnColor, ...
         'String','Cancel', ...
         'Callback','set(gcbf, ''Visible'', ''off'')');
      %======================================
      % The HELP button
      %    bottom=bottom+spacing;
      labelStr='Help';
      callbackStr='paramsel #help';
      helpHndl=uicontrol( ...
         'Style','push', ...
         'Units','normal', ...
         'Position',[left+boxDstn*3 bottom btnWid btnHt], ...
         'BackgroundColor',btnColor, ...
         'String',labelStr, ...
         'Callback',callbackStr);
      
      %------------------------------------
      % The APPLY button
      labelStr='Apply';
      callbackStr='paramsel #getselection';
      closeHndl=uicontrol( ...
         'Style','push', ...
         'Units','normal', ...
         'Position',[left+boxDstn*4 bottom btnWid btnHt], ...
         'BackgroundColor',btnColor, ...
         'String',labelStr, ...
         'Callback',callbackStr);
      %    paramsel #update
      % Normalize all coordinates
      hndlList=findobj(figNumber,'Units','pixels');
      set(hndlList,'Units','normalized');
      
      selarray{1}=localAddrulemake(figNumber,reponseH, 0, []);
      
      u=get(RespObj, 'Uicontextmenu');
      uMain=u.PlotOptions;
      plotN=length(fieldnames(uMain));
      localAddCharact(RespObj,plotN-1);

      dataInfo.selected=selected;
      dataInfo.selarray=selarray;
      dataInfo.actived = actived;
      dataInfo.consInfo=consInfo;
      dataInfo.consActive=consActive;
      % Uncover the figure
      set(figNumber, ...
         'Visible','on', ...
         'Userdata', dataInfo, ...
         'HandleVisibility','callback');
      localsetallVisible(figNumber, 1);
      localsetallEnable(figNumber, reponseH, 2);
   else
      set(figNumber, ...
         'Visible','on');
      figure(figNumber);
   end
   
case '#shiftright';
   dataInfo=get(gcbf, 'Userdata');
   arrayHndl=findobj(gcbf, 'Tag', 'Array');
   arrayindex=get(arrayHndl, 'value');
   dimInfo=dataInfo.dimInfo;
   set(gcbf, 'Unit', 'normal');
   dimLength=size(dimInfo{arrayindex}, 2);
   for i=dimLength:-1:4    % i should be > 3 for shift to be active
      rightHndl=findobj(gcbf, 'Tag', ['dim' num2str(i)]);
      visibility = get(rightHndl, 'Visible');
      if strcmp(visibility, 'on')
         lastone=i;
         break;
      end 
   end
   righttextHndl=findobj(gcbf, 'Tag', ['constrain', num2str(lastone)]);
   rightlabelHndl=findobj(gcbf, 'Tag', ['dimlabel', num2str(lastone)]);
   set(rightHndl, 'Unit', 'normal');
   set(righttextHndl, 'Unit', 'normal');
   set(rightlabelHndl, 'Unit', 'normal');
   set(rightHndl, 'Visible', 'off', 'Enable', 'off');
   set(righttextHndl, 'Visible', 'off', 'Enable', 'off');
   set(rightlabelHndl, 'Visible', 'off', 'Enable', 'off');
   lshiftHndl=findobj(gcbf, 'Tag', 'shiftleft');
   set(lshiftHndl, 'Enable', 'on');
   if lastone==4
      rshiftHndl=findobj(gcbf, 'Tag', 'shiftright');
      set(rshiftHndl, 'Enable', 'off');
   end
   pos=get(rightHndl, 'Position');
   poslabel=get(rightlabelHndl, 'Position');
   postext=get(righttextHndl, 'Position');
   
   for i=lastone-1:-1:lastone-2   % i should be > 3 for shift to be active
      Hndl=findobj(gcbf, 'Tag', ['dim' num2str(i)]);
      textHndl=findobj(gcbf, 'Tag', ['constrain', num2str(i)]);
      labelHndl=findobj(gcbf, 'Tag', ['dimlabel', num2str(i)]);
      set(Hndl, 'Unit', 'normal');
      set(textHndl, 'Unit', 'normal');
      set(labelHndl, 'Unit', 'normal');
      thispos=get(Hndl, 'Position');
      thisposlabel=get(labelHndl, 'Position');
      thispostext=get(textHndl, 'Position');
      set(Hndl, 'Position', pos, 'Visible', 'on');
      set(textHndl, 'Position', postext, 'Visible', 'on');
      set(labelHndl, 'Position', poslabel, 'Visible', 'on');
      pos=thispos;
      postext=thispostext;
      poslabel=thisposlabel;
   end
   Hndl=findobj(gcbf, 'Tag', ['dim' num2str(lastone-3)]);
   textHndl=findobj(gcbf, 'Tag', ['constrain', num2str(lastone-3)]);
   labelHndl=findobj(gcbf, 'Tag', ['dimlabel', num2str(lastone-3)]);
   set(Hndl, 'Visible', 'on');
   set(textHndl,'Visible', 'on');
   set(labelHndl,'Visible', 'on');
   
case '#shiftleft';
   dataInfo=get(gcbf, 'Userdata');
   arrayHndl=findobj(gcbf, 'Tag', 'Array');
   arrayIndex=get(arrayHndl, 'value');
   dimInfo=dataInfo.dimInfo;
   set(gcbf, 'Unit', 'normal');
   dimLenght=size(dimInfo{arrayIndex}, 2);
   for i=dimLenght:-1:3    % i should be > 3 for shift to be active
      rightHndl=findobj(gcbf, 'Tag', ['dim' num2str(i)]);
      visibility = get(rightHndl, 'Visible');
      if strcmp(visibility, 'on')
         break;
      end 
   end
   lastone=i+1;
   rightHndl=findobj(gcbf, 'Tag', ['dim' num2str(lastone)]);
   righttextHndl=findobj(gcbf, 'Tag', ['constrain', num2str(lastone)]);
   rightlabelHndl=findobj(gcbf, 'Tag', ['dimlabel', num2str(lastone)]);
   set(rightHndl, 'Unit', 'normal', 'Visible', 'on', 'Enable', 'on');
   set(righttextHndl, 'Unit', 'normal', 'Visible', 'on', 'Enable', 'on');
   set(rightlabelHndl, 'Unit', 'normal', 'Visible', 'on', 'Enable', 'on');
   if lastone == dimLenght
      lshiftHndl=findobj(gcbf, 'Tag', 'shiftleft');
      set(lshiftHndl, 'Enable', 'off');
   end
   
   for i=lastone-1:-1:1
      Hndl=findobj(gcbf, 'Tag', ['dim' num2str(i)]);
      textHndl=findobj(gcbf, 'Tag', ['constrain', num2str(i)]);
      labelHndl=findobj(gcbf, 'Tag', ['dimlabel', num2str(i)]);
      set(Hndl, 'Unit', 'normal');
      set(textHndl, 'Unit', 'normal');
      set(labelHndl, 'Unit', 'normal');
      pos=get(Hndl, 'Position');
      poslabel=get(labelHndl, 'Position');
      postext=get(textHndl, 'Position');
      set(rightHndl, 'Position', pos);
      set(righttextHndl, 'Position', postext);
      set(rightlabelHndl, 'Position', poslabel);
      rightHndl=Hndl;
      righttextHndl=textHndl;
      rightlabelHndl=labelHndl;
   end
   rshiftHndl=findobj(gcbf, 'Tag', 'shiftright');
   set(rshiftHndl, 'Enable', 'on');
   
case '#clearedit'
   thislist=gcbo;
   tag=get(thislist, 'Tag');
   tagNum=str2num(tag(4:end));
   ebox=findobj(figNumber, 'Tag', ['constrain' num2str(tagNum)]);
   set(ebox, 'String', []);
   
case '#constrain'
   thisedit=gcbo;
   str=get(thisedit, 'String');
   tag=get(thisedit, 'Tag');
   tagNum=str2num(tag(10:end));
   list=findobj(figNumber, 'Tag', ['dim' num2str(tagNum)]);
   
   try
      if isempty(str)
         selvalue= get(list,'Value');     % do nothing..
      else
         selvalue=evalin('base',str);
         if islogical(selvalue)
            ix=1:length(get(list,'String'));
            selvalue = ix(selvalue);
         end
      end
   catch
      warndlg('Please enter a valid MATLAB expression for range', ...
         'Model Selector Warning');
      selvalue = 1:length(get(list,'String'));
   end
   
   maxvalue=max(selvalue);
   minvalue=min(selvalue);
   if maxvalue>length(get(list, 'String'))|minvalue<1
      selvalue = 1:length(get(list,'String'));
      warndlg(['Values must be between 1 and '...
            num2str(length(get(list, 'String')))], ...
         'Model Selector Warning');
   end
   set(list, 'Value', selvalue);
   
case '#criterion'
   thisHndl=findobj(figNumber, 'Tag', 'criterion');
   value=get(thisHndl, 'Value');
   str=get(thisHndl, 'String');      
   localsetallVisible(figNumber, value);  
   statueHndl=findobj(figNumber, 'Tag', 'status');
   if value==2
      set(statueHndl, 'String', ['Enter a MATLAB expression using ''$'' to refer to the ', ...
            'variable of  interest (steady-state, rise time, ...). For example: $>2 & $ <5.',...
            ' See help for more examples.']);
   else
      set(statueHndl, 'String', 'Show selected plot(s)');
   end
   
case '#show'
   thispopup=gcbo;
   info = get(figNumber, 'Userdata');
   arrayIndex=info.arrayIndex;
   RespObj=info.obj;
   u=get(RespObj, 'Uicontextmenu');
   uMain=u.Main;
   currRespObj=get(uMain, 'Userdata');
   newy=get(currRespObj, 'SelectedModel');
   arrayHndl=findobj(figNumber, 'Tag', 'Array');
   arrayvalue=get(arrayHndl, 'Value');
   dimInfoIndex = newy{arrayIndex(arrayvalue)};
   diminfo=size(dimInfoIndex);
   thisvalue=get(thispopup, 'Value');
   localsetallEnable(figNumber, diminfo, thisvalue);
   
   %---Store the new popupmenu value
   info.selected(arrayvalue) = thisvalue;
   set(figNumber,'UserData',info)
   
case '#array'
   thispopup=findobj(figNumber, 'Tag', 'Array');;
   newvalue=get(thispopup, 'value');
   showHndl=findobj(figNumber, 'Tag', 'showpopup');
   info = get(figNumber, 'Userdata');
   selected=info.selected;
   selarray=info.selarray;
   actived=info.actived;
   arrayIndex=info.arrayIndex;
   consInfo=info.consInfo;
   consActiveAll=info.consActive;
   consActive=consActiveAll{newvalue};
   if selected(newvalue)~=1 & length(selarray)>=newvalue
      oldsel=selarray{newvalue};
   else
      oldsel =  [];
   end  
   RespObj=info.obj;
   u=get(RespObj, 'Uicontextmenu');
   uMain=u.Main;
   currRespObj=get(uMain, 'Userdata');
   newy=get(currRespObj, 'SelectedModel');
   dimInfoIndex = newy{arrayIndex(newvalue)};
   diminfo=size(dimInfoIndex);
   % delete old listboxes
   
   listHndl = findobj(figNumber, 'style', 'listbox');
   k=1;
   for i=1:length(listHndl)
      tag=get(listHndl(i), 'Tag');
      if strcmp(tag(1:3), 'dim')
         delete(listHndl(i));
         % count how may of them are there
         k=k+1;  
      end
   end
   for i=1:k-1;
      labelHndl=findobj(figNumber, 'Tag', ['dimlabel' num2str(i)]);
      delete(labelHndl);
      labelHndl=findobj(figNumber, 'Tag', ['constrain' num2str(i)]);
      delete(labelHndl);
   end
   
   thisselarray=localAddrulemake(figNumber,diminfo, 1, oldsel);
   selarray{newvalue}=thisselarray;
   info.selarray=selarray;
   set(figNumber, 'Userdata', info);
   if size(diminfo,2)>3
      shiftHndl=findobj(figNumber, 'Tag', 'shiftleft');
      set(shiftHndl, 'Enable', 'on');
   end
   set(showHndl, 'Value', selected(newvalue));
   localsetallEnable(figNumber, diminfo, selected(newvalue));
   crtHndl=findobj(figNumber, 'Tag', 'criterion');
   crtValue=get(crtHndl, 'Value');
   str=get(crtHndl, 'String');      
   thisStr=str{crtValue};
   %set contrains
   ConsStr=consInfo{newvalue};
   %if ~isempty(ConsStr)
      for i=1:4, %length(fieldnames(u.PlotOptions))-1
         editHndl=findobj(figNumber, 'Tag', ['criteedit' num2str(i)]);
         checkHndl=findobj(figNumber, 'Tag', ['critecheck' num2str(i)]);
         if ~isempty(ConsStr) & i<=length(ConsStr)
            str=ConsStr{i};
         else
            str='';
         end
         set(editHndl, 'String', str);
         if consActive(i)==1
            set(editHndl, 'Enable', 'on');
         else
            set(editHndl, 'Enable', 'off');
         end
         set(checkHndl, 'Value', consActive(i));
      end      
   %end
   localsetallVisible(figNumber, crtValue);  
      
case '#getselection';   
   showHndl=findobj(figNumber, 'Tag', 'showpopup');
   arrayHndl=findobj(figNumber, 'Tag', 'Array');
   info = get(figNumber, 'Userdata');
   selected=info.selected;
   actived = info.actived;
   arrayIndex=info.arrayIndex;
   selarray=info.selarray;
   arrayvalue=get(arrayHndl, 'value');
   
   RespObj=info.obj;
   u=get(RespObj, 'Uicontextmenu');
   uMain=u.Main;
   currRespObj=get(uMain, 'Userdata');
   newy=get(currRespObj, 'SelectedModel');
   dimInfoIndex = newy{arrayIndex(arrayvalue)};
   diminfo=size(dimInfoIndex);
   
   showvalue=get(showHndl, 'Value');
   [y, array]=localgetselection(figNumber, diminfo, arrayIndex(arrayvalue));
   selarray{arrayvalue}=array;
   
   RespObj=info.obj;
   u=get(RespObj, 'Uicontextmenu');
   uMain=u.Main;
   currRespObj=get(uMain, 'Userdata');
   newy=get(currRespObj, 'SelectedModel');
   arrayIndex=info.arrayIndex;
   newy{arrayIndex(arrayvalue)}=y;
   set(currRespObj, 'selectedModel', newy);
   
   %update selected infomation
   selected(arrayvalue)=showvalue;
   info.selected=selected;
   info.selarray=selarray;
   
   %save constrain
   consInfo=info.consInfo;
   consStr{1}='';
   for i=1:length(fieldnames(u.PlotOptions))-1
      name=['criteedit' num2str(i)];
      editHndl=findobj(figNumber, 'Tag', name);
      consStr{i}=get(editHndl, 'String');
   end
   consInfo{arrayvalue}=consStr;
   info.consInfo=consInfo;
   set(figNumber, 'Userdata', info);
   
case '#check'
   chkHndl=gcbo;
   info=get(figNumber, 'Userdata');
   thisTag=get(chkHndl, 'Tag');
   arrayHndl=findobj(figNumber, 'Tag', 'Array');
   value=get(arrayHndl, 'Value');
   consActiveAll=info.consActive;
   consActive=consActiveAll{value};
   numstr=thisTag(end);
   editHndl=findobj(gcbf, 'Tag', ['criteedit', numstr]);
   checkvalue=get(chkHndl, 'Value');
   if checkvalue==1
      set(editHndl, 'Enable', 'on');
   else
      set(editHndl, 'Enable', 'off');
   end
   consActive(str2num(numstr))=checkvalue;
   consActiveAll{value}=consActive;
   info.consActive=consActiveAll;
   set(figNumber, 'Userdata', info);
   statusHndl=findobj(figNumber, 'Tag', 'status');
   set(statusHndl, 'String', ['Enter a MATLAB expression using ''$'' to refer to the', ...
         'variable of  interest (steady-state, rise time, ...). Example: $>2 & $ <5.', ...
      'See Help for more examples.']);
   
case '#plottype'
   if ~isempty(figNumber)
      %---Update all the data (takes care of the fact that FRD's disappear when
      %   switching from a time domain to frequency domain response.
      localUpdata(figNumber, RespObj);
      
      %---Remove the constraints from the data
      ud = get(figNumber,'UserData');
      for i=1:length(ud.consInfo); 
         ud.consInfo{i}={};
         ud.consActive{i}=zeros(1,4);
      end  
      set(figNumber,'UserData',ud)
      
      paramsel('#array',RespObj)
      
      % Warn the user that changes to the Bounds on Characteristics page
      % may cause changes in the displayed Response plots, and that the
      % user should press Apply to see these changes. This way, the originally
      % shown channels are preserved.
      
      StatusStr={'The previously selected models are still shown.';
         'Press Apply or OK to map the selection criteria to this Response Type.'};
      statusHndl=findobj(figNumber, 'Tag', 'status');
      set(statusHndl,'String',StatusStr);
      
   end
   
case '#refresh'
   if ~isempty(figNumber)
      localUpdata(figNumber, RespObj);
      paramsel('#array',RespObj)
   end
      
case '#delete'
   if ~isempty(figNumber)
      localDelete(figNumber, RespObj, updataIndex);
   end
   
case '#help';
   %====================================
   figNumber=watchon;
   str={'Model Selector Help',{'The Model Selector for LTI Arrays allows you to plot a subset of'; ...
         ' models from any of the LTI arrays on the corresponding response'; ...
         ' plot. You can select models using either or both of the following'; ...
         ' options:'; ...
         ''; ...
         '  1. Array dimension indexing'; ...
         '  2. Conditions on the response characteristics (e.g., settling time less than 2 seconds).'; ...
         ' '; ...
         '  When using both together, only the systems in the specified array'; ...
         '  positions that meet the design criteria are displayed.'}; ...
         'Indexing into Dimensions', ...
         {'To indexing into array dimensions:'; ...
         '  1. Select Index into Dimensions in the Selection Criteria listbox.'; ...
         '  2. Select the desired setting from the popup menu under the listboxes.'; ...
         '       - Show all: displays all array models'; ...
         '       - Show selected: displays the array models in the indices selected';...
         '         in the listboxes'; ...
         '       - Hide selected: hides the array models in the indices selected in '; ...
         '         the listboxes, and shows all other array models.'; ...
         '  3. Select the indices of the models to show (or hide) by either:'; ...
         '       - Using the mouse to select model indices in each listbox'; ...
         '       - Typing a vector of indices or any MATLAB expression that specifies'; ...
         '         a vector of indices in the textbox below the associated listbox.'; ...
         '  4. Press Apply or OK to implement the selection.'; ...
         ''; ...
         'You can use the textbox to index into dimensions by either:'; ...
         '  1. Entering a logical expression that evaluates to a vector of the same '; ...
         '     length as the associated array dimension'; ...
         '  2. Entering a vector of indices directly'; ...
         ''; ...
         '  In either case, you can access variables in the MATLAB workspace when';...
         '  building the expression. For example, if p is a variable in the MATLAB '; ...
         '  workspace with length 5, as shown below'; ... 
         ''; ...
         '       p = [1 6 7 3 4]'; ...
         ''; ...
         '  and the LTI array dimension you are indexing into also has length 5,'; ...
         '  the following expression:'; ...
         ''; ...
         '       p>5'; ...
         ''; ...
         '  selects the second and third indices in that dimension.'}; ...
         'Indexing into Characteristics', ...
         {'To index into design specification criteria:'; ...
         '  1. Select Bound on Characteristics in the Selection Criteria listbox.'; ...
         '  2. Check the checkbox next to a design specification characteristic '; ...
         '     you want to index into'; ...
         '  3. Type a MATLAB relational expression in the associated textbox.'; ...
         '     Use ''$'' as the variable in the expression.'; ...
         '  4. Press Apply or OK to implement the selection.'; ...
         ''; ...
         '  Unchecking the checkbox disables indexing into that characteristic.'; ...
         ''; ...
         'Examples of relational expressions:'; ...
         '  Each relational expression must be written in terms of the variable ''$'''; ...
         '  and may contain any of the relational operators supported by MATLAB.'; ...
         ''; ...
         '  For example, to select the models with the maximum rise time in the I/O '; ...
         '  response from the first input to first output (of a MIMO LTI array), first'; ...
         '  check the Rise Time box, then type'; ... 
         ''; ...
         '       $(1,1,:) == max($(1,1,:))'; ... 
         ''; ...
         '  in the text box next to Rise Time.'; ...
         ''; ...
         '  Other examples of relational expressions include:'; ...
         '       $ > 5 | $ < 2'; ...
         '       $(2,1,:) <= 3 & $(1,1,:) > 2'}};
   helpwin(str);
   watchoff(figNumber)
   
end;    % if strcmp(action, ...


function localUpdata(figNumber, RespObj)
%========== by Karen Gondoly

dataInfo=get(figNumber, 'Userdata');
OldNames = get(findobj(figNumber, 'Tag', 'Array'),'String');

%---Initialize a new data structure for the RespObj
dataInfoNew.obj=RespObj;
arrayIndex=[];
temp=get(RespObj, 'SystemNames');
repHndls=get(RespObj, 'selectedModel');
k=1;
modelSize = length(repHndls);
for i=1:modelSize
   if prod(size(repHndls{i}))~=1
      str{k}=temp{i};
      arrayIndex(k)=i;
      dimInfo{k}=size(repHndls{i});  
      k = k+1;
   end
end
NewNames = temp(arrayIndex);

%---Initialize selarray
selarray=cell(1,k-1);
selected=ones(1,k-1)*2; 
actived=ones(1,k-1);
for i=1:k-1 
   consInfo{i}={};
   consActive{i}=zeros(1,4);
   selarray{i} = ones(max(dimInfo{i}), length(dimInfo{i}));
end  

dataInfoNew.dimInfo=dimInfo;
dataInfoNew.arrayIndex=arrayIndex;
dataInfoNew.selected=selected;
dataInfoNew.selarray=selarray;
dataInfoNew.actived = actived;
dataInfoNew.consInfo=consInfo;
dataInfoNew.consActive=consActive;

%---Update models already in the list, based on SystemNames
[garb,refreshIndex,refreshFromIndex]=intersect(NewNames,OldNames);

for i=1:length(refreshIndex)
   if isequal(dataInfoNew.dimInfo{refreshIndex(i)},dataInfo.dimInfo{refreshFromIndex(i)}),
      dataInfoNew.selected(refreshIndex(i))=dataInfo.selected(refreshFromIndex(i));
      dataInfoNew.selarray{refreshIndex(i)}=dataInfo.selarray{refreshFromIndex(i)};
      dataInfoNew.actived(refreshIndex(i)) = dataInfo.actived(refreshFromIndex(i));
      dataInfoNew.consInfo{refreshIndex(i)}=dataInfo.consInfo{refreshFromIndex(i)};
      dataInfoNew.consActive{refreshIndex(i)}=dataInfo.consActive{refreshFromIndex(i)};
   end % if isequal(array dimensions of previous and current model
end % for i

arrayHndl=findobj(figNumber, 'Tag', 'Array');
CurrentArray = popupstr(arrayHndl);
ArrayVal = strmatch(CurrentArray,NewNames,'exact');
if isempty(ArrayVal),
   ArrayVal=1;
end
set(arrayHndl,'String',NewNames,'Value',ArrayVal);
set(figNumber, 'Userdata', dataInfoNew);

function localDelete(figNumber, RespObj, index)
%========== by Karen Gondoly
dataInfo=get(figNumber, 'Userdata');

arrayIndex=dataInfo.arrayIndex;
arrayHndl=findobj(figNumber, 'Tag', 'Array');
ArrayStr = get(arrayHndl,'String');
ArrayVal = get(arrayHndl,'Value');
CurrentArray = ArrayStr{ArrayVal};
[DupInds,indold,indnew]=intersect(arrayIndex,index);

%---Remove appropriate Arrays from the popupmenu
ArrayStr(indold)=[];

if isempty(ArrayStr)
   %---No arrays left, close the Selector and turn the ArrayMenu off
   set(RespObj,'ArraySelector','off')
   delete(figNumber)
   ContextMenu = get(RespObj,'UIcontextMenu');
   set(ContextMenu.ArrayMenu,'visible','off')
else
   %---Remove the appropriate data from the Figure's UserData
   
   SystemNames = get(RespObj,'SystemNames');
   [garb,arrayIndex,garb2]=intersect(SystemNames,ArrayStr);

   dataInfo.dimInfo(indold)=[];
   dataInfo.arrayIndex = sort(arrayIndex)';
   dataInfo.consInfo(indold)=[];
   dataInfo.selarray(indold)=[];
   dataInfo.consActive(indold)=[];
	dataInfo.obj=RespObj;
   set(figNumber, 'Userdata', dataInfo);
   ArrayVal = strmatch(CurrentArray,ArrayStr);
   if isempty(ArrayVal),
      ArrayVal=1;
   end
   set(arrayHndl, 'String', ArrayStr,'Value',ArrayVal);
   paramsel('#array',RespObj)

end % if/else isempty(ArrayStr)

function localAddCharact(RespObj,resNum)
frmColor=192/255*[1 1 1];
btnColor=192/255*[1 1 1];
popupColor=192/255*[1 1 1];
editColor=255/255*[1 1 1];
axColor=128/255*[1 1 1];
scaley=.6;
scalex=.8;
border=.01/scalex;
spacing=.01/scalex;
maxRight=1;
maxTop=1;
btnWid=.14/scalex;
btnHt=0.05/scaley;


bottom=.3;
top=.86;
right=maxRight-border-spacing;
left=border+spacing+.4;
frmBorder=spacing;
boxDstn=(top-bottom)/4.5;
dispStr={'Peak Response', 'Settling Time (Sec)', 'Rise Time (Sec)', 'Steady State'};

if strcmp(get(RespObj,'ResponseType'),'bode')
   dispStr{1}=[dispStr{1},' (dB)'];
end

visibility='off';
bottom=.27;
for i=1:4
   checkPos=[left top+btnHt/2-boxDstn*i btnWid*1.75 btnHt];
   name=['critecheck' num2str(i)];
   str=dispStr{i};
   dimHndl=uicontrol( ...
      'Style','checkbox', ...
      'Units','normal', ...
      'Position',checkPos, ...
      'BackgroundColor',frmColor, ...
      'HorizontalAlignment','left', ...
      'String', str,...
      'Visible', visibility, ...
      'Tag',name, ...
      'Callback', 'paramsel #check');
   
   
   textPos=[left+btnWid*1.78 top+btnHt/2-boxDstn*i btnWid*1.2 btnHt];
   
   name=['criteedit' num2str(i)];
   helpHndl=uicontrol( ...
      'Style','edit', ...
      'Units','normal', ...
      'Position',textPos, ...
      'BackgroundColor',editColor, ...
      'HorizontalAlignment', 'left',...
      'String',' ', ...
      'Tag', name,...
      'Visible', visibility, ...
      'Enable', 'off', ...
      'Max', 1);
   
end


function out=localAddrulemake(figNumber,Hinfo, flag, selarray)
%flag ==0 is for initialization
% Information for all objects
frmColor=192/255*[1 1 1];
btnColor=192/255*[1 1 1];
popupColor=192/255*[1 1 1];
editColor=255/255*[1 1 1];
axColor=128/255*[1 1 1];
scaley=.6;
scalex=.8;
border=.01/scalex;
spacing=.01/scalex;
maxRight=1;
maxTop=1;
btnWid=.14/scalex;
btnHt=0.05/scaley;


bottom=.3;
top=.86;
right=maxRight-border-spacing;
left=border+spacing+.4;
if flag == 0  %called in init, set up frames
   frmBorder=spacing;
   frmPos=[left-frmBorder bottom-frmBorder ...
         (right-left) top-bottom+frmBorder*8];
   mainFrmHndl=uicontrol(figNumber, ...
      'Style','frame', ...
      'Units','normal', ...
      'Position',frmPos, ...
      'BackgroundColor',frmColor);
   frmPos=[left+7*frmBorder top+3*frmBorder ...
         (right-left)-20*frmBorder btnHt];
   mainFrmHndl=uicontrol(figNumber, ...
      'Style','text', ...
      'Units','normal', ...
      'Position',frmPos, ...
      'String', 'Selection Criterion Setup', ...
      'Tag', 'criterionlabel', ...
      'BackgroundColor',frmColor);
   pos=[left bottom btnWid*.5 btnHt];
   
   pos=[left+0*spacing bottom btnWid*1.3 btnHt];
   helpHndl=uicontrol(figNumber, ...
      'Style','popupmenu', ...
      'Units','normal', ...
      'Position',pos, ...
      'BackgroundColor',editColor, ...
      'String',{'show all','show selected', 'hide selected'}, ...
      'Tag', 'showpopup',...
      'Value', 2,...
      'Callback','paramsel #show');
end %flag==0
%------------------------------------
% The listboxes
boxHeight=(top-bottom)*1/2;
boxDstn=(right-left)/3;
boxWidth=(right-left)/3.5;
boxShiftY=(bottom+top)/5;
numInputs=size(Hinfo, 2);    
% set up selected array
if isempty(selarray)
   out = ones(max(Hinfo), length(Hinfo));
else
   out = selarray;
end
for i=0:numInputs-1
   rulePos=[left+i*boxDstn bottom+boxShiftY boxWidth boxHeight];
   name=['dim' num2str(i+1)];
   str=num2str((1:Hinfo(i+1))');
   visibility='off';
   enable='on';
   if i>2
      visibility = 'off';
      enable='off';
   end
   thisvalue=find(out(1:Hinfo(i+1), i+1)==1);
   dimHndl=uicontrol(figNumber, ...
      'Style','listbox', ...
      'Units','normal', ...
      'Position',rulePos, ...
      'BackgroundColor',editColor, ...
      'HorizontalAlignment','left', ...
      'String', str,...
      'Max', Hinfo(i+1), ...
      'Value', thisvalue, ...
      'Visible', visibility, ...
      'Enable', enable, ...
      'Tag',name, ...
      'Callback', 'paramsel #clearedit');
   textPos=rulePos+[0, boxHeight+spacing, 0, btnHt*2/3-boxHeight];
   name=['dimlabel' num2str(i+1)];
   
   textHndl=uicontrol(figNumber, ...
      'Style','text', ...
      'Units','normal', ...
      'Position',textPos, ...
      'BackgroundColor',frmColor, ...
      'String', num2str(i+1),...
      'Visible', visibility, ...
      'HorizontalAlignment','center', ...
      'Tag',name);
   
   textPos=rulePos+[0, boxHeight+spacing+btnHt*2/3, 0, btnHt*2/3-boxHeight];
   name=['constrain' num2str(i+1)];
   
   pos=rulePos+[0, -btnHt*1.5, 0, btnHt-boxHeight];
   helpHndl=uicontrol(figNumber, ...
      'Style','edit', ...
      'Units','normal', ...
      'Position',pos, ...
      'BackgroundColor',editColor, ...
      'HorizontalAlignment', 'left',...
      'String',' ', ...
      'Tag', name,...
      'Visible', visibility, ...
      'Max', 1,...
      'Callback', 'paramsel #constrain');
   
end
if flag ==0  %call by init, set up shift buttons
   %=======buttons for shift=============
   pos=[right-4*spacing-btnWid*2/3 bottom btnWid/3 btnHt];
   shiftEnable='off';
   shiftVisible='off';
   if size(Hinfo,2)>3
      shiftEnable = 'on';
      shiftVisible = 'on';
   end
   helpHndl=uicontrol(figNumber, ...
      'Style','push', ...
      'Units','normal', ...
      'Position',pos, ...
      'BackgroundColor',btnColor, ...
      'Tag', 'shiftleft',...
      'String','<<', ...
      'Enable', shiftEnable, ...
      'Visible', shiftVisible, ...
      'Callback','paramsel #shiftleft');
   pos=[right-2*spacing-btnWid/3 bottom btnWid/3 btnHt];
   helpHndl=uicontrol(figNumber, ...
      'Style','push', ...
      'Units','normal', ...
      'Position',pos, ...
      'BackgroundColor',btnColor, ...
      'Tag', 'shiftright',...
      'String','>>', ...
      'Enable', 'off', ...
      'Visible', shiftVisible, ...
      'Callback','paramsel #shiftright');
   pos=[left+spacing bottom btnWid btnHt];
   
end %if flag == 0


function [out, out1]=localgetselection(figNumber, dimInfo, arrayvalue)
errflag = 0;
out=ones(dimInfo);
out1=zeros(max(dimInfo), length(dimInfo));
cnstrnHndl=findobj(figNumber, 'Tag', 'criterion');
cntsStr=get(cnstrnHndl, 'String');
indexStr=cntsStr{1};
boundStr=cntsStr{2};
numInputs=size(dimInfo, 2);
showHndl=findobj(figNumber, 'Tag', 'showpopup');
showvalue = get(showHndl, 'value');
warnStr='';
if showvalue == 1
   out=ones(dimInfo);
else
   
   for i=1:numInputs
      tempout=zeros(dimInfo);
      Hndl=findobj(figNumber, 'Tag', ['dim' num2str(i)]);
      
      onIndex=get(Hndl, 'Value');
      out1(onIndex,i)=1;
      t1=repmat(':,',1,i-1);
      t2=repmat(', :',1,numInputs-i);
      t=[t1 '[' num2str(onIndex) ']' t2];
      outstr=['tempout(' t ')=1;'];
      eval(outstr);
      out=out&tempout;
   end
   
   if showvalue==3, % Get inverse of what is selected
      out=~out;
   end

end
info=get(figNumber, 'Userdata');
RespObj=info.obj;
u=get(RespObj, 'Uicontextmenu');
uMain=u.Main;
currRespObj=get(uMain, 'Userdata');
thisout=ones(dimInfo);
plottype=get(currRespObj,'ResponseType');
parentH=get(currRespObj, 'Parent');
[input, output] = size(currRespObj);

if strcmp(plottype, 'bode') & [input, output]==[1,1] & strcmp(get(parentH,'Tag'),'ResponseGUI')
  boundName={'PeakResponseValue', 'StabilityMarginValue', 'StabilityMarginValue'};
  timeName={'Peak', 'GainMargin', 'PhaseMargin',...
      'Amplitude'};

elseif (strcmp(plottype,  'nichols') | strcmp(plottype, 'nyquist' )) & [input, output]==[1,1] & strcmp(get(parentH,'Tag'),'ResponseGUI')
  boundName={'StabilityMarginValue', 'StabilityMarginValue'};
  timeName={'GainMargin', 'PhaseMargin'};
else   
  boundName={'PeakResponseValue', 'SettlingTimeValue', 'RiseTimeValue',...
      'SteadyStateValue'};
  timeName={'Peak', 'SettlingTime', 'RiseTime',...
      'Amplitude'};
end
checkHndl=findobj(figNumber, 'Style', 'checkbox');
checkTag=get(checkHndl, 'Tag');
for i=1:length(checkTag)
  tempStr=checkTag{i};
  if get(checkHndl(i), 'Value') == 1
    editHndl=findobj(figNumber,'Tag', ['criteedit' tempStr(end)]);
    editStr=get(editHndl, 'String');
    cellvalue=get(currRespObj, boundName{str2num(tempStr(end))});
    timeStr=timeName{str2num(tempStr(end))};
    thisvalue=cellvalue(arrayvalue);
    if ~isempty(eval(['thisvalue.' timeStr]))
      if ~strcmp(deblank(editStr), '')  
    
      %----By Greg
      % find a unique variable name for use in base workspace
      % use it to replace $ token
      %
      nonuniq=1;
      while nonuniq
         varnm=char(floor(rand(1,24)*25+65));
         eStr=['exist(''' varnm ''',''var'')'];
         nonuniq=evalin('base', eStr);
      end
      hasDollar=findstr(editStr, '$');
      if isempty(hasDollar)
         warndlg(['Error while evaluating ',...
               boundName{str2num(tempStr(end))}(1:end-5),...
               ' constraint.. no selection was applied.'...
               '  Expression must use $ to reference ' timeStr '.'], ...
            'Model Selector Warning');
         errflag = 1;
         thisout = logical(ones(dimInfo));
      else
         [editStr,errmsg]=LocalArrayIndexingParser(editStr);
         if ~isempty(errmsg)
            newlines = sprintf('\n\n');
            warndlg(['Error while evaluating ', ...
                  boundName{str2num(tempStr(end))}(1:end-5), ...
                  ' constraint.. no selection was applied.', ...
                  newlines errmsg], ... 
               'Model Selector Warning');
             errflag = 1;
             thisout = logical(ones(dimInfo));
         else
            editStr=strrep(editStr, '$', varnm);
            
            % Assign the response data into the workspace
            % and try to evaluate the string
            %
            assignin('base', varnm, eval(['thisvalue.' timeStr]));
            try
               thisout = evalin('base', editStr);
            catch
               newlines = sprintf('\n\n');
               errmsg=strrep(lasterr, varnm, '$');
               warndlg(['Error while evaluating ', ...
                     boundName{str2num(tempStr(end))}(1:end-5), ...
                     ' constraint.. no selection was applied.', ...
                     newlines errmsg], ... 
                  'Model Selector Warning');
               errflag = 1;
               thisout = logical(ones(dimInfo));
            end % try/catch
            evalin('base', ['clear ' varnm]);

            % use ALL to squash down IO dimensions.. some
            % may have been squashed by indexing already
            %
            while prod(size(thisout)) > prod(dimInfo)
               thisout=shiftdim(all(thisout,1),1);
            end
            
            % reshape to recover from $(:) type operations
            %
            if prod(size(thisout)) == prod(dimInfo)
               thisout = reshape(thisout,dimInfo);
            else         
               newline = sprintf('\n');
               warndlg(['Error while evaluating ',...
                        boundName{str2num(tempStr(end))}(1:end-5),...
                        ' constraint.. no selection was applied.' newline,... 
                        'Size of expression does not match array dimensions.'], ...
                        'Model Selector Warning');
               errflag = 1;
               thisout = logical(ones(dimInfo));
            end % if/else prod(size...
         end % if/else isempty(hasDollar)
        end % if/else ~isempty(errmsg)
      %----
       end % if ~strcmp(delank
      else
       warnStr = ' Stability margins are not calculated for FRD''s.';
    end %if ~isempty(eval('thisvalue.', timeStr))
 end % if get(checkHndl(i)
   out=out&thisout;
end % for i

% TEMPORARY CODE
if ~errflag
   numvis = sum(out(:));
   statusHndl=findobj(figNumber, 'Tag', 'status');
   set(statusHndl, 'String', ['Selection resulted in ' int2str(numvis) ' visible model(s).' warnStr]);
end
% END TEMPORARY CODE

function localsetallVisible(figNumber, flag)
info=get(figNumber, 'Userdata');
listHndl=findobj(figNumber, 'Style', 'listbox');
shiftlHndl=findobj(figNumber, 'Tag', 'shiftleft');
shiftrHndl=findobj(figNumber, 'Tag', 'shiftright');
editHndl=findobj(figNumber, 'Style', 'edit');
checkHndl=findobj(figNumber, 'Style', 'checkbox');
showHndl=findobj(figNumber, 'Tag', 'showpopup');
for i=1:length(listHndl)-1
   textHndl(i)=findobj(figNumber, 'Tag', ['dimlabel' num2str(i)]);
   editHndl1(i)=findobj(figNumber, 'Tag', ['constrain' num2str(i)]);
   listHndl1(i)=findobj(figNumber, 'Tag', ['dim' num2str(i)]);       
end
if flag == 1
   visibility = 'on';
   visibility1='off';
else
   visibility = 'off';
   visibility1='on';
end
set(showHndl,  'Visible', visibility);
listTag=get(listHndl,'Tag');
firstpos=get(listHndl1(1), 'position');
for i=2:length(listHndl1)
   beginpos=get(listHndl1(i), 'position');
   if beginpos(1)~=firstpos(1)
      begin=i-1;
      break;
   end
end
for i=1:length(listHndl1)
   if i>=begin & i < begin+3
      thisvisible=visibility;
   else
      thisvisible='off';
   end
   set(listHndl1(i), 'Visible', thisvisible);
   set(editHndl1(i), 'Visible', thisvisible);
   set(textHndl(i), 'Visible', thisvisible);
   
end

plottype=get(info.obj,'ResponseType');
% find out unit
parentH = get(info.obj,'Parent');
viewObj=get(parentH, 'Userdata');
phUnit=get(viewObj, 'PhaseUnits');
magUnits=get(viewObj, 'MagnitudeUnits');
if ~isempty(phUnit)
  if strcmp(phUnit(1:3), 'rad')
    phStr=' (Rad)';
  else
    phStr=' (Deg)';
  end
end
if ~isempty(magUnits)
 switch magUnits
 case 'decibels'
   magStr=' (dB)';
 case 'absolute'
   magStr = ' (Abs)';
 otherwise
   magStr = ' (Log10)';
 end
else
   magStr = '';
end

% reset check box's string
set(checkHndl(1), 'String', 'Steady State');
set(checkHndl(2), 'String', 'Rise Time (Sec)');
set(checkHndl(3), 'String', 'Settling Time (Sec)');
set(checkHndl(4), 'String', ['Peak Response' magStr]);
switch plottype
case 'bode',
   [input, output] = size(info.obj);
      if [input, output]==[1,1] & strcmp(get(parentH,'Tag'),'ResponseGUI')
     NumActive = [2 3 4];
     set(checkHndl(3), 'String', ['Gain Margin' magStr]);
     set(checkHndl(2), 'String', ['Phase Margin' phStr]);
   else
     NumActive=4;
   end
   CharStr = ['Peak Response' magStr];
case 'nichols',
   [input, output]=size(info.obj);
   parentH = get(info.obj,'Parent');
   if [input, output]==[1,1] & strcmp(get(parentH,'Tag'),'ResponseGUI')
     NumActive = [3 4];
     CharStr =  ['Gain Margin' magStr];
     set(checkHndl(3), 'String', ['Phase Margin' phStr]);
   else
     NumActive=[];
   end
case 'nyquist',
   [input, output]=size(info.obj);
   parentH = get(info.obj,'Parent');
   if [input, output]==[1,1] & strcmp(get(parentH,'Tag'),'ResponseGUI')
     NumActive = [3 4];
     CharStr = ['Gain Margin' magStr];
     set(checkHndl(3), 'String', ['Phase Margin' phStr]);
   else
     NumActive=[];
   end
case 'impulse',
   NumActive = [3 4];
   CharStr = 'Peak Response';
case 'sigma',
   NumActive = [4];
   CharStr = ['Peak Response' magStr] ;
case 'initial',
   NumActive = [4];
   CharStr = ['Peak Response' magStr] ;
case 'step',
   NumActive=[1 2 3 4];
   CharStr = 'Peak Response';
otherwise
   NumActive=[];
   CharStr = '';
end

%checkbox
set(checkHndl,'visible','off');
if length(checkHndl)>=1
   listTag=get(checkHndl,'Tag');
   for i=NumActive
      set(checkHndl(i), 'Visible', visibility1);
   end
end
%---Reset string of Peak Response Characteristic
set(checkHndl(4), 'String', CharStr);

%edit
editTag=get(editHndl,'Tag');
editCritInd = strmatch('cri',editTag);
editHndl=editHndl(editCritInd);
set(editHndl,'visible','off')
for i=NumActive
   set(editHndl(i), 'Visible', visibility1);
end

%shift button
if length(listHndl)<5
   visibility='off';
end
set(shiftlHndl, 'Visible', visibility);
set(shiftrHndl, 'Visible', visibility);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LocalArrayIndexingParser %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [s1,errmsg]=LocalArrayIndexingParser(s0)
% $ is a placeholder for an ND array
% Fix indexing to work like LTI arrays, in which
% the first two dimensions are special.  Specifically:
%
%  1. $(1,2,:) is fine as it is.
%  2. $(1,2)   is mapped to       $(1,2,:)
%  3. $(1)     is an error.
%  4. $        is mapped to       $(:,:,:)
%
% Greg

s0 = [s0 ' '];

% Handle case 4. first
ix = findstr(s0,'$');
for k=length(ix):-1:1
  if s0(ix(k)+1) ~= '('
    s0 = [s0(1:ix(k)) '(:,:,:)' s0(ix(k)+1:end)];
  end
end 

s1 = s0;
ix = findstr(s0,'$(');
errmsg = [];

if ~isempty(ix)
  jx = findstr(s0,'(');
  kx = findstr(s0,')');
  if length(jx) ~= length(kx)
    errmsg = 'Mismatched parentheses.';
    return
  end
  for n=length(ix):-1:1			% work backwards..
    bp = ix(n);				% start of $(
    ep = min(kx(kx>bp));		% first closing )
    innerp = findstr(s0(bp+2:ep),'(');
    while ~isempty(innerp)		% find the right closing )
      s0(bp+1+max(innerp):ep) = 32;	% don't be fooled by commas in between
      ep = min(kx(kx>ep));
      innerp = findstr(s0(bp+2:ep),'(');
    end
    lx = findstr(s0,',');
    cl = lx(lx>bp & lx<ep);		% all commas in between
    switch length(cl)
    case 0
      errmsg='Use multiple indexing for MIMO models or LTI arrays, as in $(i,j).'; 
    case 1
      s1 = [s1(1:ep-1) ',:' s1(ep:end)];	% add the colon
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function localsetallEnable(figNumber, dimInfo, flag)
statusHndl=findobj(figNumber, 'Tag', 'status');
if flag == 1
   thisenable = 'off';
   %set(statusHndl, 'String', 'Show all plots');
else
   thisenable = 'on';
   if flag == 2
      set(statusHndl, 'String', 'Show selected plot(s)');
   else
      set(statusHndl, 'String', 'Show unselected plot(s)');
   end
end
listlength=size(dimInfo, 2);
for i=1:listlength
   listHndl = findobj(figNumber, 'Tag', ['dim' num2str(i)]);
   textHndl = findobj(figNumber, 'Tag', ['constrain' num2str(i)]);
   labelHndl= findobj(figNumber, 'Tag', ['dimlabel' num2str(i)]);
   Hndl = [listHndl, textHndl, labelHndl];
   set(Hndl, 'Enable', thisenable);
end
sellabelHndl = findobj(figNumber, 'Tag', 'criterion');
if listlength > 3
   if flag == 1
      shiftHndl = findobj(figNumber, 'Tag', 'shiftleft');
      set(shiftHndl, 'Enable', thisenable);
      shiftHndl = findobj(figNumber, 'Tag', 'shiftright');
      set(shiftHndl, 'Enable', thisenable);
   else
      listHndl = findobj(figNumber, 'Tag', ['dim' num2str(4)]);
      visibility = get(listHndl, 'Visible');
      if strcmp(visibility, 'on')
         shiftHndl = findobj(figNumber, 'Tag', 'shiftright');
         set(shiftHndl, 'Enable', 'on');
      end
      % to check whether the last one is visible to set left shift button
      listHndl = findobj(figNumber, 'Tag', ['dim' num2str(listlength)]);
      visibility = get(listHndl, 'Visible');
      shiftHndl = findobj(figNumber, 'Tag', 'shiftleft');
      if strcmp(visibility, 'off')
         set(shiftHndl, 'Enable', 'on');
      else
         set(shiftHndl, 'Enable', 'off');
      end
   end 
end
info=get(figNumber, 'Userdata');
arrayHndl=findobj(figNumber, 'Tag', 'Array');
arrayIndex=get(arrayHndl, 'value');
consActiveAll=info.consActive;
consEditAll=info.consInfo;
consActive=consActiveAll{arrayIndex};
if isempty(arrayIndex)
  consEdit = [];
else  
  consEdit=consEditAll{arrayIndex};
end
for i=1:length(consEdit);
   checkHndl=findobj(figNumber, 'Tag', ['critecheck' num2str(i)]);
   editHndl=findobj(figNumber, 'Tag', ['criteedit' num2str(i)]);
   if ~isempty(checkHndl)
      set(checkHndl, 'Value', consActive(i));
      if isempty(consEdit)
         set(editHndl, 'String', '');
      else
         set(editHndl, 'String', consEdit{i});
      end
      if consActive(i)==1
         set(editHndl, 'Enable', 'on');
      else
         set(editHndl, 'Enable', 'off');
      end
   else
      break;
   end
end





