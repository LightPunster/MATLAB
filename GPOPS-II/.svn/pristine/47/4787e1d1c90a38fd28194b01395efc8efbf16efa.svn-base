function Hout = gpopsIpoptHesRPMI(Zin, sig, lam, probinfo)

% get Hessian nonzeros
hesnz = gpopsHesnzRPMI(sig, lam, Zin, probinfo);

% Hessian matrix
Hout = sparse(probinfo.hespat(:,1), probinfo.hespat(:,2), hesnz, probinfo.nlpnumvar, probinfo.nlpnumvar);