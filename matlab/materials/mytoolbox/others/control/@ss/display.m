function display(sys)
%DISPLAY   Pretty-print for LTI models.
%
%   DISPLAY(SYS) is invoked by typing SYS followed
%   by a carriage return.  DISPLAY produces a custom
%   display for each type of LTI model SYS.
%
%   See also LTIMODELS.

%   Author(s): A. Potvin, P. Gahinet, 4-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.15 $  $Date: 1998/07/28 12:59:44 $

% Extract state-space data and sampling/delay times
a = sys.a;   b = sys.b;   c = sys.c;   d = sys.d;   e = sys.e;
Ts = getst(sys.lti);  % sampling time
Inames = get(sys.lti,'InputName');
Onames = get(sys.lti,'OutputName');
StaticFlag = isstatic(sys);

% Get system name
SysName = inputname(1);
if isempty(SysName),
   SysName = 'ans';
end

% Get number of models in array
sizes = size(d);
asizes = [sizes(3:end) , ones(1,length(sizes)==3)];
nsys = prod(asizes);
if nsys>1,
   % Construct sequence of indexing coordinates
   indices = zeros(nsys,length(asizes));
   for k=1:length(asizes),
      range = 1:asizes(k);
      base = repmat(range,[prod(asizes(1:k-1)) 1]);
      indices(:,k) = repmat(base(:),[nsys/prod(size(base)) 1]);
   end
end

% Handle various types
if isempty(a) & isempty(d),
   disp('Empty state-space model.')
   return
   
elseif length(sizes)==2,
   % Single SS model
   printsys(a,b,c,d,e,Inames,Onames,sys.StateName,'');
   
   % Display delay info
   dispdelay(sys.lti,1,'');
   
   % Display LTI properties (I/O groups and sample times)
   dispprop(sys.lti,StaticFlag);
   
   % Last line
   if StaticFlag,
      disp('Static gain.')
   elseif Ts==0,
      disp('Continuous-time model.')
   else
      disp('Discrete-time model.');
   end
   
else
   % SS array
   Marker = '=';
   Nx = sys.Nx;
   Ne = size(e,1);
   
   for k=1:nsys,
      coord = sprintf('%d,',indices(k,:));
      Model = sprintf('Model %s(:,:,%s)',SysName,coord(1:end-1));
      disp(sprintf('\n%s',Model))
      disp(Marker(1,ones(1,length(Model))))
      
      nx = Nx(min(k,end));
      ne = min(Ne,nx);
      printsys(a(1:nx,1:nx,k),b(1:nx,:,k),c(:,1:nx,k),d(:,:,k),e(1:ne,1:ne,k),...
                               Inames,Onames,sys.StateName,'  ');
      
      dispdelay(sys.lti,k,'  ');
  end
   
   % Display LTI properties (I/O groups and sample times)
   disp(' ')
   dispprop(sys.lti,StaticFlag);
   
   % Last line
   ArrayDims = sprintf('%dx',asizes);
   if StaticFlag,
      disp(sprintf('%s array of static gains.',ArrayDims(1:end-1)))
   elseif Ts==0,
      disp(sprintf('%s array of continuous-time state-space models.',...
         ArrayDims(1:end-1)))
   else
      disp(sprintf('%s array of discrete-time state-space models.',...
         ArrayDims(1:end-1)))
   end
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = printsys(a,b,c,d,e,ulabels,ylabels,xlabels,offset)
%PRINTSYS  Print system in pretty format.
% 
%   PRINTSYS is used to print state space systems with labels to the
%   right and above the system matrices.
%
%   PRINTSYS(A,B,C,D,E,ULABELS,YLABELS,XLABELS) prints the state-space
%   system with the input, output and state labels contained in the
%   cellarrays ULABELS, YLABELS, and XLABELS, respectively.  
%   
%   PRINTSYS(A,B,C,D) prints the system with numerical labels.
%
%   See also: PRINTMAT

%   Clay M. Thompson  7-23-90
%   Revised: P. Gahinet, 4-1-96

nx = size(a,1);
[ny,nu] = size(d);


if isempty(ulabels) | isequal('',ulabels{:}),
   for i=1:nu, 
      ulabels{i} = sprintf('u%d',i);
   end
else
   for i=1:nu,
      if isempty(ulabels{i}),  ulabels{i} = '?';  end
   end
end


if isempty(ylabels) | isequal('',ylabels{:}),
   for i=1:ny, 
      ylabels{i} = sprintf('y%d',i);
   end
else
   for i=1:ny,
      if isempty(ylabels{i}),  ylabels{i} = '?';  end
   end
end


if isempty(xlabels) | isequal('',xlabels{:}),
   for i=1:nx, 
      xlabels{i} = sprintf('x%d',i);
   end
else
   for i=1:nx,
      if isempty(xlabels{i}),  xlabels{i} = '?';  end
   end
end


if isempty(a),
  % Gain matrix
  printmat(d,[offset 'd'],ylabels,ulabels);
else
  printmat(a,[offset 'a'],xlabels,xlabels);
  printmat(b,[offset 'b'],xlabels,ulabels);
  printmat(c,[offset 'c'],ylabels,xlabels);
  printmat(d,[offset 'd'],ylabels,ulabels);
  if ~isempty(e),
     printmat(e,[offset 'e'],xlabels,xlabels);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = printmat(a,name,rlab,clab)
%PRINTMAT Print matrix with labels.
%   PRINTMAT(A,NAME,RLAB,CLAB) prints the matrix A with the row labels
%   RLAB and column labels CLAB.  NAME is a string used to name the 
%   matrix.  RLAB and CLAB are cell vectors of strings.
%
%   See also  PRINTSYS.

%   Clay M. Thompson  9-24-90
%   Revised  P.Gahinet  8-12-96


space = ' ';
[nrows,ncols] = size(a);
col_per_scrn = 5;
len = 12;    % Max length of labels


if (nrows==0)|(ncols==0), 
  if ~isempty(name), disp(' '), disp([name,' = ']), end
  disp(' ')
  if (nrows==0)&(ncols==0), 
      disp('     []')
  else
      disp(sprintf('     Empty matrix: %d-by-%d',nrows,ncols));
  end
  disp(' ')
  return
end


col=1;
n = min(col_per_scrn,ncols)-1;
disp(' ')
% Print name
if ~isempty(name), disp([name,' = ']), end  

while col<=ncols
  % Print labels
  s = space(ones(1,len+1));
  for j=0:n,
    lab = clab{col+j};
    llab = length(lab);
    lab = [space(ones(1,len-llab)) , lab(1:min(len,llab))];
    s = [s,' ',lab];
  end
  disp(setstr(s))
  for i=1:nrows,
    s = rlab{i};
    ls = length(s);
    s = [' ' space(ones(1,len-ls)) s(1:min(len,ls)) ];
    for j=0:n,
      element = a(i,col+j);
      if element==0,
        s=[s, blanks(12), '0'];
      else
        s=[s, sprintf(' %12.5g',element)];
      end
    end
    disp(s)
  end % for
  col = col+col_per_scrn;
  disp(' ')
  if (ncols-col<n), n=ncols-col; end
end % while

