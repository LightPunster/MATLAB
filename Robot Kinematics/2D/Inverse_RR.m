
function [PHI, PSI, PHI_d, PSI_d, PHI_dd, PSI_dd] = Inverse_RR(c,b, Xq, Yq, Xa,Ya,Xa_d,Ya_d,Xa_dd,Ya_dd,I)

%%%%%%%%%%%%%% Inverse kinematics (Position) %%%%%%%%%%%%%% 

X = Xa - Xq;
Y = Ya - Yq;

A = X^2 + Y^2 + c^2 - b^2 +2 * c* X;
B = -2 * c * Y;
C = X^2 + Y^2 + c^2 - b^2 - 2* c * X;

t1 = (-B + sqrt(B^2-A*C))/A;
t2 = (-B - sqrt(B^2-A*C))/A;

if I == 1
    t = t1;
else
    t = t2;
end    

PHI = 2*atan(t);

U = (X- c*cos(PHI))/b;
V = (Y- c*sin(PHI))/b;

PSI = atan2(V, U);

Xb = c*cos(PHI);
Yb = c*sin(PHI);
    
%%%%%%%%%%%%%% Inverse kinematics (Velocity) %%%%%%%%%%%%%% 

X_d = Xa_d;
Y_d = Ya_d;

D = [ -c * sin(PHI)  -b * sin(PSI),
       c * cos(PHI)   b * cos(PSI)  ];
   
E = [ X_d,
      Y_d  ];
  
F = D \ E ;

PHI_d = F(1,1);
PSI_d = F(2,1);

%%%%%%%%%%%%%% Inverse kinematics (Acceleration) %%%%%%%%%%%%%%

X_dd = Xa_dd;
Y_dd = Ya_dd;

G = [ -c * sin(PHI)  -b * sin(PSI),
       c * cos(PHI)   b * cos(PSI)  ];
   
H = [ X_dd + c * cos(PHI) * PHI_d ^2 + b * cos(PSI) * PSI_d ^2  ,
      Y_dd + c * sin(PHI) * PHI_d ^2 + b * sin(PSI) * PSI_d ^2  ] ;
  
I = G \ H;

PHI_dd = I(1,1);
PSI_dd = I(2,1);

PHI = PHI / pi * 180;
PSI = PSI / pi * 180;
