classdef Queue < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vals
        priorities
    end
    
    methods
        function obj = Queue()
            %UNTITLED11 Construct an instance of this class
            %   Detailed explanation goes here
            obj.vals = {[]};
            obj.priorities = {inf};
        end
        
        function add(obj,val,priority)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for i=1:length(obj.priorities)
                if (priority<=obj.priorities{i})||(i==length(obj.priorities))
                    obj.vals = {obj.vals{1:i-1},...
                        val,...
                        obj.vals{i:end}};
                    obj.priorities = {obj.priorities{1:i-1},...
                        priority,...
                        obj.priorities{i:end}};
                    break
                end
            end
        end
        
        function [v,p] = pop(obj)
            %METHOD2 Summary of this method goes here
            %   Detailed explanation goes here
            v = obj.vals{1};
            p = obj.priorities{1};
            obj.vals = obj.vals(2:end);
            obj.priorities = obj.priorities(2:end);
        end
        
        function p = topKey(obj)
            %METHOD3 Summary of this method goes here
            %   Detailed explanation goes here
            p = obj.priorities{1};
        end
    end
end

