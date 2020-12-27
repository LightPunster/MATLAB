function Grdout = gpopsIpoptGrdRPMD(Zin, probinfo)

% get gradient nonzeros
grdnz = gpopsGrdnzRPMD(Zin, probinfo);

% full gradient
Grdout = zeros(1,probinfo.nlpnumvar);
Grdout(probinfo.grdpat) = grdnz;