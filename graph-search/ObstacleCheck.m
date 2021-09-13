function isObstacle = ObstacleCheck(node,problem,varargin)
%OBSTACLECHECK Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin==3
        verbose = varargin{1};
    else
        verbose = false;
    end

    isObstacle = false;
    
    if isfield(problem,'obstacles')
        for j=1:length(problem.obstacles)
            if isequal(node.state,problem.obstacles{j})
                isObstacle = true;
            end
        end
        
        if verbose
            if ~isObstacle
                fprintf('%s is NOT an obstacle\n',node.name);
            else
                fprintf('%s is an obstacle\n',node.name);
            end
        end
    end
end

