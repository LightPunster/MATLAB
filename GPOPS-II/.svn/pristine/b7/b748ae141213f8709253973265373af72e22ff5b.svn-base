function Fout = gpopsIpoptConScaledRPMI(Zin, probinfo)

% unscale variables
Zunscaled = (Zin - probinfo.Zshift)./probinfo.Zscale;

% evaluate constraint
Fout = gpopsConRPMI(Zunscaled, probinfo) + probinfo.jaclinMat*Zunscaled;

% scale constraint
Fout = probinfo.Fscale.*Fout;