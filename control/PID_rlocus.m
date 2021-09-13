clear all
Sys = tf([15],[1 1]);
Sys_close = feedback(Sys,1);

zeta = 0.5169;
ts_5 = 1;
z_c1 = 0;

w_n = 4.5*zeta/(ts_5);
alpha = w_n*zeta;
beta = w_n*sqrt(1-zeta^2);
Pd_1 = -alpha + i*beta;
Pd_2 = -alpha - i*beta;
g = 1/abs(evalfr(Sys,Pd_1));
ang = angle(evalfr(Sys,Pd_1));

theta = pi - ang;
if theta<-pi/2
    theta = theta + 2*pi;
elseif theta>0pi/2
    theta = theta - 2*pi;
end
if (theta<-pi/2) || (theta>pi/2)
    error('Theta is not in the correct range of -90<theta<90. Use a different compensator type.');
end

A = [1,    -alpha, -alpha/(alpha^2+beta^2);
       0,    beta,   -beta/(alpha^2+beta^2);
       z_c1, z_c1^2, 1                      ];
b = [g*cos(theta);
     g*sin(theta);
     0            ];
 
K = inv(A)*b;
K_p = K(1);K_d = K(2);K_i = K(3);

G_c = tf([K_d K_p K_i],[0 1 0])
Sys_c = G_c*Sys;
Sys_c_close = feedback(Sys_c,1);

%%
%RootLocus Plots
figure(1), rlocus(Sys), grid
figure(3), rlocus(Sys_c), grid

%%
%Calculates step responses of closed-loop systems
t = linspace(0,5,1000);
u = t;
%y = lsim(Sys_close,u,t);
y = step(Sys_close,t);
%y_c = lsim(Sys_c_close,u,t);
y_c = step(Sys_c_close,t);

figure(2)
subplot(2,1,1), plot(t,y), grid, title('Uncompensated')
subplot(2,1,2), plot(t,y_c), grid, title('Phase Lag Compensator')
%%