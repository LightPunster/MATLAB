function heuristicCostToGo = EuclideanCostToGo(frontierNode,goalState,varargin)
    if nargin==3
        weights = varargin{1};
    else
        weights = ones(size(goalState));
    end
    heuristicCostToGo = norm((frontierNode.state - goalState).*weights);
end