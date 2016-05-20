function [magout,phase,w] = bode(varargin)
%BODE  Bode frequency response of LTI models.
%
%   BODE(SYS) draws the Bode plot of the LTI model SYS (created with
%   either TF, ZPK, SS, or FRD).  The frequency range and number of  
%   points are chosen automatically.
%
%   BODE(SYS,{WMIN,WMAX}) draws the Bode plot for frequencies
%   between WMIN and WMAX (in radians/second).
%
%   BODE(SYS,W) uses the user-supplied vector W of frequencies,
%   in radian/second, at which the Bode response is to be evaluated.  
%   See LOGSPACE to generate logarithmically spaced frequency vectors.
%
%   BODE(SYS1,SYS2,...,W) plots the Bode response of multiple LTI
%   models SYS1,SYS2,... on a single plot.  The frequency vector W
%   is optional.  You can also specify a color, line style, and marker 
%   for each system, as in  
%      bode(sys1,'r',sys2,'y--',sys3,'gx').
%
%   [MAG,PHASE] = BODE(SYS,W) and [MAG,PHASE,W] = BODE(SYS) return the
%   response magnitudes and phases in degrees (along with the frequency 
%   vector W if unspecified).  No plot is drawn on the screen.  
%   If SYS has NY outputs and NU inputs, MAG and PHASE are arrays of 
%   size [NY NU LENGTH(W)] where MAG(:,:,k) and PHASE(:,:,k) determine 
%   the response at the frequency W(k).  To get the magnitudes in dB, 
%   type MAGDB = 20*log10(MAG).
%
%   For discrete-time models with sample time Ts, BODE uses the
%   transformation Z = exp(j*W*Ts) to map the unit circle to the 
%   real frequency axis.  The frequency response is only plotted 
%   for frequencies smaller than the Nyquist frequency pi/Ts, and 
%   the default value 1 (second) is assumed when Ts is unspecified.
%
%   See also NICHOLS, NYQUIST, SIGMA, FREQRESP, LTIVIEW, LTIMODELS.

%   Author(s)  P. Gahinet  8-14-96
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.31 $  $Date: 1998/10/01 20:12:25 $


ni = nargin;
no = nargout;
if ni==0,
   eval('exresp(''bode'')')
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
      % BODE(H,SYS1,SYS2,...) for LTI Viewer
      PlotAxes = argj;
   elseif isa(argj,'lti'),
      if ~isempty(argj)
         nsys = nsys+1;   
         sys{nsys} = argj;
         sysname{nsys} = inputname(j);
      end
   elseif isa(argj,'char')
      nstr = nstr+1;   
      PlotStyle{nstr} = argj;
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
   error('BODE with output arguments: can only handle single model.')
elseif nw>1,
   error('Must use same frequency range or vector for all models.')
elseif no==0 & nstr~=0 & nstr~=nsys,
   error('Plot styles should be specified for each model or not at all.')
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
npts = 40;   % min. number of points to be used
NoW = 1;     % 1 if no W vector supplied
if isempty(w),
   % No W input argument: generate freq. grids for each system
   wgrids = fgrid('bode',[],[],[],[],npts,sys{1:nsys});

elseif isa(w,'cell'),
   % W = {WMIN , WMAX}
   if ndims(w)>2 | length(w)>2,
      error('W should be of the form {WMIN,WMAX} when a cell array.')
   end
   wmin = w{1}(1); 
   wmax = w{2}(1);

   if ~isa(wmin,'double') | ~isa(wmax,'double'),
      error('WMIN and WMAX must be scalars in syntax BODE(SYS,{WMIN,WMAX}).')
   elseif wmin<=0 | wmax<=wmin,
      error('WMIN and WMAX must satisfy 0<WMIN<WMAX.')
   end
   wgrids = fgrid('bode',wmin,wmax,[],[],npts,sys{1:nsys});

elseif isa(w,'double') & ndims(w)==2 & min(size(w))==1,
   % Vector of frequency W supplied
   wgrids = cell(1,nsys);
   for k=1:nsys,
      sk = size(sys{k});
      wgrids{k} = repmat({w},[sk(3:end) 1 1]);
   end
   NoW = 0;

else
   error('Input W is of unexpected type or dimensions.')
end



% Handle various calling sequences
if no,
   % Call with output arguments
   [magout,phase,w] = boderesp(sys{1},wgrids{1}{1},NoW);

else
   % Call with graphical output: plot using LTIPLOT
   if isempty(PlotAxes),
      PlotAxes = get(gcf,'CurrentAxes');
   end
   Xdata = cell(nsys,1);
   Magdata = cell(nsys,1);
   Phdata = cell(nsys,1);

   % Compute and plot the bode response for each system
   for k=1:nsys,
      sk = size(sys{k});
      Xdata{k} = cell([sk(3:end) 1 1]);
      Magdata{k} = cell([sk(3:end) 1 1]);
      Phdata{k} = cell([sk(3:end) 1 1]);
      for j=1:prod(sk(3:end)),
         [mag,Phdata{k}{j},Xdata{k}{j}] = boderesp(sys{k}(:,:,j),wgrids{k}{j},NoW);
         %---Compile data for LTIPLOT
         Magdata{k}{j} = 20*log10(mag);
      end
   end
   
   %---Pass cell array data to LTIPLOT
   BodeRespObj = ltiplot('bode',sys(1:nsys),PlotAxes,{Magdata,Phdata},Xdata,...
      PlotStyle(1:nsys),'SystemNames',sysname(1:nsys));

end
