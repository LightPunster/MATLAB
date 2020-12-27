function Jout = gpopsIpoptJacScaledRPMI(Zin, probinfo)

% unscale variables
Zunscaled = (Zin - probinfo.Zshift)./probinfo.Zscale;

% Jacobian nonzeros
jacnz = probinfo.jacscale.*gpopsJacnzRPMI(Zunscaled, probinfo);

% non linear Jacobian sparse matrix
Jout = sparse(probinfo.jacnonlinpat(:,1), probinfo.jacnonlinpat(:,2), jacnz, probinfo.nlpnumcon, probinfo.nlpnumvar);

% complete Jacobian
Jout = Jout + probinfo.jaclinMatscaled;