function [Gc,K] = Lead(G,H,PM_d,e_ss,varargin)
%Lead designs a phase lead compensator for a dynamic system
%   Parameters:
%       - G: transfer function of the plant
%       - H: transfer function of the sensor
%       - PM_d: design-specified phase margin (degrees)
%       - e_ss: design-specified steady-state error
%   Optional parameters:
%       - input: input signal for which e_ss is specified. Possible options
%                include 'step', 'ramp', and 'parabola'. Default: 'step'
%       - phi_m_margin: margin to use when calculating how much phase to
%                       add. Default: 5 degrees
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
            phi_m_margin = 5;
            plt = false;
        case 5
            input = varargin{1};
            phi_m_margin = 5;
            plt = false;
        case 6
            input = varargin{1};
            phi_m_margin = varargin{2};
            plt = false;
        case 7
            input = varargin{1};
            phi_m_margin = varargin{2};
            plt = varargin{3};
        otherwise
            error('Invalid number of input arguments\n');
    end
    
    %% Static Gain
    K = StaticCompensator(G,H,e_ss,input);
    
    %% Dynamic compensator design
    %Form for phase lead: (1+a*T*s)/(1+T*s) where a>1
    %Places a pole at 1/T and a zero at 1/a*T < 1/T, adding gain at higher
    %frequencies and adding phase in between the pole and zero.
    
    warning('off','Control:analysis:MarginUnstable')
    [~,PM,~,~] = margin(K*G*H); %Determine phase margin after static gain
    warning('on','Control:analysis:MarginUnstable')
    if PM<0
        warning("System is unstable; may not be able to stabilize.");
    end
    [LoopMag,~,Omega] = bode(K*G*H); %Create magnitude vs frequency arrays
    phi_m = PM_d - PM + phi_m_margin; %Calculate phase to add (+ a small margin)
    
    if phi_m<=0 %PM_d requirement met or exceeded
        fprintf("No dynamic compensation required; using static gain.\n");
        Gc = K;
    else
        if phi_m>=90 %requires a=inf (at 90deg) or doesn't work (adds 180 - phi_m instead)
            error("Cannot meet design specs; must add >= 90deg phase margin, which can't be achieved with a Phase Lead compensator.");
        elseif phi_m>=70 %requires a-->inf
            warning("Must add >= 70deg phase margin; may not be feasible.");
        end
        a = (1+sind(phi_m))/(1-sind(phi_m));
        omega_m = interp1(20*log10(squeeze(LoopMag)),Omega,-10*log10(a)); %Note: transform to log scale so linear interpolation is valid
        T = 1/(omega_m*sqrt(a));
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
