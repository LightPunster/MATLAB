function explored = ExploredCheck(node,exploredSet)
%EXPLOREDCHECK Summary of this function goes here
%   Detailed explanation goes here

    explored = false;
    for i=1:length(exploredSet)
        explored = explored|isequal(node.state,exploredSet{i}.state);
    end
end

