function preferences = iptprefs
%IPTPREFS Image Processing Toolbox preference settings.
%   IPTPREFS returns a 3-column cell array containing the Image
%   Processing Toolbox preference settings.  Each row contains
%   information about a single preference.  
%   
%   The first column of each row contains a string indicating the
%   name of the preference.  The second column of each row is a
%   cell array containing the set of acceptable values for that
%   preference setting.  An empty cell array indicates that the
%   preference does not have a fixed set of values.  
%
%   The third column of each row contains a single-element cell
%   array containing the default value for the preference.  An
%   empy cell array indicates that the preference does not have a
%   default value.
%
%   See also IPTSETPREF, IPTGETPREF.

%   Steven L. Eddins, January 1997.
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 1.8 $  $Date: 1997/11/24 16:21:52 $

preferences = { ...
      'ImshowBorder',        {'tight'; 'loose'},        {'loose'}
      'ImshowAxesVisible',   {'on'; 'off'},             {'off'}
      'ImshowTruesize',      {'auto'; 'manual'},        {'auto'}
      'TruesizeWarning',     {'on'; 'off'},             {'on'}
   };
        
