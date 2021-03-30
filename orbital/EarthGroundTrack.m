function [] = EarthGroundTrack(sat, inc, O, e, w, a , propogationTime, fig, plotType)
figure(fig)
close(fig)
T = [0,propogationTime]; %Propogation Time
u = 3.986e14; %Earth constant
Re = 6378135; %Earth radius
J2 = 0.00108263; %Earth nonspherical parameter

numSats = length(a);
M = zeros(1,numSats);
inc = pi*inc/180;

%% Calculation of Position and Velocity

ci = cos(inc); si = sin(inc); 
cO = cos(O); sO = sin(O);
cw = cos(w); sw = sin(w);

for i=1:numSats
    [E(i),~,~] = EccentricAnomoly(e(i),M(i),1e-8);
    R_xform(:,:,i) = [cO(i)*cw(i)-sO(i)*ci(i)*sw(i), -cO(i)*sw(i)-sO(i)*ci(i)*cw(i),  sO(i)*si(i);
                sO(i)*cw(i)+cO(i)*ci(i)*sw(i), -sO(i)*sw(i)+cO(i)*ci(i)*cw(i), -cO(i)*si(i);
                si(i)*sw(i)                  ,  si(i)*cw(i)                  ,  ci(i)      ];
end

f = 2*atan(tan(E/2)./(((1-e)./(1+e)).^0.5));
%Check to ensure f is correct
atanCheck = abs(f-E)>pi;
f(atanCheck) = f(atanCheck)+pi;

p = a.*(1-e.^2);
Tp = 2*pi*sqrt(a.^3/u);

%Generate trajectories
rad = p./(1 + e.*cos(f));
%Note: varies from standard in order to match with Earth plot and make
%x-axis = 0 degrees longitude
r0 = [-rad.*cos(f); rad.*sin(f); zeros(1,length(rad))];
v0 = [-sqrt(u./p).*sin(f); -sqrt(u./p).*(e+cos(f)); zeros(1,length(rad))];
for i=1:numSats
    r0(:,i) = R_xform(:,:,i)*r0(:,i);
    v0(:,i) = R_xform(:,:,i)*v0(:,i);
end

%% Plot of Earth
figure(fig), hold on
Title = ['Ground track of ' sat ' over ' num2str(propogationTime/(24*3600)) ' day(s)'];
title(Title)

% if plotType=='s'
%     npanels=20;
%     erad = 6378135; % equatorial radius (meters)
%     prad = 6371009; % polar radius (meters)
%     [ xx, yy, zz ] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);
%     warp(-xx,yy,-zz, I)
%     view(9,26), hold on, axis vis3d, grid on
%     xlabel('x (m)'), ylabel('y (m)'), zlabel('z (m)')
% elseif plotType=='m'
%     imagesc([360 0], [90 -90], flip(I,2));
%     axis([0,360,-90,90])
%     xlabel('Longitude (degrees)'), ylabel('Lattitude (degrees)'),
% else
%     error('Invalid plot type selected')
% end

I = dlmread('World.txt');
plot(I(:,1),I(:,2),'.r')
axis([0,360,-90,90])
xlabel('Longitude (degrees)'), ylabel('Lattitude (degrees)')

%% Ground Track Plots
options = odeset('RelTol',1e-12,'AbsTol',1e-12);
L0 = O; %Initial longitudes of each satellite
for i=1:numSats
    [t,r] = ode45(@(t,r) OrbitDynamics_Sphere(t,r,u),T,[r0(:,i), v0(:,i)],options); %Diff Eq Solution
    %[t,r] = ode45(@(t,r) OrbitDynamics_J2(t,r,u,Re,J2),T,[r0(:,i), v0(:,i)],options); %Diff Eq Solution
    rnorm = sqrt(sum((r.^2)'));
    t_inc = t(2) - t(1);
    if e(i)~=0
        X = (rnorm-a(i)*(1-e(i)^2))./(rnorm*e(i));
        X = X.*((X<=1)&(X>=-1)) + 1*(X>1) - 1*(X<-1); %Prevents imaginary values by limiting to [-1,+1]
        f_i = acos(X); %f throughout orbit
    else
        f_i = (sqrt(u./rnorm)./rnorm).*t'; %Angle is v over r (w) times time
    end
    %Inverse cosine correction
    flag = 0;
    for j=1:(length(f_i)-1)
        if f_i(j)>f_i(j+1)
            f_i(j) = 2*pi-f_i(j);
            flag = 1;
        else
            flag = 0;
        end
    end
    if flag
        f_i(end) = 2*pi - f_i(end);
    end
    
    phi_i = f_i - w(i);  %Angle from n throughout orbit
    phi_i = phi_i + 2*pi*(phi_i<0);
   
    lat = asin(sin(phi_i)*sin(inc(i)));
    long = L0(i) + atan2(tan(lat)/tan(inc(i)),cos(phi_i)./cos(lat));
    
    %Correction for drift
    w_earth = 2*pi/(24*3600-236);
    theta = w_earth*t;
    for j=1:length(t)
        R_xform = [ cos(theta(j)) sin(theta(j)) 0;
                   -sin(theta(j)) cos(theta(j)) 0;
                    0          0          1];
        r(j,1:3) = (R_xform*r(j,1:3)')';
    end
    long = long - theta';
    while min(long)<0
        long(long<0) = long(long<0) + 2*pi;
    end
  
    % Generate plot
    if plotType=='s'
        Rsurf = 6371000*[cos(lat).*cos(long); cos(lat).*sin(long); sin(lat)];
        plot3(Rsurf(1,:),Rsurf(2,:),Rsurf(3,:),'c')
        plot3(r(:,1),r(:,2),r(:,3),'r') %Orbital path
    elseif plotType=='m'
        plot(180*long/pi,180*lat/pi,'c.')
    end
end
end

