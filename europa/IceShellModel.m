classdef IceShellModel
    %IceShellModel stores info about an ice shell covering an ocean world
    %such as Jupiter's moon Europa.
    %   Constructor call - x = IceShellModel(baseModel_name,g0,Z_max)
    %       - baseModel_name = csv file containing temperature, density,
    %         and pressure vs depth (TODO: some models list these as
    %         functions of distance from center of planetoid. This class
    %         this into account, but not other ways of specifying values.)
    %       - g0 = gravitational acceleration at surface of planet (m/s^2).
    %         (TODO: this model does not yet account for gravity below the
    %         surface.)
    %       - Z_max = maximum depth in meters
    %   For additional info on usage, see 'help IceShellModel.get' and
    %   'help IceShellModel.plot_all'.
    
    properties
        baseModel
        g0
        Z_max
        
        %Ice shell properties:
        T           %Temperature
        rho         %Density
        p           %Pressure
        r_xtal      %Radius of ice crystals
        n_bub       %Air bubble concentration
        r_bub       %Air bubble radius
        iceShellProperties = {'T','rho','p','r_xtal','n_bub','r_bub'};
    end
    
    methods
        function obj = IceShellModel(baseModel_name,g0,Z_max)
            %UNTITLED Construct an instance of IceShellModel
            %   Detailed explanation goes here
            
            obj.baseModel.name = baseModel_name;
            obj.baseModel.data = csvread(obj.baseModel.name,1,0);
            obj.baseModel.Z = 1000*(max(obj.baseModel.data(:,1)) - obj.baseModel.data(:,1));
            obj.baseModel.T = obj.baseModel.data(:,5);
            obj.baseModel.rho = obj.baseModel.data(:,2);
            
            obj.g0 = g0;
            obj.Z_max = Z_max; n = 50;
            
            %Temperature
            obj.T.name = 'Temperature'; obj.T.units = 'K';
            obj.T.Z = linspace(0,obj.Z_max,n);
            obj.T.vals = interp1(obj.baseModel.Z,obj.baseModel.T,obj.T.Z);
            
            %Density
            obj.rho.name = 'Density'; obj.rho.units = 'kg/m^3';
            obj.rho.Z = linspace(0,obj.Z_max,n);
            obj.rho.vals = interp1(obj.baseModel.Z,obj.baseModel.rho,obj.rho.Z);
            
            %Pressure
            obj.p.name = 'Pressure'; obj.p.units = 'Pa';
            obj.p.Z = linspace(0,obj.Z_max,n);
            obj.p.vals = obj.pressureCalc();
            
            %Ice Crystals
            iceCrystalModel = csvread('IceCrystalRadius_vs_Depth.csv',1,0);
            obj.r_xtal.name = 'Ice Crystal Radius'; obj.r_xtal.units = 'cm';
            obj.r_xtal.Z = iceCrystalModel(:,1);
            obj.r_xtal.vals = iceCrystalModel(:,2);
            
            %Air Bubbles
            bubbleConcentrationModel = csvread('AirBubbleConcentration_vs_Depth.csv',1,0);
            obj.n_bub.name = 'Air Bubble Concentration'; obj.n_bub.units = '1/cm^3';
            obj.n_bub.Z = bubbleConcentrationModel(:,1);
            obj.n_bub.vals = bubbleConcentrationModel(:,2);
            bubbleRadiusModel = csvread('AirBubbleRadius_vs_Depth.csv',1,0);
            obj.r_bub.name = 'Air Bubble Radius'; obj.r_bub.units = 'cm';
            obj.r_bub.Z = bubbleRadiusModel(:,1);
            obj.r_bub.vals = bubbleRadiusModel(:,2);
        end
        
        function value = get(obj,property_name,z,varargin)
            %IceShellModel.get(property_name,d,varargin) Gets ice shell property at a
            %specified location.
            %   Valid property names:
            %   - 'T' = temperature
            %   - 'rho' = ice density
            %   - 'p' = pressure
            %   - 'r_xtal' = radius of ice crystals
            %   - 'n_bub' = air bubble concentration
            %   - 'r_bub' = air bubble radius
            %
            %   If 2 parameters are given, the property at a given depth is
            %   returned. (TODO: If 4 parameters are given, the value is
            %   interpolated based on depth, lattitude, and longitude).
            switch nargin
                case 3
                    value = interp1(obj.(property_name).Z,...
                                    obj.(property_name).vals,...
                                    z);
                case 5
                    %TODO
                    fprintf('3-D interpolation code not yet written.')
                otherwise
                    error('Expected 2 or 5 arguments, got %d.\n',nargin)
            end
        end
        
        function plot_all(obj)
            %IceShellModel.plot_all() plots all ice shell model parameters 
            figure
            rows = 3;
            for i=1:length(obj.iceShellProperties)
                subplot(rows,ceil(length(obj.iceShellProperties)/rows),i)
                plot(obj.(obj.iceShellProperties{i}).Z,obj.(obj.iceShellProperties{i}).vals)
                ylabel(obj.(obj.iceShellProperties{i}).units)
                title(obj.(obj.iceShellProperties{i}).name)
                grid on
                if i>(length(obj.iceShellProperties)-ceil(length(obj.iceShellProperties)/rows))
                    xlabel('Depth (m)')
                end
            end
        end
        
        function p = pressureCalc(obj)
            try p = zeros(size(obj.p.Z)); %Pressure (Pa)
            catch, error("Object property 'p' not properly initialized with depth array 'p.Z'\n.")
            end
            M = 0;
            for i=2:numel(p)
                dV = (obj.p.Z(i)-obj.p.Z(i-1));
                M = M + (obj.rho.vals(i)+obj.rho.vals(i-1))*dV/2;
                try p(i) = M*obj.g0;
                catch, error("Object property 'g0' not properly initialized.\n")
                end
            end
        end
    end
end

