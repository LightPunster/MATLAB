% --------------- Reusable Launch Vehicle Ascent ------------------- %
%                                                                    %
% Mission Summary:                                                   %
% -Stage II to MECO- (1)                                             %
%   This phase begins after the solid rocket boosters have been      %
% dropped and ends at the MECO conditions described by Betts.        %
% -MECO to orbit- (2, 3, and 4)                                      %
%   These phases consist of a burn, coast, burn sequence immediately %
%   after MECO until the desired orbit conditions are met.           %
%                                                                    %
% Assumptions:                                                       %
% - Global                                                           %
%   - Spherical Earth                                                %
%   - Atmosphere rotates with Earth                                  %
%   - Shuttle modeled as a point mass                                %
%   - Bank angle and angle of attack are the controls                %
% - Phases 1 and 2: Stage II to MECO                                 %
%   - Propulsive & aerodynamic force models from Betts' paper        %
%   - Smooth approximation of 1962 US Standard Atmosphere            %
%   - base drag & specific impulse variation with throttled ignored  %
% - Phases 3 and 4: MECO to orbit                                    %
%   - External tank drop is performed instantaneously                %
%   - All fuel in the external tank is depleted                      %
%   - Only one continuous burn is used to acheive orbit (can be      %
%     delayed to occur after a period of coasting after MECO)        %
%   - Both orbital maneuvering systems (OMS) engines are used in the %
%     burn, and the thrust direction is defined by roll and angle of %
%     attack relative to the velocity.                               %
%   - Aerodynamic forces assumed to be negligible and are ignored    %
% ------------------------------------------------------------------ %
clearvars
close all
clc

%------------------------------------------------------------------------%
%------------------- Provide Auxiliary Data for Problem -----------------%
%------------------------------------------------------------------------%

%------------------------------------------------------------------------%
% ------------------------------- Global ------------------------------- %
%------------------------------------------------------------------------%
Re               = 6378166.000;     % Earth's equatorial radius [m]
w                = 7.292115e-5;     % Earth's rotation rate [rad/sec]
mu               = 3.98600442e14;   % Earth's gravitational constant [m^3/sec^2]
g0               = 9.80665;         % mass to weight conversion factor [m/sec^2]
S                = 249.9;           % aerodynamic reference area [m^2]
mShuttle         = 92079.2;         % return mass of shuttle [kg]
mETempty         = 26535.1;           % empty mass of ET [kg]
auxdata.Re       = Re;
auxdata.w        = w;
auxdata.mu       = mu;
auxdata.g0       = g0;
auxdata.S        = S;
auxdata.mShuttle = mShuttle;
auxdata.mETempty = mETempty;
%------------------------------------------------------------------------%
% ------------------------------ Phase 1 ------------------------------- %
%------------------------------------------------------------------------%
auxdata.FvacSSME = 213188*g0; % Vacuum thrust of SSME [N]
auxdata.IspSSME  = 455.15;    % Vacuum specific impulse of SSME [sec]
auxdata.AeSSME   = 4.17055;   % Nozzle exit area of SSME [m^2]
auxdata.KmaxSSME = 1.09;      % Maximum throttle setting of SSME

% --- lift and drag coefficients (Stage II: trig fit) --- %
% (uses alternate body frame defined by Betts in his stage II ascent paper)
auxdata.clm = [10.27573018 -2.510577161 .2693040532 ...
               3.407056328 .2358657940 .04273683824 ...
               -10.66992871 2.562677918 -.2777210471]; %lift coef.

auxdata.cdm = [5.843066454 2.712861119 -.06602454483 ...
               -.2431101587 .1959055632 -.012459511135 ...
               -5.740226972 -2.593918270 .07108121429]; %drag coef.

%------------------------------------------------------------------------%
% -------------------------- Phases 2 - 4 ------------------------------ %
%------------------------------------------------------------------------%
auxdata.FvacOMS = 2721.6*g0; % vacuum thrust of Orbital Maneuvering Engines (OMS) [N]
auxdata.IspOMS  = 316;       % vacuum specific impulse of OMS [sec]

%------------------------------------------------------------------------%
%--------------------------- Boundary Conditions ------------------------%
%------------------------------------------------------------------------%
%------------------------------------------------------------------------%
% ------------------------------ Phase 1 ------------------------------- %
%------------------------------------------------------------------------%
% ---- Initial Conditions (staging conditions at start of Phase 1) ----- %
%------------------------------------------------------------------------%
t0      = 126.1;          % staging time [sec]
h10     = 46447.588;      % altitude at t0 [m]
rad10   = h10+auxdata.Re;
lon10   = -120.74*pi/180; % longitude at t0 [rad]
lat10   = 34.1*pi/180;    % geocentric latitude at t0 [rad]
speed10 = 1384.7;         % Earth relative speed at t0 [m/sec]
fpa10   = 26.409*pi/180;  % flight path angle at t0 [rad]
head10  = 259*pi/180;     % heading at t0 [rad]
m10     = 675702.8;       % mass at t0 [kg]

%------------------------------------------------------------------------%
% --------------------- Final Conditions (MECO) ------------------------ %
%------------------------------------------------------------------------%
h1f           = 105564.1;       % altitude (above spherical Earth) at MECO [m]
rad1f         = h1f+auxdata.Re; % distance from Earth's center at MECO [m]
speedInert1f  = 7734.0;         % inertial speed at MECO [m/sec]
fpaInert1f    = .65*pi/180;     % inertial flight path angle at MECO [rad]
inclination1f = 98*pi/180;      % inclination at first equatorial crossing [rad]

%------------------------------------------------------------------------%
% ----------------------------- Phase 2  ------------------------------- %
%------------------------------------------------------------------------%
rad20 = rad1f; %distance from Earth's center at MECO [m]

%------------------------------------------------------------------------%
% ----------------------------- Phase 4  ------------------------------- %
%------------------------------------------------------------------------%
% -------------------------- Desired Orbit ----------------------------- %
%------------------------------------------------------------------------%
h4f           = 203720;         % altitude (above spherical Earth) [m]
rad4f         = h4f+auxdata.Re; % distance from Earth's center [m]
speedInert4f  = sqrt(auxdata.mu/rad4f); % inertial speed for a circular orbit [m/sec]
fpaInert4f    = 0;              % inertial flight path angle for a circular orbit [rad]
inclination4f = 98*pi/180;      % inclination of orbit [rad]

%------------------------------------------------------------------------%
%--------------------------- Limits on Variables ------------------------%
%------------------------------------------------------------------------%
%------------------------------------------------------------------------%
% ------------------------------ Phase 1 ------------------------------- %
%------------------------------------------------------------------------%
t1Min     = t0;          t1Max     = 1000;
rad1Min   = auxdata.Re;  rad1Max   = rad1Min+121920; %atmos. data limited to this altitude
lon1Min   = lon10-2*pi;  lon1Max   = lon10+2*pi;
lat1Min   = -89*pi/180;  lat1Max   = lat10;
speed1Min = 609.6;       speed1Max = 15240; %speedMin must be above speed of sound always
fpa1Min   = -89*pi/180;  fpa1Max   = 89*pi/180;
head1Min  = 0;           head1Max  = 4*pi;
aoa1Min   = -30*pi/180;  aoa1Max   = 0*pi/180; %CD and CL data given are limited to this range
w11Min    = -1.3;        w11Max    = 1.3;
w21Min    = -1.3;        w21Max    = 1.3;
kMin      = 0;           kMax      = auxdata.KmaxSSME;
m1Min     = auxdata.mShuttle + auxdata.mETempty;  % [kg]
m1Max     = m10;       %starting mass [kg]

%------------------------------------------------------------------------%
% ------------------------------ Phase 2 ------------------------------- %
%------------------------------------------------------------------------%
t2Min     = t0;          t2Max     = 3000;
rad2Min   = rad1f;       rad2Max   = rad4f+100;
lon2Min   = lon10-2*pi;  lon2Max   = lon10+2*pi;
lat2Min   = -89*pi/180;  lat2Max   = 89*pi/180;
speed2Min = 609.6;       speed2Max = 15240;
fpa2Min   = -89*pi/180;  fpa2Max   = 89*pi/180;
head2Min  = -2*pi;       head2Max  = 4*pi;
aoa2Min   = 0.1*pi/180;  aoa2Max   = 90*pi/180; % test lower aoa2min vals
w12Min    = -1.3;        w12Max    = 1.3;
w22Min    = -1.3;        w22Max    = 1.3;

% --- mass constraints --- %
m2Min = auxdata.mShuttle; % [kg]
m2Max = 181437; %mass should start at ~113398 kg

%------------------------------------------------------------------------%
% ------------------------------ Phase 3 ------------------------------- %
%------------------------------------------------------------------------%
t3Min     = t0;          t3Max     = 6000;
rad3Min   = rad1f;       rad3Max   = rad4f;
lon3Min   = lon10-2*pi;  lon3Max   = lon10+2*pi;
lat3Min   = -89*pi/180;  lat3Max   = 89*pi/180;
speed3Min = 609.6;       speed3Max = 15240;
fpa3Min   = -89*pi/180;  fpa3Max   = 89*pi/180;
head3Min  = -2*pi;       head3Max  = 4*pi;
m3Min     = auxdata.mShuttle; % [kg]
m3Max     = 181437; %mass should start at ~141294 kg

%------------------------------------------------------------------------%
% ------------------------------ Phase 4 ------------------------------- %
%------------------------------------------------------------------------%
t4Min     = t0;          t4Max     = 6000;
rad4Min   = rad1f;       rad4Max   = rad4f;
lon4Min   = lon10-2*pi;  lon4Max   = lon10+2*pi;
lat4Min   = -89*pi/180;  lat4Max   = 89*pi/180;
speed4Min = 609.6;       speed4Max = 15240;
fpa4Min   = -89*pi/180;  fpa4Max   = 89*pi/180;
head4Min  = -2*pi;       head4Max  = 4*pi;
aoa4Min   = 0.1*pi/180;  aoa4Max   = 90*pi/180;
w14Min    = -1.3;        w14Max    = 1.3;
w24Min    = -1.3;        w24Max    = 1.3;
m4Min     = auxdata.mShuttle; % [kg]
m4Max     = 181437; %mass should start at ~141294 kg

%------------------------------------------------------------------------%
%----------------- Provide Bounds and Guess for Each Phase --------------%
%------------------------------------------------------------------------%
%------------------------------------------------------------------------%
%--------------------------- Phase 1 Bounds -----------------------------%
%------------------------------------------------------------------------%
iphase = 1;
bounds.phase(iphase).initialtime.lower = t0;
bounds.phase(iphase).initialtime.upper = t0;
bounds.phase(iphase).finaltime.lower = t1Min;
bounds.phase(iphase).finaltime.upper = t1Max;
bounds.phase(iphase).initialstate.lower = [rad10, lon10, lat10, speed10, fpa10, head10, m10];
bounds.phase(iphase).initialstate.upper = [rad10, lon10, lat10, speed10, fpa10, head10, m10];
bounds.phase(iphase).state.lower = [rad1Min, lon1Min, lat1Min, speed1Min, fpa1Min, head1Min, m1Min];
bounds.phase(iphase).state.upper = [rad1Max, lon1Max, lat1Max, speed1Max, fpa1Max, head1Max, m1Max];
bounds.phase(iphase).finalstate.lower = [rad1f, lon1Min, lat1Min, speed1Min, fpa1Min, head1Min, m1Min];
bounds.phase(iphase).finalstate.upper = [rad1f, lon1Max, lat1Max, speed1Max, fpa1Max, head1Max, m1Max];
bounds.phase(iphase).control.lower = [aoa1Min, w11Min, w21Min];
bounds.phase(iphase).control.upper = [aoa1Max, w11Max, w21Max];
bounds.phase(iphase).path.lower = 1;
bounds.phase(iphase).path.upper = 1; % [w1^2+w2^2]
%------------------------------------------------------------------------%
%--------------------------- Phase 1 Guess ------------------------------%
%------------------------------------------------------------------------%
tGuess              = [0; 1000];
radGuess            = [rad10; rad1f];
lonGuess            = [lon10; lon10-10*pi/180];
latGuess            = [lat10; lat10-10*pi/180];
speedGuess          = [speed10; speedInert1f];
fpaGuess            = [fpa10; fpaInert1f];
headGuess           = [head10; head10];
mGuess              = [m10; m10/4];
aoaGuess            = [0; 0];
w1Guess             = [1; 1];
w2Guess             = [0; 0];
guess.phase(iphase).control = [aoaGuess, w1Guess, w2Guess];
guess.phase(iphase).time    = tGuess;
guess.phase(iphase).state   = [radGuess, lonGuess, latGuess, speedGuess, fpaGuess, headGuess, mGuess];

%------------------------------------------------------------------------%
%-------------------------- Phase 2 Bounds ------------------------------%
%------------------------------------------------------------------------%
iphase = 2;
bounds.phase(iphase).initialtime.lower = t1Min;
bounds.phase(iphase).initialtime.upper = t1Max;
bounds.phase(iphase).finaltime.lower = t2Min;
bounds.phase(iphase).finaltime.upper = t2Max;
bounds.phase(iphase).initialstate.lower = [rad20, lon2Min, lat2Min, speed2Min, fpa2Min, head2Min, m2Min];
bounds.phase(iphase).initialstate.upper = [rad20, lon2Max, lat2Max, speed2Max, fpa2Max, head2Max, m2Max];
bounds.phase(iphase).state.lower = [rad2Min, lon2Min, lat2Min, speed2Min, fpa2Min, head2Min, m2Min];
bounds.phase(iphase).state.upper = [rad2Max, lon2Max, lat2Max, speed2Max, fpa2Max, head2Max, m2Max];
bounds.phase(iphase).finalstate.lower = [rad2Min, lon2Min, lat2Min, speed2Min, fpa2Min, head2Min, m2Min];
bounds.phase(iphase).finalstate.upper = [rad2Max, lon2Max, lat2Max, speed2Max, fpa2Max, head2Max, m2Max];
bounds.phase(iphase).control.lower = [aoa2Min, w12Min, w22Min];
bounds.phase(iphase).control.upper = [aoa2Max, w12Max, w22Max];
bounds.phase(iphase).path.lower = 1;
bounds.phase(iphase).path.upper = 1; % [w1^2+w2^2]
%------------------------------------------------------------------------%
%---------------------------- Phase 2 Guess -----------------------------%
%------------------------------------------------------------------------%
tGuess              = [491; 750];
radGuess            = [rad20; rad4f];
lonGuess            = [lon10; lon10-20*pi/180];
latGuess            = [lat10; lat10-20*pi/180];
speedGuess          = [speedInert1f; speedInert1f];
fpaGuess            = [fpaInert1f; 0];
headGuess           = [head10; head10];
mGuess              = [113398; 111130]; % [kg]
aoaGuess            = [0; 0];
w1Guess             = [1; 1];
w2Guess             = [0; 0];
guess.phase(iphase).control = [aoaGuess, w1Guess, w2Guess];
guess.phase(iphase).time    = tGuess;
guess.phase(iphase).state   = [radGuess, lonGuess, latGuess, speedGuess, fpaGuess, headGuess, mGuess];

%------------------------------------------------------------------------%
%--------------------------- Phase 3 Bounds -----------------------------%
%------------------------------------------------------------------------%
iphase = 3;
bounds.phase(iphase).initialtime.lower = t2Min;
bounds.phase(iphase).initialtime.upper = t2Max;
bounds.phase(iphase).finaltime.lower = t3Min;
bounds.phase(iphase).finaltime.upper = t3Max;
bounds.phase(iphase).initialstate.lower = [rad3Min, lon3Min, lat3Min, speed3Min, fpa3Min, head3Min, m3Min];
bounds.phase(iphase).initialstate.upper = [rad3Max, lon3Max, lat3Max, speed3Max, fpa3Max, head3Max, m3Max];
bounds.phase(iphase).state.lower = [rad3Min, lon3Min, lat3Min, speed3Min, fpa3Min, head3Min, m3Min];
bounds.phase(iphase).state.upper = [rad3Max, lon3Max, lat3Max, speed3Max, fpa3Max, head3Max, m3Max];
bounds.phase(iphase).finalstate.lower = [rad3Min, lon3Min, lat3Min, speed3Min, fpa3Min, head3Min, m3Min];
bounds.phase(iphase).finalstate.upper = [rad3Max, lon3Max, lat3Max, speed3Max, fpa3Max, head3Max, m3Max];
%------------------------------------------------------------------------%
%---------------------------- Phase 3 Guess -----------------------------%
%------------------------------------------------------------------------%
tGuess              = [750; 1000];
radGuess            = [rad20; rad4f];
lonGuess            = [lon10; lon10-40*pi/180];
latGuess            = [lat10; lat10-40*pi/180];
speedGuess          = [speedInert1f; speedInert1f];
fpaGuess            = [0; 0];
headGuess           = [head10; head10];
mGuess              = [111130; 111130]; % [kg]
guess.phase(iphase).time    = tGuess;
guess.phase(iphase).state   = [radGuess, lonGuess, latGuess, speedGuess, fpaGuess, headGuess, mGuess];

iphase = 4;
%------------------------------------------------------------------------%
%--------------------------- Phase 4 Bounds -----------------------------%
%------------------------------------------------------------------------%
bounds.phase(iphase).initialtime.lower = t3Min;
bounds.phase(iphase).initialtime.upper = t3Max;
bounds.phase(iphase).finaltime.lower = t4Min;
bounds.phase(iphase).finaltime.upper = t4Max;
bounds.phase(iphase).initialstate.lower = [rad4Min, lon4Min, lat4Min, speed4Min, fpa4Min, head4Min, m4Min];
bounds.phase(iphase).initialstate.upper = [rad4Max, lon4Max, lat4Max, speed4Max, fpa4Max, head4Max, m4Max];
bounds.phase(iphase).state.lower = [rad4Min, lon4Min, lat4Min, speed4Min, fpa4Min, head4Min, m4Min];
bounds.phase(iphase).state.upper = [rad4Max, lon4Max, lat4Max, speed4Max, fpa4Max, head4Max, m4Max];
bounds.phase(iphase).finalstate.lower = [rad4f, lon4Min, lat4Min, speed4Min, fpa4Min, head4Min, m4Min];
bounds.phase(iphase).finalstate.upper = [rad4f, lon4Max, lat4Max, speed4Max, fpa4Max, head4Max, m4Max];
bounds.phase(iphase).control.lower = [aoa4Min, w14Min, w24Min];
bounds.phase(iphase).control.upper = [aoa4Max, w14Max, w24Max];
bounds.phase(iphase).path.lower = 1;
bounds.phase(iphase).path.upper = 1; % [w1^2+w2^2]

%------------------------------------------------------------------------%
%---------------------------- Phase 4 Guess -----------------------------%
%------------------------------------------------------------------------%
tGuess              = [2000; 2500];
radGuess            = [rad4f; rad4f];
lonGuess            = [lon10; lon10-70*pi/180];
latGuess            = [lat10; lat10-70*pi/180];
speedGuess          = [speedInert4f; speedInert4f];
fpaGuess            = [0; 0];
headGuess           = [head10; head10];
mGuess              = [111130; 108862]; % [kg]
aoaGuess            = [0; 0];
w1Guess             = [1; 1];
w2Guess             = [0; 0];
guess.phase(iphase).control = [aoaGuess, w1Guess, w2Guess];
guess.phase(iphase).time    = tGuess;
guess.phase(iphase).state   = [radGuess, lonGuess, latGuess, speedGuess, fpaGuess, headGuess, mGuess];

%------------------------------------------------------------------------%
%------------------------ Set up Event Constraints ----------------------%
%------------------------------------------------------------------------%
%------------------------------------------------------------------------%
%--------------------------- Special Events -----------------------------%
%------------------------------------------------------------------------%
bounds.eventgroup(1).lower = [speedInert1f, fpaInert1f, inclination1f]; 
bounds.eventgroup(1).upper = [speedInert1f, fpaInert1f, inclination1f]; %MECO conditions
bounds.eventgroup(2).lower = [speedInert4f, fpaInert4f, inclination4f];
bounds.eventgroup(2).upper = [speedInert4f, fpaInert4f, inclination4f]; %Payload Orbit Conditions

%------------------------------------------------------------------------%
%----------------------- Phase Linking Events ---------------------------%
%------------------------------------------------------------------------%
bounds.eventgroup(3).lower = [zeros(1,6), -auxdata.mETempty, 0];
bounds.eventgroup(3).upper = [zeros(1,6), -auxdata.mETempty, 0];
bounds.eventgroup(4).lower = zeros(1,8);
bounds.eventgroup(4).upper = zeros(1,8);
bounds.eventgroup(5).lower = zeros(1,8);
bounds.eventgroup(5).upper = zeros(1,8);
% force phase elapsed time(s) to be non-zero
%bounds.eventgroup(6).lower = [1,1,1,1];
%bounds.eventgroup(6).upper = [inf,inf,inf,inf];

%------------------------------------------------------------------------%
%------------ Provide Mesh Refinement Method and Initial Mesh -----------%
%------------------------------------------------------------------------%
mesh.method          = 'hp-LiuRao-Legendre';
mesh.tolerance       = 1e-4;
mesh.maxiterations   = 20;
mesh.colpointsmin    = 3;
mesh.colpointsmax    = 20;
N                    = 10;
for i = 1:4
    mesh.phase(i).colpoints = 4*ones(1,N);
    mesh.phase(i).fraction  = 1/N*ones(1,N);
end

%------------------------------------------------------------------------%
%------------- Configure Setup Using the Information Provided -----------%
%------------------------------------------------------------------------%
setup.name                           = 'Shuttle To Orbit';
setup.functions.continuous           = @rlvAscentContinuous;
setup.functions.endpoint             = @rlvAscentEndpoint;
setup.adigatorgrd.continuous         = @rlvAscentContinuousADiGatorGrd;
setup.adigatorgrd.endpoint           = @rlvAscentEndpointADiGatorGrd;
setup.adigatorhes.continuous         = @rlvAscentContinuousADiGatorHes;
setup.adigatorhes.endpoint           = @rlvAscentEndpointADiGatorHes;
setup.auxdata                        = auxdata;
setup.bounds                         = bounds;
setup.guess                          = guess;
setup.mesh                           = mesh;
setup.displaylevel                   = 2;
setup.nlp.solver                     = 'ipopt';
setup.nlp.ipoptoptions.tolerance     = 1e-4;
setup.nlp.ipoptoptions.linear_solver = 'ma57';
setup.derivatives.supplier           = 'adigator';
setup.derivatives.derivativelevel    = 'second';
setup.derivatives.dependencies       = 'sparseNaN';
setup.scales.method                  = 'automatic-guessUpdate';
setup.method                         = 'RPM-Differentiation';

%------------------------------------------------------------------------%
%---------------------- Solve Problem Using GPOPS II --------------------%
%------------------------------------------------------------------------%
adigatorfilenames = adigatorGenFiles4gpops2(setup);

output = gpops2(setup);
