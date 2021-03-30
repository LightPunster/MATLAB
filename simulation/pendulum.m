function fx = pendulum(x,varargin)
%pendulum.m dynamic equations of a single damped pendulum
%   Input parameters:
%       - x: state in the form [angle; angular velocity]
%   Optional input parameters:
%       - g: gravitational acceleration (must be entered along with l)
%       - l: length of pendulum (must be entered along with g)
%       - b: damping coefficient
%       - J: moment of inertia (must be entered along with u)
%       - u: input torque (must be entered along with j)
%   Outputs:
%       - fx: state derivative in the form [angular velocity; angular
%             acceleration]

    switch nargin
        case 1
            g = 9.807;
            l = 1;
            b = 0;
            J = 1;
            u = 0;
        case 3
            g = varargin{1};
            l = varargin{2};
            b = 0;
            J = 1;
            u = 0;
        case 4
            g = varargin{1};
            l = varargin{2};
            b = varargin{3};
            J = 1;
            u = 0;
        case 6
            g = varargin{1};
            l = varargin{2};
            b = varargin{3};
            J = varargin{4};
            u = varargin{5};
        otherwise
            error('Expected inputs in one of the following forms:\n\tpendulum(x)\n\tpendulum(x,g,l)\n\tpendulum(x,g,l,b)\n\tpendulum(x,g,l,b,J,u)');
    end
            
    fx = [x(2);
         -(g/l)*sin(x(1)) - b*x(2) + u/J];

end

