function objective = gpopsIpoptObjScaledRPMD(Zin, probinfo)

% unscale variables
Zunscaled = (Zin - probinfo.Zshift)./probinfo.Zscale;

% evaluate objective
objective = probinfo.objscale*gpopsObjRPMD(Zunscaled, probinfo);