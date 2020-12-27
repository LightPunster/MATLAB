function objective = gpopsIpoptObjScaledRPMI(Zin, probinfo)

% unscale variables
Zunscaled = (Zin - probinfo.Zshift)./probinfo.Zscale;

% evaluate objective
objective = probinfo.objscale*gpopsObjRPMI(Zunscaled, probinfo);