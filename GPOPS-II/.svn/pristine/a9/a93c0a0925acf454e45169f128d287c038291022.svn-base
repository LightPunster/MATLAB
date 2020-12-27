function Obj = gpopsObjRPMI(Z, probinfo)

% gpopsObjRPMI
% this function computes the NLP objective

% get OCP variables
endpinput = gpopsEndpInputRPMI(Z, probinfo);

% evaluate OCP endpoint function
endpoutput = feval(probinfo.endpfunction, endpinput);

% objective
Obj = endpoutput.objective;