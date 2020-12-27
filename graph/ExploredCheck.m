function explored = ExploredCheck(node,exploredSet)
%EXPLOREDCHECK Summary of this function goes here
%   Detailed explanation goes here

    explored = false;
    for i=1:length(exploredSet)
        %explored = explored|isequal2(node.state,exploredSet{i}.state);
        explored = explored | strcmp(node.name,exploredSet{i}.name);
    end
end

