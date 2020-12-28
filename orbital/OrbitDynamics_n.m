function drdt = OrbitDynamics_n(~,r,varargin)
%OrbitDynamics_n can be used by ode45 to propogate the orbits of n point
%masses.
%
%   Parameters are
%       ~ = unused time parameter required by ode45
%       r = vector of positions and velocities ([x;y;z;x_dot;y_dot;z_dot])
%       varargin = masses of each object
%
%   Note: This function may not work for very high values of n
    
    G = 6.67408e-11;
    n = nargin - 2;
    m = zeros(1,n);
    for i=1:n
        m(i) = varargin{i};
    end
    
    drdt = zeros(6*n,1);
    for i=1:n %Loop through each mass
        pos_i = r((6*i-5):(6*i-3)); %position given by state
        vel_i = r((6*i-2):(6*i)); %velocity given by state
        accel_i = 0;
        for j=1:n %acceleration calculated by gravitational force from each other mass
            if j~=i %(not including itself)
                pos_j = r((6*j-5):(6*j-3));
                accel_i = accel_i + (G*m(j)/(norm(pos_j-pos_i)^3))*(pos_j-pos_i);
            end
        end
        drdt((6*i-5):(6*i)) = [vel_i; accel_i]'; %Update state derivative
    end
end