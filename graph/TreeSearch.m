%TODO: Plenty of optimization of speed work to do here

function [solutionPath,nodeNames,nodeStates,nodesExplored,exploredSet,minimumCost] = TreeSearch(problem,strategy,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%TODO: Make verbose an optional input
%TODO: Make more generic graph search, & allow 'Tree' to be a generic input
%(i.e. enabling the Explored check)

verbose = false;

%initialize the search tree using the initial state of the problem
frontierSet = {};
exploredSet = {problem.startNode};

frontierCandidates = exploredSet{end}.expand(problem.expansionRule); %Expand node
for i=1:length(frontierCandidates)
    %Add new child to frontier set if node state is not an obstacle
    if ~ObstacleCheck(frontierCandidates{i},problem,verbose) && ~ExploredCheck(frontierCandidates{i},exploredSet)
        frontierSet{end+1} = frontierCandidates{i};
    end
end

%Frontier set info
if verbose
    fprintf('FrontierSet:');
    for i=1:length(frontierSet)
        if i>1, fprintf(','), end
        fprintf('%s',frontierSet{i}.name);
    end
    fprintf('\n')
end

%check if start node contains goal state
if isequal(problem.startNode.state,problem.goalState)
    solutionPath = {problem.startNode};
    nodeNames = {problem.startNode.name};
    nodeStates = {problem.startNode.state};
    nodesExplored = length(exploredSet);
    minimumCost = 0;
    fprintf('Tree search found a solution.\n');
    return
end

while true
    
    %if there are no candidates for expansion, then return failure
    if isempty(frontierSet)
        solutionPath = {};
        nodeNames = {};
        nodeStates = {};
        nodesExplored = length(exploredSet);
        minimumCost = 'NA';
        fprintf('Tree search failed; empty frontier set.\n');
        return
    end
    
    switch(strategy)
        case 'DepthFirst'
             %Picking the last frontier node results in a depth-first
             %search
            expansionIndex = length(frontierSet);
            if nargin<3 %If no cost function provided, use depth
                minimumCost = minimumDepth;
            else
                minimumCost = varargin{1}(problem.startNode,frontierSet{expansionIndex});
            end
        case 'BreadthFirst'
            minimumDepth = inf;
            for i=1:length(frontierSet)
                if frontierSet{i}.depth < minimumDepth
                    minimumDepth = frontierSet{i}.depth;
                    expansionIndex = i;
                end
            end
            if nargin<3 %If no cost function provided, use depth
                minimumCost = minimumDepth;
            else
                minimumCost = varargin{1}(problem.startNode,frontierSet{expansionIndex});
            end
        case 'A*'
            
            %Pick expansion node based on a minimum cost estimate from the
            %calculated 'Cost to Come' and a heuristically estimated 'Cost
            %to Go'
            minimumCost = inf;
            for i=1:length(frontierSet)
                
                %TODO: The structure for these parameters could be a little
                %more flexible
                
                %Calculate cost to come
                if nargin<3 %If no cost function provided, use depth
                    costToCome = frontierSet{i}.depth;
                else %If cost function provided, use it
                    costToCome = varargin{1}(problem.startNode,frontierSet{i});
                end
                
                %Calculate cost to go
                if nargin<4 %If no heuristic provided, try Euclidean distance
                    try
                        heuristicCostToGo = EuclideanCostToGo(frontierSet{i},problem.goalState);
                    catch
                        error('No heuristic provided and euclidean norm failed.')
                    end
                else %If heuristic provided, use it
                    heuristicCostToGo = varargin{2}(frontierSet{i},problem.goalState);
                end
                
                costEstimate = costToCome + heuristicCostToGo;
                if costEstimate < minimumCost
                    minimumCost = costEstimate;
                    expansionIndex = i;
                end
            end
        otherwise
            error('No valid expansion strategy selected\n');
    end
    
    %Expansion node info
    if verbose
        fprintf('Node:\t%s\tState:\t[', frontierSet{expansionIndex}.name);
        for i=1:length(frontierSet{expansionIndex}.state)
            if i>1, fprintf(','), end
            fprintf('%f',frontierSet{expansionIndex}.state(i));
        end
        fprintf(']\tCostEst:\t%f\n', minimumCost);
    end
    
    %check if expansion node contains goal state
    if isequal(frontierSet{expansionIndex}.state,problem.goalState)
        solutionNode = frontierSet{expansionIndex};
        d = frontierSet{expansionIndex}.depth;
        solutionPath = cell(1,d);
        nodeNames = cell(1,d);
        nodeStates = cell(1,d);
        for i=1:d
            solutionPath{d - i + 1} = solutionNode;
            nodeNames{d - i + 1} = solutionNode.name;
            nodeStates{d - i + 1} = solutionNode.state;
            solutionNode = solutionNode.parent;
        end
        if ~isequal(solutionNode,problem.startNode.parent) %First solution node should be start node, with parent 'None'
            error('Solution path did not contain start node\n');
        end
        fprintf('Tree search found a solution.\n');
        nodesExplored = length(exploredSet);
        return
    end
    
    exploredSet{end+1} = frontierSet{expansionIndex}; %Add to explored set
    frontierSet(expansionIndex) = []; %Remove from frontierSet
    frontierCandidates = exploredSet{end}.expand(problem.expansionRule); %Expand node
    for i=1:length(frontierCandidates)
        %Add new child to frontier set if node state is not an obstacle and
        %is not in the already explored set
        if ~ObstacleCheck(frontierCandidates{i},problem,verbose) && ~ExploredCheck(frontierCandidates{i},exploredSet)
            frontierSet{end+1} = frontierCandidates{i};
        end
    end
    
    %Frontier set info
    if verbose
        fprintf('FrontierSet:');
        for i=1:length(frontierSet)
            if i>1, fprintf(','), end
            fprintf('%s',frontierSet{i}.name);
        end
        fprintf('\n')
    end
    %pause
end

end

