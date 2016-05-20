function value = iptgetpref(prefName)
%IPTGETPREF Get Image Processing Toolbox preference.
%   VALUE = IPTGETPREF(PREFNAME) returns the value of the Image
%   Processing Toolbox preference specified by the string
%   PREFNAME.  Valid preference names are 'ImshowBorder' and
%   'ImshowAxesVisible'.  Preference names are case insensitive
%   and can be abbreviated.
%
%   IPTGETPREF without an input argument displays the current
%   setting of all Image Processing Toolbox preferences.
%
%   Example
%   -------
%       value = iptgetpref('ImshowAxesVisible')
%
%   See also IMSHOW, IPTSETPREF.

%   Steven L. Eddins, January 1997
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 1.5 $  $Date: 1997/11/24 15:35:41 $

error(nargchk(0,1,nargin));

% Get IPT factory preference settings.
factoryPrefs = iptprefs;
allNames = factoryPrefs(:,1);

% What is currently stored in the IPT registry?
registryStruct = iptregistry;
if (isempty(registryStruct))
    registryFieldNames = {};
else
    registryFieldNames = fieldnames(registryStruct);
end

if (nargin == 0)
    % Display all current preference settings.
    value = [];
    for k = 1:length(allNames)
        thisField = allNames{k};
        registryContainsPreference = length(strmatch(thisField, ...
                registryFieldNames, 'exact')) > 0;
        if (registryContainsPreference)
            value = setfield(value, thisField, ...
                    getfield(registryStruct, thisField));
        else
            % Use default value
            value = setfield(value, thisField, factoryPrefs{k,3}{1});
        end
    end
    
else
    % Return specified setting.
    if (~isa(prefName, 'char'))
        error('Preference name must be a string.');
    end

    % Convert factory preference names to lower case.
    lowerNames = cell(size(allNames));
    for k = 1:length(lowerNames)
        lowerNames{k} = lower(allNames{k});
    end
    
    matchIdx = strmatch(lower(prefName), lowerNames);
    if (isempty(matchIdx))
        error(sprintf(['Unknown Image Processing ' ...
                    'Toolbox preference "%s".'], prefName));
    elseif (length(matchIdx) > 1)
        error(sprintf(['Ambiguous Image Processing ' ...
                    'Toolbox preference "%s".'], prefName));
    else
        preference = allNames{matchIdx};
    end

    registryContainsPreference = length(strmatch(preference, ...
            registryFieldNames, 'exact')) > 0;
    if (registryContainsPreference)
        value = getfield(registryStruct, preference);
    else
        value = factoryPrefs{matchIdx, 3}{1};
    end
end

