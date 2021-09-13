function Gc = LeadLag(G,H,PO,t_s,e_ss,varargin)
%LeadLag designs a phase lead-lag compensator for a dynamic system
%   Parameters:
%       - G: transfer function of the plant
%       - H: transfer function of the sensor
%       - PO: design-specified percent overshoot
%       - t_s: design-specified settling time
%       - e_ss: design-specified steady-state error
%   Optional parameters:
%       - input: input signal for which e_ss is specified. Possible options
%                include 'step', 'ramp', and 'parabola'. Default: 'step'
%       - omega_g_zero_ratio: ratio to use to place zero to left of gain
%                             crossover. Default: 10
%       - t_s_spec: percent to use when calculating percent overshoot
%       - plt: boolean, specifies whether to give bode plots of compensated
%              and uncompensated system.
%   Operation:
%       Designs a static gain to meet a nonzero steady state error
%       requirement, then a dynamic compensator to ensure
%       stability/desirable transient performance. A phase lag compensator
%       is used to stabilize the system, then a phase lead is used to speed
%       it up. Outputs the dynamic compensator in series with the static
%       gain.
    
    %% Input parsing
    switch nargin
        case 5
            input = 'step';
            omega_g_zero_ratio = 10;
            t_s_spec = 2;
            plt = false;
        case 6
            input = varargin{1};
            omega_g_zero_ratio = 10;
            t_s_spec = 2;
            plt = false;
        case 7
            input = varargin{1};
            omega_g_zero_ratio = varargin{2};
            t_s_spec = 2;
            plt = false;
        case 8
            input = varargin{1};
            omega_g_zero_ratio = varargin{2};
            t_s_spec = varargin{3};
            plt = false;
        case 9
            input = varargin{1};
            omega_g_zero_ratio = varargin{2};
            t_s_spec = varargin{3};
            plt = varargin{4};
        otherwise
            error('Invalid number of input arguments\n');
    end
    
    %% Lead Compensator
    %Create second order approximation by looking at dominant poles
    G
    [~,poles,gain] = zpkdata(G*H);
    poles = sort(poles{1},'ComparisonMethod','real');
    if length(poles)>2
        poles_soa = poles(end-1:end);
    else
        poles_soa = poles;
    end
    GH_soa = zpk([],poles_soa,gain)
    
    %Calculate target closed-loop poles from performance specs
    zeta = -log(PO/100)/sqrt(pi^2 + log(PO/100)^2);
    switch t_s_spec
        case 2
            omega_n = 4/(zeta*t_s);
        otherwise
            error("Invalid t_s_spec")
    end
    target_poles = roots([1 2*zeta*omega_n omega_n^2]);
    
    %Use lead zero to cancel one pole
    [zeros,poles,~] = zpkdata(GH_soa);
    poles = sort(poles{1},'ComparisonMethod','real');
    Gc1_zero = poles(2); %(cancel least dominant pole)
    
    %Use phase condition & graphical root locus method to calculate desired
    %pole location
    theta_zeros = (180/pi)*atan2(...
        imag(target_poles(1) - [zeros{1} Gc1_zero]),...
        real(target_poles(1) - [zeros{1} Gc1_zero]));
    theta_poles = (180/pi)*atan2(...
        imag(target_poles(1) - poles),...
        real(target_poles(1) - poles));
    theta_Gc2_pole = 180 + sum(theta_zeros) - sum(theta_poles);
    Gc1_pole = real(target_poles(1)) - imag(target_poles(1))/tand(theta_Gc2_pole);
    
    %Find the gain using the gain condition
    L_zeros = abs(target_poles(1) - [zeros{1} Gc1_zero]);
    L_poles = abs(target_poles(1) - poles);
    Gc1_K = prod(L_poles)/prod(L_zeros);
    
    %Lead compensator transfer function
    Gc1 = zpk(Gc1_zero,Gc1_pole,Gc1_K)
    
    %Verify, if necessary
%     figure(2)
%     rlocus(GH_soa)
%     figure(3),clf(3),hold on
%     plot(real(target_poles),imag(target_poles),'*')
%     rlocus(Gc1*GH_soa)
    
    %% Static Gain & Lag Compensator
    G2 = Gc1*G;
    PM_d = 100*zeta;
    [Gc2,~] = Lag(G,H,PM_d,e_ss,input,omega_g_zero_ratio)
    
    
    %% Plot output
    Gc = Gc1*Gc2
    if plt
        figure(1),clf(1),hold on
        margin(G*H),
        margin(Gc1*G*H)
        margin(Gc*G*H)
        legend('Uncompensated','Lead','Lead-Lag')
        grid on
    end

end
