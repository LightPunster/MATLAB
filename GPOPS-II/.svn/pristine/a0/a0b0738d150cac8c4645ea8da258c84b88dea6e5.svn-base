function output = ToOrbitEndpoint(input)
%This function computes the value of the objective function and the Events.
%
%Input:
%       input  - A structure with the fields phase, auxdata, and parameter.
%                For more information, please refer to the GPOPS-II user's
%                guide.
%Output:
%       output - A structure with the fields objective and eventgroup. For 
%                more information, please refer to the GPOPS-II user's 
%                guide.
%________________________________________________________________________%


%------------------------------------------------------------------------%
%------------------- Extract Phase and Auxiliary Data -------------------%
%------------------------------------------------------------------------%

% --- Phase data --- %
%Variables at Start and Terminus of Phase 1
t0phase1 = input.phase(1).initialtime;
tfphase1 = input.phase(1).finaltime;
x0phase1 = input.phase(1).initialstate;
xfphase1 = input.phase(1).finalstate;
% Variables at Start and Terminus of Phase 2
t0phase2 = input.phase(2).initialtime;
tfphase2 = input.phase(2).finaltime;
x0phase2 = input.phase(2).initialstate;
xfphase2 = input.phase(2).finalstate;
% Variables at Start and Terminus of Phase 3
t0phase3 = input.phase(3).initialtime;
tfphase3 = input.phase(3).finaltime;
x0phase3 = input.phase(3).initialstate;
xfphase3 = input.phase(3).finalstate;
% Variables at Start and Terminus of Phase 4
t0phase4 = input.phase(4).initialtime;
tfphase4 = input.phase(4).finaltime;
x0phase4 = input.phase(4).initialstate;
xfphase4 = input.phase(4).finalstate;

% --- auxiliary data --- %
w  = [0; 0; input.auxdata.w]; %ECI coordinates {I;J;K}

%------------------------------------------------------------------------%
%-------------------- Calculate Events and Objective --------------------%
%------------------------------------------------------------------------%

%========================%
% --- Linkage Events --- %
%========================%
% Event Group 3:  Linkage Constraints Between Phases 1 and 2
output.eventgroup(3).event = [x0phase2(1:7)-xfphase1(1:7), t0phase2-tfphase1];
% Event Group 4:  Linkage Constraints Between Phases 2 and 3
output.eventgroup(4).event = [x0phase3(1:7)-xfphase2(1:7), t0phase3-tfphase2];
% Event Group 5:  Linkage Constraints Between Phases 3 and 4
output.eventgroup(5).event = [x0phase4(1:7)-xfphase3(1:7), t0phase4-tfphase3];

% --- Force each phase to take a non-zero time --- %
% Event Group 6
%output.eventgroup(6).event = [tfphase1-t0phase1, tfphase2-t0phase2, tfphase3-t0phase3, tfphase4-t0phase4];

%========================%
% --- Special Events --- %
%========================%
% Event Group 1:  Conditions for MECO
% --- initial and final time --- %
t0 = input.phase(1).initialtime;
t1 = input.phase(1).finaltime;

% --- final state --- %
rad1f   = input.phase(1).finalstate(1);
lon1f   = input.phase(1).finalstate(2);
lat1f   = input.phase(1).finalstate(3);
speed1f = input.phase(1).finalstate(4); %Earth relative speed
fpa1f   = input.phase(1).finalstate(5);
head1f  = input.phase(1).finalstate(6);
%m1f     = input.phase(1).finalstate(7);

% --- Determine r1 and vRel1 in terms of ECI coordinates --- %
theta1 = lon1f+w(3)*(t1-t0); %local sidereal time (Greenwich sidereal time assumed to be 0 at t0)
r1 = rad1f.*[cos(lat1f)*cos(theta1);...
             cos(lat1f)*sin(theta1);...
             sin(lat1f)];                 % [I;J;K]
vRel1 = speed1f.*[sin(fpa1f)*cos(lat1f)*cos(theta1)-cos(fpa1f)*cos(head1f)*...
                   sin(theta1)-cos(fpa1f)*sin(head1f)*sin(lat1f)*cos(theta1);...
                sin(fpa1f)*cos(lat1f)*sin(theta1)+cos(fpa1f)*cos(head1f)*...
                   cos(theta1)-cos(fpa1f)*sin(head1f)*sin(lat1f)*sin(theta1);...
                sin(fpa1f)*sin(lat1f)+cos(fpa1f)*sin(head1f)*cos(lat1f)];        % [I;J;K]

% --- Determine v1 and find its magnitude --- %
% (v1 = velocity as viewed from the inertial frame)
v1 = vRel1 + cross(w,r1);
speedInert1f = sqrt(v1.'*v1);

% --- Determine inertial fpa and inclination of orbit --- %
h1 = cross(r1,v1);
%localHorizontal1 = cross(h1,r1);
%fpaInert1f = acos((v1.'*localHorizontal1)/(speedInert1f*sqrt(localHorizontal1.'*localHorizontal1)));
fpaInert1f = asin(r1.'*v1./(speedInert1f.*sqrt(r1.'*r1)));
%if (r1.'*v1) < 0
%    fpaInert1f = -fpaInert1f;
%end    
inclination1f = acos(h1(3)/sqrt(h1.'*h1));

%Output Event Group 1
output.eventgroup(1).event = [speedInert1f, fpaInert1f, inclination1f];

      % - - - - - - - - - - end event group 1 - - - - - - - - - - %

% Event Group 2:  Conditions for final Orbit
% --- initial and final time --- %
t0 = input.phase(1).initialtime;
t4 = input.phase(4).finaltime;

% --- final state --- %
rad4f   = input.phase(4).finalstate(1);
lon4f   = input.phase(4).finalstate(2);
lat4f   = input.phase(4).finalstate(3);
speed4f = input.phase(4).finalstate(4); %Earth relative speed
fpa4f   = input.phase(4).finalstate(5);
head4f  = input.phase(4).finalstate(6);
%m4f     = input.phase(4).finalstate(7);

% --- Determine r4 and vRel4 in terms of ECI coordinates --- %
theta4 = lon4f+w(3)*(t4-t0); %local sidereal time (Greenwich sidereal time assumed to be 0 at t0)
r4 = rad4f.*[cos(lat4f)*cos(theta4);...
             cos(lat4f)*sin(theta4);...
             sin(lat4f)];               % [I;J;K]
vRel4 = speed4f.*[sin(fpa4f)*cos(lat4f)*cos(theta4)-cos(fpa4f)*cos(head4f)*...
                   sin(theta4)-cos(fpa4f)*sin(head4f)*sin(lat4f)*cos(theta4);...
                sin(fpa4f)*cos(lat4f)*sin(theta4)+cos(fpa4f)*cos(head4f)*...
                   cos(theta4)-cos(fpa4f)*sin(head4f)*sin(lat4f)*sin(theta4);...
                sin(fpa4f)*sin(lat4f)+cos(fpa4f)*sin(head4f)*cos(lat4f)];        % [I;J;K]

% --- Determine v4 and find its magnitude --- %
% (v4 = velocity as viewed from the inertial frame)
v4 = vRel4 + cross(w,r4);
speedInert4f = sqrt(v4.'*v4);

% --- Determine inertial fpa and inclination of orbit --- %
h4 = cross(r4,v4);
%localHorizontal4 = cross(h4,r4);
%argument = (v4.'*localHorizontal4)/(speedInert4f*sqrt(localHorizontal4.'*localHorizontal4));
%if argument > 1 %for some reason 1.000000000000000 > 1 in Matlab and yields a complex number when used in acos
%    argument = 1;
%end
%fpaInert4f = acos(argument);
fpaInert4f = asin(r4.'*v4./(speedInert4f.*sqrt(r4.'*r4)));
%if (r4.'*v4) < 0
%    fpaInert4f = -fpaInert4f;
%end    
inclination4f = acos(h4(3)/sqrt(h4.'*h4));

%Output Event Group 2
output.eventgroup(2).event = [speedInert4f, fpaInert4f, inclination4f];


%Compute the Cost
m4f = input.phase(4).finalstate(7);
output.objective = -m4f;
end