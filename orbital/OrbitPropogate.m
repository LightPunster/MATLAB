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
%       J2 = nonspherical 2nd order parameter (the value for Earth is
%       0.00108263)
%       R = radius, which is required for nonspherical gravity calculations
%   
%   If no nonspherical parameters are provided, this functions assumes that
%   the large body creating the orbit is perfectly spherical.

    %Differential equation solution
    options = odeset('RelTol',1e-12,'AbsTol',1e-12);
    if nargin==4
        [~,r] = ode45(@(t,r) OrbitDynamics_Sphere(t,r,mu),[0,tf],[r0,v0],options);
    elseif nargin==6
        R = varargin{1};
        J2 = varargin{2};
        [~,r] = ode45(@(t,r) OrbitDynamics_J2(t,r,mu,R,J2),[0,tf],[r0,v0],options);
    else
        error('Function requires 4 or 6 input parameters.')
    end

    %Plot of Orbit
    
    %Make sure that other plots are not overwritten
    precallState = ishold;
    if ~precallState
        hold on
    end
    
    plot3(r(1,1), r(1,2), r(1,3), 'r*') %Start of sim
    plot3(r(end,1), r(end,2), r(end,3), 'rH') %Stop of sim
    plot3(r(:,1),r(:,2),r(:,3)) %Orbital path

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

