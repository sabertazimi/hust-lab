function Values = pvalues(RespObj)
%PVALUES  Values of all public properties of an object
%
%   VALUES = PVALUES(RespObj)  returns the list of values of all
%   public properties of the object RespObj.  VALUES is a cell vector.
%
%   See also  GET.
% $Revision: 1.1 $

%       Author(s): P. Gahinet, 7-8-97
%       Copyright (c) 1986-98 by The MathWorks, Inc.

Npublic = 6;  % Number of Nyquist  Response (nyqresp) specific public properties

Values = struct2cell(RespObj);
Values = Values(1:Npublic);

% Add parent properties
Values = [Values ; pvalues(RespObj.response)];

% end nyqresp/pvalues.m
