
function [r, PHI, r_d, PHI_d, r_dd, PHI_dd] = Inverse_RP(a, Xq, Yq, Xa,Ya,Xa_d,Ya_d,Xa_dd,Ya_dd, I)

%%%%%%%%%%%%%% Inverse kinematics (Position) %%%%%%%%%%%%%% 

X = Xa - Xq;
Y = Ya - Yq;
X_d = Xa_d;
Y_d = Ya_d;
X_dd = Xa_dd;
Y_dd = Ya_dd;

if I == 1;
    r = sqrt( X ^2 + Y ^2 - a ^2);
elseif I ==2;
    r = - sqrt( X ^2 + Y ^2 - a ^2);
end

V = - (a * X - r * Y) / ( a ^ 2 + r ^ 2);
U =  (a * Y + r * X) / ( a ^ 2 + r ^ 2);

PHI = atan2(V, U);

%%%%%%%%%%%%%% Inverse kinematics (Velocity) %%%%%%%%%%%%%% 

PHI_d = - (X_d * sin (PHI) - Y_d * cos(PHI)) / r;
r_d = (X_d * (r * cos(PHI) - a * sin(PHI)) + Y_d * (a * cos(PHI) + r * sin(PHI))) / r;

%%%%%%%%%%%% Inverse kinematics (Acceleration) %%%%%%%%%%%%%

G = [ -a * cos(PHI) - r * sin(PHI)    cos(PHI)  ,
      -a * sin(PHI) + r * cos(PHI)    sin(PHI)  ];
   
H = [ X_dd - (a * sin(PHI) * PHI_d ^2 - r * PHI_d ^2 * cos(PHI) - r_d * sin(PHI) * PHI_d - PHI_d * sin(PHI) * r_d) ,
      Y_dd - (-a * cos(PHI) * PHI_d ^2 - r * PHI_d ^2 * sin(PHI) + r_d * cos(PHI) * PHI_d + PHI_d * cos(PHI) * r_d) ] ;
  
I = G \ H;

PHI_dd = I(1,1);
r_dd = I(2,1);

PHI = PHI / pi *180;

