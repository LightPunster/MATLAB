function drdt = OrbitDynamics_Sphere(~,r,mu)
%OrbitDynamics_J2 can be used by ode45 to propogate orbits
%
%   Parameters are
%       ~ = unused time parameter required by ode45
%       r = vector of positions and velocities ([x;y;z;x_dot;y_dot;z_dot])
%       mu = standard gravitational parameter of the body being orbited
%            (the value for Earth in SI units is 3.986e14)
%
%   Note that this function assumes the large body creating the orbit is
%   perfectly spherical.

    drdt = [r(4:6); -(mu/norm(r(1:3))^3)*r(1:3)]; 
end

