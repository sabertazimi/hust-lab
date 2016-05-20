function SysOut = minus(Sys1,Sys2)
%MINUS  Binary minus for LTI models.
%          
%   SYS = MINUS(SYS1,SYS2) is invoked by SYS=SYS1-SYS2.
%
%   See also PLUS, UMINUS, LTIMODELS.

%   Author(s): A. Potvin, 3-1-94
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/02/12 22:27:56 $

SysOut = Sys1 + (-Sys2);
