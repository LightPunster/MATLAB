n_range = 2000; %input('Enter n range: ');
mag = -9;
To = 10*(10^mag);
omega = 2*pi/To;

n = [-n_range:-1, 1:n_range];
t = linspace(-20,20,1000);

[T,N] = meshgrid(t,n);

X_n = (0*sin(3*(10^mag)*N*omega)./(N*omega));
X_n = X_n + (5.8*(10^-mag)*cos(2*(10^mag)*N*omega))./((N.^2)*(omega^2));
X_n = X_n - (5.8*(10^-mag)*cos(3*(10^mag)*N*omega))./((N.^2)*(omega^2));
X_n = X_n/(To);

X_t = X_n.*exp((j*N).*(omega*T));
x_t = sum(X_t);
x_t = x_t + 1.65;
plot(t,x_t)

fprintf('Min peak: %f\n',min(x_t))
fprintf('Max peak: %f\n',max(x_t))

P_x = abs([X_n(:,1); 1.65]).^2;
p_x = sum(P_x);
fprintf('Power w/ DC component: %f\n',p_x)

P_x = abs([X_n(:,1)]).^2;
p_x = sum(P_x);
fprintf('Power w/out DC component: %f\n',p_x)

