function [E,V]=dpss(N, NW, varargin)
%DPSS Discrete prolate spheroidal sequences (Slepian sequences).
%   [E,V] = DPSS(N,NW) are the first 2*NW discrete prolate spheroidal sequences
%   (DPSSs, or Slepian sequences) of length N (in the columns of E) and 
%   their corresponding concentrations (in vector V) in the frequency band 
%   |w|<=(2*pi*W) (where  W = NW/N is the half-bandwidth and w is in radians). 
%   E(:,1) is the length N signal most concentrated in the frequency band 
%   |w|<=(2*pi*W) radians, E(:,2) is the signal orthogonal to E(:,1) which 
%   is most concentrated in this band, E(:,3) is the signal orthogonal to 
%   both E(:,1) and E(:,2) which is most concentrated in this band, etc.  
%
%   For multi-taper spectral analysis, typical choices for NW are 2, 5/2, 3, 
%   7/2, or 4.
%
%   [E,V] = DPSS(N,NW,K) are the K most band-limited discrete prolate spheroidal
%   sequences.  [E,V] = DPSS(N,NW,[K1 K2]) returns the K1-th through the 
%   K2-th sequences.
%
%   [E,V] = DPSS(N,NW,'spline') uses spline interpolation to compute the DPSSs 
%   from existing DPSSs in the DPSS database with length closest to N.
%   [E,V] = DPSS(N,NW,'spline',Ni) interpolates from existing length Ni DPSSs.
%   DPSS(N,NW,'linear') and DPSS(N,NW,'linear',Ni) use linear interpolation, 
%   which is much faster but less accurate than spline interpolation.  
%   'linear' requires Ni > N.
%
%   Use a trailing 'trace' argument to find out which method DPSS uses, e.g.
%   DPSS(N,NW,'trace') or DPSS(N,NW,'int','trace').
%
%   See also PMTM, DPSSLOAD, DPSSDIR, DPSSSAVE, DPSSCLEAR.

%   Author: Eric Breitenberger, 10/3/95
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 1998/06/03 14:42:29 $

method = 'calc';
TRACE = 'notrace';
Ni = [];
k = min(round(2*NW),N); % Default number of sequences to return
k = max(k,1);

if nargin > 2
    if ~isstr(varargin{1})
        k = varargin{1};
        if isempty(k) | any(k~=round(abs(k))) | any(k>N) | length(k)>2
            error('K must be a positive integer in the range 1:N')
        end
    else
        method = lower(varargin{1});
        if strcmp(method,'trace')
            method = 'calc';
            TRACE = 'trace';
        end
    end
end
if nargin > 3
    if isstr(varargin{2})
        TRACE = lower(varargin{2});
    else
        Ni = varargin{2};
    end
end
if nargin > 4
    TRACE = lower(varargin{3});
end

if NW >= N/2
    error('NW must be less than N/2.')
end

switch method

case 'calc'
    if strcmp(TRACE,'trace')
        disp('Computing the DPSS using direct algorithm...')
    end
    [E,V] = dpsscalc(N,NW,k);

case {'spline','linear'}
    errmsg = '';
    if isempty(Ni)
        ind = dpssdir(NW,'NW');
        if ~isempty(ind)
            Nlist = [ind.N];
            % find closest length and use that one
            [dum,i] = min(abs(N-Nlist));
            Ni = Nlist(i);
            if strcmp(method,'linear') & Ni<N
                if i<length(Nlist)
                    Ni = Nlist(i+1);
                else
                    Ni = [];
                    errmsg = sprintf('No DPSS with NW = %g and N > %g in database.',NW,N);
                end
            end
        else
            errmsg = sprintf('No DPSS with NW = %g in database.',NW);
        end
    end
    error(errmsg)
    
    if strcmp(TRACE,'trace')
        disp(['Computing DPSS using ' method ' interpolation from length ' int2str(Ni) '...'])
    end

    [E,V]=dpssint(N,NW,Ni,method);

otherwise
    error('Method string should be ''calc'', ''spline'' or ''linear''.')

end

%------------------------------------
function [E,V] = dpsscalc(N,NW,k)
%DPSSCALC Calculate slepian sequences.
%   [E,V] = dpsscalc(N,NW,k) uses tridieig() to get eigenvalues 1:k if k is 
%   a scalar, and k(1):k(2) if k is a matrix, of the sparse tridiagonal matrix.
%   It then uses inverse iteration using the exact eigenvalues on a starting 
%   vector with approximate shape, to get the eigenvectors required.  It then 
%   computes the eigenvalues V of the Toeplitz sinc matrix using a fast 
%   autocorrelation technique.

%   Authors: T. Krauss, C. Moler, E. Breitenberger
W=NW/N;
if nargin < 3
    k = min(round(2*N*W),N);
    k = max(k,1);
end
if length(k) == 1
    k = [1 k];
end

% Generate the diagonals
d=((N-1-2*(0:N-1)').^2)*.25*cos(2*pi*W);  % diagonal of B
ee=(1:N-1)'.*(N-1:-1:1)'/2;               % super diagonal of B

% Get the eigenvalues of B.
v = tridieig(d,[0; ee],N-k(2)+1,N-k(1)+1);
v = v(end:-1:1);
Lv = length(v);

%B = spdiags([[ee;0] d [0;ee]],[-1 0 1],N,N);
%I = speye(N,N);

% Compute the eigenvectors by inverse iteration with
% starting vectors of roughly the right shape.
E = zeros(N,k(2)-k(1)+1);
t = (0:N-1)'/(N-1)*pi;
warn_save = warning;  
warning('off')      % Turn off warnings in case tridisolve encounters
                    % an exactly singular matrix.
for j = 1:Lv
   e = sin((j+k(1)-1)*t);
   e = tridisolve(ee,d-v(j),e,N);
   e = tridisolve(ee,d-v(j),e/norm(e),N);
   e = tridisolve(ee,d-v(j),e/norm(e),N);
   E(:,j) = e/norm(e);
end
warning(warn_save)

d=mean(E);
for i=k(1):k(2)
   if rem(i,2)  % i is odd
     % Polarize symmetric dpss
       if d(i-k(1)+1)<0, E(:,i-k(1)+1)=-E(:,i-k(1)+1); end
   else         % i is even
     % Polarize anti-symmetric dpss
       if E(2,i-k(1)+1)<0, E(:,i-k(1)+1)=-E(:,i-k(1)+1); end
   end
end

% get eigenvalues of sinc matrix
%  Reference: Percival & Walden, Exercise 8.1, p.390
s = [2*W; 4*W*sinc(2*W*(1:N-1)')];
q = zeros(size(E));
blksz = Lv;  % <-- set this to some small number if OUT OF MEMORY!!!
for i=1:blksz:Lv
    blkind = i:min(i+blksz-1,Lv);
    q(:,blkind) = fftfilt(E(N:-1:1,blkind),E(:,blkind));
end
V = q'*flipud(s);

% return 1 for any eigenvalues greater than 1 due to finite precision errors
V = min(V,1);
% return 0 for any eigenvalues less than 0 due to finite precision errors
V = max(V,0);

%------------------------------------

function [En,V] = dpssint(N, NW, M, int, E,V)
% Syntax: [En,V]=dpssint(N,NW); [En,V]=dpssint(N,NW,M,'spline');
%  Dpssint calculates discrete prolate spheroidal
%  sequences for the parameters N and NW. Note that
%  NW is normally 2, 5/2, 3, 7/2, or 4 - not i/N. The 
%  dpss are interpolated from previously calculated 
%  dpss of order M (128, 256, 512, or 1024). 256 is the 
%  default for M. The interpolation can be 'linear' 
%  or 'spline'. 'Linear' is faster, 'spline' the default.
%  Linear interpolation can only be used for M>N. 
%  Returns:
%              E: matrix of dpss (N by 2NW)
%              V: eigenvalue vector (2NW)
% 
% Errors in the interpolated dpss are very small but should be 
% checked if possible. The differences between interpolated
% values and values from dpsscalc are generally of order
% 10ee-5 or better. Spline interpolation is generally more
% accurate. Fractional errors can be very large near
% the zero-crossings but this does not seriously affect
% windowing calculations. The error can be reduced by using
% values for M which are close to N.
%
% Written by Eric Breitenberger, version date 10/3/95.
% Please send comments and suggestions to eric@gi.alaska.edu
%

W = NW/N;

if     nargin==2,
  M=256; int='spline';
elseif nargin==3,
  if isstr(M), int=M; M=256; 
  else, int='spline';, end
end

if int=='linear' & N>M
  error('Linear interpolation cannot be used for N>M. Use splining instead.')
end

if nargin<=4
    [E,V] = dpssload(M,NW);
else
    if size(E,1)~=M
        error('M and row size of E don''t match.')
    end
end

k=min(round(2*NW),N); % Return only first k values
k = max(k,1);
E=E(:,1:k);
V=V(1:k);
x=1:M;

% The scaling for the interpolation:
% This is not necessarily optimal, and 
% changing s can improve accuracy.
 
s=M/N;
midm=(M+1)/2;
midn=(N+1)/2;
delta=midm-s*midn;
xi=linspace(1-delta, M+delta, N);

% Interpolate from M values to N
% Spline interpolation is a bit better,
% but takes about twice as long.
% Errors from linear interpolation are 
% usually smaller than errors from scaling.

En=interp1(x,E,xi,['*' int]);

% Re-normalize the eigenvectors
En=En./(ones(N,1)*sqrt(sum(En.*En)));

