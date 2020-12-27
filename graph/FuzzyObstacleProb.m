function costToCome = FuzzyObstacleProb(startNode,frontierNode,obstacles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    d = frontierNode.depth;
    costToCome = 0;
    node = frontierNode;
    for i=1:d-1
        for j=1:length(obstacles)
            switch(obstacles{j}.distr)
                case 'norm'
                    mu = obstacles{j}.mu;
                    Sigma = obstacles{j}.Sigma;
                    k = length(mu);
                    x = node.state(1:k);
                    if size(x,2)~=1
                        x = x';
                    end
                    
                    if isfield(obstacles{j},'conf')
                        P_obse = obstacles{j}.conf*exp((-1/2)*((x - mu)')*(Sigma\(x - mu))); %specified confidence at mean
                    else
                        P_obs = ((2*pi)^(-k/2))*(det(Sigma)^(-1/2))*exp((-1/2)*((x - mu)')*(Sigma\(x - mu))); %Regular normal distribution
                    end
                    costToCome = costToCome + (1/(1-P_obs)-1);
                otherwise
                    error('Distribution "%s" has not yet been accounted for in "FuzzyObstaclesCostToCome" function.\n');
            end
        end
        node = node.parent;
    end

    if ~isequal(node,startNode)
        error('"endNode" is not a descendent of "startNode"\n');
    end
    
end

