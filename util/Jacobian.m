function J = Jacobian(f,x0,varargin)
    %calculates the jacobian of function f at point x
    
    switch(nargin)
        case 2
            p = 1e-12;
        case 3
            p = varargin{1};
        otherwise
            error('Invalid number of input parameters.');
    end
    
    n = length(x0);
    f0 = f(x0);
    m = length(f0);
    J = zeros(m,n);
    
    for i=1:n
        x_i_pp = x0 + p*e(n,i);
        f_pp = f(x_i_pp);
        x_i_mp = x0 - p*e(n,i);
        f_mp = f(x_i_mp);
        J(:,i) = (f_pp - f_mp)/(2*p);
    end
    
    J = round(J,floor(-log10(p))); %Round to reflect precision
            
end