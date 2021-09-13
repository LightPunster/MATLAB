function x_star = ConjugateGradientMinimize(obj,x0,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    switch(nargin)
        case 2
            cnstr = @(x) 0;
            k_max = inf;
            epsilon = 1e-6;
        case 3
            cnstr = varargin{1};
            k_max = inf;
            epsilon = 1e-6;
        case 4
            cnstr = varargin{1};
            k_max = varargin{2};
            epsilon = 1e-6;
        case 5
            cnstr = varargin{1};
            k_max = varargin{2};
            epsilon = varargin{3};
        otherwise
            error("Invalid number of input arguments");
    end
    
    Lagrangian = @(x) obj(x) + (~(cnstr(x)<=0))'*cnstr(x);
    xk = x0;
    k = 1;
    while(k<k_max)
        %Calculate gradient
        gradf = Jacobian(Lagrangian,xk);
        if norm(gradf)<epsilon
            break;
        end
        
        %Calculate step using Fletcher-Reeves method
        if(k==1)
            pk = -gradf';
            alphak = 0.1;
        else
            Beta = (norm(gradf)^2)/(norm(gradf_1))^2;
            pk = -gradf' + Beta*pk_1;
            alphak = alphak_1*(gradf_1*pk_1)/(gradf*pk);
        end
        if (gradf*pk>=0)
            pk = -gradf';
        end
        
        %Take step and increment k
        gradf
        alphak
        pk
        xk = xk + alphak*pk
        pk_1 = pk;
        gradf_1 = gradf;
        alphak_1 = alphak;
        k = k+1;
        pause;
    end
    
    x_star = xk;

end

