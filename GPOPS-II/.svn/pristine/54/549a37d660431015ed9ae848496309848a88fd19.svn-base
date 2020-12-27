function phaseout = rlvAscentContinuous(input)
%This function computes the rates of change of the state variables using
%the equations of motion for atmospheric flight around a spherical Earth
%(refer to "Hypersonic and Planetary Entry Flight Mechanics" for more
%information).
%
%Input:
%       input    - A structure with the fields phase and auxdata. For more
%                  information, please refer to the GPOPS-II user's guide.
%Output:
%       phaseout - A structure with the fields dynamics and path. For more
%                  information, please refer to the GPOPS-II user's guide.
%________________________________________________________________________%

%------------------------------------------------------------------------%
%------------------------ Extract Auxiliary Data ------------------------%
%------------------------------------------------------------------------%
%================%
% --- Global --- %
%================%
Re = input.auxdata.Re;
w  = input.auxdata.w;
mu = input.auxdata.mu;
g0 = input.auxdata.g0;
S  = input.auxdata.S;
% --- Known Weights --- %
%mShuttle = input.auxdata.mShuttle;
%mETfull  = input.auxdata.mETfull;
%mETempty = input.auxdata.mETempty;

%=================%
% --- Phase 1 --- %
%=================%
FvacSSME = input.auxdata.FvacSSME;
IspSSME  = input.auxdata.IspSSME;
AeSSME   = input.auxdata.AeSSME;
KmaxSSME = input.auxdata.KmaxSSME;

% --- extract coeficients for lift --- %
clm1  = input.auxdata.clm(1);
clm2  = input.auxdata.clm(2);
clm3  = input.auxdata.clm(3);
clm4  = input.auxdata.clm(4);
clm5  = input.auxdata.clm(5);   
clm6  = input.auxdata.clm(6);
clm7  = input.auxdata.clm(7);
clm8  = input.auxdata.clm(8);
clm9  = input.auxdata.clm(9);

% --- extract coeficients for drag --- %
cdm1  = input.auxdata.cdm(1);
cdm2  = input.auxdata.cdm(2);
cdm3  = input.auxdata.cdm(3);
cdm4  = input.auxdata.cdm(4);
cdm5  = input.auxdata.cdm(5);
cdm6  = input.auxdata.cdm(6);
cdm7  = input.auxdata.cdm(7);
cdm8  = input.auxdata.cdm(8);
cdm9  = input.auxdata.cdm(9);

%======================%
% --- Phases 2 - 4 --- %
%======================%
FvacOMS = input.auxdata.FvacOMS;
IspOMS  = input.auxdata.IspOMS;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
%                                                                        %
%------------------------------------------------------------------------%
%-------------------------- Dynamics in Phase 1 -------------------------%
%------------------------------------------------------------------------%
%                                                                        %
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
iphase  = 1;

%rename for convenience and brevity
Fvac = FvacSSME;
Isp  = IspSSME;
Ae   = AeSSME;
Kmax = KmaxSSME;

%------------------------------------------------------------------------%
%------------ Extract Each Component of the State and Control -----------%
%------------------------------------------------------------------------%
% --- extract state --- %
rad   = input.phase(iphase).state(:,1);
lat   = input.phase(iphase).state(:,3);
speed = input.phase(iphase).state(:,4);
fpa   = input.phase(iphase).state(:,5);
head  = input.phase(iphase).state(:,6);
mass  = (input.phase(iphase).state(:,7));

% --- extract control --- %
aoa   = input.phase(iphase).control(:,1);
w1    = input.phase(iphase).control(:,2);
w2    = input.phase(iphase).control(:,3);

%------------------------------------------------------------------------%
%------------ Compute Forces and Gravitational Acceleration -------------%
%------------------------------------------------------------------------%
% --- Calculate density, pressure, and speed of sound --- %
altitude = rad-Re;
[P,rho,A] = standardAtmosphere1962(altitude*3.28084);
% - convert to SI units
P   = P*6894.76;   % [psi] to [Pa]
rho = rho*515.379; % [slug/ft^3] to [kg/m^3]
A   = A*0.3048;    % [ft/s] to [m/s]

% --- Calculate mach number and dynamic pressure --- %
Mach = speed./A; %Mach number
q = 0.5.*rho.*speed.^2; %dynamic pressure [Pa]

% --- Compute Throttle
K = (mass.*g0+Ae.*P)/Fvac;
iKgtKmax = K>Kmax;
K(iKgtKmax) = Kmax;

% --- Compute Thrust --- %
T = 3.*(K.*Fvac-Ae.*P);

% --- Compute Coeficients of Lift and Drag --- %
CL = (clm1+clm2.*Mach+clm3.*Mach.^2)+...
     (clm4+clm5.*Mach+clm6.*Mach.^2).*sin(aoa)+...
     (clm7+clm8.*Mach+clm9.*Mach.^2).*cos(aoa);

CD = (cdm1+cdm2.*Mach+cdm3.*Mach.^2)+...
     (cdm4+cdm5.*Mach+cdm6.*Mach.^2).*sin(aoa)+...
     (cdm7+cdm8.*Mach+cdm9.*Mach.^2).*cos(aoa);

% --- Compute Lift and Drag --- %
L = q.*CL.*S;
D = q.*CD.*S;

% --- Compute FT and FN --- %
% (tangent and normal components of the propulsive and aerodynamic forces)
FT = T.*cos(aoa)-D;
FN = T.*sin(aoa)+L;

% --- Compute gravitational Acceleration --- %
gravity  = mu./rad.^2;

%------------------------------------------------------------------------%
%-------------- Evaluate Right-Hand Side of the Dynamics ----------------%
%------------------------------------------------------------------------%
% --- Kinematic Equations --- %
raddot   = speed.*sin(fpa);
londot   = speed.*cos(fpa).*cos(head)./(rad.*cos(lat));
latdot   = speed.*cos(fpa).*sin(head)./rad;

% --- Force Equations --- %
speeddot = FT./mass-gravity.*sin(fpa)+w.^2.*rad.*cos(lat).*(sin(fpa).*...
           cos(lat)-cos(fpa).*sin(lat).*sin(head));
fpadot   = (FN.*w1./(mass)-(gravity-speed.^2./rad).*cos(fpa)+...
           2.*w.*speed.*cos(lat).*cos(head)+rad.*w.^2.*cos(lat).*...
           (cos(fpa).*cos(lat)+sin(fpa).*sin(lat).*sin(head)))./speed;

headdot  = (FN.*w2./(mass.*cos(fpa))-speed.^2.*cos(fpa).*...
           cos(head).*tan(lat)./rad+2.*w.*speed.*(tan(fpa).*cos(lat).*...
           sin(head)-sin(lat))-rad.*w.^2.*sin(lat).*cos(lat).*...
           cos(head)./cos(fpa))./speed;
       
% --- Mass Equation --- %
massdot = -T./(Isp.*g0);

%------------------------------------------------------------------------%
%--------------------- Compute Sensed Acceleration ----------------------%
%------------------------------------------------------------------------%
%sensedAcceleration = sqrt(FT.^2+FN.^2)./(mass.*g0); %AKA "g-force"

%output the dynamics and path constraint
%------------------------------------------------------------------------%
%------------------------- Construct Phaseout ---------------------------%
%------------------------------------------------------------------------%
phaseout(iphase).dynamics = [raddot, londot, latdot, speeddot, fpadot, headdot, massdot];
phaseout(iphase).path = (w1.^2+w2.^2);





%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
%                                                                        %
%------------------------------------------------------------------------%
%-------------------------- Dynamics in Phase 2 -------------------------%
%------------------------------------------------------------------------%
%                                                                        %
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
iphase  = 2;

%rename for convenience and brevity
Fvac = FvacOMS;
Isp  = IspOMS;

%------------------------------------------------------------------------%
%------------ Extract Each Component of the State and Control -----------%
%------------------------------------------------------------------------%
% --- extract state --- %
rad   = input.phase(iphase).state(:,1);
%lon   = input.phase.state(:,2); not necessary for eqns.
lat   = input.phase(iphase).state(:,3);
speed = input.phase(iphase).state(:,4);
fpa   = input.phase(iphase).state(:,5);
head  = input.phase(iphase).state(:,6);
mass  = (input.phase(iphase).state(:,7));

% --- extract control --- %
aoa   = input.phase(iphase).control(:,1);
w1    = input.phase(iphase).control(:,2);
w2    = input.phase(iphase).control(:,3);

%------------------------------------------------------------------------%
%------------ Compute Forces and Gravitational Acceleration -------------%
%------------------------------------------------------------------------%
% --- Compute T, L, and D --- %
K = ones(size(rad));
T = 2.*(K.*Fvac);
L = 0;
D = 0;

% --- Compute FT and FN --- %
% (tangent and normal components of the propulsive and aerodynamic forces)
FT = T.*cos(aoa)-D;
FN = T.*sin(aoa)+L;

% --- Compute gravitational Acceleration --- %
gravity  = mu./rad.^2;

%------------------------------------------------------------------------%
%-------------- Evaluate Right-Hand Side of the Dynamics ----------------%
%------------------------------------------------------------------------%
% --- Kinematic Equations --- %
raddot   = speed.*sin(fpa);
londot   = speed.*cos(fpa).*cos(head)./(rad.*cos(lat));
latdot   = speed.*cos(fpa).*sin(head)./rad;

% --- Force Equations --- %
speeddot = FT./mass-gravity.*sin(fpa)+w.^2.*rad.*cos(lat).*(sin(fpa).*...
           cos(lat)-cos(fpa).*sin(lat).*sin(head));
fpadot   = (FN.*w1./(mass)-(gravity-speed.^2./rad).*cos(fpa)+...
           2.*w.*speed.*cos(lat).*cos(head)+rad.*w.^2.*cos(lat).*...
           (cos(fpa).*cos(lat)+sin(fpa).*sin(lat).*sin(head)))./speed;

headdot  = (FN.*w2./(mass.*cos(fpa))-speed.^2.*cos(fpa).*...
           cos(head).*tan(lat)./rad+2.*w.*speed.*(tan(fpa).*cos(lat).*...
           sin(head)-sin(lat))-rad.*w.^2.*sin(lat).*cos(lat).*...
           cos(head)./cos(fpa))./speed;
       
% --- Mass Equation --- %
massdot = -T./(Isp.*g0);

%------------------------------------------------------------------------%
%------------------------- Construct Phaseout ---------------------------%
%------------------------------------------------------------------------%
phaseout(iphase).dynamics = [raddot, londot, latdot, speeddot, fpadot, headdot, massdot];
phaseout(iphase).path = (w1.^2+w2.^2);





%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
%                                                                        %
%------------------------------------------------------------------------%
%-------------------------- Dynamics in Phase 3 -------------------------%
%------------------------------------------------------------------------%
%                                                                        %
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
iphase  = 3;

%------------------------------------------------------------------------%
%------------ Extract Each Component of the State and Control -----------%
%------------------------------------------------------------------------%
% --- extract state --- %
rad   = input.phase(iphase).state(:,1);
%lon   = input.phase.state(:,2); not necessary for eqns.
lat   = input.phase(iphase).state(:,3);
speed = input.phase(iphase).state(:,4);
fpa   = input.phase(iphase).state(:,5);
head  = input.phase(iphase).state(:,6);
%mass  = (input.phase(iphase).state(:,7));

%------------------------------------------------------------------------%
%------------ Compute Forces and Gravitational Acceleration -------------%
%------------------------------------------------------------------------%
% --- Compute gravitational Acceleration --- %
gravity  = mu./rad.^2;

%------------------------------------------------------------------------%
%-------------- Evaluate Right-Hand Side of the Dynamics ----------------%
%------------------------------------------------------------------------%
% --- Kinematic Equations --- %
raddot   = speed.*sin(fpa);
londot   = speed.*cos(fpa).*cos(head)./(rad.*cos(lat));
latdot   = speed.*cos(fpa).*sin(head)./rad;

% --- Force Equations --- %
speeddot = -gravity.*sin(fpa)+w.^2.*rad.*cos(lat).*(sin(fpa).*...
           cos(lat)-cos(fpa).*sin(lat).*sin(head));
fpadot   = (-(gravity-speed.^2./rad).*cos(fpa)+...
           2.*w.*speed.*cos(lat).*cos(head)+rad.*w.^2.*cos(lat).*...
           (cos(fpa).*cos(lat)+sin(fpa).*sin(lat).*sin(head)))./speed;

headdot  = (-speed.^2.*cos(fpa).*...
           cos(head).*tan(lat)./rad+2.*w.*speed.*(tan(fpa).*cos(lat).*...
           sin(head)-sin(lat))-rad.*w.^2.*sin(lat).*cos(lat).*...
           cos(head)./cos(fpa))./speed;
       
% --- Mass Equation --- %
massdot = zeros(size(rad));

%------------------------------------------------------------------------%
%------------------------- Construct Phaseout ---------------------------%
%------------------------------------------------------------------------%
phaseout(iphase).dynamics = [raddot, londot, latdot, speeddot, fpadot, headdot, massdot];





%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
%                                                                        %
%------------------------------------------------------------------------%
%-------------------------- Dynamics in Phase 4 -------------------------%
%------------------------------------------------------------------------%
%                                                                        %
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
iphase  = 4;

%rename for convenience and brevity
Fvac = FvacOMS;
Isp  = IspOMS;

%------------------------------------------------------------------------%
%------------ Extract Each Component of the State and Control -----------%
%------------------------------------------------------------------------%
% --- extract state --- %
rad   = input.phase(iphase).state(:,1);
%lon   = input.phase.state(:,2); not necessary for eqns.
lat   = input.phase(iphase).state(:,3);
speed = input.phase(iphase).state(:,4);
fpa   = input.phase(iphase).state(:,5);
head  = input.phase(iphase).state(:,6);
mass  = (input.phase(iphase).state(:,7));

% --- extract control --- %
aoa   = input.phase(iphase).control(:,1);
w1    = input.phase(iphase).control(:,2);
w2    = input.phase(iphase).control(:,3);

%------------------------------------------------------------------------%
%------------ Compute Forces and Gravitational Acceleration -------------%
%------------------------------------------------------------------------%
% --- Compute T, L, and D --- %
K = ones(size(rad));
T = 2.*(K.*Fvac);
L = 0;
D = 0;

% --- Compute FT and FN --- %
% (tangent and normal components of the propulsive and aerodynamic forces)
FT = T.*cos(aoa)-D;
FN = T.*sin(aoa)+L;

% --- Compute gravitational Acceleration --- %
gravity  = mu./rad.^2;

%------------------------------------------------------------------------%
%-------------- Evaluate Right-Hand Side of the Dynamics ----------------%
%------------------------------------------------------------------------%
% --- Kinematic Equations --- %
raddot   = speed.*sin(fpa);
londot   = speed.*cos(fpa).*cos(head)./(rad.*cos(lat));
latdot   = speed.*cos(fpa).*sin(head)./rad;

% --- Force Equations --- %
speeddot = FT./mass-gravity.*sin(fpa)+w.^2.*rad.*cos(lat).*(sin(fpa).*...
           cos(lat)-cos(fpa).*sin(lat).*sin(head));
fpadot   = (FN.*w1./(mass)-(gravity-speed.^2./rad).*cos(fpa)+...
           2.*w.*speed.*cos(lat).*cos(head)+rad.*w.^2.*cos(lat).*...
           (cos(fpa).*cos(lat)+sin(fpa).*sin(lat).*sin(head)))./speed;

headdot  = (FN.*w2./(mass.*cos(fpa))-speed.^2.*cos(fpa).*...
           cos(head).*tan(lat)./rad+2.*w.*speed.*(tan(fpa).*cos(lat).*...
           sin(head)-sin(lat))-rad.*w.^2.*sin(lat).*cos(lat).*...
           cos(head)./cos(fpa))./speed;
       
% --- Mass Equation --- %
massdot = -T./(Isp.*g0);

%------------------------------------------------------------------------%
%------------------------- Construct Phaseout ---------------------------%
%------------------------------------------------------------------------%
phaseout(iphase).dynamics = [raddot, londot, latdot, speeddot, fpadot, headdot, massdot];
phaseout(iphase).path = (w1.^2+w2.^2);
end
