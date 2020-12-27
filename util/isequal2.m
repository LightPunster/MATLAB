function equal = isequal2(a,b,varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    if nargin==2
        tol = 1e-10;
    else
        tol = varargin{1};
    end
    
    equal = isequal(a,b) | isclose(a,b,tol);

end

