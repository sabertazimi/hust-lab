function f=Dirac(t)
% DIRAC Unit Impulse function
% f=Dirac(t) returns a vector f the same size as
% the input vector, where the elememnt of f is 1 if the 
% corresponding element of t is zero.
f=(t==0);
