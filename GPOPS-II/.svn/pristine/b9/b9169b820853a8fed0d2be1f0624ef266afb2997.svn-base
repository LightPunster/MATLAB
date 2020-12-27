function [grdpat, probinfo] = gpopsGrdPatRPMI(probinfo)

% gpopsGrdPatRPMI
% this function finds the sparsity pattern of the Gradient

% NLP variable order
% [states*(nodes+1); controls*nodes; t0; tf, Q] for each phase
% [stack all phases(1;...;numphase); parameters]

% number of nonlinear nonzeros in gradient
grdnnz = probinfo.derivativemap.objnnz1;

% preallocate gradient sparsity, all row values are 1
grdpat = ones(grdnnz,2);

% gradient nonzero locations
grdpat(:,2) = probinfo.nlpendpvarmap(probinfo.derivativemap.objvarmap1)';

% add to probinfo
probinfo.grdnnz = grdnnz;