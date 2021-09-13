
function [Xa,Ya,Xa_d,Ya_d,Xa_dd,Ya_dd] = Forward_RP(a, Xq, Yq, r, PHI, r_d, PHI_d, r_dd, PHI_dd)

PHI = PHI / 180 * pi;

%%%%%%%%%%%%%% Forward kinematics (Position) %%%%%%%%%%%%%% 

X = - a * sin(PHI) + r *cos(PHI);
Y = r * sin(PHI) + a *cos(PHI);

Xa = Xq + X;
Ya = Yq + Y;

%%%%%%%%%%%%%% Forward kinematics (Velocity) %%%%%%%%%%%%%% 

X_d = (-a * cos(PHI) - r * sin(PHI)) * PHI_d + cos(PHI) * r_d ;
Y_d = (r * cos (PHI) - a * sin(PHI)) * PHI_d + sin(PHI) * r_d ;

Xa_d = X_d;
Ya_d = Y_d;

%%%%%%%%%%%% Forward kinematics (Acceleration) %%%%%%%%%%%%%

X_dd = (-a * cos(PHI) - r * sin(PHI)) * PHI_dd + cos(PHI) * r_dd + (a * PHI_d * sin(PHI) - r * PHI_d * cos(PHI) - r_d * sin(PHI)) * PHI_d + (-PHI_d * sin(PHI)) * r_d;
Y_dd = (r * cos(PHI) - a * sin(PHI)) * PHI_dd + sin(PHI) * r_dd + (- a * PHI_d * cos(PHI) - r * PHI_d * sin(PHI) + r_d * cos(PHI)) * PHI_d + (PHI_d * cos(PHI)) * r_d;

Xa_dd = X_dd;
Ya_dd = Y_dd;