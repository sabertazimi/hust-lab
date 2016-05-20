function [Props,AsgnVals] = pnames(sys,flag)
%PNAMES  All public properties and their assignable values
%
%   [PROPS,ASGNVALS] = PNAMES(SYS) returns the list PROPS of
%   public properties of the SS object SYS, as well as the
%   assignable values ASGNVALS for these properties.  Both
%   PROPS and ASGNVALS are cell vector of strings, and PROPS
%   contains the true case-sensitive property names, including 
%   the parent properties.
%
%   [PROPS,ASGNVALS] = PNAMES(SYS,'specific') returns only
%   the SS-specific public properties of SYS.
%
%   See also  GET, SET.

%       Author(s): P. Gahinet, 7-8-97
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.6 $  $Date: 1998/10/01 20:12:27 $

no = nargout;

% SS-specific public properties and their assignable values
Props = {'a' ; 'b' ; 'c' ; 'd' ; 'e' ; 'StateName'};
if no>1,
   AsgnVals = {'Nx-by-Nx matrix (Nx = no. of states)'; ...
               'Nx-by-Nu matrix (Nu = no. of inputs)'; ...
               'Ny-by-Nx matrix (Ny = no. of outputs)'; ...
               'Ny-by-Nu matrix'; ...
               'Nx-by-Nx matrix (or [])';...
               'Nx-by-1 cell array of strings'};
end

% Add public parent properties unless otherwise requested
if nargin==1,
   if no==1,
      Props = [Props ; pnames(sys.lti)];
   else
      [LTIprops,LTIvals] = pnames(sys.lti);
      Props = [Props ; LTIprops];
      AsgnVals = [AsgnVals ; LTIvals];
   end
end

