function K = StaticCompensator(G,H,e_ss,varargin)
%StaticCompensator Designs a static gain to meet a nonzero steady state
%error for a stable system.
%   Parameters:
%       - G: transfer function of the plant
%       - H: transfer function of the sensor
%       - e_ss: design-specified steady-state error
%   Optional parameters:
%       - input: input signal for which e_ss is specified. Possible options
%                include 'step', 'ramp', and 'parabola'. Default: 'step'
        
    switch nargin
        case 3
            input = 'step';
        case 4
            input = varargin{1};
        otherwise
            error('Invalid number of input arguments\n');
    end
    
    G_uf = G/(1+G*H-G); %G transformed to unity feedback (if H=1, G_uf=G)
    switch input
        case {'step','Step','position','Position','pos','Pos','pose','Pose'}
            y = step(1/(1+G_uf));
            Kp = 1/y(end) - 1;
            K = (1/e_ss - 1)/Kp;
        case {'ramp','Ramp','velocity','Velocity','vel','Vel','speed','Speed'}
            y = step(tf([1],[1 0])/(1+G_uf));
            Kv = 1/y(end);
            K = 1/(e_ss*Kv);
        case {'parabola','Parabola','acceleration','Acceleration'}
            y = step(tf([1],[1 0 0])/(1+G_uf));
            Ka = 1/y(end);
            K = 1/(e_ss*Ka);
        otherwise
            error('Invalid specification for input signal.')
    end
    
    if (K>0) && (K<1) %i.e. steady state error requirement already met
        K=1;
    elseif (K<0) && (K>-1) %steady state error met, negative gain is stabilizing
        K=-1;
    end
end

