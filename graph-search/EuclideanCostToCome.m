function costToCome = EuclideanCostToCome(startNode,frontierNode)
    d = frontierNode.depth;
    costToCome = 0;
    node = frontierNode;
    for i=1:d-1
        costToCome = costToCome + norm(node.state - node.parent.state);
        node = node.parent;
    end
    if ~isequal(node,startNode)
        error('Path does not contain start node\n');
    end
end