function [Xa,Ya,Xa_d,Ya_d,Xa_dd,Ya_dd] = Forward_RR(c,b, Xq, Yq, PHI, PSI,PHI_d, PSI_d, PHI_dd, PSI_dd)

PHI = PHI /180 * pi;
PSI = PSI /180 * pi;

%%%%%%%%%%%%%%%%    Forward RR Displacement Ananlysis   %%%%%%%%%%%%%%%%%

X = c *cos(PHI) + b *cos(PSI);
Y = c *sin(PHI) + b *sin(PSI);
Xa = X + Xq;
Ya = Y + Yq;

%%%%%%%%%%%%%%%%      Forward RR Velocity Ananlysis     %%%%%%%%%%%%%%%%%

X_d = -c * PHI_d * sin(PHI) - b * PSI_d * sin(PSI);
Y_d = c * PHI_d * cos(PHI) + b * PSI_d * cos(PSI);
Xa_d = X_d;
Ya_d = Y_d;

%%%%%%%%%%%%%%%%    Forward RR Acceleration Ananlysis   %%%%%%%%%%%%%%%%%

X_dd = -c * PHI_dd * sin(PHI) - b * PSI_dd * sin(PSI) - c * cos(PHI)*PHI_d^2 - b * cos(PSI)* PSI_d^2;
Y_dd = c * PHI_dd * cos(PHI) + b * PSI_dd * cos(PSI) - c * sin(PHI)* PHI_d^2 - b * sin(PSI) * PSI_d^2;
Xa_dd = X_dd;
Ya_dd = Y_dd;

PHI = PHI / pi * 180;
PSI = PSI / pi * 180;



