
function [S, PHI, S_d, PHI_d, S_dd, PHI_dd] = Inverse_PR(c, b, Xa, Ya, Xa_d, Ya_d, Xa_dd, Ya_dd, I);

%%%%%%%%%%%%%% Inverse kinematics (Position) %%%%%%%%%%%%%% 

PHI_1 = asin((Ya-c)/b);
PHI_2 = pi - asin((Ya-c)/b);

if I == 1;
    PHI = PHI_1;
elseif I == 2
    PHI = PHI_2; 
end

S = Xa - b * cos(PHI);

%%%%%%%%%%%%%% Inverse kinematics (Velocity) %%%%%%%%%%%%%% 

PHI_d = Ya_d / ( b * cos(PHI) );

S_d = Xa_d + b * PHI_d * sin(PHI);

%%%%%%%%%%%% Inverse kinematics (Acceleration) %%%%%%%%%%%% 

PHI_dd = (b * PHI_d ^2 * sin(PHI) + Ya_dd) / ( b * cos(PHI) );

S_dd = Xa_dd + b * PHI_dd * sin(PHI) + b * PHI_d ^ 2 * cos(PHI);

PHI = PHI / pi * 180;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
