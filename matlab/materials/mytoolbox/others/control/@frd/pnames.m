function [Props,AsgnVals] = pnames(sys,flag)
%PNAMES  All public properties and their assignable values
%
%   [PROPS,ASGNVALS] = PNAMES(SYS) returns the list PROPS of
%   public properties of the FRD object SYS, as well as the
%   assignable values ASGNVALS for these properties.  Both
%   PROPS and ASGNVALS are cell vector of strings, and PROPS
%   contains the true case-sensitive property names, including 
%   the parent properties.
%
%   [PROPS,ASGNVALS] = PNAMES(SYS,'specific') returns only
%   the FRD-specific public properties of SYS.
%
%   See also  GET, SET.

%       Author(s): S. Almy, 3-1-98, P. Gahinet, 7-8-97
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.1 $  $Date: 1998/04/14 21:40:36 $

no = nargout;

% FRD-specific public  properties  and their assignable values
Props = {'Frequency' ; 'ResponseData' ; 'Units'};
if no>1,
   AsgnVals = {'vector of frequency points( Nf frequency points)'; ...
               'Ny-by-Nu-by-Nf array of complex responses'; ...
               '[ ''rad/s'' | ''Hz'' ]' };
end
      
      
% Add parent properties unless otherwise requested
if nargin==1,
   if no==1,
      Props = [Props ; pnames(sys.lti)];
   else
      [LTIprops,LTIvals] = pnames(sys.lti);
      Props = [Props ; LTIprops];
      AsgnVals = [AsgnVals ; LTIvals];
   end
end
