function [ output_args ] = ClosedLoopFrequencyResponse(system,order)

if nargin==1
    [w_n, zeta] = damp(a);
    w_n = mode(w_n);
    zeta = mode(zeta);
else
    w_n = a;
    zeta = b;
end

w_r = w_n*(1-2*zeta^2)^0.5;
M_r = 1/(2*zeta*(1-zeta^2)^0.5);
BW = w_n*((1-2*zeta^2)+(4*zeta^4 - 4*zeta^2 + 2)^0.5)^0.5;

w = linspace(0,2*BW,10000);
s = j*w;
M_s = w_n^2./((j*w).^2 + 2*zeta*w_n*(j*w) + w_n^2);
Title = strcat("w_r=",num2str(w_r)," rad/s       M_r=",num2str(M_r),"       BW=",num2str(BW)," rad/s");
figure(2),plot(w,abs(M_s))
title(Title)
xlabel('omega (rad/s)'),ylabel('|M(s)|')
grid


end

