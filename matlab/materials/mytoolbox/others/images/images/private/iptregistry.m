function varargout = iptregistry(varargin)
%IPTREGISTRY Store information in persistent memory.
%   IPTREGISTRY(A) stores A in persistent memory.
%   A = IPTREGISTRY returns the value currently stored.
%
%   Once called, IPTREGISTRY cannot be cleared by calling clear
%   mex.
%
%   See also IPTGETPREF, IPTSETPREF.

%   Steven L. Eddins, September 1996
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 1.4 $  $Date: 1997/11/24 15:56:06 $

error('Missing MEX-file IPTREGISTRY');
