GH = zpk([],[-5,-6,-6],100);

zeta = 0.5169;
ts = 2;
POd = 100*exp(-pi*zeta/sqrt(1-zeta^2));

zeta_d = 0.55;
ts_d = 2;
zc = -1;

if zeta_d<0.69
    wn = 3.2/(ts_d*zeta_d);
else
    wn = 4.5*zeta/ts_d;
end

alpha = wn*zeta_d;
beta = wn*sqrt(1-zeta_d^2);
Pd = -alpha + j*beta;
g = 1/abs(evalfr(GH,Pd));
theta = 180 - 180*angle(evalfr(GH,Pd))/pi;

if theta>90
    theta = theta - 360;
elseif theta<-90
    theta = theta + 360;
end

A_pid = [1 -alpha -alpha/(alpha^2 + beta^2)
         0  beta  -beta/(alpha^2 + beta^2)
         zc zc^2   1                        ];
A_pi = [A_pid(1:2,1) A_pid(1:2,3)];
A_pd = A_pid(1:2,1:2)
b1 = [g*cosd(theta)
     g*sind(theta)
     0];
b2 = b1(1:2);

K1 = inv(A_pid)*b1;
K2 = inv(A_pi)*b2;
K3 = inv(A_pd)*b2;

Gc1 = tf([K1(2) K1(1) K1(3)],[1 0]);
Gc2 = tf([K2(1) K2(2)],[1 0]);
Gc3 = tf([K3(2) K3(1)],[1]);

%sys = Gc1*GH; Gc1
sys = Gc2*GH; Gc2
%sys = Gc3*GH; Gc3
closed = feedback(sys,1);

figure(1), rlocus(sys), grid
figure(2), step(closed), grid

info = stepinfo(closed);
POc = info.Overshoot;

%Title = ['PO_d: ' num2str(POd) ', PO_c: ' num2str(POc)];

%title(Title)


