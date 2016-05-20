function sys = subsasgn(sys,Struct,rhs)
%SUBSASGN  Subscripted assignment for LTI objects.
%
%   The following assignment operations can be applied to any 
%   LTI model SYS: 
%     SYS(Outputs,Inputs)=RHS  reassigns a subset of the I/O channels
%     SYS.Fieldname=RHS        equivalent to SET(SYS,'Fieldname',RHS)
%   The left-hand-side expressions can be themselves followed by any 
%   valid subscripted reference, as in SYS(1,[2 3]).inputname='u' or
%   SYS.num{1,1}=[1 0 2].
%
%   For arrays of LTI models, indexed assignments take the form
%      SYS(Outputs,Inputs,j1,...,jk) = RHS
%   where k is the number of array dimensions (in addition to the
%   input and output dimensions).
%
%   See also SET, SUBSREF, LTIMODELS.

%   Author(s): P. Gahinet
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.20 $  $Date: 1998/10/01 20:12:36 $

if nargin==1,
   return
end
StructL = length(Struct);

% Peel off first layer of subassignment
switch Struct(1).type
case '.'
   % Assignment of the form sys.fieldname(...)=rhs
   FieldName = Struct(1).subs;
   try
      if StructL==1,
         FieldValue = rhs;
      else
         FieldValue = subsasgn(get(sys,FieldName),Struct(2:end),rhs);
      end
      set(sys,FieldName,FieldValue)
   catch
      error(lasterr)
   end
   
case '()'
   % Assignment of the form sys(indices)...=rhs
   try
      if StructL==1,
         sys = indexasgn(sys,Struct(1).subs,rhs);
      else
         % First reassign tmp = sys(indices)
         tmp = subsasgn(subsref(sys,Struct(1)),Struct(2:end),rhs);
         % Then set sys(indices) to tmp
         sys = indexasgn(sys,Struct(1).subs,tmp);
      end
   catch
      error(lasterr)
   end
   
case '{}'
   error('Cell contents reference from a non-cell array object')

otherwise
   error(['Unknown type: ' Struct(1).type])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Subfunction INDEXASGN: Reassigns sys(indices)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys = indexasgn(sys,indices,rhs)

% Handle case sys=[] (case when SYS is created by subsasgn statement)
CreateLHS = 0;
if isa(sys,'double'),
   % Initialize to empty SS
   sys = ss;
   CreateLHS = 1;
end
sizes = size(sys.d);   % sizes of sys
DelFlag = isequal(rhs,[]);

% Check and format indices
indices = asgnchk(indices,sizes,DelFlag,sys.lti);

% Handle case sys(i1,...,ik) = [] separately
% RE: * state vector left untouched
%     * if all indices are colons, only delete outputs to mimic a(:,:)=[] 
%       for matrices
if DelFlag,
   nci = find(~strcmp(indices,':'));  % empty or contains single index
   anynci = ~isempty(nci);
   if anynci & nci>2,   % Delete entries in dims>2
      sys.a(indices{:}) = [];
      sys.e(indices{:}) = [];
      if length(sys.Nx)>1,
         sys.Nx(indices{3:end}) = [];
      end
      sys.e = ematchk(sys.e,sys.Nx);
   end
   if anynci & nci~=1,  % Delete inputs or entries in dims>2
      sys.b(indices{:}) = [];
   end
   if ~isequal(nci,2),  % Delete outputs or entries in dims>2
      sys.c(indices{:}) = [];  
   end
   sys.d(indices{:}) = [];
   sys.lti = ltiasgn(sys.lti,indices,[]);
   sys = xclip(sys);
   return
end


% Left with case sys(i1,...,ik) = rhs
% -----------------------------------
% Get RHS data
if isa(rhs,'double'),
   % RHS is an double array. 
   d = rhs;
   rnames = cell(0,1);
   sflags = [isstatic(sys) , 1];  % 1 when static gains
   rlti = lti(1,1);   % same as scalar assignment from LTI viewpoint
   zerorhs = ~any(rhs(:));
else
   % RHS is LTI
   rhs = ss(rhs); % convert to TF
   d = rhs.d;
   rnames = rhs.StateName;
   sflags = [isstatic(sys) , isstatic(rhs)];  
   rlti = rhs.lti;
   zerorhs = isempty(rhs.a) & ~any(rhs.d(:));
end
rsizes = size(d);    % sizes of rhs

% Update D matrix of LHS. Rely on ND assignment code to detect errors.
sys.d(indices{:}) = d;
newsizes = size(sys.d);

% List of reassigned models
if length(indices)>2,
   AssignedModels = zeros([newsizes(3:end) 1 1]);
   AssignedModels(indices{3:end}) = 1;
   AssignedModels = find(AssignedModels(:));
else
   AssignedModels = 1;
end
nac = size(sys.d(indices{1:2},1));  % number of reassigned channels
nam = length(AssignedModels);       % number of reassigned models

% Prepare RHS state-space data. Ensure that number of RHS models and
% number of assigned models (NAM) are consistent
if isa(rhs,'double'),
   % Shape A,B,C,E adequately when RHS is not LTI. Cf. difference
   % between sys(1,2,:) = ones(20,1)  and  sys(:,:,3) = ones(2) )
   a = zeros([0 0 nam]);
   e = zeros([0 0 nam]);
   b = zeros([0 nac(2) nam]);
   c = zeros([nac(1) 0 nam]);
   nx = 0;
elseif all(rsizes(1:2)==1),
   % RHS is a single scalar LTI or an array of scalar LTIs
   arrayrep = 1 + (length(rsizes)==2) * (nam-1);
   a = repmat(rhs.a(:,:,:),[1 1 arrayrep]);
   e = repmat(rhs.e(:,:,:),[1 1 arrayrep]);
   b = repmat(rhs.b(:,:,:),[1 nac(2) arrayrep]);
   c = repmat(rhs.c(:,:,:),[nac(1) 1 arrayrep]);
   nx = size(a,1);
else
   % RHS is a non scalar LTI
   if ~isequal(nac,rsizes(1:2)),
      % Prohibit sys(1,2,1:60) = ss(ones(1,60))
      error('I/O dimension mismatch in LTI assignment.')
   end
   a = rhs.a(:,:,:);
   e = rhs.e(:,:,:);
   b = rhs.b(:,:,:);
   c = rhs.c(:,:,:);
   nx = rhs.Nx(:);
end

% Get state dimensions of LHS and enforce consistency of E matrices
Na = size(sys.a,1);
[sys.e,e] = ematchk(sys.e,Na,e,size(a,1));  
Ne = size(sys.e,1);
Nx = nxarray(sys);  

% Resize LHS to match the array dimensions of assignment result
if prod(newsizes(3:end))>prod(sizes(3:end)),
   arrayend = num2cell(newsizes(3:end));
   if Na==0,
      % REVISIT: superfluous when 41450 fixed
      sys.a = zeros([0 0 newsizes(3:end)]);
      sys.b = zeros([0 newsizes(2:end)]);
      sys.c = zeros([newsizes(1) 0 newsizes(3:end)]);
   else
      sys.a(Na,Na,arrayend{:}) = 0;
      sys.b(Na,newsizes(2),arrayend{:}) = 0;
      sys.c(newsizes(1),Na,arrayend{:}) = 0;
   end
   if Ne==0,
      sys.e = zeros([0 0 newsizes(3:end)]);
   else
      sys.e(Ne,Ne,arrayend{:}) = 0;
   end
   if isempty(arrayend),
      Nx = 0;
   else
      Nx(arrayend{:}) = 0;
   end
end

% Construct the state matrices for the reassigned models
if ~isequal(nac,newsizes(1:2)),
   % Only a subset of the I/O channels is reassigned
   % Extract data for reassigned models
   A = sys.a(:,:,AssignedModels);
   E = sys.e(:,:,AssignedModels);
   B = sys.b(:,:,AssignedModels);
   C = sys.c(:,:,AssignedModels);  
   % Resize B if number of inputs increases
   if newsizes(2)>size(B,2),
      % REVISIT: this should be superfluous when 41450 is fixed
      % use simply B(1:end,newsizes(2),1) = 0
      if isempty(B),
         B = zeros([size(A,1),newsizes(2),prod(newsizes(3:end))]);
      else
         B(1:end,newsizes(2),1) = 0;
      end
   end
   % Resize C if number of outputs increases
   if newsizes(1)>size(C,1),
      if isempty(C),
         C = zeros([newsizes(1),size(A,1),prod(newsizes(3:end))]);
      else
         C(newsizes(1),1:end,1) = 0;
      end
   end
   % Derive state matrices for reassigned models
   [a,b,c,e,nx,rnames] = blockasgn(indices{1},indices{2},...
      A,B,C,E,Nx(AssignedModels),sys.StateName,a,b,c,e,nx,rnames);
   % All I/O channels include in B,C
   outasgn = 1:newsizes(1);
   inasgn = 1:newsizes(2);
   
else
   % All I/O channels reassigned
   outasgn = indices{1};
   inasgn = indices{2};
   if size(a,1)<Na
      % Pad a,b,c,e with zeros to match number of states in sys.a
      % (ensures proper zero padding when state dimension decreases)
      na = size(a,1);
      a(Na,Na,1) = 0;
      b(Na,1:end,1) = 0;
      c(1:end,Na,1) = 0;
      e(na+1:Ne,na+1:Ne,1) = 0;
      rnames(na+1:Na,1) = {''};
   end
end

% Perform state matrix reassignment
Na = size(a,1);  % >= size(sys.a,1) by construction
Ne = size(e,1);  % >= size(sys.e,1) by construction
sys.a(1:Na,1:Na,AssignedModels) = a;
sys.e(1:Ne,1:Ne,AssignedModels) = e;
if isempty(b),
   % Can't trust A(INDIXES)=B with both A,B empty
   sys.b = zeros(Na,newsizes(2),size(sys.b,3));
else
   sys.b(1:Na,inasgn,AssignedModels) = b;
end
if isempty(c),
   sys.c = zeros(newsizes(1),Na,size(sys.c,3));
else
   sys.c(outasgn,1:Na,AssignedModels) = c;
end
Nx(AssignedModels) = nx(:);

% Update state names 
if all(strcmp(sys.StateName,'')) | nam==prod(newsizes(3:end)),
   sys.StateName(1:Na,1) = rnames;
else
   sys.StateName(end+1:Na,1) = {''};
end

% Reshape to correct array dimensions
sys.a = reshape(sys.a,[Na Na newsizes(3:end)]);
sys.e = ematchk(reshape(sys.e,[Ne Ne newsizes(3:end)]),Nx);
sys.b = reshape(sys.b,[Na newsizes(2:end)]);
sys.c = reshape(sys.c,[newsizes(1) Na newsizes(3:end)]);
sys.Nx = reshape(Nx,[newsizes(3:end) 1 1]);

% Get rid of extra zero padding, and state names if uneven state dim.
sys = xclip(sys);
if length(sys.Nx)>1,
   sys.StateName = repmat({''},[size(sys.a,1) 1]);
end

% LTI property management:
% (1) Adjust sample time of static gains to avoid unwarranted clashes
%     RE: static gains are regarded as sample-time free
if any(sflags),
   [sys.lti,rlti] = sgcheck(sys.lti,rlti,sflags);
end

% (2) Update LTI properties of LHS
sys.lti = ltiasgn(sys.lti,indices,rlti,sizes,newsizes,rsizes,zerorhs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,B,C,E,Nx,Sn] = ...
   blockasgn(arows,acols,A,B,C,E,Nx,Sn,a,b,c,e,nx,sn)
%BLOCKASGN  Reassignment of a subset of the I/O channels
% 
%   Given SYS:(A,B,C,E) and RHS:(a,b,c,e), BLOCKASGN computes
%   a realization for SYS after the reassignment
%      SYS(AROWS,ACOLS,:) = RHS
%
%   It is assumed that
%      * SYS is 3D at most
%      * AROWS and ACOLS are subsets of the I/O channels of SYS.
%
%   Note: Resulting A has as many or more states than incoming A.

% Map AROWS and ACOLS to integer indices
P = size(C,1);
if isstr(arows),
   arows = 1:P;
elseif islogical(arows),  
   arows = find(arows);  
end
   
M = size(B,2);
if isstr(acols),
   acols = 1:M;
elseif islogical(acols),  
   acols = find(acols);  
end

% Get row and column indices not affected by assignment, and
% implicitly permute I/O so that the assignment looks like 
%    [sys11  sys12 ;         [sys11  sys12;
%     sys21  sys22 ]   -->    sys21   rhs ]
frows = 1:P;  frows(arows) = [];   % fixed rows
fcols = 1:M;  fcols(acols) = [];   % fixed rows
rperm = [frows , arows];           % row permutation
cperm = [fcols , acols];           % column permutation


% Loop over each model
Na = size(A,1);
Ne = size(E,1);
D = zeros(P,M);
dk = D(arows,acols);
Snout = Sn;

for k=1:length(Nx),
   % Extract true state matrices for k-th model
   Ns = Nx(k);              Nek = min(Ns,size(E,1));
   Ak = A(1:Ns,1:Ns,k);     Ek = E(1:Nek,1:Nek,k);
   Bk = B(1:Ns,:,k);        Ck = C(:,1:Ns,k);
   ns = nx(min(k,end));     nek = min(ns,size(e,1));
   ak = a(1:ns,1:ns,k);     ek = e(1:nek,1:nek,k);
   bk = b(1:ns,:,k);        ck = c(:,1:ns,k);
   
   if ~(isequal(Ak,ak) & isequal(Ek,ek) & ...
         isequal(Bk(:,acols),bk) & isequal(Ck(arows,:),ck)),
      % SYS(ROWS,COLS,K) and RHS(:,:,K) don't have the same strictly 
      % proper part.  Split B(:,:,K) and C(:,:,K)
      B1 = Bk(:,fcols);   B2 = Bk(:,acols);
      C1 = Ck(frows,:);   C2 = Ck(arows,:);
      
      % Compute structural order of [[sys11 sys12] ; [sys21 rhs]]
      [Ar1,Br1,Cr1,Er1,Snr1] = smreal(Ak,[B1 B2],C1,Ek,Sn(1:Ns));
      [A21,B21,C21,E21,Snr2] = smreal(Ak,B1,C2,Ek,Sn(1:Ns));
      Naug1 = size(Ar1,1) + size(A21,1);
      
      % Compute structural order of [[sys11 ; sys21] , [sys12 ; rhs]]
      [Ac1,Bc1,Cc1,Ec1,Snc1] = smreal(Ak,B1,[C1;C2],Ek,Sn(1:Ns));
      [A12,B12,C12,E12,Snc2] = smreal(Ak,B2,C1,Ek,Sn(1:Ns));
      Naug2 = size(Ac1,1) + size(A12,1);
      
      % Derive realization (A,B,C,E) of SYS(:,:,k)
      % RE: We don't care about D since it's already updated
      if Naug1<=Naug2,
         % Assemble result as [[sys11 sys12] ; [sys21 rhs]]
         [Ak,Bk,Ck,Dk,Ek] = ...
            ssops('hcat',A21,B21,C21,D(arows,fcols),E21,[],ak,bk,ck,dk,ek,[]); 
         [Ak,Bk,Ck,Dk,Ek] = ...
            ssops('vcat',Ar1,Br1,Cr1,D(frows,[fcols acols]),Er1,[],Ak,Bk,Ck,Dk,Ek,[]); 
         Snout = [Snr1 ; Snr2 ; sn];            
      else
         % Assemble result as [[sys11 ; sys21] , [sys12 ; rhs]]
         [Ak,Bk,Ck,Dk,Ek] = ...
            ssops('vcat',A12,B12,C12,D(frows,acols),E12,[],ak,bk,ck,dk,ek,[]); 
         [Ak,Bk,Ck,Dk,Ek] = ...
            ssops('hcat',Ac1,Bc1,Cc1,D([frows arows],fcols),Ec1,[],Ak,Bk,Ck,Dk,Ek,[]); 
         Snout = [Snc1 ; Snc2 ; sn];
      end
      
      % Store result
      Ns = size(Ak,1); 
      Nx(k) = Ns;
      if Ns<Na,
         % Pad Ak,Bk,.. with zeros to match number of states in A
         % (ensures proper zeroing of previous data if state dim. decreases)
         Ak(Na,Na) = 0;
         Bk(Na,1:end) = 0;
         Ck(1:end,Na) = 0;
         Ek(Ns+1:Ne,Ns+1:Ne) = 0;
         Ns = Na;
      end
      Nse = size(Ek,1);
      A(1:Ns,1:Ns,k) = Ak;      E(1:Nse,1:Nse,k) = Ek;
      B(1:Ns,cperm,k) = Bk;     C(rperm,1:Ns,k) = Ck;
   end
end

% Resize state names if necessary
% Note: case where Nx varies is covered later
nA = size(A,1);
Sn = Snout;
Sn(end+1:nA,1) = {''};

