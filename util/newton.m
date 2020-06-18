function [x,n,err] = newton(f, x0, varargin)
%"newton.m" uses Newton-Rhapson method to find a root of a function in x
%   Usage: [x, n, err] = newton(f, x0, varargin);
%       f = function handle for a function of x
%       x0 = initial guess for x
%       x = root of the function
%       n = number of iterations
%       err = residual in final iteration
%
%   Optional Parameters:
%       tol sets the maximum difference between consecutive estimates to
%           obtain convergence (default: 1e-6)
%       iter sets the maximum number of iterations (default: 10)
%       h sets the perturbation used to calculated df/dx (dfault: tol/10)
%   
%   Author: Nathan Daniel
%   Date: 06/15/2020

n = 0; %Stores number of iterations
switch nargin
    case 2
        if(x0==0)
            tol = 1e-10;
        else
            tol = abs(x0)*1e-6;
        end
        iter = 10;
        h = tol/10;
    case 3
        tol = varargin{1};
        iter = 10;
        h = tol/10;
    case 4
        tol = varargin{1};
        iter = varargin{2};
        h = tol/10;
    otherwise
        tol = varargin{1};
        iter = varargin{2};
        h = varargin{3};        
end

x = x0;

%Ensures accuracy condition not met initially
x_m1 = x + max(10*tol,1);

%Iterate on x using Newton's method to achieve more accurate estimatezzz
while(abs(x-x_m1)>tol) && (n<iter)
    x_m1 = x;
    dfdx = (f(x+h) - f(x-h))/(2*h);
    %If dfdx is 0, set to 1/h to avoid divide-by-zero error
    if dfdx==0, dfdx = -1/h; end
    x = x_m1 - f(x)/dfdx;
    n = n + 1;
end

err = x - x_m1;

end
