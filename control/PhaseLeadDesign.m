%Written by Nathan Daniel for ECE4210 Control Systems Design F2017

%%PHASE LEAD

%Specs
max_ess_step = 0.01;
%max_ess_ramp = 0.05;
min_phase_margin = 52;

%Open loop system
Sys = tf([6.5],[10 1 0]);
%Sys = tf([0.206],[0.0254 1]);
Sys_close = feedback(Sys,1);

%Static gain to correct e_ss
%K = (d(end)/n(end))*(1-max_ess_step)/max_ess_step
%K = (d(end-1)/n(end))/max_ess_ramp
K = 1
if K<1 %Would only decrease accuracy
    K=1;
end
Sys_k = K*Sys;
Sys_k_close = feedback(Sys_k,1);

%Calculates compensator parameters
[g_m,p_m,w_p,w_g] = margin(Sys_k);
phi_m = min_phase_margin - p_m + 20;
a = (1+sind(phi_m))/(1-sind(phi_m));

if a<=1
    error('Cannot use Phase Lead Compensator because a<1, i.e. phi_m < 0, i.e. PMU > PMD')
end

g = -10*log10(a);
System_gained = sqrt(a)*Sys_k;
[g_m,p_m,w_p,w_g] = margin(System_gained);
w_m = w_g;
T = 1/(w_m*sqrt(a));

%Compensator transfer function
Gc = tf([a*T,1],[T,1])
Sys_c = series(Sys_k,Gc);
Sys_c_close = feedback(Sys_c,1);
%ess_ramp = dc(end-1)/nc(end)

%Bode plots and Gain/Phase Margins

figure(1)
subplot(2,3,1:3), bode(Sys), hold on, bode(Sys_k), hold on, bode(Sys_c), grid
subplot(2,3,4), margin(Sys), grid
subplot(2,3,5), margin(Sys_k), grid
subplot(2,3,6), margin(Sys_c), grid


%Calculates step responses of closed-loop systems

figure(2)
t = linspace(0,50,1000);
y = step(Sys_close,t);
y_k = step(Sys_k_close,t);
y_c = step(Sys_c_close,t);
subplot(3,1,1), plot(t,y), grid, title('Uncompensated')
subplot(3,1,2), plot(t,y_k), grid, title('Gain Compensated')
subplot(3,1,3), plot(t,y_c), grid, title('Phase Lead Compensator')
stepinfo(Sys_c_close)

%Ramp Responses
%{
t = linspace(0,10,1000);
u = t;
y = lsim(n,n+d,u,t); %Note: lsim takes u, an arbitrary input signal
y_k = lsim(nk,nk+dk,u,t);
y_c = lsim(nc,nc+dc,u,t);

figure(3), plot(t,y,t,y_k,t,y_c), grid, title({'Ramp Responses','Blue=Uncompensated, Red = Gain Compensated, Yellow = Gain+Phase Compensated'})
%}