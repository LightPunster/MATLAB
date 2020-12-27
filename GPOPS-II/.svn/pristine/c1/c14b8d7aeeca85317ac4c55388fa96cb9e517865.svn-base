function Obj = gpopsObjRPMD(Z, probinfo)

% gpopsObjRPMD
% this function computes the NLP objective

% get OCP variables
endpinput = gpopsEndpInputRPMD(Z, probinfo);

% evaluate OCP endpoint function
endpoutput = feval(probinfo.endpfunction, endpinput);

% objective
Obj = endpoutput.objective;