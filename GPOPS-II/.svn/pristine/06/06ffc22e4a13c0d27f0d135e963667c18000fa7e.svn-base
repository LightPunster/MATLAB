%------------------------------%
% Extract Solution from Output %
%------------------------------%
color = true; % use to turn phases into different colors or leave as one

solution     = output.result.solution;
g0           = output.result.setup.auxdata.g0;

time{1}      = solution.phase(1).time;
altitude{1}  = (solution.phase(1).state(:,1)-auxdata.Re)/1000; %km
longitude{1} = solution.phase(1).state(:,2)*180/pi; %deg
latitude{1}  = solution.phase(1).state(:,3)*180/pi; %deg
speed{1}     = solution.phase(1).state(:,4)/1000; %km/s
fpa{1}       = solution.phase(1).state(:,5)*180/pi; %deg
heading{1}   = solution.phase(1).state(:,6)*180/pi; %deg
weight{1}    = solution.phase(1).state(:,7); %kg
aoa{1}       = solution.phase(1).control(:,1)*180/pi; %deg
w1{1}        = solution.phase(1).control(:,2);
w2{1}        = solution.phase(1).control(:,3);
bank{1}      = atan2(w2{1}, w1{1}); %deg
% bank{1}      = wrapTo360(bank{1}); %this is to get rid of the angle wrap jump
bank{1}      = unwrap(bank{1})*180/pi; %this is to get rid of the angle wrap jump
if size(solution.phase(1).control,2) == 4
  throttle{1}  = solution.phase(1).control(:,4);
end

time{2}      = solution.phase(2).time;
altitude{2}  = (solution.phase(2).state(:,1)-auxdata.Re)/1000; %km
longitude{2} = solution.phase(2).state(:,2)*180/pi; %deg
latitude{2}  = solution.phase(2).state(:,3)*180/pi; %deg
speed{2}     = solution.phase(2).state(:,4)/1000; %km/s
fpa{2}       = solution.phase(2).state(:,5)*180/pi; %deg
heading{2}   = solution.phase(2).state(:,6)*180/pi; %deg
weight{2}    = solution.phase(2).state(:,7); %kg
aoa{2}       = solution.phase(2).control(:,1)*180/pi; %deg
w1{2}        = solution.phase(2).control(:,2);
w2{2}        = solution.phase(2).control(:,3);
bank{2}      = atan2d(w2{2}, w1{2}); %deg

time{3}      = solution.phase(3).time;
altitude{3}  = (solution.phase(3).state(:,1)-auxdata.Re)/1000; %km
longitude{3} = solution.phase(3).state(:,2)*180/pi; %deg
latitude{3}  = solution.phase(3).state(:,3)*180/pi; %deg
speed{3}     = solution.phase(3).state(:,4)/1000; %km/s
fpa{3}       = solution.phase(3).state(:,5)*180/pi; %deg
heading{3}   = solution.phase(3).state(:,6)*180/pi; %deg
weight{3}    = solution.phase(3).state(:,7); %kg
aoa{3}       = zeros(size(time{3})); %no control in this phase
bank{3}      = zeros(size(time{3})); %no control in this phase

time{4}      = solution.phase(4).time;
altitude{4}  = (solution.phase(4).state(:,1)-auxdata.Re)/1000; %km
longitude{4} = solution.phase(4).state(:,2)*180/pi; %deg
latitude{4}  = solution.phase(4).state(:,3)*180/pi; %deg
speed{4}     = solution.phase(4).state(:,4)/1000; %km/s
fpa{4}       = solution.phase(4).state(:,5)*180/pi; %deg
heading{4}   = solution.phase(4).state(:,6)*180/pi; %deg
weight{4}    = solution.phase(4).state(:,7); %kg
aoa{4}       = solution.phase(4).control(:,1)*180/pi; %deg
w1{4}        = solution.phase(4).control(:,2);
w2{4}        = solution.phase(4).control(:,3);
bank{4}      = atan2d(w2{4}, w1{4}); %deg

tTot        = [time{1}; time{2}; time{3}; time{4}];
altTot      = [altitude{1}; altitude{2}; altitude{3}; altitude{4}];
lonTot      = [longitude{1}; longitude{2}; longitude{3}; longitude{4}];
latTot      = [latitude{1}; latitude{2}; latitude{3}; latitude{4}];
speedTot    = [speed{1}; speed{2}; speed{3}; speed{4}];
fpaTot      = [fpa{1}; fpa{2}; fpa{3}; fpa{4}];
headTot     = [heading{1}; heading{2}; heading{3}; heading{4}];
weightTot   = [weight{1}; weight{2}; weight{3}; weight{4}];
aoaTot      = [aoa{1}; aoa{2}; aoa{3}; aoa{4}];
bankTot     = [bank{1}; bank{2}; bank{3}; bank{4}];

[contoutput, endpoutput] = gpopsEvalFunAtSolution(output.result);
%gLoad = contoutput(1).path(:,1); %first phase only

%Determine position in ECI coordinates {i,j,k}
if color == true
    theta = cell(4,1);
    I     = cell(4,1);
    J     = cell(4,1);
    K     = cell(4,1);
    for i = 1:4
        theta{i} = longitude{i}.*pi./180+auxdata.w.*(time{i}-tTot(1)); %local sidereal time (Greenwich sidereal time assumed to be 0 at t0)
        I{i}     = (altitude{i}+auxdata.Re).*cos(latitude{i}.*pi./180).*cos(theta{i})/1000; %I                             
        J{i}     = (altitude{i}+auxdata.Re).*cos(latitude{i}.*pi./180).*sin(theta{i})/1000; %J       
        K{i}     = (altitude{i}+auxdata.Re).*sin(latitude{i}.*pi./180)/1000;             %K
    end
else
    theta = lonTot.*pi./180+auxdata.w.*(tTot-tTot(1)); %local sidereal time (Greenwich sidereal time assumed to be 0 at t0)
    I     = (altTot+auxdata.Re).*cos(latTot.*pi./180).*cos(theta); %I                             
    J     = (altTot+auxdata.Re).*cos(latTot.*pi./180).*sin(theta); %J       
    K     = (altTot+auxdata.Re).*sin(latTot.*pi./180);             %K
end

%---------------%
% Plot Solution %
%---------------%
figure(1)
if color == true
    pp = plot(time{1},altitude{1},'-o', ...
              time{2},altitude{2},'-d', ...
              time{3},altitude{3},'-s', ...
              time{4},altitude{4},'-v');
else
    pp = plot(tTot,altTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Altitude vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$h(t)$~(km)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',18,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'southeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentAltitude.eps
print -dpng rlvAscentAltitude.png

figure(2)
if color == true
    pp = plot(longitude{1},latitude{1},'-o', ...
              longitude{2},latitude{2},'-d', ...
              longitude{3},latitude{3},'-s', ...
              longitude{4},latitude{4},'-v');
else
    plot(lonTot,latTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Latitude vs. Longitude','FontSize',36)
xl = xlabel('$\theta(t)$~(deg)','Interpreter','LaTeX');
yl = ylabel('$\phi(t)$~(deg)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'northwest';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentLonLat.eps
print -dpng rlvAscentLonLat.png

figure(3)
if color == true
    pp = plot(time{1},speed{1},'-o', ...
              time{2},speed{2},'-d', ...
              time{3},speed{3},'-s', ...
              time{4},speed{4},'-v');
else
    plot(tTot,speedTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Speed vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$v(t)$~(km$\cdot$s${}^{-1}$)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'southeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentSpeed.eps
print -dpng rlvAscentSpeed.png

figure(4)
if color == true
    pp = plot(time{1},fpa{1},'-o', ...
              time{2},fpa{2},'-d', ...
              time{3},fpa{3},'-s', ...
              time{4},fpa{4},'-v');
else
    plot(tTot,fpaTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Flight Path Angle vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$\gamma(t)$~(deg)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'northeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentFlightPathAngle.eps
print -dpng rlvAscentFlightPathAngle.png

figure(5)
if color == true
    pp = plot(time{1},heading{1},'-o', ...
              time{2},heading{2},'-d', ...
              time{3},heading{3},'-s', ...
              time{4},heading{4},'-v');
else
    plot(tTot,headTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Heading Angle vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$\psi(t)$~(deg)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'southwest';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentHeadingAngle.eps
print -dpng rlvAscentHeadingAngle.png

figure(6)
if color == true
    pp = plot(time{1},weight{1}./10^4,'-o', ...
              time{2},weight{2}./10^4,'-d', ...
              time{3},weight{3}./10^4,'-s', ...
              time{4},weight{4}./10^4,'-v');
else
    plot(tTot,weightTot./10^4,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Mass vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$m(t)$~(kg $\times 10^4$)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'northeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentWeight.eps
print -dpng rlvAscentWeight.png

figure(7)
if color == true
    pp = plot(time{1},aoa{1},'-o', ...
              time{2},aoa{2},'-d', ...
              time{3},aoa{3},'-s', ...
              time{4},aoa{4},'-v');
else
    plot(tTot,aoaTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Angle of Attack vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$\alpha(t)$~(deg)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'southeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentAngleofAttack.eps
print -dpng rlvAscentAngleofAttack.png

figure(8)
if color == true
    pp = plot(time{1},bank{1},'-o', ...
              time{2},bank{2},'-d', ...
              time{3},bank{3},'-s', ...
              time{4},bank{4},'-v');
else
    plot(tTot,bankTot,'-o', 'markersize', 8, 'linewidth', 1.5);
end
% title('Bank Angle vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$\sigma(t)$~(deg)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1','Phase 2','Phase 3','Phase 4');
ll.Location = 'northeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentBankAngle.eps
print -dpng rlvAscentBankAngle.png

if 0
figure(9)
plot(time{1},throttle{1},'-o', 'markersize', 8, 'linewidth', 1.5);
% title('Throttle vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$K(t)$','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1');
ll.Location = 'northeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentThrottle.eps
print -dpng rlvAscentThrottle.png

figure(10)
plot(time{1},gLoad,'-o', 'markersize', 8, 'linewidth', 1.5);
% title('Sensed Acceleration vs. Time','FontSize',36)
xl = xlabel('$t$~(s)','Interpreter','LaTeX');
yl = ylabel('$G=\displaystyle\frac{\sqrt{F_T^2+F_N^2}}{m g_0}$','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
ll = legend('Phase 1');
ll.Location = 'southeast';
% set(ll,'FontSize',20,'FontName','Times');
set(ll,'FontSize',22,'Interpreter','LaTeX');
print -depsc2 rlvAscentGLoad.eps
print -dpng rlvAscentGLoad.png
end % if 0

figure(11)
if color == true
    plot3(I{1},J{1},K{1},'-o',I{2},J{2},K{2},'-d', ...
          I{3},J{3},K{3},'-s',I{4},J{4},K{4},'-v')
else
    plot3(I,J,K);
end
xl = xlabel('$x(t)$~(km)','Interpreter','LaTeX');
yl = ylabel('$y(t)$~(km)','Interpreter','LaTeX');
zl = zlabel('$z(t)$~(km)','Interpreter','LaTeX');
set(xl,'FontSize',18);
set(yl,'FontSize',18);
set(zl,'FontSize',18);
set(gca,'FontSize',16,'FontName','Times');
set(pp,'LineWidth',1.5,'MarkerSize',8);
grid on
