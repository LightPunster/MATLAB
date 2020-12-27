function Fout = gpopsIpoptConScaledRPMD(Zin, probinfo)

% unscale variables
Zin = Zin - probinfo.Zshift;
Zunscaled = Zin./probinfo.Zscale;

% evaluate non linear constraint
F = gpopsConRPMD(Zunscaled, probinfo);

% scale constraint with linear part
%Fout = probinfo.Fscale.*F + probinfo.jaclin*Zin;
Fout = probinfo.Fscale.*(F + probinfo.jaclinNS*Zunscaled);