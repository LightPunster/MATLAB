function heuristicCostToGo = EuclideanCostToGo(frontierNode,goalState)
    heuristicCostToGo = norm(frontierNode.state - goalState);
end