function Jacpat = gpopsIpoptJacPatRPMI(probinfo)

% non linear jacobian sparse matrix
Jacpat = sparse(probinfo.jacnonlinpat(:,1), probinfo.jacnonlinpat(:,2), ones(probinfo.jacnonlinnnz,1), probinfo.nlpnumcon, probinfo.nlpnumvar);
Jacpat = spones(Jacpat + spones(probinfo.jaclinMat));