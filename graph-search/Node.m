classdef Node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        state
        parent
        depth
        children
        
        %Costs
        h %Predicted cost from current node to goal (typically some heuristic)
        g %Cost from start to current node
        rhs %LPA* "Look-ahead value" for g
        
    end
    
    methods
        function obj = Node(name,state,varargin)
            %NODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.name = name;
            obj.state = state;
            switch(nargin)
                case 2
                    obj.parent = 'None';
                    obj.depth = 1;
                case 3
                    obj.parent = varargin{1};
                    obj.depth = obj.parent.depth + 1;
                otherwise
                    error('Invalid number of arguments in Node constructor.')
            end
            obj.children = {};
            obj.g = inf;
            obj.rhs = inf;
        end
        
        function addChild(obj,childNode)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.children{end+1} = childNode;
        end
        
        function newNodes = expand(obj,Rule)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            [childNames,childStates] = Rule(obj.state);
            newNodes = cell(1,length(childStates));
            for i=1:length(childStates)
                childNode = Node(childNames{i},childStates{i},obj);
                obj.addChild(childNode);
                newNodes{i} = childNode;
            end
        end
        
        function go = CostToCome(obj)
            go = min(obj.g,obj.rhs);
        end
        
        function f = Cost(obj)
            f = obj.CostToCome() + obj.h;
        end
            
    end
end

