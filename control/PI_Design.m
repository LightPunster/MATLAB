%Written by Nathan Daniel for ECE4210 Control Systems Desgin, F2017
close all
%PI

%Specs
%min_phase_margin = 0;
max_PO = 10;
min_phase_margin = 100*sqrt(((log(max_PO/100)^2)/(pi)^2)/(1+(log(max_PO/100)^2)/(pi)^2))
%min_zeta = 0.5;
%min_phase_margin = 100*min_zeta;

%Open loop system
Sys = tf([20],[1 1],'InputDelay',0.1);
Sys_close = feedback(Sys,1);

%Calculates compensator parameters
phi_m = min_phase_margin - 180;
w = logspace(-2,2,10000);
bode(Sys,w)
prompt = ['Enter frequency where phase = ', num2str(phi_m), ': '];
w_gc = input(prompt);
close all
g = 20*log10(abs(evalfr(Sys,j*w_gc)));
Kp = 10^(-g/20);
Ki = Kp*w_gc/100;

%Compensator transfer function
Gc = tf([Kp,Ki],[1,0])
Sys_c = series(Sys,Gc);
Sys_c_close = feedback(Sys_c,1);
%%
%Bode plots and Gain/Phase Margins

figure(1)
subplot(2,2,1:2), bode(Sys), hold on, bode(Sys_c), grid
subplot(2,2,3), margin(Sys), grid
subplot(2,2,4), margin(Sys_c), grid

%%
%Calculates step responses of closed-loop systems

t = linspace(0,100,1000);
y = step(Sys_close,t);
y_c = step(Sys_c_close,t);
figure(2)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('PI Controller')
stepinfo(Sys_c_close)
%%
%Ramp Responses
%{
t = linspace(0,1000,1000);
u = t;
y = lsim(Sys_close,u,t); %Note: lsim takes u, an arbitrary input signal
y_c = lsim(Sys_c_close,u,t);
figure(3)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('Phase Lag Compensator')
%}