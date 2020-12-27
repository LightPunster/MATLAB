function P_AintersectB = Intersect(A,B,varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin==3
        P_AUB = varargin{1};
        P_AintersectB = A.P + B.P - P_AUB;
    else
        try
            P_AcondB = A.P_cond(B.d);
            P_AintersectB = P_AcondB*B.P;
        catch
            try
                P_BcondA = B.P_cond(A.d);
                P_AintersectB = P_BcondA*A.P;
            catch
                error('Not enough info to calculate probability of the intersection of (%s (event A),%s (event B)); need either\n\t- P(A U B) (3rd arg)\n\t- Event A added as a condition for event B\n\t- Event B added as a condition for event A',...
                      A.d,B.d);
            end
        end
    end
    
end

