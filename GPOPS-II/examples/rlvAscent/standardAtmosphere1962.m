function [P,rho,A] = standardAtmosphere1962(geometricAltitude)
%This function computes the pressure, temperature, density, and speed of
%sound given the geometric altitude. The US 1962 Standard Atmosphere model
%is interpolated linearly for P and rho. The speed of sound was calculated
%using A=sqrt(gamma*R*TempM), where gamma=cp/cv=1.4 for air, R is the gas
%constant for air, and TempM=(M0/M)*T is the molecular scale temperature.
%The mean molecular weight of air, M, and the temperature, T, are also 
%obtained via interpolation of the 1962 model.
%
%Note: Data intervals are 5000ft apart starting at 0ft and ending at 
%      400,000ft. Any values for the geometric altitude below this
%      range will be interpolated using the closest two data values. For
%      values above 400,000ft this program returns A=inf, P=rho=0.
%
%Input:
%      geometricAltitude - mx1 array containing the geometric altitudes at
%                          which the outputs are to be evaluated [ft]
%Output:
%      P   - mx1 array of the ambient atmospheric pressure [psi]
%      rho - mx1 array of the ambient atmospheric density [slug/ft^3]
%      A   - mx1 array of the speed of sound [ft/s]
%________________________________________________________________________%

% --- Check if size of input is appropriate --- %
%D=size(geometricAltitude);
%if D(2) ~= 1
%    error('geometricAltitude must be a column vector')
%end

% --- Find indices and modify if any out of bounds --- %
%ind = floor(geometricAltitude./5000)+1;
%Mdim=size(geometricAltitude,1);

%for i = 1:Mdim
%    if ind(i) < 1
%        ind(i) = 1;
%    elseif ind(i) > 80
%        ind(i) = 80;
%    elseif isnan(ind(i)) %prevents program from crashing when GPOPS-II
%        ind(i) = 1;      %passes NaN to check dependencies
%    end
%end

% --- Declare constants --- %
R     = 1.71655e3;    % gas constant for air (ft^2/sec^2/degR)
gamma = 1.40;         % cp/cv for air; assumed constant
P0    = 14.695972;    % ambient pressure at sea level (psi)
rho0  = 2.3768846e-3; % ambient density of air at sea level (slug/ft^3)
M0    = 28.9644;      % mean molecular weight of air at sea level (lb_mass/lb-mol)

% --- Form 1962 std. atmos. data matrix --- %
% 81 lines of data starting at 0 ft and going up by increments of 5000ft
%Matrix = [altitude [1000ft], Temperature [degR], Pressure (P/P0), Density (rho/rho0), Molecular Weight]
Matrix = [0,      518.670,    1.00000,     1.0000,     28.964;...
          5,      500.843,    8.32085e-1,  8.6170e-1,  28.964;...
          10,     483.025,    6.87832e-1,  7.3859e-1,  28.964;...
          15,     465.216,    5.64587e-1,  6.2946e-1,  28.964;...
          20,     447.415,    4.59912e-1,  5.3316e-1,  28.964;...
          25,     429.623,    3.71577e-1,  4.4859e-1,  28.964;...
          30,     411.839,    2.97544e-1,  3.7473e-1,  28.964;...
          35,     394.064,    2.35962e-1,  3.1058e-1,  28.964;...
          40,     389.970,    1.85769e-1,  2.4708e-1,  28.964;...
          45,     389.970,    1.46227e-1,  1.9449e-1,  28.964;...
          50,     389.970,    1.15116e-1,  1.5311e-1,  28.964;...
          55,     389.970,    9.06336e-2,  1.2055e-1,  28.964;...
          60,     389.970,    7.13644e-2,  9.4919e-2,  28.964;...
          65,     389.970,    5.62015e-2,  7.4749e-2,  28.964;...
          70,     392.246,    4.42898e-2,  5.8565e-2,  28.964;...
          75,     394.971,    3.49635e-2,  4.5914e-2,  28.964;...
          80,     397.693,    2.76491e-2,  3.6060e-2,  28.964;...
          85,     400.415,    2.19023e-2,  2.8371e-2,  28.964;...
          90,     403.135,    1.73793e-2,  2.2360e-2,  28.964;...
          95,     405.854,    1.38133e-2,  1.7653e-2,  28.964;...
          100,    408.572,    1.09971e-2,  1.3960e-2,  28.964;...
          105,    411.289,    8.76918e-3,  1.1059e-2,  28.964;...
          110,    418.384,    7.01123e-3,  8.6918e-3,  28.964;...
          115,    425.983,    5.62884e-3,  6.8536e-3,  28.964;...
          120,    433.578,    4.53705e-3,  5.4275e-3,  28.964;...
          125,    441.170,    3.67112e-3,  4.3160e-3,  28.964;...
          130,    448.758,    2.98150e-3,  3.4460e-3,  28.964;...
          135,    456.342,    2.43013e-3,  2.7620e-3,  28.964;...
          140,    463.923,    1.98760e-3,  2.2222e-3,  28.964;...
          145,    471.500,    1.63111e-3,  1.7943e-3,  28.964;...
          150,    479.073,    1.34291e-3,  1.4539e-3,  28.964;...
          155,    486.643,    1.10910e-3,  1.1821e-3,  28.964;...
          160,    487.170,    9.17640e-4,  9.7697e-4,  28.964;...
          165,    487.170,    7.59302e-4,  8.0840e-4,  28.964;...
          170,    487.170,    6.28341e-4,  6.6897e-4,  28.964;...
          175,    483.944,    5.19819e-4,  5.5712e-4,  28.964;...
          180,    478.550,    4.29240e-4,  4.6523e-4,  28.964;...
          185,    473.158,    3.53708e-4,  3.8773e-4,  28.964;...
          190,    467.769,    2.90849e-4,  3.2250e-4,  28.964;...
          195,    462.383,    2.38642e-4,  2.6769e-4,  28.964;...
          200,    456.999,    1.95371e-4,  2.2174e-4,  28.964;...
          205,    448.465,    1.59516e-4,  1.8449e-4,  28.964;...
          210,    437.707,    1.29642e-4,  1.5362e-4,  28.964;...
          215,    426.955,    1.04831e-4,  1.2735e-4,  28.964;...
          220,    416.207,    8.43186e-5,  1.0508e-4,  28.964;...
          225,    405.465,    6.74421e-5,  8.6272e-5,  28.964;...
          230,    394.728,    5.36268e-5,  7.0465e-5,  28.964;...
          235,    383.996,    4.23776e-5,  5.7240e-5,  28.964;...
          240,    373.269,    3.32693e-5,  4.6229e-5,  28.964;...
          245,    362.547,    2.59380e-5,  3.7108e-5,  28.964;...
          250,    351.83,     2.0074e-5,   2.959e-5,   28.964;...
          255,    341.12,     1.5415e-5,   2.344e-5,   28.964;...
          260,    330.41,     1.1740e-5,   1.843e-5,   28.964;...
          265,    325.17,     8.8729e-6,   1.415e-5,   28.964;...
          270,    325.17,     6.6996e-6,   1.069e-5,   28.964;...
          275,    325.17,     5.0593e-6,   8.070e-6,   28.964;...
          280,    325.17,     3.8211e-6,   6.095e-6,   28.964;...
          285,    325.17,     2.8863e-6,   4.604e-6,   28.964;...
          290,    325.17,     2.1805e-6,   3.478e-6,   28.964;...
          295,    325.17,     1.6475e-6,   2.628e-6,   28.964;...
          300,    332.90,     1.2489e-6,   1.946e-6,   28.961;...
          305,    341.07,     9.5321e-7,   1.449e-6,   28.96;...
          310,    349.20,     7.3234e-7,   1.087e-6,   28.95;...
          315,    357.28,     5.6618e-7,   8.211e-7,   28.94;...
          320,    365.28,     4.4034e-7,   6.242e-7,   28.92;...
          325,    373.20,     3.4443e-7,   4.775e-7,   28.90;...
          330,    383.13,     2.7095e-7,   3.656e-7,   28.87;...
          335,    396.32,     2.1483e-7,   2.799e-7,   28.83;...
          340,    409.39,     1.7170e-7,   2.162e-7,   28.79;...
          345,    422.33,     1.3825e-7,   1.685e-7,   28.74;...
          350,    435.14,     1.1210e-7,   1.324e-7,   28.69;...
          355,    447.82,     9.1492e-8,   1.048e-7,   28.63;...
          360,    460.37,     7.5133e-8,   8.350e-8,   28.57;...
          365,    483.87,     6.2170e-8,   6.558e-8,   28.50;...
          370,    509.60,     5.1976e-8,   5.193e-8,   28.43;...
          375,    535.14,     4.3859e-8,   4.162e-8,   28.36;...
          380,    560.49,     3.7322e-8,   3.372e-8,   28.28;...
          385,    585.67,     3.2002e-8,   2.760e-8,   28.21;...
          390,    610.68,     2.7631e-8,   2.279e-8,   28.13;...
          395,    642.43,     2.4013e-8,   1.877e-8,   28.05;...
          400,    693.61,     2.1071e-8,   1.522e-8,   27.97];
      

% --- Interpolate T, P, rho, and M --- %
%run  = geometricAltitude./1000-Matrix(ind,1);
%run  = [run, run, run, run];
%data = Matrix(ind,2:5)+run.*(Matrix(ind+1,2:5)-Matrix(ind,2:5))./5;
%data = interp1(Matrix(:,1),Matrix(:,2:end),geometricAltitude./1000,'spline');

T   = interp1(Matrix(:,1),Matrix(:,2),geometricAltitude./1000,'pchip');       %[degR]
P   = interp1(Matrix(:,1),Matrix(:,3),geometricAltitude./1000,'pchip').*P0;   %[psi]
rho = interp1(Matrix(:,1),Matrix(:,4),geometricAltitude./1000,'pchip').*rho0; %[slug/ft^3]
M   = interp1(Matrix(:,1),Matrix(:,5),geometricAltitude./1000,'pchip');

% --- Calculate speed of sound --- %
TempM=(M0./M).*T; %molecular scale temp [degR]
A = sqrt(gamma.*R.*TempM); %[ft/sec]

%Turn A=inf, P=rho=0 at altitudes above 400000ft
%for i = 1:Mdim
%    if geometricAltitude(i) > 400000
%        P(i) = 0; rho(i) = 0; A(i) = inf;
%    end
%end

end

