function [Fout, Jout] = gpopsSnoptFunJacScaledRPMI(Zin)

global GLOBALPROBINFO

% unscale variables
Zunscaled = (Zin - GLOBALPROBINFO.Zshift)./GLOBALPROBINFO.Zscale;

% evaluate function and derivative
F = full(gpopsObjConRPMI(Zunscaled, GLOBALPROBINFO) + GLOBALPROBINFO.grdjaclinMat*Zunscaled);
grdjacnz = gpopsGrdJacnzRPMI(Zunscaled, GLOBALPROBINFO);

% scale constraint
Fout = GLOBALPROBINFO.Fscale.*F;

% scale Jacobian
Jout = zeros(GLOBALPROBINFO.snJacnonlinnnz,1);
Jout(GLOBALPROBINFO.grdjacnzasgindex) = grdjacnz.*GLOBALPROBINFO.Jacscale;
Jout = Jout + GLOBALPROBINFO.grdjaclinVectscaled;