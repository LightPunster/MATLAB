function Jacpat = gpopsIpoptJacPatRPMD(probinfo)

% non linear jacobian sparse matrix
Jacnlpat = sparse(probinfo.jacnlpat(:,1), probinfo.jacnlpat(:,2), ones(probinfo.jacnonlinnnz,1), probinfo.nlpnumcon, probinfo.nlpnumvar);
Jacpat = spones(Jacnlpat + spones(probinfo.jaclin));