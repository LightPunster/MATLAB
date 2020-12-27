function Fout = gpopsIpoptConRPMI(Zin, probinfo)

% scale constraint with linear part
Fout = gpopsConRPMI(Zin, probinfo) + probinfo.jaclinMat*Zin;