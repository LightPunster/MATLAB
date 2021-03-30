function [i_d,i_d_prime] = TunnelDiode(v_d,P_prime)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    i_d = zeros(size(v_d));
    i_d_prime = zeros(size(v_d));
    n = length(P_prime);
    
    for i=1:n
        i_d_prime = i_d_prime + P_prime(i)*v_d.^(n-i);
        i_d = i_d + (P_prime(i)/(n-i+1))*v_d.^(n-i+1);
    end

end

