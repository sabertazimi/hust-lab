function display(sys)
%DISPLAY   Pretty-print for LTI models.
%
%   DISPLAY(SYS) is invoked by typing SYS followed
%   by a carriage return.  DISPLAY produces a custom
%   display for each type of LTI model SYS.
%
%   See also LTIMODELS.

%       Author(s): A. Potvin, 3-1-94
%       Revised: P. Gahinet, 4-1-96
%       Copyright (c) 1986-98 by The MathWorks, Inc.
%       $Revision: 1.16 $  $Date: 1998/07/16 20:07:55 $

LineMax = 70;      % max number of char. per line

Ts = getst(sys.lti);  % sampling time
Inames = get(sys.lti,'InputName');
Onames = get(sys.lti,'OutputName');
AllDelays = totaldelay(sys);
StaticFlag = isstatic(sys);

% Get system name
SysName = inputname(1);
if isempty(SysName),
   SysName = 'ans';
end

% Get number of models in array
sizes = size(sys.k);
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

% Handle various cases
if any(sizes==0),
   disp('Empty zero-pole-gain model.')
   return
   
elseif length(sizes)==2,
   % Single ZPK model
   SingleModelDisplay(sys.z,sys.p,sys.k,Inames,Onames,Ts,...
      AllDelays,sys.Variable,LineMax,'');
   
   % Display LTI properties (I/O groups, sample times)
   dispprop(sys.lti,StaticFlag);
     
else
   % TF array
   Marker = '=';
   for k=1:nsys,
      coord = sprintf('%d,',indices(k,:));
      Model = sprintf('Model %s(:,:,%s)',SysName,coord(1:end-1));
      disp(sprintf('\n%s',Model))
      disp(Marker(1,ones(1,length(Model))))
      
      SingleModelDisplay(sys.z(:,:,k),sys.p(:,:,k),sys.k(:,:,k),...
         Inames,Onames,Ts,AllDelays(:,:,min(k,end)),sys.Variable,LineMax,'  ')
   end
   
   % Display LTI properties (I/O groups and sample time)
   disp(' ')
   dispprop(sys.lti,StaticFlag);
   
   % Last line
   ArrayDims = sprintf('%dx',asizes);
   if StaticFlag,
      disp(sprintf('%s array of static gains.',ArrayDims(1:end-1)))
   elseif Ts==0,
      disp(sprintf('%s array of continuous-time zero-pole-gain models.',...
         ArrayDims(1:end-1)))
   else
      disp(sprintf('%s array of discrete-time zero-pole-gain models.',...
         ArrayDims(1:end-1)))
   end
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SingleModelDisplay(Zero,Pole,Gain,Inames,Onames,Ts,Td,ch,LineMax,offset)
% Displays a single ZPK model

[p,m] = size(Gain);
relprec = 0.0005;  % 1+relprec displays as 1

Istr = '';  Ostr = ''; Ending = ':';
NoInames = isequal('','',Inames{:});
NoOnames = isequal('','',Onames{:});

if m==1 & NoInames,
  % Single input and no name
  if p>1 | ~NoOnames,
     Istr = ' from input';
  end
else
  for i=1:m, 
     if isempty(Inames{i}),
        Inames{i} = int2str(i); 
     else
        Inames{i} = ['"' Inames{i} '"'];
     end
  end
  Istr = ' from input ';
end

if p>1,
  for i=1:p, 
     if isempty(Onames{i}), Onames{i} = ['#' int2str(i)]; end
  end
  Ostr = ' to output...';
  Ending = '';
elseif ~NoOnames,
  % Single output with name
  Ostr = ' to output ';
  Onames{1} = ['"' Onames{1} '"'];
else
  % Single unnamed output, but several inputs
  Onames = {''};
  if ~isempty(Istr),  
     Ostr = ' to output';  
  end
end


% REVISIT: Possibly make a matrix gain display as a simple matrix
i = 1; j = 1;
while j<=m,
   disp(' ');

   % Display header for each new input
   if i==1,
      str = ['Zero/pole/gain' Istr Inames{j} Ostr];
      if p==1,  str = [str Onames{1}];  end
      disp([offset str Ending])
   end

   % Set output label
   if p==1,
      OutputName = offset;
   else
      OutputName = [offset ' ' Onames{i} ':  '];
   end
 
   kij = Gain(i,j);
   if kij,
      GainStr = num2str(kij);
      s1 = pole2str(Zero{i,j},ch);
      s2 = pole2str(Pole{i,j},ch);
      if strcmp(ch,'z^-1') | strcmp(ch,'q'),
         % Add appropriate power of 1/z or q 
         reldeg = length(Zero{i,j})-length(Pole{i,j});
         absr = abs(reldeg);
         if absr==1,
            str = [ch ' '];
         elseif absr & strcmp(ch,'q'),
            str = ['q^' int2str(absr) ' '];
         elseif absr,
            str = ['z^-' int2str(absr) ' '];
         end
         if reldeg<0,
            s1 = [str s1];
         elseif reldeg>0,
            s2 = [str s2];
         end
      end
      
      % Add delay time
      if Td(i,j),
         if Ts==0,
            OutputName = [OutputName , sprintf('exp(-%.2g*%s) * ',Td(i,j),ch)];
         elseif strcmp(ch,'q'),
            OutputName = [OutputName , sprintf('q^%d * ',Td(i,j))];
         else 
            OutputName = [OutputName , sprintf('z^(-%d) * ',Td(i,j))];
         end
      end
      loutname = length(OutputName);
      
      % Handle long lines and case |kij|=1
      maxchars = max(LineMax/2,LineMax-loutname);
      if isempty(s1)
         s1 = GainStr;
      elseif abs(kij-1)<relprec,
         s1 = sformat(s1,'(',maxchars); 
      elseif abs(kij+1)<relprec,
         s1 = sformat(['- ' s1],'(',maxchars); 
      else
         s1 = sformat([GainStr ' ' s1],'(',maxchars); 
      end
      s2 = sformat(s2,'(',maxchars);  
      
      if isempty(s2);
         disp([OutputName s1])
      else
         [m1,l1] = size(s1);
         [m2,l2] = size(s2);
         if m1>1 | m2>1, disp(' '); end
         sep = '-';
         b = ' ';
         extra = fix((l2-l1)/2);
         disp([b(ones(m1,loutname+max(0,extra))) s1]);
         disp([OutputName sep(ones(1,max(l1,l2)))]);
         disp([b(ones(m2,loutname+max(0,-extra))) s2]);
      end
   else
      disp([OutputName '0']);
   end

   i = i+1;  
   if i>p,  
     i = 1;  j = j+1; 
   end
end

disp(' ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = pole2str(p,ch)
%POLE2STR Return polynomial as string.
%       S = POLE2STR(P,'s') or S=POLE2STR(P,'z') returns a string S
%       consisting of the poles in the vector P subtracted from the
%       transform variable 's' or 'z' and then multiplied out.
%
%       Example: POLE2STR([1 0 2],'s') returns the string  's^2 + 2'. 

%       Author(s): A. Potvin, 3-1-94, P. Gahinet 5-96

s = '';
if isempty(p),
   return
else
   p = mroots(p,'roots',1e-6);  % Denoise multiple roots for nicer display
end

% Formats for num to char conversion
form = '%.4g';
relprec = 0.0005;   % 1+relprec displays as 1
tol = eps^0.4;      % tolerance for comparisons

zinv = 0;
if strcmp(ch,'z^-1'),
   ch = 'q';
   zinv = 1;
end

% Put real roots first
[trash,ind] = sort(abs(imag(p)));
p = p(ind);

p = -p;
while ~isempty(p),
   p1 = p(1);
   p1tol = tol * max(1,abs(p1));
   cmplxpair = 0;
   if isreal(p1),
      ind = find(abs(p-p1)<tol);   
      pow = length(ind);      
   else
      sgn = sign(imag(p1));
      ind = find(sgn*imag(p)>0 & abs(p-p1)<tol);
      indcjg = find(sgn*imag(p)<0 & abs(p-p1')<tol);
      pow = length(ind);
      if abs(imag(p1)) < tol * abs(p1),
         % Display as real
         p1 = real(p1);
         ind = [ind indcjg];
         pow = pow + length(indcjg);
      elseif length(ind)==length(indcjg),
         % Display as complex pair
         cmplxpair = 1;
         ind = [ind indcjg];
      end
   end
   p(ind) = [];

   % Form polynomial inside parentheses
   if ch=='q',
      % Variable = 'z^-1' or 'q'
      if abs(p1)<tol,
         tmp = '';
      elseif isreal(p1),    % string of the form (1 +/- p * ch)   
         [sp1,val1] = xprint(p1,form);
         sp1 = [sp1 ' '];
         if abs(abs(p1)-1)>=relprec,  
            sp1 = [sp1 val1];
         end   
         tmp = ['(1 ' sp1 ch ')'];
      elseif cmplxpair,      % string (1+2*real(p1)*ch+abs(p1)^2*ch^2)
         rp1 = 2*real(p1);
         tmp = '(1 ';
         if abs(rp1) > 1e4*eps*abs(imag(p1)),
            [srp1,val1] = xprint(rp1,form);
            srp1 = [srp1 ' '];
            if abs(abs(rp1)-1)>=relprec,
               srp1 = [srp1 val1];
            end
            tmp = [tmp srp1 ch ' '];
         end 
         tmp = [tmp '+ ' sprintf(form,p1*p1') ch '^2)'];
      else
         [sgn1,val1] = xprint(p1,form);
         tmp = ['(1 ' sgn1 ' ' val1  ch ')'];
      end
   else
      % Variable = 's', 'p', or 'z'
      if isreal(p1),
         if abs(p1)<tol,      % string ch
            tmp = ch;
         else                 % string of the form (ch +/- p) 
            [sgn,val] = xprint(p1,form);
            tmp = ['(' ch sgn val  ')'];
         end
      elseif cmplxpair, 
         if abs(p1)<tol,      % string of the form ch^2
            tmp = [ch '^2'];
         else                 % string (ch^2+2*real(p1)*ch+abs(p1)^2)
            rp1 = 2*real(p1);
            tmp = ['(' ch '^2 '];
            if abs(rp1) > 1e4*eps*abs(imag(p1))
               [srp1,val1] = xprint(rp1,form);
               srp1 = [srp1 ' '];
               if abs(abs(rp1)-1)>=relprec,
                  srp1 = [srp1 val1];
               end
               tmp = [tmp srp1 ch ' '];
            end 
            tmp = [tmp '+ ' sprintf(form,p1*p1') ')'];
         end
      else                    % complex polynomial
         [sgn1,val1] = xprint(p1,form);
         tmp = ['(' ch sgn1 val1 ')'];
      end
   end
   
   % Raise tmp to right power
   if pow~=1 & ~isempty(tmp),
      tmp = [tmp '^' int2str(pow)];
   end

   % Add to s and remove elements from p
   if isempty(s),
      s = tmp;
   elseif p1==0,
      s = [tmp ' ' s];
   else
      s = [s ' ' tmp];
   end
end

% Take care of ch='z^-1'
if zinv,
  s = strrep(s,'q^','z^-');
  s = strrep(s,'q','z^-1');
end

% end pole2str


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [signx,valx] = xprint(x,form)
%NICEDISP  Returns sign and value of real or complex number x 
%          as strings

if isreal(x),
   if sign(x)>=0,  signx = '+';   else  signx = '-';   end
   valx = sprintf(form,abs(x));
elseif real(x)>=0
   signx = '+';
   valx = ['(' num2str(x,form) ')'];
else
   signx = '-';
   valx = ['(' num2str(-x,form) ')'];
end



