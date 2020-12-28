function [ E , num, error] = EccentricAnomoly(e,M,varargin)
%EccentricAnomoly estimates eccentric analomoly of an orbit using the
%Newton-Rhapson method and a secant interpolation for the initial guess.
%   Parameters:
%       e = eccentricity
%       M = mean anomoly
%   Optional Parameters:
%       tol = sets the maximum difference between consecutive estimates to
%             obtain convergence (default: 1e-8)

    switch nargin
        case 2
            tol = 1e-8;
        case 3
            tol = varargin{1};
    end
    
    %Per Prussing & Conway, use a "secant interpolation between values
    %at bounds F(M) and F(M+e)" for an initial guess.
    u = M + e;
    E1 = (M*(1 - sin(u)) + u*sin(M))/(1 + sin(M) - sin(u));

%     E0 = E1 + 10*tol; %Ensures accuracy condition not met initially
%     num = 0; %Stores number of iterations
%     %Iterator
%     while abs(E1-E0)>tol
%         E0 = E1;
%         F = E0 - e*sin(E0) - M;
%         dFdE = 1 - e*cos(E0);
%         E1 = E0 - F/dFdE;
%         num = num + 1;
%     end
%     E = E1;
%     error = E1-E0; %Difference in current estimate from previous estimate
    
    [E, num, error] = newton(@(Ei) Residual(Ei,e,M),E1);
end

function r = Residual(E,e,M)
    r = E - e*sin(E) - M;
end
   


