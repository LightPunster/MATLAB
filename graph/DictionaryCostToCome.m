function costToCome = DictionaryCostToCome(startNode,frontierNode,edgeCosts)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    d = frontierNode.depth;
    costToCome = 0;
    node = frontierNode;
    for i=1:d-1
        costToCome = costToCome + edgeCosts([node.parent.name '->' node.name]);
        node = node.parent;
    end
    if ~isequal(node,startNode)
        error('Path does not contain start node\n');
    end

end

