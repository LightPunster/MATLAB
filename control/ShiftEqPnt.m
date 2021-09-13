function x_dot2 = ShiftEqPnt(x_dot,x_eq,varargin)
%ShiftEqPnt shifts the equilibrium point of a dynamic system
%   Parameters:
%       - x_dot = a vector containing the symbolic equations for the state
%                 derivatives OR a function handle for the calculating the
%                 state derivative
%       - x_eq = the known equilibrium point
%   Optional Parameters:
%       - x2 = the point in the shifted coordinate frame that will be used
%              to calculate the state derivative if a function handle is
%              passed (only if x_dot is a function handle. If symbolic,
%              x_eq2 is the third varargin)
%       - x_eq2 = the new equilibrium point. 0 by default.
%       - u = the input to use to calculate the state derivative (only if
%             x_dot is a function handle)
    
    if isa(x_dot,'function_handle')
        switch(nargin)
            case 3
                x2 = varargin{1};
                x_dot2 = x_dot(x2 + x_eq);
            case 4
                x2 = varargin{1};
                x_eq2 = varargin{2};
                x_dot2 = x_dot(x2 + (x_eq - x_eq2));
            case 5
                x2 = varargin{1};
                x_eq2 = varargin{2};
                u = varargin{3};
                x_dot2 = x_dot(x2 + (x_eq - x_eq2),u);
            otherwise
                error("Incorrect number of input arguments");
        end
    else
        x = [];
        for i=1:length(x_dot)
            exp = ['syms x' num2str(i) '; x=[x;x' num2str(i) '];'];
            eval(exp);
        end
        if any(has(x_dot,x))
            switch(nargin)
                case 2
                    x_eq2 = zeros(size(x_dot));
                case 3
                    x_eq2 = varargin{1};
                otherwise
                    error("Incorrect number of input arguments");
            end
            for i=1:length(x_dot)
                exp = ['x' num2str(i) '=x' num2str(i) '+(x_eq(' num2str(i) ')-x_eq2(' num2str(i) '));'];
                eval(exp);
            end
            x_dot2 = simplify(eval(x_dot));
        else
            error("Input 'x_dot' must be a function handle of x or (x,u) or a \n symbolic expression depending on x.");
        end
    end
end

