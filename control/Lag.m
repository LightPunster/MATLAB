function [Gc,K] = Lag(G,H,PM_d,e_ss,varargin)
%Lag designs a phase lag compensator for a dynamic system
%   Parameters:
%       - G: transfer function of the plant
%       - H: transfer function of the sensor
%       - PM_d: design-specified phase margin (degrees)
%       - e_ss: design-specified steady-state error
%   Optional parameters:
%       - input: input signal for which e_ss is specified. Possible options
%                include 'step', 'ramp', and 'parabola'. Default: 'step'
%       - omega_g_zero_ratio: ratio to use to place zero to left of gain
%                             crossover. Default: 10
%       - plt: boolean, specifies whether to give bode plots of compensated
%              and uncompensated system.
%   Operation:
%       Designs a static gain to meet a nonzero steady state error
%       requirement, then a dynamic compensator to ensure
%       stability/desirable transient performance (as specified by phase
%       margin requirement). Outputs the dynamic compensator in series with
%       the static gain.
    
    %% Input parsing
    switch nargin
        case 4
            input = 'step';
            omega_g_zero_ratio = 10;
            plt = false;
        case 5
            input = varargin{1};
            omega_g_zero_ratio = 10;
            plt = false;
        case 6
            input = varargin{1};
            omega_g_zero_ratio = varargin{2};
            plt = false;
        case 7
            input = varargin{1};
            omega_g_zero_ratio = varargin{2};
            plt = varargin{3};
        otherwise
            error('Invalid number of input arguments\n');
    end
    
    %% Static Gain
    K = StaticCompensator(G,H,e_ss,input);
    
    %% Dynamic compensator design
    %Form for phase lag: (1+a*T*s)/(1+T*s) where a<1
    %Places a pole at 1/T and a zero at 1/a*T > 1/T, subtracting gain at
    %the gain crossover to improve stability. Substracts phase in between
    %pole and zero, but this should have negligible effect if well placed.
    
    warning('off','Control:analysis:MarginUnstable')
    [~,PM,~,~] = margin(K*G*H); %Determine phase margin after static gain
    warning('on','Control:analysis:MarginUnstable')
    if PM>=PM_d %PM_d requirement met or exceeded
        fprintf("No dynamic compensation required; using static gain.\n");
        Gc = K;
    else
        [LoopMag,LoopPhase,Omega] = bode(K*G*H); %Create magnitude vs frequency arrays
        omega_g_c = interp1(squeeze(LoopPhase),Omega,PM_d-180);
        g = interp1(Omega,20*log10(squeeze(LoopMag)),omega_g_c); %Note: g must be calculated in order for linear interp to be valid
        a = 10^(-g/20);
        T = omega_g_zero_ratio/(omega_g_c*a);
        Gc = K*tf([a*T,1],[T,1]);
    end
    
    %% Plot output
    if plt
        figure(1),clf(1),hold on
        margin(G*H),
        margin(K*G*H)
        margin(Gc*G*H)
        legend('Uncompensated','Static Gain','Compensated')
        grid on
    end

end
