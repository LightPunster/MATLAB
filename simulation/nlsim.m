function [y,t,x] = nlsim(f,u,t,x0,varargin)
%nlsim simulates a time-invariant system with nonlinear dynamics
%   This function is meant to serve as a nonlinear variant of the lsim
%   function. Inputs are:
%       - f: the function handle which has inputs x (1xn) and u (1xn) and outputs x_d
%       (the state derivatives) and y (the system output, if applicable)
%       - u: 

%Input checking
if numel(x0)>length(x0)
    error('x0 should be a 1-dimensional column or row vector.')
end
if size(x0,1)==1 %If x0 is given as row vector, convert it to a column vector
    x0 = x0';
end

x = zeros(length(x0),length(t));
x(:,1) = x0; %State @ t=0
[y,x_d] = f(x(:,1),u(1)); %State derivate & output @ t=0

for i=2:length(t)
    dt = t(i)-t(i-1); %Calculate time increment
    x(:,i) = x(:,i-1) + dt*x_d; %Update state
    [y_i,x_d] = f(x(:,i),u(i)); %Update state derivative & output
    y = [y y_i];
end

x = x'; y = y'; %Return transposed output
end