clear, clc, close('all')

%% Odd & Even example
problem.expansionRule = @OddAndEven;
problem.startNode = Node('1',1);
problem.goalState = 13;
[~,names,~,n,~,cost] = TreeSearch(problem,'A*');
fprintf('Nodes Explored: %d, Min Cost: %f\n',n,cost)
path = names

%% 2D Path Finder w/ 4-connectivity
problem.expansionRule = @(state) FourConnectivity_2D(state,1,1);
problem.startNode = Node('(1,1)',[1,1]);
problem.goalState = [8,5];
problem.obstacles = {[2,1],[2,5],[3,2],[2,3],[2,4],[5,3],[6,3],[7,3],[4,3],[4,4],[8,4]};
[~,~,states,n,~,cost] = TreeSearch(problem,'A*');
x_path = []; y_path = [];
for i=1:length(states)
    x_path = [x_path states{i}(1)];
    y_path = [y_path states{i}(2)];
end
x_obst = []; y_obst = [];
for i=1:length(problem.obstacles)
    x_obst = [x_obst problem.obstacles{i}(1)];
    y_obst = [y_obst problem.obstacles{i}(2)];
end

figure(1)
plot(x_path,y_path,x_obst,y_obst,'Sk')
xlabel('x'), ylabel('y'),title('2D Path Finder w/ 4-connectivity')
grid on, axis equal
xticks(min([x_path x_obst]):1:max([x_path x_obst]))
yticks(min([y_path y_obst]):1:max([y_path y_obst]))

fprintf('Nodes Explored: %d, Min Cost: %f\n',n,cost)
fprintf('See fig 1 for path.\n\n')

%% 2D Path Finder w/ 6-connectivity
problem.expansionRule = @(state) SixConnectivity_2D(state,1,1);
problem.startNode = Node('(1,1)',[1,1]);
problem.goalState = [8,5];
problem.obstacles = {[2,1],[2,5],[3,2],[2,3],[2,4],[5,3],[6,3],[7,3],[4,3],[4,4],[8,4]};
[~,~,states,n,~,cost] = TreeSearch(problem,'A*',@EuclideanCostToCome);
x_path = []; y_path = [];
for i=1:length(states)
    x_path = [x_path states{i}(1)];
    y_path = [y_path states{i}(2)];
end
x_obst = []; y_obst = [];
for i=1:length(problem.obstacles)
    x_obst = [x_obst problem.obstacles{i}(1)];
    y_obst = [y_obst problem.obstacles{i}(2)];
end

figure(2)
plot(x_path,y_path,x_obst,y_obst,'Sk')
xlabel('x'), ylabel('y'),title('2D Path Finder w/ 6-connectivity')
grid on, axis equal
xticks(min([x_path x_obst]):1:max([x_path x_obst]))
yticks(min([y_path y_obst]):1:max([y_path y_obst]))

fprintf('Nodes Explored: %d, Min Cost: %f\n',n,cost)
fprintf('See fig 2 for path.\n\n')

%% Romania Plane Route
Start = 'Vaslui'
problem.goalState = 'Sibiu';
problem.expansionRule = @RomanianMap;
problem.startNode = Node(Start,Start);

RomaniaMapDistances = containers.Map(...
    {'Oradea->Zerind','Zerind->Oradea','Zerind->Arad','Arad->Zerind',...
     'Arad->Sibiu','Sibiu->Arad','Sibiu->Oradea','Oradea->Sibiu',...
     'Arad->Timisoara','Timisoara->Arad','Timisoara->Lugoj','Lugoj->Timisoara',...
     'Lugoj->Mehadia','Mehadia->Lugoj','Mehadia->Dobreta','Dobreta->Mehadia',...
     'Dobreta->Craiova','Craiova->Dobreta','Craiova->Rimnicu Vilcea','Rimnicu Vilcea->Craiova',...
     'Rimnicu Vilcea->Sibiu','Sibiu->Rimnicu Vilcea','Sibiu->Fagaras','Fagaras->Sibiu',...
     'Rimnicu Vilcea->Pitesti','Pitesti->Rimnicu Vilcea',...
     'Craiova->Pitesti','Pitesti->Craiova','Pitesti->Bucharest','Bucharest->Pitesti',...
     'Fagaras->Bucharest','Bucharest->Fagaras','Bucharest->Giurgiu','Giurgiu->Bucharest',...
     'Bucharest->Urziceni','Urziceni->Bucharest','Urziceni->Hirsova','Hirsova->Urziceni',...
     'Hirsova->Eforie','Eforie->Hirsova','Vaslui->Urziceni','Urziceni->Vaslui',...
     'Vaslui->Iasi','Iasi->Vaslui','Neamt->Iasi','Iasi->Neamt'},...
    {71,71,75,75,140,140,151,151,118,118,111,111,70,70,75,75,120,120,146,146,...
     80,80,99,99,97,97,138,138,101,101,211,211,90,90,85,85,98,98,86,86,142,142,...
     92,92,87,87}...
);

[~,names,~,n,explored,cost] = TreeSearch(problem,'DepthFirst',...
    @(startNode,frontierNode) DictionaryCostToCome(startNode,frontierNode,RomaniaMapDistances));
path = names
fprintf('Depth-First Exploration Order:\n')
for i=1:length(explored)
    if i>1, fprintf(','), end
    fprintf('\t%s',explored{i}.name);
end
fprintf('\n');
fprintf('Total Nodes Explored: %d, Cost: %f\n',n,cost)

[~,names,states,n,explored,cost] = TreeSearch(problem,'BreadthFirst',...
    @(startNode,frontierNode) DictionaryCostToCome(startNode,frontierNode,RomaniaMapDistances));
path = names
fprintf('Breadth-First Exploration Order:\n')
for i=1:length(explored)
    if i>1, fprintf(','), end
    fprintf('\t%s',explored{i}.name);
end
fprintf('\n');
fprintf('Total Nodes Explored: %d, Cost: %f\n',n,cost)

%% Expansion Rules
function [names,states] = OddAndEven(state)
    states = {2*state,...
              2*state+1};
    names = {num2str(2*state),...
             num2str(2*state+1)}; 
end
    
function [names,states] = RomanianMap(state)
    switch(state)
        case 'Oradea'
            names = {'Zerind','Sibiu'};
        case 'Zerind'
            names = {'Oradea','Arad'};
        case 'Arad'
            names = {'Zerind','Timisoara','Sibiu'};
        case 'Timisoara'
            names = {'Arad','Lugoj'};
        case 'Lugoj'
            names = {'Timisoara','Mehadia'};
        case 'Mehadia'
            names = {'Lugoj','Dobreta'};
        case 'Dobreta'
            names = {'Mehadia','Craiova'};
        case 'Craiova'
            names = {'Pitesti','Dobreta','Rimnicu Vilcea'};
        case 'Rimnicu Vilcea'
            names = {'Sibiu','Craiova','Pitesti'};
        case 'Sibiu'
            names = {'Fagaras','Arad','Rimnicu Vilcea','Oradea'};
        case 'Fagaras'
            names = {'Sibiu','Bucharest'};
        case 'Pitesti'
            names = {'Bucharest','Craiova','Rimnicu Vilcea'};
        case 'Bucharest'
            names = {'Giurgiu','Urziceni','Fagaras','Pitesti'};
        case 'Giurgiu'
            names = {'Bucharest'};
        case 'Urziceni'
            names = {'Bucharest','Hirsova','Vaslui'};
        case 'Hirsova'
            names = {'Eforie','Urziceni'};
        case 'Eforie'
            names = {'Hirsova'};
        case 'Vaslui'
            names = {'Iasi','Urziceni'};
        case 'Iasi'
            names = {'Neamt','Vaslui'};
        case 'Neamt'
            names = {'Iasi'};
    end
    states = names;
end
