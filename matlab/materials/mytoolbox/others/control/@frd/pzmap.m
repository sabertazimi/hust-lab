function [pout,z] = pzmap(sys)
%PZMAP  Pole-zero map of LTI models.
%
%   PZMAP(SYS) computes the poles and (transmission) zeros of the
%   LTI model SYS and plots them in the complex plane.  The poles 
%   are plotted as x's and the zeros are plotted as o's.  
%
%   When invoked with left-hand arguments,
%      [P,Z] = PZMAP(SYS)
%   returns the poles and zeros of the system in the column vectors 
%   P and Z.  No plot is drawn on the screen.  
%
%   The functions SGRID or ZGRID can be used to plot lines of constant
%   damping ratio and natural frequency in the s or z plane.
%
%   For arrays SYS of LTI models, PZMAP plots the poles and zeros of
%   each model in the array on the same diagram.
%
%   See also POLE, ZERO, RLOCUS, SGRID, ZGRID, LTIMODELS.

%	Clay M. Thompson  7-12-90
%	Revised ACWG 6-21-92, AFP 12-1-95, PG 5-10-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/08/26 16:42:32 $

error('PZMAP is not supported for FRD models.')
