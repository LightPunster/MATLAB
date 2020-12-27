function probinfo = gpopsIpoptGrdJacSparsityRPMI(probinfo)

% gradient sparsity
[grdpat, probinfo] = gpopsGrdPatRPMI(probinfo);
probinfo.grdpat = grdpat(:,2);

% Jacobian sparsity pattern for IPOPT
[jacnonlinpat, probinfo] = gpopsJacPatRPMI(probinfo);
probinfo.jacnonlinpat = jacnonlinpat;