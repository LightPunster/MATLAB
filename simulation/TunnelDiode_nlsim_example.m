%Netlist:
%GND --> Vsup --> V1
%V1 --> R --> V2
%V2 --> L --> V_c
%V_c --> C --> GND
%V_c --> D --> GND

%x1 = i_L
%x2 = V_c

V_d = linspace(-1,8);
plot(V_d,h(V_d))
grid on

C = 1e-6;
L = 1e-1;
R = 100;

t = linspace(0,0.005);
Vsup = 12*ones(size(t));

[y,t,x] = nlsim(@(x,u) f(x,u,L,R,C),Vsup,t,[0;0]);

plot(t,x)
legend('i_L','V_c')


%Tunnel diode current function
function i_d = h(V_d)
    i_d = 0.001*(V_d-0.67).*(V_d-4.59).*(V_d-6.59) + 0.02;
end

%State derivatives
function [y,x_d] = f(x,Vsup,L,R,C)
    x_d = [ (Vsup - R*x(1) - x(2))/L;
            (x(1) - h(x(2)))/C];
    y = zeros(length(x));
end
