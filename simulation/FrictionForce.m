function Ff = FrictionForce(mg,u_s,u_v,F_ext,x_dot)
%Friction Static, Coulomb, and Viscous friction model
%   Parameters
%       mg = contact force (often mass x gravitation acceleration)
%       u_s = static friction coefficient
%       u_v = viscous friction coefficient
%       F_ext = external applies forces or moments
%       x_dot = state derivative
%       
%   Can accept state vectors

    n = size(x_dot,1);
    t = size(x_dot,2);
    Ff = zeros(n,t);
    for i=1:n
        
        
        Ff(i,:) = (abs(F_ext(i,:)) <= mg(i)*u_s(i)).*...
            (-F_ext(i,:)) + ... %Static Friction
            (abs(F_ext(i,:)) > mg(i)*u_s(i)).*...
            (-mg(i)*u_s(i)*sign(x_dot)) + ... %Coulomb Friction
                   ;
        
        Ff(i,:) = 
    end
    
end

