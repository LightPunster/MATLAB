%-------------------------------------------------------------------------%
%                             Extract Solution                            %
%-------------------------------------------------------------------------%
solution = output.result.solution;
time = solution.phase(1).time;
state = solution.phase(1).state;
control = solution.phase(1).control;
for i=1:length(output.meshhistory);
  mesh(i).meshPoints = [0 cumsum(output.meshhistory(i).result.setup.mesh.phase.fraction)];
  mesh(i).time =  output.meshhistory(i).result.solution.phase.time;
  mesh(i).iteration = i*ones(size(mesh(i).meshPoints));
  mesh(i).iterationTime = i*ones(size(mesh(i).time));
end;

%-------------------------------------------------------------------------%
%                              Plot Solution                              %
%-------------------------------------------------------------------------%
figure(1);
pp = plot(time,state(:,1),'-o',time,state(:,2),'-d');
xl = xlabel('Time');
yl = ylabel('State');
ll = legend('State-1','State-2');
set(xl,'Fontsize',18);
set(yl,'Fontsize',18);
set(ll,'Fontsize',18);
set(gca,'Fontsize',16);
set(pp,'LineWidth',1.25);
grid on

figure(2);
pp = plot(time,state(:,1),'-o');
xl = xlabel('Time');
yl = ylabel('Altitude');
set(xl,'Fontsize',18);
set(yl,'Fontsize',18);
set(gca,'Fontsize',16);
set(pp,'LineWidth',1.25);
grid on

figure(3);
pp = plot(time,state(:,2),'-o');
xl = xlabel('Time');
yl = ylabel('Velocity');
set(xl,'Fontsize',18);
set(yl,'Fontsize',18);
set(gca,'Fontsize',16);
set(pp,'LineWidth',1.25);
grid on

figure(4);
pp = plot(time,control,'-o');
xl = xlabel('Time');
yl = ylabel('Control');
ll = legend('Control');
set(xl,'Fontsize',18);
set(yl,'Fontsize',18);
set(ll,'Fontsize',18);
set(gca,'Fontsize',16);
set(pp,'LineWidth',1.25);
grid on

figure(5);
tf = time(end);
for i=1:length(mesh);
  pp = plot(mesh(i).meshPoints*tf,mesh(i).iteration,'bo');
  set(pp,'LineWidth',1.25);
  hold on;
end;
xl = xlabel('Mesh Point Location (Fraction of Interval)');
yl = ylabel('Mesh Iteration');
set(xl,'Fontsize',18);
set(yl,'Fontsize',18);
set(gca,'YTick',0:length(mesh),'FontSize',16);
grid on;

figure(6);
for i=1:length(mesh);
  pp = plot(mesh(i).time,mesh(i).iterationTime,'bo');
  set(pp,'LineWidth',1.25);
  hold on;
end;
xl = xlabel('Collocation Point Location');
yl = ylabel('Mesh Iteration');
set(xl,'Fontsize',18);
set(yl,'Fontsize',18);
set(gca,'YTick',0:length(mesh),'FontSize',16);
grid on;
