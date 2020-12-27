function [Fout, Jout] = gpopsSnoptFunJacRPMD(Zin)

global GLOBALPROBINFO

% evaluate function and derivative
F = gpopsObjConRPMD(Zin, GLOBALPROBINFO);
grdjacnz = gpopsGrdJacnzRPMD(Zin, GLOBALPROBINFO);

% constraint
Fout = F + GLOBALPROBINFO.JaclinMat*Zin;

% Jacobian
Jout = zeros(GLOBALPROBINFO.snJacnonlinnnz,1);
Jout(GLOBALPROBINFO.Jacnzasg) = grdjacnz;
Jout = Jout + GLOBALPROBINFO.JaclinC;