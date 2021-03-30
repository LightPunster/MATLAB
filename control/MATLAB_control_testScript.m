%% MaxRoA
clear,clc,close all
f = @(x) [-x(1) + x(1)*x(2); -x(2)];
[P,A,r] = MaxRoA(f)


%% EquilibriumPoints
clear, clc, close all
fprintf('Stable Node\n')
[x_eq,~,~,stability] = EquilibriumPoints(@stable)
fprintf('Undamped Pendulum\n')
[x_eq,~,~,stability] = EquilibriumPoints(@(x) pendulum(x,10,1))
fprintf('Damped Pendulum\n')
[x_eq,~,~,stability] = EquilibriumPoints(@(x) pendulum(x,10,1,0.1),[0.1 3;0.1 0.1])
fprintf('Tunnel Diode\n')
P_h = [418.6/5,-905.24/4,688.86/3,-207.58/2,17.76,0];
L = 5; R = 1.5; C = 2; u = 1.2;
[x_eq,~,~,stability] = EquilibriumPoints(@(x) tunneldiode(x,P_h,L,R,C,u),...
    [0;0],[u;u/R],[4;2])

%% TunnelDiodeEqPnts
clear, clc, close all
P = [418.6,-905.24,688.86,-207.58,17.76];
%v_d = 1.2;
%[h,hp] = TunnelDiode(v_d,P)
[x_eq,~,~,stability] = TunnelDiodeEqPnts(5,1.5,2,1.2,@(v) TunnelDiode(v,P))

%% PhasePlane
clear, clc, close all
theta_range = [-2*pi,2*pi];
omega_range = [-4*pi,4*pi];

figure(1),hold on
%PhasePlane(theta_range,omega_range,@(x) pendulum(x,10,1));
PhasePlane(theta_range,omega_range,@(x) pendulum(x,10,1),20);
%PhasePlane(theta_range,omega_range,@(x) pendulum(x,10,1),20,10);
plot([-2*pi,0,2*pi],[0,0,0],'g*') %Stable equilibrium
plot([-pi,pi],[0,0],'r*') %Unstable equilibrium

range = [-1,1];
figure(2)
subplot(3,4,1)
PhasePlane(range,range,@stable); title('Stable Node (l1<0,l2<0)'); axis([range range])
subplot(3,4,2)
PhasePlane(range,range,@saddle); title('Saddle Point (l1<0,l2>0)'); axis([range range])
subplot(3,4,3)
PhasePlane(range,range,@unstable); title('Unstable Node (l1>0,l2>0)'); axis([range range])
subplot(3,4,4)
PhasePlane(range,range,@stable_focus); title('Stable Focus (Real(l1)<0, Real(l2)<0)'); axis([range range])
subplot(3,4,5)
PhasePlane(range,range,@unstable_focus); title('Unstable Focus (Real(l1)>0, Real(l2)>0)'); axis([range range])
subplot(3,4,6)
PhasePlane(range,range,@marginal); title('Marginally Stable Focus (l1,l2 imaginary)'); axis([range range])
subplot(3,4,7)
PhasePlane(range,range,@stable_repeated); title('Stable Repeated (l1=l2<0)'); axis([range range])
subplot(3,4,8)
PhasePlane(range,range,@unstable_repeated); title('Unstable Repeated (l1=l2>0)'); axis([range range])
subplot(3,4,9)
PhasePlane(range,range,@stable_line); title('Stable w/ 0 (l1<0,l2=0)'); axis([range range])
subplot(3,4,10)
PhasePlane(range,range,@unstable_line); title('Unstable w/ 0 (l1>0,l2=0)'); axis([range range])
%% Functions
function x_dot = stable(x) %Stable node Jordan form
    A = [-1 0; 0 -2];
    x_dot = A*x;
end
function x_dot = saddle(x) %Saddle point Jordan form
    A = [1 0; 0 -2];
    x_dot = A*x;
end
function x_dot = unstable(x) %Unstable node Jordan form
    A = [1 0; 0 2];
    x_dot = A*x;
end
function x_dot = stable_focus(x) %Stable node with complex eig vals in Jordan form
    A = [-2 -1; 1 -2];
    x_dot = A*x;
end
function x_dot = unstable_focus(x) %Unstable node with complex eig vals in Jordan form
    A = [2 -1; 1 2];
    x_dot = A*x;
end
function x_dot = marginal(x) %Marginally stable focus in Jordan form
    A = [0 -1; 1 0];
    x_dot = A*x;
end
function x_dot = stable_repeated(x)
    A = [-2 1; 0 -2];
    x_dot = A*x;
end
function x_dot = unstable_repeated(x)
    A = [2 1; 0 2];
    x_dot = A*x;
end
function x_dot = stable_line(x)
    A = [-2 0; 0 0];
    x_dot = A*x;
end
function x_dot = unstable_line(x)
    A = [2 0; 0 0];
    x_dot = A*x;
end
