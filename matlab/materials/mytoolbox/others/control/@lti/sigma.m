function [svout,w] = sigma(varargin)
%SIGMA  Singular value plot of LTI models.
%
%   SIGMA(SYS) produces a singular value (SV) plot of the frequency 
%   response of the LTI model SYS (created with TF, ZPK, SS, or FRD).  
%   The frequency range and number of points are chosen automatically.  
%   See BODE for details on the notion of frequency in discrete time.
%
%   SIGMA(SYS,{WMIN,WMAX}) draws the SV plot for frequencies ranging
%   between WMIN and WMAX (in radian/second).
%
%   SIGMA(SYS,W) uses the user-supplied vector W of frequencies, in
%   radians/second, at which the frequency response is to be evaluated.  
%   See LOGSPACE to generate logarithmically spaced frequency vectors.
%
%   SIGMA(SYS,W,TYPE) or SIGMA(SYS,[],TYPE) draws the following
%   modified SV plots depending on the value of TYPE:
%          TYPE = 1     -->     SV of  inv(SYS)
%          TYPE = 2     -->     SV of  I + SYS
%          TYPE = 3     -->     SV of  I + inv(SYS) 
%   SYS should be a square system when using this syntax.
%
%   SIGMA(SYS1,SYS2,...,W,TYPE) draws the SV response of several LTI
%   models SYS1,SYS2,... on a single plot.  The arguments W and TYPE
%   are optional.  You can also specify a color, line style, and marker 
%   for each system, as in  sigma(sys1,'r',sys2,'y--',sys3,'gx').
%   
%   SV = SIGMA(SYS,W) and [SV,W] = SIGMA(SYS) return the singular 
%   values SV of the frequency response (along with the frequency 
%   vector W if unspecified).  No plot is drawn on the screen. 
%   The matrix SV has length(W) columns and SV(:,k) gives the
%   singular values (in descending order) at the frequency W(k).
%
%   For details on Robust Control Toolbox syntax, type HELP RSIGMA.
%
%   See also BODE, NICHOLS, NYQUIST, FREQRESP, LTIVIEW, LTIMODELS.

%	Andrew Grace  7-10-90
%	Revised ACWG 6-21-92
%	Revised by Richard Chiang 5-20-92
%	Revised by W.Wang 7-20-92
%       Revised P. Gahinet 5-7-96
%	Copyright (c) 1986-98 by The MathWorks, Inc.
%	$Revision: 1.27 $  $Date: 1998/10/01 20:12:26 $


ni = nargin;
no = nargout;
if ni==0,
   eval('exresp(''sigma'')')
   return
end

% Parse input list
w = [];  type = 0;
nsys = 0;      % counts LTI systems
nstr = 0;      % counts plot style strings 
nw = 0;
sys = cell(1,ni);
sysname = cell(1,ni);
PlotAxes = [];
PlotStyle = cell(1,ni);
for j=1:ni,
   argj = varargin{j};
   if j==1 & ishandle(argj),
      % SIGMA(H,SYS1,SYS2,...) for LTI Viewer
      PlotAxes = argj;
   elseif isa(argj,'lti'),
      if ~isempty(argj)
         nsys = nsys+1;   
         sys{nsys} = argj;
         sysname{nsys} = inputname(j);
      end
   elseif ischar(argj)
      nstr = nstr+1;   PlotStyle{nstr} = argj;
   elseif nw==0,
      nw = nw+1;   w = argj(:);
   else
      nw = nw+1;   type = argj;
   end
end

% Error checking
if nsys==0,
   if no,  
      yout = [];  t = [];  x = [];
   else
      warning('All models are empty: no plot drawn.');
   end
   return
elseif no & (nsys>1 | ndims(sys{1})>2),
   error('SIGMA with output arguments: can only handle single model.')
elseif nw>2,
   error('Must use same W and TYPE for all models.')
elseif no==0 & nstr~=0 & nstr~=nsys,
   error('Plot styles should be specified for each model or not at all.')
elseif ~isequal(size(type),[1 1]),
   error('TYPE must be a scalar.')
elseif ~any(type==[0 1 2 3]),
   error('Unknown TYPE.')
elseif nstr==1 & strcmp(PlotStyle{1},'inv')
   type = 1; 
end

% Check systems are square for TYPE 1,2,3
for j=1:nsys,
   [nyj,nuj] = size(sys{j});
   if type & nyj~=nuj,
      error('Types 1 through 3 only applicable to square systems.')
   end
end

% Generate frequency grid(s) if not supplied
npts = 50;   % min. number of points to be used
if isempty(w),
   % No W input argument: generate freq. grids for each system
   wgrids = fgrid('sigma',[],[],[],[],npts,sys{1:nsys});

elseif isa(w,'cell'),
   % W = {WMIN , WMAX}
   if ndims(w)>2 | length(w)>2,
      error('W should be of the form {WMIN,WMAX} when a cell array.')
   end
   wmin = w{1}(1); 
   wmax = w{2}(1);

   if ~isa(wmin,'double') | ~isa(wmax,'double'),
      error('WMIN and WMAX must be scalars in syntax SIGMA(SYS,{WMIN,WMAX}).')
   elseif wmin<=0 | wmax<=wmin,
      error('WMIN and WMAX must satisfy 0<WMIN<WMAX.')
   end
   wgrids = fgrid('sigma',wmin,wmax,[],[],npts,sys{1:nsys});

elseif isa(w,'double') & ndims(w)==2 & min(size(w))==1,
   % Vector of frequency W supplied
   wgrids = cell(1,nsys);
   for k=1:nsys,
      sk = size(sys{k});
      wgrids{k} = repmat({w},[sk(3:end) 1 1]);
   end

else
   error('Input W is of unexpected type or dimensions.')
end



% Handle various calling sequences
if no,
   % Call with output arguments
   w = wgrids{1}{1};
   svout = sigresp(sys{1},w,type);

else
   % Call with graphical output: plot using LTIPlot
   if isempty(PlotAxes),
      PlotAxes = get(gcf,'CurrentAxes');
   end
   Ydata = cell(nsys,1);

   % Compute and plot the sigma response for each system
   for k=1:nsys,
      sk = size(sys{k});
      Ydata{k} = cell([sk(3:end) 1 1]);
      for j=1:prod(sk(3:end)),
         %---Compile data for LTIPLOT
         Ydata{k}{j} = sigresp(sys{k}(:,:,j),wgrids{k}{j},type);
      end
   end
   
   %---Pass cell array data to LTIPLOT
   SvRespObj = ltiplot('sigma',sys(1:nsys),PlotAxes,Ydata,wgrids,PlotStyle(1:nsys),...
      'SystemNames',sysname(1:nsys));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sv = sigresp(sys,w,type)
%SIGRESP   Computes the singular value response of the LTI system SYS
%          over the frequency grid w

% Calculate complex frequency response
h = freqresp(sys,w);  
[ny,nu,lw] = size(h);

% Derive appropriate frequency response
switch type,
case 2
   % Overwrite H with I+H
   heye = eye(nu);
   for i=1:lw,
      h(:,:,i) = heye + h(:,:,i);
   end
case 3
   % Overwrite H with I+inv(H)
   heye = eye(nu);
   for i=1:lw,
      h(:,:,i) = heye + inv(h(:,:,i));
   end
end

% Compute singular values
nsv = min(ny,nu);
sv = zeros(nsv,lw);
for i=1:lw,
   sv(:,i) = svd(h(:,:,i));
end

% Handle case TYPE=1 
if type==1,
   % Singular values of inv(SYS) are the reciprocals of those of SYS
   zsv = (sv==0);    % zero SV
   if any(zsv),
      warning('Frequency response is singular at some frequencies.')
   end
   sv(~zsv) = 1./sv(~zsv);
   sv(zsv) = Inf;
   sv = flipud(sv);
end


