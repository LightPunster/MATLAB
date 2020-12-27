function Jout = gpopsIpoptJacRPMI(Zin, probinfo)

% Jacobian nonzeros
jacnz = gpopsJacnzRPMI(Zin, probinfo);

% Jacobian sparse matrix
Jout = sparse(probinfo.jacnonlinpat(:,1), probinfo.jacnonlinpat(:,2), jacnz, probinfo.nlpnumcon, probinfo.nlpnumvar);

% complete Jacobian
Jout = Jout + probinfo.jaclinMat;