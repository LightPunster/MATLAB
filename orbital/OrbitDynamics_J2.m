function drdt = OrbitDynamics_J2(~,r,mu,R,J2)
%OrbitDynamics_J2 can be used by ode45 to propogate orbits
%
%   Parameters are
%       ~ = unused time parameter required by ode45
%       r = vector of positions and velocities ([x;y;z;x_dot;y_dot;z_dot])
%       mu = standard gravitational parameter of the body being orbited
%            (the value for Earth in SI units is 3.986e14)
%       R = average ellipsoid radius
%       J2 = nonspherical 2nd-order parameter


    drdt = [r(4:6);
            (-mu/(norm(r(1:3))^3))*r(1) + (3/2)*J2*(mu/norm(r(1:3))^2)*((R/norm(r(1:3)))^2)*(1-5*(r(3)/norm(r(1:3)))^2)*(r(1)/norm(r(1:3)));
            (-mu/(norm(r(1:3))^3))*r(2) + (3/2)*J2*(mu/norm(r(1:3))^2)*((R/norm(r(1:3)))^2)*(1-5*(r(3)/norm(r(1:3)))^2)*(r(2)/norm(r(1:3)));
            (-mu/(norm(r(1:3))^3))*r(3) + (3/2)*J2*(mu/norm(r(1:3))^2)*((R/norm(r(1:3)))^2)*(3-5*(r(3)/norm(r(1:3)))^2)*(r(1)/norm(r(1:3)))];

end

