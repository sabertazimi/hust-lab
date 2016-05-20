function sys = lti(Ny,Nu,Ts)
%LTI  Constructor for the LTI parent object.
%
%   SYS = LTI(NY,NU) creates a LTI object with NY outputs and
%   NU inputs.
%
%   SYS = LTI(NY,NU,TS) creates a LTI object with NY outputs,
%   NU inputs, and sample time TS. 
%
%   Note: This function is not intended for users.
%         Use TF, SS, or ZPK to specify LTI models.

%   Author(s): A. Potvin, P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.11 $  $Date: 1998/04/14 21:10:19 $

% Define default property values.
% RE: system is continuous by default, and I/O names are cell vectors of
%     empty strings


ni = nargin;
if ni==0,
   % Create empty LTI
   Ny = 0;  Nu = 0;  Ts = 0;
elseif isa(Ny,'lti')
   % Conversion to LTI for LTI object
   sys = Ny;
   return
elseif ni<3,
   Ts = 0;
end

% Create the structure
sys = struct(...
   'Ts',Ts,...
   'InputDelay',zeros(Nu,1),...
   'OutputDelay',zeros(Ny,1),...
   'ioDelayMatrix',zeros(Ny,Nu),...
   'InputName',{cell(Nu,1)},...
   'OutputName',{cell(Ny,1)},...
   'InputGroup',{cell(0,2)},...
   'OutputGroup',{cell(0,2)},...
   'Notes',{{}},...
   'UserData',[],...
   'Version',2.0);

% Set all I/O names to ''
sys.InputName(:) = {''};
sys.OutputName(:) = {''};

% Label SYS as an object of class LTI
sys = class(sys,'lti');

