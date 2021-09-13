clear all
Sys = zpk([],[],1);
Sys_close = feedback(Sys,1);

%PO_max = 7;
%xf = (log(PO_max/100)/(-pi))^2;
%zeta = sqrt(xf/(1 + xf));
%zeta = 0.65;
%ts_5 = 3;
ess_ramp_max = 0.05;
%ts_2 = ;
thetaLim = 2;

Pd_1 = 0.5 + j*0.993;
K_star = 1.24;

a = K_star*ess_ramp_max;
T = 1;
theta = 100;

while theta > thetaLima
    T = T*10;
    p_c = -1/T;
    z_c = p_c/a;
    G_c = tf([1 z_c],[1 p_c]);
    theta = angle(evalfr(G_c,Pd_1))*180/pi;
end

Sys_c = K_star*G_c*Sys;
Sys_c_close = feedback(Sys_c,1);

%%
%RootLocus Plots
figure(1), rlocus(Sys), hold on, rlocus(Sys_c), grid

%%
%Calculates step responses of closed-loop systems
t = linspace(0,10,1000);
u = t;
y = step(Sys_close,t);
%y = lsim(Sys_close,u,t);
y_c = step(Sys_c_close,t);
%y_c = lsim(Sys_c_close,u,t);
%stepinfo(Sys_c_close)
figure(2)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('Phase Lag Compensator')
%%
