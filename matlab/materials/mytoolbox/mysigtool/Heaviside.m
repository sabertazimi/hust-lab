function f=Heaviside(tt)
% HEAVISIDE Unit Step function
% f=Heaviside(t) returns a vector f the same size as
% the input vector, where each elememnt of f is 1 if the 
% corresponding element of t is greater than zero.
f=(tt>=0);
