
function [Xa, Ya, Xa_d, Ya_d, Xa_dd, Ya_dd] = Forward_PR(c, b, S, PHI, S_d, PHI_d, S_dd, PHI_dd)

%%%%%%%%%%%%%% Inverse kinematics (Position) %%%%%%%%%%%%%% 

PHI = PHI / 180 * pi;

Xa = S + b * cos (PHI);
Ya = c + b * sin (PHI);

Xa_d = S_d - b * sin(PHI) * PHI_d;
Ya_d = b * cos(PHI) * PHI_d;

Xa_dd = S_dd - b * cos(PHI) * PHI_d ^2 - b * sin(PHI) * PHI_dd;
Ya_dd = - b * sin(PHI) * PHI_d ^2 + b * cos(PHI) * PHI_dd;

PHI = PHI / pi * 180;

