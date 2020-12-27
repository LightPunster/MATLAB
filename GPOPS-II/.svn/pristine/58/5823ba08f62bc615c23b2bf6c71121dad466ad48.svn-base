function Fout = gpopsIpoptConRPMD(Zin, probinfo)

% evaluate non linear constraint
F = gpopsConRPMD(Zin, probinfo);

% scale constraint with linear part
Fout = F + probinfo.jaclin*Zin;