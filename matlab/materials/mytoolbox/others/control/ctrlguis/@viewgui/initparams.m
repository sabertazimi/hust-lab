function ViewerObj = initparams(ViewerObj,ExtraArg,plottype);
%INITPARAMS Store extra input arguments from LTI Viewer initialization
%   ViewerObj = INITPARAMS(ViewerObj,ExtraArg,PLOTTYPE) stores the
%   extra input arguments in the cell array ExtraArg in the appropriate
%   LTI Viewer properties in ViewerObj. The contents of ExtraArg is 
%   determined based on the type of response being plotted, as indicated
%   by the string PLOTTYPE.

%   Copyright (c) 1986-98 by The MathWorks, Inc.
% $Revision: 1.1 $
%   Karen Gondoly, 4-14-98

switch plottype
case {'step','impulse'},
   ViewerObj.TimeVectorMode = 'manual';
   ViewerObj.TimeVector = ExtraArg{1};
   
case 'initial',
   ViewerObj.InitialCondition= ExtraArg{1};
   if length(ExtraArg)>1,
      ViewerObj.TimeVectorMode = 'manual';
      ViewerObj.TimeVector = ExtraArg{2};
   end
   
case 'lsim',
   ViewerObj.TimeVectorMode = 'manual';
   ViewerObj.InputSignal = ExtraArg{1};
   ViewerObj.TimeVector = ExtraArg{2};
   
case {'bode','nyquist','nichols'}
   ViewerObj.FrequencyVectorMode = 'manual';
   ViewerObj.FrequencyVector = ExtraArg{1};
   
case 'sigma',
   if ~isempty(ExtraArg{1}),
      ViewerObj.FrequencyVectorMode = 'manual';
      ViewerObj.FrequencyVector = ExtraArg{1};
   end
   
   if length(ExtraArg)>1,
      ViewerObj.SingularValueType = ExtraArg{2};
   end
   
end % switch plottype
