function Fs = SpringForce(k,a,x)
%SpringForce calculates force from nonideal spring
%   Parameters:
%       k = spring constant
%       a = softening/hardening factor. If negative, interpreted as softening,
%           and if positive, interpreted as hardening. Use 0 for an ideal
%           spring.
%       x = state with stiffness
%
%   Can accept state vectors and time series
%   Does not allow force to fall below 0 or exceed two times the unhardened
%   spring force
%
%   Example:
%       clc, clear, close all
%       x = [-5:0.1:5; -5:0.1:5; -5:0.1:5];
%       k = [1;1;1];
%       a = [0.25;0;-0.25];
%       Fs = SpringForce(k,a,x);
%       figure(1)
%       hold on
%       plot(x(1,:),Fs(1,:))
%       plot(x(2,:),Fs(2,:))
%       plot(x(3,:),Fs(3,:))
%       legend('Hardening','Ideal','Softening')
%

    n = size(x,1);
    t = size(x,2);
    Fs = zeros(n,t);
    for i=1:n
        Fs(i,:) = k(i)*lim(1 + sign(a(i))*(a(i)^2)*(x(i,:).^2),[0,2]).*x(i,:);
    end
    
end

