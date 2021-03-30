function [x_eq,A_lin,lambda_lin,stab_lin] = EquilibriumPoints(f,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    options = optimset('Display','off');

    switch nargin
        case 1 %No input guidance, use origin as initial guess
            %Determine input dimensions
            i = 1;
            x0 = 0;
            try
                fx0 = f(x0);
            catch
                fx0 = zeros(i,2);
            end
            while ~isequal(size(x0),size(fx0))
                if i>100
                    error('Dimension of system is greater than 100 or cannot be determined.');
                end
                i=i+1;
                x0 = zeros(i,1);
                try
                    fx0 = f(x0);
                catch
                    fx0 = zeros(i,2);
                end
            end
            [x_eq,fval] = fsolve(f,x0,options);
            if norm(fval)>optimset('fsolve').TolFun
                x_eq = [];
            end
        case 2 %Discrete initial guesses provided
            x0 = varargin{1};
            m_doe = size(x0,2);
            x_eq = [];
            for j=1:m_doe
                [x_eq_j,fval] = fsolve(f, x0(:,j),options);
                if norm(fval)<optimset('fsolve').TolFun
                    %Determine if new equilibrium
                    new = true;
                    for k=1:size(x_eq,2)
                        if norm(x_eq_j-x_eq(:,k)) < 2*optimset('fsolve').TolFun
                            new = false;
                        end
                    end
                    if new
                        x_eq(:,end+1) = x_eq_j;
                    end
                end
            end
        case 4 %Initial guess grid provided
            x_min = varargin{1};
            x_max = varargin{2};
            x_grid = varargin{3};
            
            %Generate points to look for equilibria with a DoE
            m_doe = prod(x_grid);
            x_min_rep = repmat(x_min,[1,m_doe]);
            x_max_rep = repmat(x_max,[1,m_doe]);
            x_grid_rep = (repmat(x_grid,[1,m_doe])-1);
            x0 =  x_min_rep + ((x_max_rep-x_min_rep)./x_grid_rep).*(fullfact(x_grid)-1)';
            %Search for equilibria starting at each DoE, and only add to list if
            %it's new
            x_eq = [];
            for j=1:m_doe
                [x_eq_j,fval] = fsolve(f, x0(:,j),options);
                if norm(fval)<optimset('fsolve').TolFun
                    %Determine if new equilibrium
                    new = true;
                    for k=1:size(x_eq,2)
                        if norm(x_eq_j-x_eq(:,k)) < 2*optimset('fsolve').TolFun
                            new = false;
                        end
                    end

                    if new
                        x_eq(:,end+1) = x_eq_j;
                    end
                end
            end
        otherwise
            error('Invalid number of inputs. Expected\n\tEquilibriumPoints(f)\n\tEquilibriumPoints(f,x0)\n\tEquilibriumPoints(f,x_min,x_max,x_grid)');
    end
    
    %Linearize at each DoE & calculate stability
    [n,m] = size(x_eq);
    A_lin = zeros(n,n,m);
    lambda_lin = zeros(n,m);
    stab_lin = {};
    if n>0 %If any equilibria were found
        for j=1:m
            A_lin(:,:,j) = Jacobian(f,x_eq(:,j));
            lambda_lin(:,j) = eig(A_lin(:,:,j));
        end
        stab_lin = stable(lambda_lin);
    end
end


