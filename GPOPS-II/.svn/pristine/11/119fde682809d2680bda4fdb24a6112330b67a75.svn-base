function Hespat = gpopsIpoptHesPatRPMD(probinfo)

% non linear jacobian sparse matrix
Hespat = sparse(probinfo.hespat(:,1), probinfo.hespat(:,2), ones(probinfo.hesnnz,1), probinfo.nlpnumvar, probinfo.nlpnumvar);
Hespat = spones(Hespat);