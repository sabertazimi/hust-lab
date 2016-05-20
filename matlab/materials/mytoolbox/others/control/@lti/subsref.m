function L = subsref(L,Struct)
%SUBSREF  LTI property management in referencing operation.
%
%   RESULT.LTI = SYS.LTI(Outputs,Inputs) sets the LTI properties
%   of the subsystem produced by
%            RESULT = SYS(Outputs,Inputs) .
%
%   See also TF/SUBSREF.

%   Author(s):  P. Gahinet, 5-23-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 1998/04/14 21:10:25 $

% RE: * restricted to referencing of the form
%           sys(row_indices,col_indices)
%     * minimal error checking

indices = Struct(1).subs;
if ~strcmp(Struct(1).type,'()'),
   error('This type of referencing is not supported for LTI objects.')
end
indrow = indices{1};
indcol = indices{2};

% Delete Notes and UserData
L.Notes = {};
L.UserData = [];

% Set output names and output groups
L.OutputName = L.OutputName(indrow,1);
L.OutputGroup = groupref(L.OutputGroup,indrow);

% Set input names and input groups
L.InputName = L.InputName(indcol,1);
L.InputGroup = groupref(L.InputGroup,indcol);

% Update delays
L.ioDelayMatrix = L.ioDelayMatrix(indices{1:min(ndims(L.ioDelayMatrix),end)});
L.InputDelay = ...
   L.InputDelay(indices{2},:,indices{3:min(end,ndims(L.InputDelay))});
L.OutputDelay = ...
   L.OutputDelay(indices{1},:,indices{3:min(end,ndims(L.OutputDelay))});

