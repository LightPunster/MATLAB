%TODO: Plenty of optimization of speed work to do here

function [solutionPath,nodeNames,nodeStates,nodesExplored,exploredSet,minimumCost] = TreeSearch(problem,strategy,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%TODO: Make verbose an optional input
%TODO: Make more generic graph search, & allow 'Tree' to be a generic input
%(i.e. enabling the Explored check)

verbose = false;
plot_setting = true;

if plot_setting
    figure,clf,hold on
    grid on
    title('Nodes explored')
end

%Setup state weightings if none exist
if ~isfield(problem,'weights')
    problem.weights = ones(size(problem.goalState));
end

%initialize the search tree using the initial state of the problem
problem.startNode.g = 0;
frontierSet = Queue();
exploredSet = {problem.startNode};
if plot_setting
    plot(problem.startNode.state(1),problem.startNode.state(2),'*r')
    plot(problem.goalState(1),problem.goalState(2),'*g')
end

frontierCandidates = exploredSet{end}.expand(problem.expansionRule); %Expand node
for i=1:length(frontierCandidates)
    %Add new child to frontier set if node state is not an obstacle
    if ~ObstacleCheck(frontierCandidates{i},problem,verbose) && ~ExploredCheck(frontierCandidates{i},exploredSet)
        
        %Calculate cost to come
        if nargin<3 %If no cost function provided, use depth
            frontierCandidates{i}.g = frontierCandidates{i}.depth;
        else %If cost function provided, use it
            frontierCandidates{i}.g = varargin{1}(problem.startNode,frontierCandidates{i});
        end
        %Calculate cost to go
        if nargin<4 %If no heuristic provided, try Euclidean distance
            try
                frontierCandidates{i}.h = EuclideanCostToGo(frontierCandidates{i},problem.goalState,problem.weights);
            catch
                error('No heuristic provided and euclidean norm failed.')
            end
        else %If heuristic provided, use it
            frontierCandidates{i}.h = varargin{2}(frontierCandidates{i},problem.goalState,problem.weights);
        end
        
        frontierSet.add(frontierCandidates{i},frontierCandidates{i}.Cost());
        
        if plot_setting
            updateFrontierPlot(frontierCandidates{i})
        end
    end
end

%Frontier set info
if verbose
    frontierSetInfo(frontierSet)
end

%check if start node contains goal state
if isGoal(problem.startNode.state,problem.goalState,problem)
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
        solutionPath = {}; nodeNames = {}; nodeStates = {};
        nodesExplored = length(exploredSet);
        minimumCost = 'NA';
        fprintf('Tree search failed; empty frontier set.\n');
        return
    end
    
    switch(strategy)
%         case 'DepthFirst'
%              %Picking the last frontier node results in a depth-first
%              %search
%             expansionIndex = length(frontierSet);
%             if nargin<3 %If no cost function provided, use depth
%                 minimumCost = minimumDepth;
%             else
%                 minimumCost = varargin{1}(problem.startNode,frontierSet{expansionIndex});
%             end
%         case 'BreadthFirst'
%             minimumDepth = inf;
%             for i=1:length(frontierSet)
%                 if frontierSet{i}.depth < minimumDepth
%                     minimumDepth = frontierSet{i}.depth;
%                     expansionIndex = i;
%                 end
%             end
%             if nargin<3 %If no cost function provided, use depth
%                 minimumCost = minimumDepth;
%             else
%                 minimumCost = varargin{1}(problem.startNode,frontierSet{expansionIndex});
%             end
        case 'A*'
            
            %Pick expansion node based on a minimum cost estimate from the
            %calculated 'Cost to Come' and a heuristically estimated 'Cost
            %to Go'
            [expansionNode,minimumCost] = frontierSet.pop();
            
        case 'LPA*'
%             while (frontierSet.topKey())||(g
%                 
%             end
                
            [expansionNode,minimumCost] = frontierSet.pop();
            
        otherwise
            error("No valid expansion strategy selected");
    end
    
    %Expansion node info
    if verbose
        fprintf('Node:\t%s\tState:\t[', expansionNode.name);
        for i=1:length(expansionNode.state)
            if i>1, fprintf(','), end
            fprintf('%f',expansionNode.state(i));
        end
        fprintf(']\tCostEst:\t%f\n', minimumCost);
    end
    
    %check if expansion node contains goal state
    if isGoal(expansionNode.state,problem.goalState,problem)
        solutionNode = expansionNode;
        d = expansionNode.depth;
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
        
        if plot_setting
            for i=2:d
                updateSoluPlot(solutionPath{i});
            end
        end
        return
    end
    
    exploredSet{end+1} = expansionNode; %Add to explored set
    if plot_setting
        updateExploredPlot(expansionNode)
    end
    %expansionNode = []; %Remove from frontierSet
    frontierCandidates = exploredSet{end}.expand(problem.expansionRule); %Expand node
    for i=1:length(frontierCandidates)
        %Add new child to frontier set if node state is not an obstacle and
        %is not in the already explored set
        if ~ObstacleCheck(frontierCandidates{i},problem,verbose) && ~ExploredCheck(frontierCandidates{i},exploredSet)
            %Calculate cost to come
            if nargin<3 %If no cost function provided, use depth
                frontierCandidates{i}.g = frontierCandidates{i}.depth;
            else %If cost function provided, use it
                frontierCandidates{i}.g = varargin{1}(problem.startNode,frontierCandidates{i});
            end
            %Calculate cost to go
            if nargin<4 %If no heuristic provided, try Euclidean distance
                try
                    frontierCandidates{i}.h = EuclideanCostToGo(frontierCandidates{i},problem.goalState,problem.weights);
                catch
                    error('No heuristic provided and euclidean norm failed.')
                end
            else %If heuristic provided, use it
                frontierCandidates{i}.h = varargin{2}(frontierCandidates{i},problem.goalState,problem.weights);
            end

            frontierSet.add(frontierCandidates{i},frontierCandidates{i}.Cost());

            if plot_setting
                updateFrontierPlot(frontierCandidates{i})
            end
        end
    end
    
    %Frontier set info
    if verbose
        frontierSetInfo(frontierSet)
    end
    %pause
end

end

%% Auxillary Functions

function updateFrontierPlot(node)
    grey = [0.75,0.75,0.75];
    
    plot(node.state(1),node.state(2),'.','MarkerEdge',grey)
    plot([node.state(1),node.parent.state(1)],...
         [node.state(2),node.parent.state(2)],...
         'Color',grey)
    pause(0)
end

function updateExploredPlot(node)
    plot(node.state(1),node.state(2),'k.')
    plot([node.state(1),node.parent.state(1)],...
         [node.state(2),node.parent.state(2)],...
         'k')
    pause(0)
end

function updateSoluPlot(node)
    plot(node.state(1),node.state(2),'r.')
    plot([node.state(1),node.parent.state(1)],...
         [node.state(2),node.parent.state(2)],...
         'r')
    pause(0)
end

function goal_status = isGoal(x,g,problem)
    if isfield(problem,'tol')
        e = (g - x).*problem.weights;
        goal_status = norm(e)<=problem.tol;
    else
        goal_status = isequal(x,g);
    end
end

function frontierSetInfo(frontierSet)
%     fprintf('FrontierSet:');
%     for i=1:min(3,length(frontierSet))
%         if i>1, fprintf(','), end
%         fprintf("%s\n",frontierSet{i}.name);
%     end
%     if length(frontierSet)>5
%         fprintf("...\n")
%     end
%     fprintf('\n')
end