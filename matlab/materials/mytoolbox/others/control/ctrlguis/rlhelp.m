function rlhelp(varargin);
%RLHELP Help text for the Root Locus Design GUI
%   RLHELP(ACTION) displays the help text for the portion of
%   the Root Locus GUI specified by ACTION. 

%   Karen D. Gondoly
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
% $Revision: 1.3 $

ni=nargin;

if ni
   action=varargin{1};
else
   return
end

switch action,
case 'main',
   %---Help for the main Root Locus Design window
   helptext={'Overview', ...
         {'The Root Locus Design GUI is an interactive environment for developing';
         'compensators using root locus techniques. ';
         '';
         'The Root Locus Design GUI helps you design a SISO compensator by:';
         '  1) Adding/removing compensator poles and zeros';
         '  2) Changing the compensator gain';
         '  3) Draging compensator poles and zeros';
         '  4) Dragging the closed-loop poles';
         '  4) Drawing constraints for the closed-loop poles';
         '  5) Viewing closed-loop time and frequency responses';
         '';
         'Flip through the remaining Topics for a detailed description of how ';
         'to use these and other Root Locus Design GUI features.'};
      'Menus', ...
         {'The menus provide additional options for setting up and configuring ';
         'the compensator design. The menus available are as follows.';
         '';
         '1) File:';
         '     a) Import Model: Import an LTI design model';
         '     b) Import Compensator: Import an LTI compensator';
         '     c) Export: Export open-loop, closed-loop or compensator models';
         '     d) Draw Simulink Diagram: Create a closed-loop Simulink diagram';
         '     e) Display History: Lists all steps in the compensator design.';
         '     f) Print locus: Generate a hard copy of the Root Locus Axes.';
         '     g) Send Locus to Figure: Open a separate figure showing only the locus';
         '     h) Exit Design: Closes the Root Locus Design GUI and all related windows.';
         '';
         '';
         '2) Tools:';
         '     a) Edit Compensator: Modify the compensator poles, zeros and name.';
         '     b) List ModelPoles/Zeros: Display the design model poles and zeros.';
         '     c) List Closed-loop Poles: Display the closed-loop poles.';
         '     d) Convert Model/Compensator: Convert the model and compensator';
         '          from continuous to discrete, and back again.';
         '     e) Clear Model: Remove all model data from the Root Locus GUI.';
         '     f) Add Grid/Boundary: Add a grid and/or boundaries to the Root Locus'; 
         '          Axes.';
         '';
         '     g) Set Axes Preferences: Set the axis limits or root locus plot colors';
         '';
         '';
         '3) Window:';
         '     Show and switch between all the open windows.';
         '';
         '';
         '4) Help:';
         '     a) Main Help: Open the general Root Locus Design GUI help text.';
         '     b) All other Help menus: Open Tool specific help text.'};
         'Current Compensator Text', ...
         {'The Current Compensator text displays the poles and zeros of the current';
         'compensator design, including the gain "Gain".';
         '';
         '  1) Click in this field to open the Edit Compensator window';
         '  2) "numK", or "denK" indicates the text is to large for the field';
         '';
         '  To view text that is too long, either:';
         '     a) Resize the Root Locus GUI or';
         '     b) Click on the "Zeros" or "Poles" text in the Edit Compensator window.'};
         'Feedback Structure', ...
         {'The feedback structure field displays the connectivity between';
         'the compensator and the design model. ';
         '';
         'The feedback structure is fixed once the design model has been imported,';
         'however, different feedback structures may be available. See the Import';
         'window for a selection of available feedback structures.';
         '';
         'The +/- button toggles the feedback sign between positive and negative.';
         '';
         'You can access other Root Locus GUI utility windows directly from the';
         'closed-loop configuration diagram.';
         '  1) Click on the compensator block (Gc) to open the Edit Compensator window.';
         '  2) Click on the Plant block to open the List Model Poles/Zeros window.'};
      'The Root Locus Toolbar', ...
        {'The toolbar above the Root Locus Axes provides functions for ';
         'interactively designing the compensator. Only one function can be active';
         'at any particular time. To use the toolbar:';
         '';
         '  1) Press the button associated with the desired function.'
         '  2) Perform the action by clicking on the Root Locus Axes.';
         '  3) The default axes functions are restored after performing the action once.';
         '';
         '';
         'The functions, from left to right, are:';
         '  1) Defaults';
         '  2) Add compensator poles';
         '  3) Add compensator zeros';
         '  4) Erase compensator poles or zeros';
         '';
         'To Use:';
         '  1) The Default mode:';
         '     a) Click/Drag closed-loop poles: Moves the pole along its locus.';
         '     b) Click root locus: Places closed-loop poles at that location.';
         '     c) Click/drag compensator pole/zero: Moves it to the pointer location.';
         '     d) Double click on a compensator pole/zero: Opens the Edit Compensator';
         '           window.';
         '';
         '  2/3) The Add Pole/Zero mode:';
         '     a) Click in the Root Locus Axes to add poles/zeros at that location';
         '     b) Poles/zeros dropped near the real axis are forced onto the axis';
         '     c) Complex conjugates are added for poles/zeros dropped elsewhere';
         '';
         '  4) The Erase mode:';
         '     a) Click on a compensator pole or zero to remove it;';
         '     b) Complex conjugates are automatically removed, as well.';
         '';
         '';
         'Changing the Gain:';
         '  The compensator gain can be changed in three ways:';
         '';
         '    1) Enter a value in the Gain text box above the Root Locus Axes';
         '    2) Drag a closed-loop pole to a new location to find that gain';
         '    3) Click on a specific locus location to find that gain'};      
         'The Root Locus Axes', ...
         {'The axes display the current model and compensator poles and zeros, ';
         'their root locus, and the current closed-loop pole locations. It provides';
         'various features for designing and manipulating the compensator.';
         '';
         'By default:';
         '';
         '   1) An "O" marks any compensator or plant zero location';
         '   2) An "X" marks any compensator or plant pole location';
         '   3) Squares mark the closed-loop pole locations';
         '   4) The plant poles and zeros are blue, as is the root locus.';
         '   5) The compensator poles and zeros are red';
         '   6) The closed-loop poles are red';
         '';
         '   To change the default, either:';
         '';
         '       a) Select Set Axes Preferences... from the Tools menu';
         '       b) Click on the "Axes settings" text below the Root Locus Axes';
         '';
         '';
         'The cursor shape over the Root Locus Axes indicates the active axis mode.'; 
         '';
         '  1) Default mode = plain white arrow.';
         '  2) White arrow with an ''x'' = Add Pole';
         '  3) White arrow with an ''o'' = Add Zero';
         '  4) Eraser = Erase';
         '  5) Crosshairs = Zoom';
         '  6) Open hand = The cursor is over a draggable object';
         '  7) Closed hand = Drag an object';
         ''};
      'Axes Functions:', ...
         {'The remaining controls above and below the Root Locus Axes';
         'provide additional functions for customizing the view of the locus.';
         '';
         '1)Grid: Toggle the grid by checking the Grid box either:';
         '        1) Above the Root Locus Axes';
         '        2) On the Grid and Constraints Options window';
         '';
         '     From the Grid and Constraints Options window';
         '        a) Select the type of grid to display ';
         '        b) Add boundaries on the Root Locus Axes for values of constant';
         '           1) damping ratio';
         '           2) natural frequency';
         '           3) settling time';
         '';
         '2)Axes Settings: Four axes settings buttons are located at the lower left';
         '     corner of the Root Locus Axes.';
         '';
         '       a) Save: Store the current axes limits';
         '       b) Restore: Use the last saved axes limits and preferences';
         '       c) Square/rectangle: Toggle the axes shape';
         '       d) Equal/unequal: Toggle the axes aspect ratios';
         '';
         '     Caution: The Restore button over-rides the square and equal settings.';
         ''
         '     Note: The settings can also be changed in the Axes Preferences window';
         '';
         '3)Zooming: Four zoom features are located to the lower right of the ';
         '     Root Locus Axes. In order, these:';
         '       a) Zoom in the X-direction, only';
         '       b) Zoom in the Y-direction, only';
         '       c) Zoom in both the X- and Y-directions';
         '       d) Zoom out to show the entire locus';
         '';
         '    Selecting any of the zoom functions allows you to zoom in on the'
         '    Root Locus Axes once.'};
      'Viewing Responses', ...
         {'The response check boxes allow you to view time/frequency domain ';
         'responses in an LTI Viewer.';
         '';
         'When you select any of the response check boxes, an LTI Viewer ';
         'linked to the Root Locus Design Tool opens.  This Viewer contains';
         'the open-loop and closed-loop model used in the Root Locus';
         'Design Tool. By default, step and impulse responses of the closed-';
         'loop model, and Bode plots, Nyquist diagrams, and Nichols ';
         'charts of the open-loop model are shown.';
         '';
         'If you select additional check boxes, the response plots are';
         'added to the current Viewer.  You can show all 5 responses at once,';
         'if desired.';
         '';
         'Once a response is plotted, you can right-click on the axes to access';
         'various controls for manipulating and interpreting the plot.';
         '';
         'The response is updated under the following conditions:';
         '  1) A compensator pole/zero is added.';
         '  2) A compensator pole/zero is moved.';
         '       (Note: The response is updated when the pole/zero is dropped ';
         '              on its new location, not while it is being moved.)';
         '  3) The closed-loop poles are moved.';
         '       (Note: Again, the response is updated when the pole is dropped ';
         '              on its new location, not while it is being moved.)';
         '  4) The gain is changed (using any of the gain changing methods.)';
         '  5) The feedback sign is changed.';
         ''}};
   
case 'configure',
   %---Help for the Closed-loop configuration window
   helptext = {'Closed-loop Configurations', ...
         {'The Closed-loop Configurations window shows all the available closed-loop ';
         'configurations.';
         '';
         '   1) Use the radio buttons to select the desired configuration';
         '   2) Press OK button to accept change to the selected configuration';
         '   3) Press Close to ignore any changes in configuration selection'}};
         
case 'editcomp',
   %---Help for the Edit Compensator window
   helptext = {'Editing the Compensator', ...
         {'The Edit Compensator window allows you to explicitly specify the ';
         'compensator poles and zeros, and change the compensator name.';
         '';
         '  1) Changing a pole/zero location';
         '     a) Click in the appropriate editable text field';
         '     b) Enter the new value';
         '     c) Make the imaginary value empty or zero to change the complex';
         '        pole/zero pair into a single pole/zero on the real axis';
         '';
         '  2) Deleting a pole/zero';
         '     a) Check the associated Delete box.';
         '     b) Both poles/zeros are deleted if they are complex.';
         '';
         '  3) Adding poles/zeros';
         '     a) Press the Add Pole or Add Zero button';
         '     b) Enter the desired location for the pole or zero';
         '';
         'Poles or zeros with neither real nor imaginary values specified are ignored.'}};
   
case 'discretize',
   %---Help for the Discretize window
   helptext={'Convert Model', ...
         {'Use the Convert Continuous/Discrete Model window to convert the plant';
         'and compensator between continuous and discrete.';
         '';
         'For continuous systems:';
         '  1) Choose a discretization method';
         '  2) Enter a positive sample time';
         '  3) Enter a critical frequency, if using prewarping';
         '';
         'For discrete systems:';
         '  1) Choose the type of conversion';
         '     a) to continuous';
         '     b) to resampled discrete';
         '  2) Select a conversion method';
         '  3) Enter a sample time when resampling the model (Note: this value';
         '     is ignored for continous conversions)';
         '  4) Enter a critical frequency, if using prewarping';
         '';
         'In both cases, both the Plant and Compensator are converted.'};
      'Continuous Models', ...
         {'If the plant is continuous, the Convert Model window';
         'can be used to convert it to discrete by:';
         '';
         '   1) Selecting the conversion method';
         '   2) Entering the sample time';
         '   3) Pressing the OK button';
         '';
         'If both a plant and compensator are currently stored in the Root Locus';
         'Design GUI, both are converted using the same method and sampling time.'};      
      'Discrete Models', ...
         {'If the plant is discrete, the Convert Model window';
         'is used to:';
         '   1) Convert a discrete model to continuous';
         '   2) Resample a discrete model';
         '';
         'You can convert the model by:';
         '   1) Selecting the conversion method';
         '   2) Pressing the OK button';
         '';
         'If both a plant and compensator are currently stored in the Root Locus';
         'Design GUI, both are converted using the same method. Any entries';
         'in the Sampling Time field are ignored.';
	      '';
         'You can resample the model by:';
         '   1) Checking the Resample? box';
         '   2) Entering the new sample time in the editable text field';
         '   3) Pressing the OK button';
         '';
         'If the Resample box is checked, it is assumed you are resampling';
         'the model. It will only be converted to continous when the Resample';
         'box is unchecked.'}};
         
case 'grid',
   %---Help for the Grid and Constraints Options window
   helptext = {'Grids and Constraints', ...
         {'Use the Grid and Constraints Options window to specify what type';
         'of grid and constraints should be labled on the Root Locus Design window.';
         '';
         'Grid Options:';
         '  A grid is displayed whenever the Grid Checkbox is checked on:';
         '     1) The main Root Locus Design GUI';
         '     2) The Grid and Constraints Options window'; 
         '';
         '  The type of grid is determined by the radio button on the Grid and';
         '  Constraints Options window. You can choose from the following grids:'
         '     1) Constant damping ratio and natural frequency (sgrid/zgrid)';
         '     2) Constant Peak Overshoot (similar to constant damping ratio)';
         '';
         '     By default, the sgrid or zgrid is displayed.';
         '';
         'Constraint Options:';
         '  A constraint is displayed for all of the checked Constraint check boxes.';
         '';
         '  1) Use the editable text fields to indicate constant boundary values';
         '  2) Separate multiple boundary values using spaces, commas, or semicolons';
         '';
         '  By default, no boundaries are drawn.'}};

case 'axes',
   %---Help for the Axes Preferences window
   helptext={'Axes Preferences',...
         {'Use the Axes Preferences window to change the axis limits or root locus';
         'colors.'
         '';
         'Axes Limits:';
         '  1) Displays the current set of axis limit preferences';
         '  2) Uses current axis limits if no preferences have been set';
         '  3) Change the appropriate text entries to set the axis limit preferences.';
         '  4) Maximum limit must be greater then the lower limit.';
         '';
         'Axes Equal and Square:';
         '  1) Checking Axis Equal makes the axes limits change so ';
         '     there are equal tick mark increments on both the X- and Y- axis.';
         '  2) Checking Axis Square makes the X- and Y-axis the same size';
         '';
         '  Note: If both the Axis Equal and Axis Square boxes are checked, the X- ';
         '  and Y-axes will have the same length and same limits.';
         '';
         '  Caution: Changing the Axis Equal and Square settings may over-ride any ';
         '    preferred axes limits.';
         '';
         'Root Locus Colors:';
         '  The window can also be used to change the colors used for displaying the ';
         '   root locus and all poles and zeros. By default:';
         '   1) Blue = Root locus and model poles/zeros';
         '   2) Red = Compensator poles/zeros';
         '   3) Red squares = Closed-loop poles';
         '';
         '  The popup menus can be used to change one or all of the following:';
         '   1) The color of the root locus and model poles/zeros';
         '   2) The color of the compensator poles/zeros';
         '   3) The color of the closed-loop poles';
         '   4) The shape of the closed-loop poles'}};
end, % switch action

helpwin(helptext);
