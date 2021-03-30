function fx = tunneldiode(x,P_h,varargin)
%tunneldiode.m dynamic equations of an LRC tunnel diode circuit
%   Input parameters:
%       - x: state in the form [diode voltage (v_d); diode current (i_d)]
%       - P_h: polynomial relating v_d to i_d
%   Optional input parameters:
%       - L: inductor value
%       - R: resistor value
%       - C: capacitor value
%       - u: supply voltage
%   Outputs:
%       - fx: state derivative in the form [d/dt(v_d); d/dt(i_d)]
    
    switch nargin
        case 2
            L = 1;
            R = 1;
            C = 1;
            u = 1;
        case 6
            L = varargin{1};
            R = varargin{2};
            C = varargin{3};
            u = varargin{4};
        otherwise
            error('Expected inputs in one of the following forms:\n\ttunneldiode(x,P_h)\n\ttunneldiode(x,P_h,L,R,C,u)');
    end
    fx = [(1/C)*(-P(x(1,:),P_h) + x(2,:));
          (1/L)*(-x(1,:) - R*x(2,:) + u)];
end





