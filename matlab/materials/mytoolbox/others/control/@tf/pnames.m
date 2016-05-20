function [Props,AsgnVals] = pnames(sys,flag)
%PNAMES  All public properties and their assignable values
%
%   [PROPS,ASGNVALS] = PNAMES(SYS) returns the list PROPS of
%   public properties of the TF object SYS, as well as the
%   assignable values ASGNVALS for these properties.  Both
%   PROPS and ASGNVALS are cell vector of strings, and PROPS
%   contains the true case-sensitive property names, including 
%   the parent properties.
%
%   [PROPS,ASGNVALS] = PNAMES(SYS,'specific') returns only
%   the TF-specific public properties of SYS.
%
%   See also  GET, SET.

%       Author(s): P. Gahinet, 7-8-97
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.3 $  $Date: 1998/02/12 19:55:34 $

no = nargout;

% TF-specific public  properties  and their assignable values
Props = {'num' ; 'den' ; 'Variable'};
if no>1,
   AsgnVals = {'Ny-by-Nu cell of row vectors (Nu = no. of inputs)'; ...
               'Ny-by-Nu cell of row vectors (Ny = no. of outputs)'; ...
               '[ ''s'' | ''p'' | ''z'' | ''z^-1'' | ''q'' ]' };
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
