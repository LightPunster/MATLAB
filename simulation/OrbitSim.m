

%Settings and initial conditions
X0=[0,6378135,0];
V0=[7700,0,0];
t1 = [0,1.5*3600];
t2 = [0,3*3600];
options = odeset('RelTol',1e-12,'AbsTol',1e-12);

%Differential equation solution
[t_launch,r_launch] = ode45(@launchDynamics,t1,[X0,V0],options);
[t_orbit,r_orbit] = ode45(@launchDynamics,t2,r_launch(end,:),options);
close all
figure(1)

%Plot of Earth
npanels=20;
erad = 6378135; % equatorial radius (meters)
prad = 6371009; % polar radius (meters)
axis(4e7*[-1 1 -1 1 -1 1]);
view(9,26);
hold on;
axis vis3d;
[ xx, yy, zz ] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);
globe = surf(xx,yy,-zz, 'FaceColor', 'none', 'EdgeColor', 0.6*[1 1 1]);

%Plot of Orbit
plot3(r_launch(1,1), r_launch(1,2), r_launch(1,3), 'r*') %Start of sim
plot3(r_launch(end,1), r_launch(end,2), r_launch(end,3), 'rH') %Stop of sim
plot3(r_launch(:,1),r_launch(:,2),r_launch(:,3),'r') %launch path

plot3(r_orbit(end,1), r_orbit(end,2), r_orbit(end,3), 'bH') %Stop of sim
plot3(r_orbit(:,1),r_orbit(:,2),r_orbit(:,3),'b') %orbital path

%Plot formatting
grid on
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('AE6353 HW1 Output Plot')

%Dynamics function
function drdt = launchDynamics(t,r)
    u_e = 3.986e14;
    drdt = [r(4:6); (-u_e/(norm(r(1:3))^3))*r(1:3) + 0.05*r(4:6)/norm(r(4:6))];
end

function drdt = orbitDynamics(t,r)
    u_e = 3.986e14;
    drdt = [r(4:6); (-u_e/(norm(r(1:3))^3))*r(1:3) + r(4:6)/norm(r(4:6))];
end