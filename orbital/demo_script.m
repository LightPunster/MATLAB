clear, clc, close all

mu_e = 3.986e14;
J2 = 0.00108263;

hour = 3600;
day = 24*hour;

%% Plot Planet
figure(1)
PlotPlanet('EarthMercator1.jpg')

%% Orbit Propogate & Orbit Dynamics Functions
r0 = [-4733864.21277513,-4979793.03035316,14962.3595148493];
v0 = [101.014031795983,-88.2635217808004,7616.55417363462];
OrbitPropogate(mu_e,r0,v0,1.5*hour);

figure(2)
n = 5*ceil(rand()) + 1;
r0 = 10*rand(1,3*n) - 5;
v0 = 0.1*rand(1,3*n) - 0.05;
m = 1e6*rand(1,n);
OrbitPropogate(mu_e,r0,v0,300,'n-body',m);





