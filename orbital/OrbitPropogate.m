function OrbitPropogate(mu,r0,v0,tf,varargin)
%OrbitPropogate: Propogates an orbit using ode45 given initial conditions
%
%   Parameters:
%       mu = standard gravitational parameter of the body being orbited
%            (the value for Earth in SI units is 3.986e14)
%       r0 = initial radial vector
%       v0 = initial velocity vector
%       tf = length of time to propogate
%
%   Optional Parameters:
%       method = specifies dynamics functions to use
%           If 'spherical', no further parameters are needed
%           If 'J2', the following nonspherical gravity
%           parameters are needed:
%               J2 = nonspherical 2nd order parameter (the value for Earth is
%                       0.00108263)
%               R = radius, which is required for nonspherical gravity calculations
%           If 'n-body', the next parameter is interpreted as a
%           1xn list of point masses. r0 and v0 should both be 1x(3n) arrays
%           constaining r0 and v0 for each mass.
%
%   If no nonspherical parameters are provided, this functions assumes that
%   the large body creating the orbit is perfectly spherical.

    %Differential equation solution
    options = odeset('RelTol',1e-12,'AbsTol',1e-12);
    if nargin==4 %Default - propogate orbit around spherical body
        [~,r] = ode45(@(t,r) OrbitDynamics_Sphere(t,r,mu),[0,tf],[r0,v0],options);
    else
        method = varargin{1};
        switch method
            case 'spherical'
                [~,r] = ode45(@(t,r) OrbitDynamics_Sphere(t,r,mu),[0,tf],[r0,v0],options);
            case 'J2'
                R = varargin{2};
                J2 = varargin{3};
                [~,r] = ode45(@(t,r) OrbitDynamics_J2(t,r,mu,R,J2),[0,tf],[r0,v0],options);
            case 'n-body'
                m = varargin{2};
                [~,r] = ode45(@(t,r) OrbitDynamics_n(t,r,m),[0,tf],[r0,v0],options);
            otherwise
                error('Specified dynamics function is invalid.');
        end
    end

    %Plot of Orbit
    
    %Make sure that other plots are not overwritten
    precallState = ishold;
    if ~precallState
        hold on
    end
    
    plot3(r(:,1),r(:,2),r(:,3)) %Orbital path
    plot3(r(1,1), r(1,2), r(1,3), 'r*') %Start of sim
    plot3(r(end,1), r(end,2), r(end,3), 'rH') %Stop of sim
    
    %Plot formatting
    grid on, xlabel('x (m)'), ylabel('y (m)'), zlabel('z (m)')
    expandPlotLimits(1.25*[min(r(:,1)),max(r(:,1))],...
        1.25*[min(r(:,2)),max(r(:,2))],...
        1.25*[min(r(:,3)),max(r(:,3))])
    
    %Turn hold back off if it was off before call
    if ~precallState
        hold off
    end

end

