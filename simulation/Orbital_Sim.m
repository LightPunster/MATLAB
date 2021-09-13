
M1 = 10;
M2 = 5.972e24;
Re = 6371000;
Ro = 425000 + Re;
G = 6.6725e-11;
Earthx = linspace(-Re,Re,1000);
Earthy_plus = sqrt(Re^2 - Earthx.^2);
Earthy_minus = -sqrt(Re^2 - Earthx.^2);

t = linspace(1,10000,100000); t_inc = t(2) - t(1);

r = zeros(1,length(t));
theta = zeros(1,length(t));
p_cart = zeros(2,length(t));
v_cart = zeros(2,length(t));
a_cart = zeros(2,length(t));
F_cart = zeros(2,length(t));
    
m1 = M1*ones(1,length(t));

p_cart(:,1) = [0;Ro];
v_cart(:,1) = [9000;0];

landed = 0;
landingCoords = [0,0];

close all
figure(1), hold on
%figure(2), hold on

for i=2:length(t)
    v_cart(:,i) = v_cart(:,i-1) + a_cart(:,i-1)*t_inc;
    p_cart(:,i) = p_cart(:,i-1) + v_cart(:,i-1)*t_inc;
    
    r(i) = sqrt(p_cart(1,i)^2 + p_cart(2,i)^2);
    theta(i) = atan2(p_cart(2,i),p_cart(1,i));
 
    F_cart(:,i) = -(G*M1*M2/(r(1,i)^3))*p_cart(:,i);
    a_cart(:,i) = F_cart(:,i)/m1(i);
    
    if r(i)<Re
        landed = 1;
        theta_land = (theta(i)*(Re-r(i)) + theta(i-1)*(r(i-1)-Re))/(r(i-1)-r(i));
        theta_land = (theta(i)+theta(i-1))/2;
        landingCoords = [Re*cos(theta_land); Re*sin(theta_land)];
    end
    if landed
        p_cart(:,i) = landingCoords;
        v_cart(:,i) = [0;0];
        a_cart(:,i) = [0;0];
        F_cart(:,i) = [0;0];
    end
    
    %figure(1),plot(p_cart(1,i),p_cart(2,i),'k*')
    %figure(2),plot(t(i),F_cart(2,i),'r*')
    %pause(1)
end
plot(Earthx,Earthy_plus,'c',Earthx,Earthy_minus,'c')
plot(p_cart(1,:),p_cart(2,:),'k--')


    