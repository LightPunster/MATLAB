clear all
Sys = zpk([],[0, -0.1],1);
Sys_close = feedback(Sys,1);

%PO_max = 7;
%xf = (log(PO_max/100)/(-pi))^2;
%zeta = sqrt(xf/(1 + xf));
zeta = 0.65;
ts_5 = 3;
%ts_2 = ;
rlocus(Sys_close)
z_c = -0.1;

if zeta < 0.69
    w_n = 3.2/(zeta*ts_5);
else
    w_n = 4.5*zeta/ts_5;
end
%w_n = 4/(zeta*ts_2);

alpha = w_n*zeta;
beta = w_n*sqrt(1-zeta^2);
Pd_1 = -alpha + i*beta;
Pd_2 = -alpha - i*beta;


ang = angle(evalfr(Sys,Pd_1));

theta = pi - ang;
if theta<-pi
    theta = theta + 2*pi;
elseif theta>pi
    theta = theta - 2*pi;
end
if (theta<0) || (theta>pi/2)
    error('Theta is not in the correct range of 0<theta<90. Use a different compensator type.');
end

gamma1 = atan((alpha+z_c)/beta);
gamma2 = theta - gamma1;
p_c = -alpha-beta*tan(gamma2);

G_c = tf([1 -z_c],[1 -p_c]);

K = 1/abs(evalfr(G_c*Sys,Pd_1)); %1 over the gain of GcGH at Pd
G_c = K*G_c

Sys_c = G_c*Sys;
Sys_c_close = feedback(Sys_c,1);


%%
%RootLocus Plots
figure(1), rlocus(Sys), hold on, rlocus(Sys_c), grid

%%
%Calculates step responses of closed-loop systems
t = linspace(0,10,1000);
y = step(Sys_close,t);
y_c = step(Sys_c_close,t);
stepinfo(Sys_c_close)
figure(2)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('Phase Lag Compensator')
%%