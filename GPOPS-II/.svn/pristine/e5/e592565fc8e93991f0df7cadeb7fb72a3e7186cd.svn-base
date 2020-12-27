function Grdout = gpopsIpoptGrdScaledRPMI(Zin, probinfo)

% unscale variables
Zunscaled = (Zin - probinfo.Zshift)./probinfo.Zscale;

% full gradient
Grdout = zeros(1,probinfo.nlpnumvar);
Grdout(probinfo.grdpat) = probinfo.grdscale.*gpopsGrdnzRPMI(Zunscaled, probinfo);