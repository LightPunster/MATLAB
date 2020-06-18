function [solu,status,free,RREF] = linEqnSol(A,b)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
m = size(A,2);

%Calculate reduced row echelon form and find pivots
[RREF,pivots] = rref([A b]);

if (RREF(end,end)==1) && ~any(RREF(end,1:end-1)) %Condition for no solution
    solu = NaN;
    status = 'No solution';
    free = NaN;
else
    if length(pivots)==m %Condition for unique solution
        status = 'Unique solution';
    else
        status = 'Infinite solutions';
    end

    rank = length(pivots);

    %Find free variables
    vars = 1:m;
    free = setdiff(vars,pivots);

    %Calculate homogeneous solution components
    homog_solu = zeros(m,1);
    for i=1:length(pivots)
        homog_solu(pivots(i)) = RREF(i,end);
    end
    solu = homog_solu;

    %Calculate nonhomogeneous solution components
    for i=1:length(free)
        coeff = zeros(m,1);
        for j=1:rank
            coeff(pivots(j)) = -RREF(j,free(i));
        end
        coeff(free(i)) = 1;
        solu = [solu coeff];
    end
end

end

