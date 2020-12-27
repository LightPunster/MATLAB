function [Fout, Jout] = gpopsSnoptFunJacScaledRPMD(Zin)

global GLOBALPROBINFO

% unscale variables
Zunscaled = (Zin - GLOBALPROBINFO.Zshift)./GLOBALPROBINFO.Zscale;

% evaluate function and derivative
F = gpopsObjConRPMD(Zunscaled, GLOBALPROBINFO);
grdjacnz = gpopsGrdJacnzRPMD(Zunscaled, GLOBALPROBINFO);

% scale constraint
%Fout = GLOBALPROBINFO.Fscale.*F + GLOBALPROBINFO.JaclinMat*Zin + GLOBALPROBINFO.Fshift;
Fout = GLOBALPROBINFO.Fscale.*F + GLOBALPROBINFO.JaclinMat*Zin;

% scale Jacobian
Jout = zeros(GLOBALPROBINFO.snJacnonlinnnz,1);
Jout(GLOBALPROBINFO.Jacnzasg) = grdjacnz.*GLOBALPROBINFO.Jacscale;
Jout = Jout + GLOBALPROBINFO.JaclinC;