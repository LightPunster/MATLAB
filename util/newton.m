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
%   Date: 06/23/2020

n = 0; %Stores number of iterations
switch nargin
    case 2
        if(x0==0)
            tol = 1e-10;
        else
            tol = norm(x0)*1e-6; %Norm allows function to be used for tensors
        end
        iter = 10;
        h = tol/10;
        range = [-inf,inf];
    case 3
        tol = varargin{1};
        iter = 10;
        h = tol/10;
        range = [-inf,inf];
    case 4
        tol = varargin{1};
        iter = varargin{2};
        h = tol/10;
        range = [-inf,inf];
    case 5
        tol = varargin{1};
        iter = varargin{2};
        h = varargin{3};
        range = [-inf,inf];
    case 6
        tol = varargin{1};
        iter = varargin{2};
        h = varargin{3};
        range = varargin{4};
    otherwise
        error('Expected between 2 & 6 input arguments. Got %d.',nargin);
end

x = x0;
%Ensures accuracy condition not met initially
x_m1 = x + max(10*tol,1);

%Iterate on x using Newton's method to achieve more accurate estimate
while (norm(x-x_m1)>tol) && (n<iter) %Norm allows function to be used for tensors
    x_m1 = x;
    f_m1 = f(x_m1);
    fail = abs(f_m1)>tol; %Points where objective is not met
    
    dfdx = (f(x+h) - f(x-h))/(2*h);
    dfdx((dfdx==0)&fail) = 1/h; %If dfdx is 0 but f(x) is not w/in tolerance, set to 1/h (i.e. perturb x by h)
    x(fail) = x_m1(fail) - f_m1(fail)./dfdx(fail); %Only adjust points outside of tol
    n = n + 1;
end

err = norm(x - x_m1); %Purely for output

end

