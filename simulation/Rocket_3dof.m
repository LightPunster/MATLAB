function X_dot = Rocket_3dof(X,U,m,J,g,S,Cd,Cda,Ca,Cq)
%Rocket.m 3-dof dynamic equations of a rocket
%   1DOF Example:
%       g = 9.807; m = 10; J = 0.01;
%       S = 1; Cd = 1; Ca = 0; Cda = 0; Cq = 0;
%       t = 0:1e-3:120;
%       [t,x] = nlsim(@(x,u)Rocket_3dof(x,u,m,J,g,S,Cd,Cda,Ca,Cq),...
%                     zeros(6,1),t,10*m*g*ones(size(t)).*(t<10));
%       plot(t,x(:,2))
%   2DOF Example:
%       g = 9.807; m = 10; J = 0.01;
%       S = 1; Cd = 1; Ca = 0.1; Cda = 0; Cq = 0.1;
%       t = 0:1e-3:120;
%       theta0 = -0.1;
%       [t,x] = nlsim(@(x,u)Rocket_3dof(x,u,m,J,g,S,Cd,Cda,Ca,Cq),...
%                     [0;0;theta0;0;0;0],t,10*m*g*ones(size(t)).*(t<10));
%       subplot(2,1,1)
%       plot(x(:,1),x(:,2))
%       subplot(2,1,2)
%       plot(x(:,1),x(:,3))

    x = [X(1);X(2)]; %Position vector
    theta = X(3); %Pitch
    V = [X(4);X(5)]; %Velocity vector
    q = X(6); %Pitch rate
    
    %Thrust
    T = U(1);
    
    %Aerodynamic forces
    [rho,~,~] = Atmos(x(2)); %Air density at altitude
    P = 0.5*rho*norm(V)^2; %Dynamic pressure
    alpha = atan2(V(1),V(2)) - theta; %angle of attack
    if norm(V)==0
        Fa = zeros(size(V));
    else
        Fa = -(V/norm(V))*P*S.*(Cd + Cda*alpha);
    end
    Ma = P*S*(Ca*alpha - sign(q)*Cq*(q^2));
    
    F = [-T*sin(theta) + Fa(1);
          T*cos(theta) + Fa(2) - m*g];
    M = Ma;
    if x(2)>=0
        X_dot = [V;q;F/m;M/J];
    else
        X_dot = zeros(6,1);
    end
end

function [rho,P,T] = Atmos(y)
    %https://en.wikipedia.org/wiki/U.S._Standard_Atmosphere
    %https://en.wikipedia.org/wiki/Gas_constant#Specific_gas_constant
    Y = [0,11000,20000,32000,47000,51000,71000,90000];
    P = [101325,22632.1,5474.89,868.019,110.906,66.9389,3.95642,0];
    T = [288.15,216.65,216.65,228.65,270.65,270.65,214.65,176.65];
    R  = 287.058; 
    
    p = interp1(Y,P,y,'linear','extrap');
    t = interp1(Y,T,y,'linear','extrap');
    rho = p/(R*t);
end

