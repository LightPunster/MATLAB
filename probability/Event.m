%TODO: For some reason, adding compliment conditions also adds to the
%conditions for the main event

classdef Event < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d
        P
        conds = {};
        cond_keys = {};
        P_cond = containers.Map();
        conds_are_partition = false;
        c
    end
    
    methods
        function obj = Event(descrip,varargin)
            %Event Construct an instance of this class
            %   Detailed explanation goes here
            obj.d = descrip;
            
            switch(nargin)
                case 2
                    obj.P = varargin{1};
            end
        end
        
        function Compliment(obj,varargin)
            %Compliment Summary of this method goes here
            %   Detailed explanation goes here
            if ~isempty(obj.P)
                obj.c = Event(['not{' obj.d '}'], 1 - obj.P);
            else
                obj.c = Event(['not{' obj.d '}']);
            end
            
            if ~isempty(obj.conds)
                P_cond_c = cell(1,length(obj.conds));
                for i=1:length(obj.conds)
                    P_cond_c{i} = 1 - obj.P_cond(obj.cond_keys{i});
                end
                obj.c.conds = obj.conds;
                obj.c.cond_keys = obj.cond_keys;
                obj.c.P_cond = containers.Map(obj.cond_keys,P_cond_c);
                obj.c.conds_are_partition = obj.c.conds_are_partition;
            end
            
            obj.c.c = obj;
        end  
        
        function addConditions(obj,events,probs)
            %addConditions Summary of this method goes here
            %   Detailed explanation goes here
            for i=1:length(events)
                %Check if already in conditions
                alreadyAdded = false;
                for j=1:length(obj.conds)
                    alreadyAdded = alreadyAdded | isequal(obj.conds{j},events{i});
                end
                %If not, add to conditions
                if ~alreadyAdded
                    obj.cond_keys{end+1} = events{i}.d;
                    obj.conds{end+1} = events{i};
                end
                obj.P_cond(events{i}.d) = probs{i};
            end
            
            %Calculate probability of all conditions
            %(TODO: does not account for the fact that events may have nonzero intersection)
            total = 0;
            for i=1:length(obj.conds)
                total = total + obj.conds{i}.P;
            end
            if norm(total-1)<1e-10
                obj.conds_are_partition = true;
            else
                obj.conds_are_partition = false;
            end
            
            %If partition, set probability
            if isempty(obj.P) && (obj.conds_are_partition)
                obj.P = 0;
                for i=1:length(obj.conds)
                    Ei = obj.conds{i};
                    obj.P = obj.P + Ei.P*(obj.P_cond(Ei.d));
                end
            end
        end
        
        function invertConditions(obj,E)
            obj.addConditions({E,E.c},{Intersect(obj,E)/E.P,Intersect(obj,E.c)/E.c.P});
        end
    end
end

