function [v1,v2] = GaussProblemP(r1,r2,t,mu,way)
%GaussProblemP solves Gauss' Problem using p-iteration
%   Detailed explanation goes here
    
    alpha = 1;
    eps_rel = 1e-6;
    k_max = 20;
    
    switch(way)
        case {'l','L','long','Long'}
            Delta_f = 2*pi - acos(dot(r1,r2)/(norm(r1)*norm(r2)));
        otherwise
            Delta_f = acos(dot(r1,r2)/(norm(r1)*norm(r2)));
    end
    
    K = norm(r1)*norm(r2)*(1 - cos(Delta_f));
    L = norm(r1) + norm(r2);
    M = norm(r1)*norm(r2)*(1 + cos(Delta_f));
    
    k = 0;
    p_k = ((K/(L + (2*M)^0.5)) + (K/(L - (2*M)^0.5)))/2;
    while(k < k_max)
        F = 1 - norm(r2)*(1-cos(Delta_f))/p_k;
        F_dot = sqrt(mu/p_k)*tan(Delta_f/2)*((1-cos(Delta_f))/p_k - 1/norm(r1) - 1/norm(r2));
        G = norm(r1)*norm(r2)*sin(Delta_f)/sqrt(mu*p_k);
        G_dot = 1 - norm(r1)*(1-cos(Delta_f))/p_k;
        
        a = M*K*p_k/((2*M-L^2)*p_k^2 + 2*K*L*p_k - K^2);
        
        if a>0
            Delta_E = atan2(-norm(r1)*norm(r2)*F_dot/sqrt(mu*a), 1 - norm(r1)*(1-F)/a);
            t_k = G + sqrt(a^3/mu)*(Delta_E - sin(Delta_E));
            dt_dp = -G/(2*p_k) - 1.5*a*(t - G)*(K^2 + (2*M - L^2)*p_k^2)/(M*K*p_k^2) + sqrt(a^3/mu)*(2*K*sin(Delta_E)/(p_k*(K-L*p_k)));
        elseif a<0
            Delta_F = acos(1 - norm(r1)*(1-F)/a);
            t_k = G + sqrt((-a)^3/mu)*(sinh(Delta_F) - Delta_F);
            dt_dp = -G/(2*p_k) - 1.5*a*(t - G)*(K^2 + (2*M - L^2)*p_k^2)/(M*K*p_k^2) - sqrt((-a)^3/mu)*(2*K*sinh(Delta_F)/(p_k*(K-L*p_k)));
        end
        
        err = abs((t - t_k)/t);
        
        k
        t_k
        p_k
        err
        
        if err<eps_rel
            break;
        else
            p_k = p_k + alpha*(t - t_k)/dt_dp;
            k = k + 1;
        end
    end
    
    v1 = (r2 - F*r1)/G;
    v2 = F_dot*r1 + G_dot*r2;

end

