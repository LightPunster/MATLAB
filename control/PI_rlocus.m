clear all
Sys = zpk([],[-1,-5,-10],1);
Sys_close = feedback(Sys,1);

zeta = 0.6;
ts_5 = 3;

w_n = 3.2/(zeta*ts_5);
alpha = w_n*zeta;
beta = w_n*sqrt(1-zeta^2);
Pd_1 = -alpha + i*beta;
Pd_2 = -alpha - i*beta;
g = 1/abs(evalfr(Sys,Pd_1));
ang = angle(evalfr(Sys,Pd_1));

theta = pi - ang;
if theta<-pi/2
    theta = theta + 2*pi;
elseif theta>0
    theta = theta - 2*pi;
end
if (theta<-pi/2) || (theta>0)
    error('Theta is not in the correct range of -90<theta<0. Use a different compensator type.');
end

A = [1, -alpha/(alpha^2+beta^2);
     0, -beta/(alpha^2+beta^2)];
b = [g*cos(theta);
     g*sin(theta)];
 
K = inv(A)*b;
K_p = K(1);;K_i = K(2);

G_c = tf([K_p K_i],[1 0])
Sys_c = G_c*Sys;
Sys_c_close = feedback(Sys_c,1);

%%
%RootLocus Plots
figure(1), rlocus(Sys), hold on, rlocus(Sys_c), grid

%%
%Calculates step responses of closed-loop systems
t = linspace(0,5,1000);
y = step(Sys_close,t);
y_c = step(Sys_c_close,t);
stepinfo(y_c)
figure(2)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('Phase Lag Compensator')
%%