function probinfo = gpopsIpoptGrdJacSparsityRPMD(probinfo)

% gradient sparsity
[grdpat, probinfo] = gpopsGrdPatRPMD(probinfo);
probinfo.grdpat = grdpat(:,2);

% Jacobian sparsity pattern for IPOPT
[jacnlpat, probinfo] = gpopsJacNonlinPatRPMD(probinfo);
probinfo.jacnlpat = jacnlpat;
[jaclindiag, jaclinoffdiag] = gpopsJacLinearRPMD(probinfo);

% Get JaclinMat
jaclindiagMat = sparse(jaclindiag(:,1), jaclindiag(:,2), jaclindiag(:,3), probinfo.nlpnumcon, probinfo.nlpnumvar);
jaclinoffMat = sparse(jaclinoffdiag(:,1), jaclinoffdiag(:,2), jaclinoffdiag(:,3), probinfo.nlpnumcon, probinfo.nlpnumvar);

% Jacobian linear part
probinfo.jaclin = jaclindiagMat + jaclinoffMat;