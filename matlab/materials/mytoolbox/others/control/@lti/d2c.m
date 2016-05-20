function L = d2c(L)
%D2C  Manages LTI properties in D2C conversion
%
%   CSYS.LTI = D2C(DSYS)  sets the LTI properties of the 
%   system CSYS produced by
%
%             CSYS = D2C(DSYS)

%       Author(s): P. Gahinet, 5-28-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1998/04/14 21:12:48 $

% Delete Notes and UserData
L.Notes = {};
L.UserData = [];

% Multiply delay times by Ts and set sample time to zero
L.InputDelay = L.InputDelay * L.Ts;
L.OutputDelay = L.OutputDelay * L.Ts;
L.ioDelayMatrix = L.ioDelayMatrix * L.Ts;
L.Ts = 0;

