function [gd_out,w_out] = grpdelay(b,a,n,dum,Fs)
%GRPDELAY Group delay of a digital filter.
%   [Gd,W] = GRPDELAY(B,A,N) returns length N vectors Gd and W
%   containing the group delay and the frequencies (in radians) at which it 
%   is evaluated. Group delay is -d{angle(w)}/dw.  The frequency
%   response is evaluated at N points equally spaced around the
%   upper half of the unit circle.   When N is a power of two,
%   the computation is done faster using FFTs.  If you don't specify
%   N, it defaults to 512.
%
%   GRPDELAY(B,A,N,'whole') uses N points around the whole unit circle.  
%
%   [Gd,F] = GRPDELAY(B,A,N,Fs) and [Gd,F] = GRPDELAY(B,A,N,'whole',Fs)
%   given sampling frequency Fs in Hz return a vector F in Hz.
%
%   Gd = GRPDELAY(B,A,W) and Gd = GRPDELAY(B,A,F,Fs) return the group delay
%   evaluated at the points in W (in radians) or F (in Hz), where Fs is the
%   sampling frequency in Hz.
%
%   GRPDELAY(B,A,...) with no output arguments plots the group delay versus
%   normalized frequency (Nyquist == 1) in the current figure window.
%
%   See also FREQZ.

%   Unpublished algorithm from J. O. Smith, 5-9-88
%   Author(s): L. Shure, 5-9-88
%   	   T. Krauss, 4-19-93, revised
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1998/08/18 18:09:04 $
	
error(nargchk(1,5,nargin))
if nargin == 1,
    a = 1;  n = 512;  whole = 'no';  samprateflag = 'no';
elseif nargin == 2,
    n = 512;  whole = 'no';  samprateflag = 'no';
elseif nargin == 3,
    whole = 'no';  samprateflag = 'no';
elseif nargin == 4,
    if isstr(dum),
        whole = 'yes';  samprateflag = 'no';
    else
        whole = 'no';  samprateflag = 'yes';  Fs = dum;
    end
elseif nargin == 5,
    whole = 'yes';  samprateflag = 'yes';
end
nb = length(b);
na = length(a);
nn = length(n);
if strcmp(whole,'yes'),
    s = 1;
else
    s = 2;
end
c = conv(b, conj(a(na:-1:1)));
c = c(:).';	% make a row vector
nc = length(c);
cr = c.*(0:(nc-1));
if length(n)==1,
   w = (2*pi/s*(0:n-1)/n)';
   if s*n >= nc	% pad with zeros to get the n values needed
      % dividenowarn temporarily supresses warnings to avoid "Divide by zero"
      gd = dividenowarn(fft([cr zeros(1,s*n-nc)]),...
                        fft([c zeros(1,s*n-nc)]));
      gd = real(gd(1:n)) - ones(1,n)*(na-1);
   else	% find multiple of s*n points greater than nc
      nfact = s*ceil(nc/(s*n));
      mmax = n*nfact;
      % dividenowarn temporarily supresses warnings to avoid "Divide by zero"
      gd = dividenowarn(fft(cr,mmax), fft(c,mmax));
      gd = real(gd(1:nfact:mmax)) - ones(1,n)*(na-1);
   end
   gd = gd(:);
else
    if strcmp(samprateflag,'no'),
       w = n;
    else
       w = 2*pi*n/Fs;
    end
    s = exp(j*w);
    gd = real(polyval(cr,s)./polyval(c,s));
    gd = gd - ones(size(gd))*(na-1);
end

if strcmp(samprateflag,'yes')
    f = w*Fs/2/pi;
else
    f = w;
end

if nargout == 0   % do plots
    newplot;
    if strcmp(samprateflag,'no'),
        plot(f/pi,gd)
        xlabel('Normalized frequency (Nyquist == 1)')
    else
        plot(f,gd)
        xlabel('Frequency (Hertz)')
    end
    ylabel('Group delay (in samples)')
    set(gca,'xgrid','on','ygrid','on')
elseif nargout == 1
    gd_out = gd;
elseif nargout == 2
    gd_out = gd;
    w_out = f;
end
