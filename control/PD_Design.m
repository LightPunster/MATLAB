%Written by Nathan Daniel for ECE4210 Control Systems Desgin, F2017
clear all
%PD 

%Specs
x = 0.15; %Choose x=BW/w_gc between 1.2 and 1.6
min_phase_margin = 100;
    zeta = min_phase_margin/100;
%ts_5p_max = 1;
    %wn = 3.2/(zeta*ts_5p_max);
ts_2p_max = 3;
    wn = 4/(zeta*ts_2p_max);
BW = wn*((1-2*zeta^2)+sqrt(4*(zeta^4)-4*(zeta^2)+2));
%zeta = 60;
%BW = 15;
%wn = BW/(-1.19*zeta+1.85);

%Open loop system
%Sys = tf([0.0802],[0.0308 1 0]);
Sys = tf([0.206],[0.0254 1 0]);
Sys_close = feedback(Sys,1);

%Calculates compensator parameters
phi_m = min_phase_margin - 180;
w_gc = BW/x;
phi = 180*angle(evalfr(Sys,j*w_gc))/pi;
%Note: Calculated phi may be 360 degrees off from visually determined Phi, but should not change results
g = abs(evalfr(Sys,j*w_gc));
lambda = tand(phi_m - phi);
Kp = 1/(g*sqrt(1+lambda^2));
Kd = 1*lambda*Kp/w_gc;

if Kp<0
    error('Kp is less than 0')
end

%Compensator transfer function
%Gc = tf([Kd,Kp],[1])
Gc = tf([0.2180,5.4946],[1]);
Sys_c = series(Sys,Gc);
Sys_c_close = feedback(Sys_c,1);
%%
%Bode plots and Gain/Phase Margins
%{
figure(1)
subplot(2,2,1:2), bode(Sys), hold on, bode(Sys_c), grid
subplot(2,2,3), margin(Sys), grid
subplot(2,2,4), margin(Sys_c), grid
%}
%%
%Calculates step responses of closed-loop systems
t = linspace(0,10,1000);
y = step(Sys_close,t);
y_c = step(Sys_c_close,t);
figure(2)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('PD Controller')
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