function J = Jacobian(f,x0,varargin)
%Jacobian calculates the jacobian of vector function f at point x0.
%   If f is a scalar function, Jacobian calculates its gradient. The method
%   and step size may be specified using the named arguments 'method'
%   (default to finite-diff-2) and 'step' (default to 1e-12). Other
%   method options include 'finite-diff-1', 'complex-step' (if the function is numeric and
%   can support complex inputs) and 'adjoint' (not yet implimented).
    
    %Default method & step size
    step = 1e-10;
    method = 'complex-step';
    
    %Check for appropriate number of inputs
    if (nargin~=2)&&(nargin~=4)&&(nargin~=6)
        error("Invalid number of inputs; expected 2, 4, or 6")
    end
    
    %Apply input specifications
    for i=1:2:length(varargin)
        switch(varargin{i})
            case {'Step','step'}
                step = varargin{i+1};
            case {'Method','method'}
                method = varargin{i+1};
            otherwise
                error("Invalid input label; expected 'step' or 'method'.");
        end
    end
    
    n = length(x0);
    if size(x0,2)>1
        x0 = x0';
    end
    f0 = f(x0);
    m = length(f0);
    J = zeros(m,n);
    
    switch(method)
        case {'finite-diff-1'}
            %n+1 function evaluations
            %Truncation error & subtractive cancellation decreases accuracy
            %High dependence on step size
            f0 = f(x0);
            for i=1:n
                x_i_p = x0 + step*e(n,i); f_p = f(x_i_p);
                J(:,i) = (f_p - f0)/step;
            end
            J = round(J,floor(-log10(step))); %Round to reflect precision
        case {'finite-diff-2'}
            %2*n function evaluations
            %Truncation error & subtractive cancellation decreases accuracy
            %High dependence on step size
            for i=1:n
                x_i_p = x0 + step*e(n,i); f_p = f(x_i_p);
                x_i_m = x0 - step*e(n,i); f_m = f(x_i_m);
                J(:,i) = (f_p - f_m)/(2*step);
            end
            J = round(J,floor(-log10(step))); %Round to reflect precision
        case {'complex-step'}
            %n function evaluations
            %High accuracy
            %Low dependence on step size
            for i=1:n
                x_i = x0 + step*e(n,i)*1j; f_i = f(x_i);
                J(:,i) = imag(f_i)/step;
            end
        case {'adjoint'}
            %TODO:
            error("Adjoint method not yet implemented in this function.")
        otherwise
            error("Invalid method provided; expected 'finite-difference', 'complex-step', or 'adjoint'.");
    end      
end