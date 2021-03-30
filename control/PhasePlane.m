function PhasePlane(f,x1_range,x2_range,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch nargin
    case 3
        n = 10;
        m = 10;
    case 4
        n = varargin{1};
        m = varargin{1};
    case 5
        n = varargin{1};
        m = varargin{2};
    otherwise
        error('Expected 3, 4, or 5 inputs.');
end

x1 = linspace(min(x1_range),max(x1_range),n);
x2 = linspace(min(x2_range),max(x2_range),m);
[X1,X2] = meshgrid(x1,x2);
X1_dot = zeros(size(X1));
X2_dot = zeros(size(X2));

for i=1:(n*m)
    x = [X1(i);X2(i)];
    x_dot = f(x);
    X1_dot(i) = x_dot(1);
    X2_dot(i) = x_dot(2);
end

quiver(X1,X2,X1_dot,X2_dot,2);
grid on
xlabel('x1')
ylabel('x2')
title('f(x1,x2)')

end

