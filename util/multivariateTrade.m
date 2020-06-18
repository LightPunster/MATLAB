function parameters = multivariateTrade(parameters,residual,output,varargin)
%"multivariateTrade.m" plots relationship between up to three
%mathematically related paramters
%   parameters = structure containing any number of scalars and at most 2
%                vectors (these will be treated as the inputs)
%   residual = handle for a function with inputs x (generic), p (a struct
%              of the same type as "parameters"), and o (a string).
%              The first line of the function should set p.(o) = x;
%   output = number (scalar) or name (string) of output parameter
%   
%   The return 'parameters' is a copy of the input structure, but with the
%   given value for parameters.(output) replaced with the solutions of the
%   relation.
%
%   Optional Parameters
%       x0 = initial guess for output
%       verb = boolean, specifies whether to print additional info during
%              funtion run
%       
%   Example Usage:
%   This code plots Z as a function of X and Y for fixed W given the known
%   relationship: X - W*Z*sin(1 - 2*Y*Z^2) = 0.
%
%         param.W = 1;
%         param.X = linspace(-0.3,0.3);
%         param.Y = linspace(-0.3,0.3);
%         param.Z = 0; % As the output, Z's set value isn't used
% 
%         multivariateTrade(param, @Residual, 'Z')
% 
%         function res = Residual(x,p,o)
%             p.(o) = x;
%             res = p.X - p.W*p.Z*sin(1 - 2*p.Y*p.Z^2);
%         end
%
%   Author: Nathan Daniel
%   Date: 06/15/2020
    
    switch nargin
        case 3
            x0 = 0;
            verb = 0;
        case 4
            x0 = varargin{1};
            verb = 0;
        case 5
            x0 = varargin{1};
            verb = varargin{2};
        otherwise
    end

    fN = fieldnames(parameters);
    if isnumeric(output), output = fN{output}; end
    input = {'0','0'};
    
    %% Identify which parameters are varied as inputs
    for i=1:length(fN)
        if ~strcmp(fN{i},output)
            if (length(parameters.(fN{i}))>1) && strcmp(input{1},'0') %Set first variable
                input{1} = fN{i};
            elseif (length(parameters.(fN{i}))>1) && strcmp(input{2},'0') %Set 2nd variable
                input{2} = fN{i};
                %If there are two variables, create meshgrid
                [parameters.(input{1}),parameters.(input{2})] = meshgrid(parameters.(input{1}),parameters.(input{2}));
            end
        end
    end
    %Set specified output to 0-array of the same size as the inputs
    if ~strcmp(input{1},'0')
        parameters.(output) = zeros(size(parameters.(input{1})));
    else
        parameters.(output)=0;
    end

    %Use Newton's method at each point to allow for relations with no explicit solution.
    for i=1:numel(parameters.(output))
        
        %Build parameter structure at each point
        for j=1:length(fN)
            if ~strcmp(fN{j},output) %If the parameter is NOT the output
                if length(parameters.(fN{j}))>1 %If the parameter is variable...
                    parameters_i.(fN{j}) = parameters.(fN{j})(i); % set to the particular value at i
                else %Otherwise, just copy the constant value
                    parameters_i.(fN{j}) = parameters.(fN{j});
                end
            end
        end
        
        %Newton's method call
        [parameters.(output)(i),n_iter,~] = newton(@(x) residual(x,parameters_i,output),x0);
        if verb
            fprintf('Percent Complete: %.2f\n',100*i/numel(parameters.(output)))
            fprintf('\tSolved relation in %d iterations.\n',n_iter)
        end
    end

    %% Plotting
    if ~(strcmp(input{1},'0')) && (strcmp(input{2},'0'))
        plot(parameters.(input{1}),parameters.(output))
        xlabel(input{1}),ylabel(output)
        Title = [output ' vs ' input{1}];
        title(Title)
        grid on
    elseif ~(strcmp(input{2},'0'))
        surf(parameters.(input{1}),parameters.(input{2}),parameters.(output))
        xlabel(input{1}),ylabel(input{2}),zlabel(output)
        Title = [output ' vs ' input{1} ', ' input{2}];
        title(Title)
        grid on
    else
        fprintf('Output (%s): %f\n',output,parameters.(output))
    end

end


