function [Fout, Jout] = gpopsSnoptFunJacRPMI(Zin)

global GLOBALPROBINFO

% evaluate function and derivative
Fout = full(gpopsObjConRPMI(Zin, GLOBALPROBINFO) + GLOBALPROBINFO.grdjaclinMat*Zin);
grdjacnz = gpopsGrdJacnzRPMI(Zin, GLOBALPROBINFO);

% Jacobian
Jout = zeros(GLOBALPROBINFO.snJacnonlinnnz,1);
Jout(GLOBALPROBINFO.grdjacnzasgindex) = grdjacnz;
Jout = Jout + GLOBALPROBINFO.grdjaclinVect;