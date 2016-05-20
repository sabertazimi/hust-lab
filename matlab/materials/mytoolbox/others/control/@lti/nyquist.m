function [reout,im,w] = nyquist(varargin)
%NYQUIST  Nyquist frequency response of LTI models.
%
%   NYQUIST(SYS) draws the Nyquist plot of the LTI model SYS
%   (created with either TF, ZPK, SS, or FRD).  The frequency range 
%   and number of points are chosen automatically.  See BODE for  
%   details on the notion of frequency in discrete-time.
%
%   NYQUIST(SYS,{WMIN,WMAX}) draws the Nyquist plot for frequencies
%   between WMIN and WMAX (in radians/second).
%
%   NYQUIST(SYS,W) uses the user-supplied vector W of frequencies 
%   (in radian/second) at which the Nyquist response is to be evaluated.  
%   See LOGSPACE to generate logarithmically spaced frequency vectors.
%
%   NYQUIST(SYS1,SYS2,...,W) plots the Nyquist response of multiple
%   LTI models SYS1,SYS2,... on a single plot.  The frequency vector
%   W is optional.  You can also specify a color, line style, and marker 
%   for each system, as in  
%      nyquist(sys1,'r',sys2,'y--',sys3,'gx').
%
%   [RE,IM] = NYQUIST(SYS,W) and [RE,IM,W] = NYQUIST(SYS) return the
%   real parts RE and imaginary parts IM of the frequency response 
%   (along with the frequency vector W if unspecified).  No plot is 
%   drawn on the screen.  If SYS has NY outputs and NU inputs,
%   RE and IM are arrays of size [NY NU LENGTH(W)] and the response 
%   at the frequency W(k) is given by RE(:,:,k)+j*IM(:,:,k).
%
%   See also BODE, NICHOLS, SIGMA, FREQRESP, LTIVIEW, LTIMODELS.

%   Author(s)  P. Gahinet 6-21-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.19 $  $Date: 1998/07/29 19:05:43 $

ni = nargin;
no = nargout;
if ni==0,
   eval('exresp(''nyquist'')')
   return
end


% Parse input list
w = [];
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
      % NYQUIST(H,SYS1,SYS2,...) for LTI Viewer
      PlotAxes = argj;
   elseif isa(argj,'lti'),
      if ~isempty(argj)
         nsys = nsys+1;   
         sys{nsys} = argj;
         sysname{nsys} = inputname(j);
      end
   elseif isa(argj,'char')
      nstr = nstr+1;   PlotStyle{nstr} = argj;
   else
      nw = nw+1;   w = argj(:);
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
   error('NYQUIST with output arguments: can only handle single model.')
elseif nw>1,
   error('Must use same frequency range or vector for all systems.')
elseif no==0 & nstr~=0 & nstr~=nsys,
   error('Plot styles should be specified for each system when specified at all.')
end  

% Check system dimension compatibility
[ny,nu] = size(sys{1});
for j=2:nsys,
   [nyj,nuj] = size(sys{j});
   if nyj~=ny | nuj~=nu,
      error('All models must have the same number of inputs and outputs.')
   end
end


% Generate frequency grid(s) if not supplied
npts = 60;   % min. number of points to be used
if isempty(w),
   % No W input argument: generate freq. grids for each system
   wgrids = fgrid('nyquist',[],[],[],[],npts,sys{1:nsys});

elseif isa(w,'cell'),
   % W = {WMIN , WMAX}
   if ndims(w)>2 | length(w)>2,
      error('W should be of the form {WMIN,WMAX} when a cell array.')
   end
   wmin = w{1}(1); 
   wmax = w{2}(1);

   if ~isa(wmin,'double') | ~isa(wmax,'double'),
      error('WMIN and WMAX must be scalars in syntax NYQUIST(SYS,{WMIN,WMAX}).')
   elseif wmin<=0 | wmax<=wmin,
      error('WMIN and WMAX must satisfy 0<WMIN<WMAX.')
   end
   wgrids = fgrid('nyquist',wmin,wmax,[],[],npts,sys{1:nsys});

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
   h = freqresp(sys{1},w);
   reout = real(h);
   im = imag(h);

else
   % Call with graphical output: plot using LTIPLOT
   if isempty(PlotAxes),
      PlotAxes = get(gcf,'CurrentAxes');
   end
   FreqData = cell(nsys,1);

   % Compute and plot the Nyquist response for each system
   for k=1:nsys,
      sk = size(sys{k});
      FreqData{k} = cell([sk(3:end) 1 1]);
      for j=1:prod(sk(3:end)),
         FreqData{k}{j} = freqresp(sys{k}(:,:,j),wgrids{k}{j});
      end
   end
   
   %---Pass cell array data to LTIPLOT
   NyqRespObj = ltiplot('nyquist',sys(1:nsys),PlotAxes,FreqData,wgrids,PlotStyle(1:nsys),...
      'SystemNames',sysname(1:nsys));
   
end


