function Jout = gpopsIpoptJacRPMD(Zin, probinfo)

% jacobian nonzeros
jacnz = gpopsJacnzRPMD(Zin, probinfo);

% non linear jacobian sparse matrix
Jacnl = sparse(probinfo.jacnlpat(:,1), probinfo.jacnlpat(:,2), jacnz, probinfo.nlpnumcon, probinfo.nlpnumvar);
Jout = Jacnl + probinfo.jaclin;