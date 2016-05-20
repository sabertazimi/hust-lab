function Ts = checkst(varargin)
%CHECKST  Checks sample time consistency for a collection of LTI models
%
%   TS = CHECKST(SYS1,SYS2,...,SYSk)  checks if the LTI models 
%   SYS1,SYS2,...,SYSk have consistent sample time, i.e., are
%   either all continuous or all discrete with identical sample
%   time.  CHECKST returns the common sample time TS when all
%   sample times are consistent, and TS=[] otherwise.
%
%   See also  ISCT, ISDT, GET

%   Author(s): P. Gahinet  8-21-97
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 1997/12/01 22:04:34 $

ni = nargin;

% Discard static gains and get sample time of remaining systems
Ts = zeros(1,ni);
idyn = zeros(1,ni);
for i=1:ni,
   if isa(varargin{i},'lti') & ~isstatic(varargin{i}),
      idyn(i) = 1;
      Ts(i) = get(varargin{i},'Ts');
   end
end

% Compare sample times
Ts = Ts(logical(idyn));

if ~any(Ts),
   % All gains or all continuous
   Ts = 0;

elseif any(Ts==0) | any(diff(Ts(Ts>0),1,2))
   % Incompatible
   Ts = [];

else
   % All discrete and compatible   
   Ts = max(Ts);
end

% end checkst.m
