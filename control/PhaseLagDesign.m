%Written by Nathan Daniel for ECE4210 Control Systems Design F2017
close all

%Specs
max_ess_step = 0.05;
min_phase_margin = 48;

%Open loop system
G = tf([1 0.1 7.5],[1 0.12 9 0 0]);
Sys = G;
[n,d] = tfdata(Sys);
Sys_close = feedback(G,H);

%Static gain to correct e_ss
%K = (d(end)/n(end))*(1-max_ess_step)/max_ess_step
%K = (d(end-1)/n(end))/max_ess_ramp
K = 1; Sys_k = K*Sys;
Sys_k_close = feedback(K*G,H);

%Calculates compensator parameters
phi_m = min_phase_margin - 180;
w = logspace(-1,4,10000);
bode(Sys_k,w)
prompt = ['Enter frequency where phase = ', num2str(phi_m), ': '];
w_gc = input(prompt);
close all
g = 20*log10(abs(evalfr(Sys_k,j*w_gc)));
a = 10^(-g/20);
T = 10/(a*w_gc);

%Compensator transfer function
Gc = tf([a*T,1],[T,1])
Sys_c = Gc*Sys_k;
Sys_c_close = feedback(Gc*K*G,H);
%%
%Bode plots and Gain/Phase Margins

figure(1)
subplot(2,3,1:3), bode(Sys), hold on, bode(Sys_k), hold on, bode(Sys_c), grid
subplot(2,3,4), margin(Sys), grid
subplot(2,3,5), margin(Sys_k), grid
subplot(2,3,6), margin(Sys_c), grid

%%
%Calculates step responses of closed-loop systems
t = linspace(0,1000,1000);
y = step(Sys_close,t);
y_k = step(Sys_k_close,t);
y_c = step(Sys_c_close,t);
figure(2)
subplot(3,1,1), plot(t,y), grid, title('Uncompensated')
subplot(3,1,2), plot(t,y_k), grid, title('Gain Compensated')
subplot(3,1,3), plot(t,y_c), grid, title('Phase Lag Compensator')
%%
%Ramp Responses
%{
t = linspace(0,10,1000);
u = t;
y = lsim(Sys_close,u,t); %Note: lsim takes u, an arbitrary input signal
y_k = lsim(Sys_k_close,u,t);
y_c = lsim(Sys_c_close,u,t);
figure(3)
subplot(3,1,1), plot(t,y), grid, title('Uncompensated')
subplot(3,1,2), plot(t,y_k), grid, title('Gain Compensated')
subplot(3,1,3), plot(t,y_c), grid, title('Phase Lag Compensator')
%}