function close = isclose(a,b,varargin)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin==2
    tol = 1e-10;
else
    tol = varargin{1};
end

close = norm(a-b)<tol;
end

