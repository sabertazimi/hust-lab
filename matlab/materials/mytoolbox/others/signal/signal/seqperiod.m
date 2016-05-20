function [P,N] = seqperiod(X)
%SEQPERIOD Find minimum-length repeating sequence in a vector.
% 
%  P = SEQPERIOD(X) returns the index P of the sequence of samples
%  X(1:P) which is found to repeat (possibly multiple times) in
%  X(P+1:end).  P is the sample period of the repetitive sequence.
%  No intervening samples may be present between repetitions.  An
%  incomplete repetition is permitted at the end of X.  If no
%  repetition is found, the entire sequence X is returned as the
%  minimum-length sequence and hence P=length(X).
%
%  [P,N] = SEQPERIOD(X) returns the number of repetitions N of the
%  sequence X(1:P) in X.  N will always be >= 1 and may be non-
%  integer valued.
%
%  If X is a matrix or N-D array, the sequence period is determined
%  along the first non-singleton dimension of X.

%  Author: D. Orofino
%  Copyright (c) 1988-98 by The MathWorks, Inc.
%  $Revision: 1.1 $ $Date: 1998/06/03 14:43:48 $

error('MEX file for SEQPERIOD not found');
