function Grdout = gpopsIpoptGrdRPMI(Zin, probinfo)

% get gradient nonzeros
grdnz = gpopsGrdnzRPMI(Zin, probinfo);

% full gradient
Grdout = zeros(1,probinfo.nlpnumvar);
Grdout(probinfo.grdpat) = grdnz;