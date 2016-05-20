function [InNames,OutNames,clash] = mrgname(Systems,varargin)
%MRGNAME  Input/output name management for Response Objects.  
%    [INNAMES,OUTNAMES,CLASH]=MRGNAME(SYSTEMS) returns the common set of
%    Input and Output names for all the LTI Objects in the cell array SYSTEMS
%
%    Names that are not common among all the Objects are returned as empty.
%  
%    CLASH is a 1x2 vector indicating if input or output names have been
%    removed. 1 = names have been deleted; 0 = names have not been changed.
%    The first element relates to input names, the second to output names.
% $Revision: 1.5 $

%       Author(s): P. Gahinet, 4-1-96
%       Revised for Response Objects: K. Gondoly, 1-28-98
%       Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.

clash = [0 0];

%---Quick exit when only one system is passed in
if isequal(length(Systems),1),
   InNames = Systems{1}.InputName;
   OutNames = Systems{1}.OutputName;
   
   InGroups = Systems{1}.InputGroup;
   OutGroups = Systems{1}.OutputGroup;
   
   %---Check for empty names and add defaults
   for cti=1:length(InNames),
      if isempty(InNames{cti}),
         InNames{cti}=['U(',num2str(cti),')'];
      end
   end
   for cto=1:length(OutNames),
      if isempty(OutNames{cto}),
         OutNames{cto}=['Y(',num2str(cto),')'];
      end
   end
   
else
   [numout,numin]=size(Systems{1});
   AllInputNames = cell(length(Systems),1);
   AllInputGroups = cell(length(Systems),1);
   AllOutputNames = cell(length(Systems),1);
   AllOutputGroups = AllOutputNames;
   InNames = cell(numin,1);
   OutNames = cell(numout,1);
   AllSizes = zeros(length(Systems),2);
   
   for ctSys = 1:length(Systems),
      sizeTemp = size(Systems{ctSys});
      AllSizes(ctSys,:) = sizeTemp(1:2);
      AllInputNames{ctSys} = Systems{ctSys}.InputName;
      AllInputGroups {ctSys} = Systems{ctSys}.InputGroup;
      AllOutputNames{ctSys} = Systems{ctSys}.OutputName;
      AllOutputGroups {ctSys} = Systems{ctSys}.OutputGroup;
   end % for ctSys
   
   if all(AllSizes(1,2)==AllSizes(:,2)),
      AllInputNames=[AllInputNames{:}];
      for ct=1:size(AllInputNames,1),
         if isequal(AllInputNames{ct,:}) & ~isempty(AllInputNames{ct,1}),
            InNames{ct,1} = AllInputNames{ct,1};   
         else
            InNames{ct,1}=['U(',num2str(ct),')'];
            clash(1)=1;
         end % if/else isequal
      end % for ct
      
      %---Get any group names
      if isequal(AllInputGroups{:}),
         InGroups = AllInputGroups{1};
      else
      	InGroups = [];   
      end % if isequal(AllInputGroups)
      
   else
      InNames={''};
      InGroups = [];   
   end % if/else isequal
   
   if all(AllSizes(1,1)==AllSizes(:,1)),
      AllOutputNames=[AllOutputNames{:}];
      for ct=1:size(AllOutputNames,1),
         if isequal(AllOutputNames{ct,:}) & ~isempty(AllOutputNames{ct,1}),
            OutNames{ct,1} = AllOutputNames{ct,1};   
         else
            OutNames{ct,1}=['Y(',num2str(ct),')'];
            clash(2)=1;
         end % if/else isequal
      end % for ct
      
      %---Get any group names
      if isequal(AllOutputGroups{:}),
         OutGroups = AllOutputGroups{1};
      else
         OutGroups = [];
      end % if isequal(AllInputGroups)
      
   else
      OutNames={''};
      OutGroups = [];
   end % if/else isequal
   
end % if/else isequal(length(Systems...

%---Append any group names
if ~isempty(InGroups)
   for ct=1:size(InGroups,1),
      groupname = cell(length(InGroups{ct,1}),1);
      groupname(:) = {[' (',InGroups{ct,2},')']};
      InNames(InGroups{ct,1}) = strcat(InNames(InGroups{ct,1}),groupname);
   end, % for ct
end, % if ~isempty(InGroups)

if ~isempty(OutGroups)
   for ct=1:size(OutGroups,1),
      groupname = cell(length(OutGroups{ct,1}),1);
      groupname(:) = {[' (',OutGroups{ct,2},')']};
      OutNames(OutGroups{ct,1}) = strcat(OutNames(OutGroups{ct,1}),groupname);
   end, % for ct
end % if ~isempty(OutGroups)

