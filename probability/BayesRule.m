function P_AcondB = BayesRule(A,B)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    
    if isempty(A.P)
        error('Probability of {%s} not defined.\n',A.d);
    elseif isempty(B.P)
        error('Probability of {%s} not defined.\n',B.d);
    elseif B.P==0
        error('Probability of {%s} is 0.\n',B.d);
    end
    
    try
        P_BcondA = B.P_cond(A.d);
    catch
        error('Probability of {%s|%s} is not defined.\n',B.d,A.d)
    end
    
    P_AcondB = A.P*P_BcondA/B.P;

end

