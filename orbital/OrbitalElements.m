function [a, e, i, O, w, T0] = OrbitalElements(r,v,u)

h = cross(r,v);
e_vect = cross(v,h)/u - (1/norm(r))*r;
e = norm(e_vect);

p = (norm(h)^2)/u;
a = p/(1-e^2);

i = acos(sum(h.*[0,0,1])/norm(h))*180/pi;

n = cross(h,[0,0,1])/norm(cross(h,[0,0,1]));
if isnan(n) %h = +-|h|k, orbit in equatorial plane, no ascending or descending nodes
    n = [1,0,0]; %Let line of nodes be x-axis --> Omega=0
end

O = acos(n(1)/norm(n))*180/pi;
if i<180 % orbit is ccw
    w = acos(sum(e_vect.*n)/(norm(e)*norm(n)))*180/pi;
else % orbit is cw
    w = -acos(sum(e_vect.*n)/(norm(e)*norm(n)))*180/pi;
end
    
f = acos(sum(e_vect.*r)/(norm(e)*norm(r)))

if a<0 %hyperbolic
    F = 2*atanh(sqrt((e-1)/(e+1))*tan(f/2))
    M = e*sinh(F) - F;
    n = sqrt(u/(-a)^3);
elseif a>0
    E = 2*atan(sqrt((1-e)/(1+e))*tan(f/2))
    M = E - e*sin(E)
    n = sqrt(u/a^3)
end

T0 = M/n

end

