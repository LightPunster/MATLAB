function Hout = gpopsIpoptHesScaledRPMD(Zin, sig, lam, probinfo)

% unscale variables
Zunscaled = (Zin - probinfo.Zshift)./probinfo.Zscale;

% scale multipliers
sig = probinfo.objscale*sig;
lam = probinfo.Fscale.*lam;

% get Hessian nonzeros
hesnz = probinfo.hesscale.*gpopsHesnzRPMD(sig, lam, Zunscaled, probinfo);

% Hessian matrix
Hout = sparse(probinfo.hespat(:,1), probinfo.hespat(:,2), hesnz, probinfo.nlpnumvar, probinfo.nlpnumvar);