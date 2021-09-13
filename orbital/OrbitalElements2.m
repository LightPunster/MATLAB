function [a,e,i,O,w,f] = OrbitalElements2(mu,r_vec,v_vec)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    if (~isequal(size(r_vec),size(v_vec)))||(size(r_vec,1)~=3)
        error('r_vec and v_vec must be 3xn arrays of the same dimension.')
    end
    n = size(r_vec,2);
    
    a = zeros(1,n);
    e = zeros(1,n);
    i = zeros(1,n);
    O = zeros(1,n);
    w = zeros(1,n);
    f = zeros(1,n);
    
    for iter = 1:n
        %Calculate eccentricity from v x (solution to n-body problem)
        h_vec = cross(r_vec(:,iter),v_vec(:,iter)); %angular momentum vector
        e_vec = cross(v_vec(:,iter),h_vec)/mu - r_vec(:,iter)/norm(r_vec(:,iter)); 
        e(iter) = norm(e_vec);

        %Calculate semi-major axis from definitions of angular momentum &
        %parameter of ellipse
        h = norm(h_vec);
        a(iter) = (h^2)/(mu*(1-e(iter)^2));

        %Calculate eccentricity from dot product of angular momentum vector &
        %z-axis
        i(iter) = (180/pi)*acos(h_vec(3)/norm(h_vec));

        %Calculate longitude of line of nodes from dot product of line of
        %nodes & x-axis
        n_vec = cross([0;0;1],h_vec)/norm(h_vec); %line of nodes
        if norm(n_vec)==0 %h on z-axis ==> orbit in equatorial plane ==> no ascending
            % or descending nodes ==> pick n to be x-axis ==> Omega=0
            n_vec = [1;0;0];
        end
        O(iter) = (180/pi)*acos(n_vec(1)/norm(n_vec));

        %Calculate argument of periapse from dot product of line of nodes &
        %periapse direction vector e
        w(iter) = (180/pi)*acos(dot(n_vec,e_vec)/(norm(n_vec)*norm(e_vec)));

        %Calculate true anomaly from dot product of position & periapse vectors
        f(iter) = (180/pi)*acos(dot(e_vec,r_vec)/(norm(e_vec)*norm(r_vec)));
    
end

