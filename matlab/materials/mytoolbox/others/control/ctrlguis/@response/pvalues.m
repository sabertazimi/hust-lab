function Values = pvalues(RespObj)
%PVALUES  Values of all public properties of an object
%
%   VALUES = PVALUES(RespObj)  returns the list of values of all
%   public properties of the object SYS.  VALUES is a cell vector.
%
%   See also  GET.
% $Revision: 1.2 $

%       Author(s): P. Gahinet, 7-8-97
%       Copyright (c) 1986-98 by The MathWorks, Inc.

Npublic = 28;  % Number of Step Response (stepresp)-specific public properties

% Values of public LTI properties
Values = struct2cell(RespObj);
Values = Values(1:Npublic);

% end response/pvalues.m
