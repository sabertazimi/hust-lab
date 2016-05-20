function h=imshow(varargin)
%IMSHOW Display image.
%   IMSHOW(I,N) displays the intensity image I with N discrete
%   levels of gray. If you omit N, IMSHOW uses 256 gray levels on
%   24-bit displays, or 64 gray levels on other systems.
%
%   IMSHOW(I,[LOW HIGH]) displays I as a grayscale intensity
%   image, specifying the data range for I. The value LOW (and
%   any value less than LOW) displays as black, the HIGH (and any
%   value greater than HIGH) displays as white, and values in
%   between display as intermediate shades of gray. IMSHOW uses
%   the default number of gray levels. If you use an empty matrix
%   ([]) for [LOW HIGH], IMSHOW uses [min(I(:)) max(I(:))]; the
%   minimum value in I displays as black, and the maximum value
%   displays as white.
%
%   IMSHOW(BW) displays the binary image BW. Values of 0 display
%   as black, and values of 1 display as white.
%
%   IMSHOW(X,MAP) displays the indexed image X with the colormap
%   MAP.
%
%   IMSHOW(RGB) displays the truecolor image RGB.
%
%   IMSHOW(...,DISPLAY_OPTION) displays the image, calling
%   TRUESIZE if DISPLAY_OPTION is 'truesize', or suppressing the
%   call to TRUESIZE if DISPLAY_OPTION is 'notruesize'. Either
%   option string can be abbreviated. If you do not supply this
%   argument, IMSHOW determines whether to call TRUESIZE based on
%   the setting of the 'ImshowTruesize' preference.
%
%   IMSHOW(x,y,A,...) uses the 2-element vectors x and y to
%   establish a nondefault spatial coordinate system, by
%   specifying the image XData and YData.
%
%   IMSHOW(FILENAME) displays the image stored in the graphics
%   file FILENAME. IMSHOW calls IMREAD to read the image from the
%   file, but the image data is not stored in the MATLAB
%   workspace. The file must be in the current directory or on
%   the MATLAB path.
%
%   H = IMSHOW(...) returns the handle to the image object
%   created by IMSHOW.
%
%   Class Support
%   -------------
%   The input image can be of class uint8, uint16, or double.
%
%   Remarks
%   -------
%   You can use the IPTSETPREF function to set several toolbox
%   preferences that modify the behavior of IMSHOW:
%
%   - 'ImshowBorder' controls whether IMSHOW displays the image
%     with a border around it.
%
%   - 'ImshowAxesVisible' controls whether IMSHOW displays the
%     image with the axes box and tick labels.
%
%   - 'ImshowTruesize' controls whether IMSHOW calls the TRUESIZE
%     function.
%
%   For more information about these preferences, see the
%   reference entry for IPTSETPREF.
%
%   See also IMREAD, IPTGETPREF, IPTSETPREF, SUBIMAGE, TRUESIZE, WARP, IMAGE, IMAGESC.

%   Clay M. Thompson 5-12-93
%   Revised Steven L. Eddins, April 1996
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 5.24 $  $Date: 1998/02/17 22:06:50 $

% 1. Parse input arguments
% 2. Get an axes to plot in.
% 3. Create the image and axes objects and set their display
%    properties.
% 4. If the image is alone in the figure, position the axes
%    according to the current IMBORDER setting and then call
%    TRUESIZE.
%
% Local function:
% ParseInputs
% IsVector
% DoTruesize

newFigure = isempty(get(0,'CurrentFigure')) | ...
        strcmp(get(get(0,'CurrentFigure'), 'NextPlot'), 'new');

[imtype, cdata, cdatamapping, clim, map, xdata, ydata, filename, ...
            truesizeStr] = ParseInputs(varargin{:});
imsize = size(cdata);
imsize = imsize(1:2);  % In case ndims(cdata) > 2

if (newFigure)
    figHandle = figure('Visible', 'off');
    axHandle = axes('Parent', figHandle);
else
    axHandle = newplot;
    figHandle = get(axHandle, 'Parent');
end

% Make the image object.
hh = image(xdata, ydata, cdata, 'BusyAction', 'cancel', ...
   'Parent', axHandle, 'CDataMapping', cdatamapping, ...
   'Interruptible', 'off');

% Set axes and figure properties if necessary to display the 
% image object correctly.
showAxes = iptgetpref('ImshowAxesVisible');
set(axHandle, ...
        'TickDir', 'out', ...
        'XGrid', 'off', ...
        'YGrid', 'off', ...
        'DataAspectRatio', [1 1 1], ...
        'PlotBoxAspectRatioMode', 'auto', ...
        'Visible', showAxes);
set(get(axHandle,'Title'),'Visible','on');
set(get(axHandle,'XLabel'),'Visible','on');
set(get(axHandle,'YLabel'),'Visible','on');
if (~isempty(map))
    set(figHandle, 'Colormap', map);
end
if (~isempty(clim))
    set(axHandle, 'CLim', clim);
end

% Do truesize if called for.
truesizePref = iptgetpref('ImshowTruesize');
autoTruesize = strcmp(truesizePref, 'auto');
singleImage = SingleImageDefaultPos(figHandle, axHandle);


% Syntax specification overrides truesize preference setting.
if (strcmp(truesizeStr, 'notruesize'))
    callTruesize = 0;
    
elseif (strcmp(truesizeStr, 'truesize'))
    callTruesize = 1;
    
else
    % If there was no command-line override, and the truesize preference
    % is 'on', we still might not want to call truesize if the image
    % isn't the only thing in the figure, or if it isn't in the 
    % default position.

    if (autoTruesize)
        callTruesize = singleImage;
    else
        callTruesize = 0;
    end
end

% Adjust according to ImshowBorder setting, unless we don't have a single
% image in the default position.
borderPref = iptgetpref('ImshowBorder');
if (strcmp(borderPref, 'tight') & singleImage)
    % Have the image fill the figure.
    set(axHandle, 'Units', 'normalized', 'Position', [0 0 1 1]);
    
    % The next line is so that a subsequent plot(1:10) goes back
    % to the default axes position instead of taking up the
    % entire figure.
    set(figHandle, 'NextPlot', 'replacechildren');
end

if (callTruesize)
    truesize(figHandle);
end

if (~isempty(filename) & isempty(get(get(axHandle,'Title'),'String')))
    set(get(axHandle, 'Title'), 'String', filename, ...
            'Interpreter', 'none', ...
            'Visible', 'on');
end

if (nargout > 0)
  % Only return handle if caller requested it.
  h = hh;
end

if (newFigure)
    set(figHandle, 'Visible', 'on');
end


%----------------------------------------------------------------------
% Subfunction ParseInputs
%----------------------------------------------------------------------

function [imtype, cdata, cdatamapping, clim, map, xdata, ...
            ydata, filename, truesizeStr] =  ParseInputs(varargin);

filename = '';
truesizeStr = '';

if (get(0,'ScreenDepth') > 16)
    defGrayMapLength = 256;
else
    defGrayMapLength = 64;
end

% If nargin > 1, see if there's a trailing string argument.
if ((nargin > 1) & (ischar(varargin{end})))
    str = varargin{end};
    varargin(end) = [];  % remove string from input arg list
    strs = {'truesize', 'notruesize'};
    idx = strmatch(str, strs);
    if (isempty(idx))
        error(sprintf('Unknown option string "%s"', str));
    elseif (length(idx) > 1)
        error(sprintf('Ambiguous option string "%s"', str));
    else
        truesizeStr = strs{idx};
    end
end

switch length(varargin)
case 0
    error('Not enough input arguments.  See HELP IMSHOW');
    
case 1
    % IMSHOW(I)
    % IMSHOW(RGB)
    % IMSHOW(FILENAME)
    
    if (isstr(varargin{1}))
        % IMSHOW(FILENAME)
        filename = varargin{1};
        [cdata,map] = imread(filename);
        xdata = (1:size(cdata,2));
        ydata = (1:size(cdata,1));
        if (isempty(map))
            if (ndims(cdata) == 3)
                imtype = 'rgb';
                map = [];
            else
                imtype = 'intensity';
                map = gray(defGrayMapLength);
            end
            cdatamapping = 'scaled';
            if (isa(cdata, 'double'))
                clim = [0 1];
            elseif (isa(cdata, 'uint8') & ~islogical(cdata))
                clim = [0 255];
            elseif (isa(cdata, 'uint8') & islogical(cdata))
                clim = [0 1];
            elseif (isa(cdata, 'uint16'))
                % Binary uint16 images not supported
                clim = [0 65535];
            end
            
        else
            imtype = 'indexed';
            cdatamapping = 'direct';
            clim = [];  % irrelevant
        end
    
    elseif (ndims(varargin{1}) == 3)
        % IMSHOW(RGB)
        imtype = 'rgb';
        cdata = varargin{1};
        cdatamapping = 'direct'; % irrelevant for RGB
        clim = [];               % irrelevant for RGB
        map = [];                % irrelevant for RGB
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    else
        % IMSHOW(I)
        imtype = 'intensity';
        cdata = varargin{1};
        cdatamapping = 'scaled';
        switch class(cdata)
        case 'uint8'
            if (islogical(cdata))
                clim = [0 1];
            else
                clim = [0 255];
            end
        case 'uint16'
            % Binary uint16 images not supported
            clim = [0 65535];
        case 'double'
            clim = [0 1];
        otherwise
            error('Unsupported image class');
        end
        map = gray(defGrayMapLength);
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    end
    
case 2
    % IMSHOW(X,map)
    % IMSHOW(I,N)
    % IMSHOW(I,[a b])
    % IMSHOW(I,[])
    
    if (prod(size(varargin{2})) == 1)
        % IMSHOW(I,N)
        imtype = 'intensity';
        cdata = varargin{1};
        cdatamapping = 'scaled';
        switch class(cdata)
        case 'uint8'
            if (islogical(cdata))
                clim = [0 1];
            else
                clim = [0 255];
            end
        case 'uint16'
            clim = [0 65535];
        case 'double'
            clim = [0 1];
        otherwise
            error('Unsupported image class');
        end
        map = gray(varargin{2});
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    elseif (isequal(size(varargin{2}), [1 2]))
        % IMSHOW(I,[a b])
        imtype = 'intensity';
        cdata = varargin{1};
        cdatamapping = 'scaled';
        clim = varargin{2};
        map = gray(defGrayMapLength);
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    elseif (size(varargin{2},2) == 3)
        % IMSHOW(X,map)
        imtype = 'indexed';
        cdata = varargin{1};
        cdatamapping = 'direct';
        clim = [];   % irrelevant
        map = varargin{2};
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    elseif (isempty(varargin{2}))
        % IMSHOW(I,[])
        imtype = 'intensity';
        cdata = varargin{1};
        cdatamapping = 'scaled';
        clim = [min(cdata(:)) max(cdata(:))];
        map = gray(defGrayMapLength);
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    else
        error('Invalid input arguments; see HELP IMSHOW');
        
    end
    
case 3
    % IMSHOW(R,G,B)
    % IMSHOW(x,y,I)
    % IMSHOW(x,y,RGB)
    
    if (ndims(varargin{3}) == 3)
        % IMSHOW(x,y,RGB)
        imtype = 'rgb';
        cdata = varargin{3};
        cdatamapping = 'direct'; % irrelevant
        clim = [];               % irrelevant
        map = [];                % irrelevant
        xdata = varargin{1};
        ydata = varargin{2};
        
    elseif (IsVector(varargin{1}) & IsVector(varargin{2}))
        % IMSHOW(x,y,I)
        imtype = 'intensity';
        cdata = varargin{3};
        cdatamapping = 'scaled';
        switch class(cdata)
        case 'uint8'
            if (islogical(cdata))
                clim = [0 1];
            else
                clim = [0 255];
            end
        case 'uint16'
            clim = [0 65535];
        case 'double'
            clim = [0 1];
        otherwise
            error('Unsupported image class');
        end
        map = gray(defGrayMapLength);
        xdata = varargin{1};
        ydata = varargin{2};
        
    elseif (isequal(size(varargin{1}), size(varargin{2})) & ...
                isequal(size(varargin{1}), size(varargin{3})))
        % IMSHOW(R,G,B)
        imtype = 'rgb';
        cdata = cat(3,varargin{:});
        cdatamapping = 'direct';        % irrelevant
        clim = [];                      % irrelevant
        map = [];                       % irrelevant
        xdata = [1 size(cdata,2)];
        ydata = [1 size(cdata,1)];
        
    else
        error('Invalid input arguments; see HELP IMSHOW');
        
    end
    
case 4
    % IMSHOW(x,y,X,MAP)
    % IMSHOW(x,y,I,N)
    % IMSHOW(x,y,I,[a b])
    % IMSHOW(x,y,I,[])
    
    if (prod(size(varargin{4})) == 1)
        % IMSHOW(x,y,I,N)
        imtype = 'intensity';
        cdata = varargin{3};
        cdatamapping = 'scaled';
        switch class(cdata)
        case 'uint8'
            if (islogical(cdata))
                clim = [0 1];
            else
                clim = [0 255];
            end
        case 'uint16'
            clim = [0 65535];
        case 'double'
            clim = [0 1];
        otherwise
            error('Unsupported image class');
        end
        map = gray(varargin{4});
        xdata = varargin{1};
        ydata = varargin{2};
        
    elseif (isequal(size(varargin{4}), [1 2]))
        % IMSHOW(x,y,I,[a b])
        imtype = 'intensity';
        cdata = varargin{3};
        cdatamapping = 'scaled';
        clim = varargin{4};
        map = gray(defGrayMapLength);
        xdata = varargin{1};
        ydata = varargin{2};
        
    elseif (size(varargin{4},2) == 3)
        % IMSHOW(x,y,X,map)
        imtype = 'indexed';
        cdata = varargin{3};
        cdatamapping = 'direct';
        clim = [];                % irrelevant
        map = varargin{4};
        xdata = varargin{1};
        ydata = varargin{2};
        
    elseif (isempty(varargin{4}))
        % IMSHOW(x,y,I,[])
        imtype = 'intensity';
        cdata = varargin{3};
        cdatamapping = 'scaled';
        clim = [min(cdata(:)) max(cdata(:))];
        map = gray(defGrayMapLength);
        xdata = varargin{1};
        ydata = varargin{2};
        
    else
        error('Invalid input arguments.  See HELP IMSHOW');
        
    end
    
case 5
    % IMSHOW(x,y,R,G,B)

    imtype = 'rgb';
    cdata = cat(3,varargin{3:5});
    cdatamapping = 'direct';           % irrelevant
    clim = [];                         % irrelevant
    map = [];                          % irrelevant
    xdata = varargin{1};
    ydata = varargin{2};
    
otherwise
    
    error('Too many input arguments.  See HELP IMSHOW');
    
end

% Catch complex CData case
if (~isreal(cdata))
    warning('Displaying real part of complex input');
    cdata = real(cdata);
end


%%%
%%% Subfunction IsVector
%%%
function tf = IsVector(x)
%ISVECTOR True if x has only one non-singleton dimension.
tf = (sum(size(x)~=1) <= 1);


%%%
%%% Subfunction SingleImageDefaultPos
%%%
function tf = SingleImageDefaultPos(figHandle, axHandle)

if (length(findobj(axHandle, 'Type', 'image')) > 1)
    % More than one image in axes
    tf = 0;

else

    figKids = allchild(figHandle);
    kids = [findobj(figKids, 'Type', 'axes') ;
        findobj(figKids, 'Type', 'uicontrol', 'Visible', 'on')];
    if (length(kids) > 1)
        % The axes isn't the only thing around, so don't truesize
        tf = 0;
    else
        % Is axHandle in the default position?
        if (isequal(get(axHandle, 'Position'), ...
                    get(get(axHandle,'Parent'), 'DefaultAxesPosition')))
            % Yes, call truesize
            tf = 1;
            
        else
            % No, don't call truesize
            tf = 0;
        end
    end
end
