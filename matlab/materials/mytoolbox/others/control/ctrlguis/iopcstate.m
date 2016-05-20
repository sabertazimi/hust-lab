function iopcstate(Hin, newstate)
% Set the linearization state of a single I/O Point

%   Authors: G. Wolodkin, K. Gondoly
%   Copyright (c) 1986-1999 The Mathworks, Inc. All Rights Reserved.
%   $Revision: 1.2 $

switch get_param(Hin,'masktype');
case 'InputPoint'
   % Get block & line handles
   tblk  = local_find_system(Hin,'Terminator');
   oblk  = local_find_system(Hin,'Outport');
   sblk  = local_find_system(Hin,'Sum');
   iblk  = local_find_system(Hin,'Inport');
   Lines = get_param(Hin,'Lines');

   % Perturbed output from sum block to Outport/Terminator
   pline = Lines(handList(Lines.SrcBlock)==sblk);

   % Feedthrough from Inport block to Outport/Terminator
   fline = Lines(handList(Lines.SrcBlock)==iblk);
   ix = handList(fline.Branch.DstBlock)~=sblk;
   fbran = fline.Branch(ix);

   % Swap position of Outport and Terminator
   tpos = get_param(tblk,'Position');
   opos = get_param(oblk,'Position');

   fstate = tpos(2)>opos(2);		% perturbed output
   
   if newstate ~= fstate
      % Delete these lines
      delete_line(pline.Handle);
      delete_line(fbran.Handle);
      
     set_param(tblk,'Position',opos);
     set_param(oblk,'Position',tpos);
     
     % Reconnect the same lines
     add_line(Hin,pline.Points);
     add_line(Hin,fbran.Points);
     
     % Set Inport PortWidth to size of PerturbationValue
     P = get_param(Hin,'PerturbationValue');
     p = eval(P);
     Plength = length(p);
     set_param(iblk,'PortWidth',num2str(Plength));
   end % if newstate~=fstate

case 'OutputPoint'
   % Get block & line handles
   tblk = local_find_system(Hin,'Terminator');
   sblk = local_find_system(Hin,'S-Function');
   oblk = local_find_system(Hin,'Outport');
   iline = get_param(Hin,'Lines');		% only one line
   ix = handList(iline.Branch.DstBlock)~=oblk;
   fbran = iline.Branch(ix);			% branch to tblk/sblk

   % S-function parameters
   oind = get_param(Hin,'SigprobeOutputIndex');
   pstr = ['''y' oind ''''];

   fstate = ~isempty(sblk);			% Sigprobe in place
   if fstate == newstate
      set_param(sblk,'Parameters',pstr);
      return					% that's what we want
   end
   
   delete_line(fbran.Handle);			% otherwise swap state
   if fstate
     pp = get_param(sblk,'Position');
     delete_block(sblk);
     add_block('built-in/Terminator',...
               [getfullname(Hin) '/Terminator'],...
               'Position',['[' num2str(pp) ']']);
   else
     pp = get_param(tblk,'Position');
     delete_block(tblk);
     add_block('built-in/S-Function',...
               [getfullname(Hin) '/S-Function'],...
               'Position',['[' num2str(pp) ']'],...
               'FunctionName','sigprobe',...
               'Parameters',pstr);
   end
   add_line(Hin,fbran.Points);
end

%----

function blk = local_find_system(Hin, btype)
% find_system with lots of verbose constraints

blk = find_system(Hin,'LookUnderMasks','all','FollowLinks','on',...
                  'blocktype',btype);
%----

function y = handList(varargin)
% Replace [] in Simulink structures with NaN
% Specifically, turn {1 [] 3} into [1 NaN 3]

ci = varargin;
ix = cellfun('isempty',ci);
ci(ix) = {NaN};
y = [ci{:}];

