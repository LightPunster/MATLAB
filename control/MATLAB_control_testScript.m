%% ShiftEqPnt
f = @(x) [-x(1) + x(1)*x(2) + 1; -x(2)];
x_eq = EquilibriumPoints(f);
figure(1)
subplot(1,2,1)
PhasePlane(f,x_eq(1)+[-2,2],x_eq(2)+[-2,2],20);
subplot(1,2,2)
%PhasePlane(@(x) ShiftEqPnt(f,x_eq,x),[-2,2],[-2,2],20);
PhasePlane(@(x) ShiftEqPnt(f,x_eq,x),[-2,2],[-2,2],20);

syms x1 x2
x = [x1;x2];
f = [-x(1) + x(1)*x(2) + 1; -x(2)]
%f2 = ShiftEqPnt(f,x_eq)
f2 = ShiftEqPnt(f,x_eq,[4;5])

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
%PhasePlane(@(x) pendulum(x,10,1),theta_range,omega_range);
PhasePlane(@(x) pendulum(x,10,1),theta_range,omega_range,20);
%PhasePlane(@(x) pendulum(x,10,1),theta_range,omega_range,20,10);
plot([-2*pi,0,2*pi],[0,0,0],'g*') %Stable equilibrium
plot([-pi,pi],[0,0],'r*') %Unstable equilibrium

range = [-1,1];
figure(2)
subplot(3,4,1)
PhasePlane(@stable,range,range); title('Stable Node (l1<0,l2<0)'); axis([range range])
subplot(3,4,2)
PhasePlane(@saddle,range,range); title('Saddle Point (l1<0,l2>0)'); axis([range range])
subplot(3,4,3)
PhasePlane(@unstable,range,range); title('Unstable Node (l1>0,l2>0)'); axis([range range])
subplot(3,4,4)
PhasePlane(@stable_focus,range,range); title('Stable Focus (Real(l1)<0, Real(l2)<0)'); axis([range range])
subplot(3,4,5)
PhasePlane(@unstable_focus,range,range); title('Unstable Focus (Real(l1)>0, Real(l2)>0)'); axis([range range])
subplot(3,4,6)
PhasePlane(@marginal,range,range); title('Marginally Stable Focus (l1,l2 imaginary)'); axis([range range])
subplot(3,4,7)
PhasePlane(@stable_repeated,range,range); title('Stable Repeated (l1=l2<0)'); axis([range range])
subplot(3,4,8)
PhasePlane(@unstable_repeated,range,range); title('Unstable Repeated (l1=l2>0)'); axis([range range])
subplot(3,4,9)
PhasePlane(@stable_line,range,range); title('Stable w/ 0 (l1<0,l2=0)'); axis([range range])
subplot(3,4,10)
PhasePlane(@unstable_line,range,range); title('Unstable w/ 0 (l1>0,l2=0)'); axis([range range])
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
