t = linspace(0,5,10000);
%%
%Open loop system
Sys = tf([10],[1 11 10 0])
Sys_close = feedback(Sys,1);
subplot(3,1,1), step(Sys_close,t)
%%
%Finding K_cr, the static gain which results in oscillation (PM = 0)
PM=1000;
K_cr = 0;

while abs(PM)>=10
    K_cr = K_cr + 0.1;
    Sys_k = K_cr*Sys;
    [GM,PM,w_cg,w_cp] = margin(Sys_k);
end

while abs(PM)>=1
    K_cr = K_cr + 0.01;
    Sys_k = K_cr*Sys;
    [GM,PM,w_cg,w_cp] = margin(Sys_k);
end

while abs(PM)>=0.1
    K_cr = K_cr + 0.001;
    Sys_k = K_cr*Sys;
    [GM,PM,w_cg,w_cp] = margin(Sys_k);
end

while abs(PM)>=0.01
    K_cr = K_cr + 0.0001;
    Sys_k = K_cr*Sys;
    [GM,PM,w_cg,w_cp] = margin(Sys_k);
end


Sys_k = K_cr*Sys;
Sys_k_close = feedback(Sys_k,1);
subplot(3,1,2), step(Sys_k_close,t)

%%
%Finding the Period of Oscillation
[n,d] = tfdata(Sys_k_close,'v');
P = zeros(1,length(d)-1);
for i=1:2:(length(d)-1)
    P(i) = d(i+1);
end
aux_roots = roots(P);
aux_freqs = abs(imag(aux_roots));
omega = mode(aux_freqs);
f = omega/(2*pi);
P_cr = 1/f;

%%
%Compensator Design
Kp = 0.6*K_cr;
Ti = 0.5*P_cr;
Ki = Kp/Ti;
Td = 1.25*P_cr;
Kd = Kp*Td;
Gc = tf([Kd Kp Ki],[1 0])

Sys_c = Gc*Sys;
Sys_c_close = feedback(Sys_c,1)
subplot(3,1,3), step(Sys_c_close,t)
