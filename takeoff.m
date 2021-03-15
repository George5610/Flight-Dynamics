function [S_g] = takeoff(W)
%% Variables
p = 101325; %pressure in pascals
d = 1.225; % density at sea level kg/m^3
A = 31.25; %wing area in m^2
Cl_max = 1.5; %cl max according to airfoil tools, around 20 AoA
Cd = 0.015; %Cd from initial sizing sheet
MTOW = 15580; %Max take off weight
mu = 0.45; %best braking conditions, coefficent of braking
g = 9.81; %acceleration due to gravity
span = 18.5; %wing span
T = 18450; % static thrust per engine sea lvl
%% Weight defaulting, defaults to MLW if 0 is given as an input
if W == 0
   fprintf("no weight value assinged, using MTOW");
   W = MTOW;
end

%% Area Calculations
WRT = 0.12 * 2.143; % wing root thickness
WTT = 0.12 *  0.965; % wing tip thickness
FA = pi * (0.5 * 2.5)^2; %fuselage area
A_csa = (2 * (0.5 * (0.5 * span) * (WRT + WTT))) + FA; %front cross sectional area
%% Stall and velocity calculations
V_stall = sqrt((2 * W) / (d * A * Cl_max));
V_rot = 1.05 * V_stall;
V_lof = 1.1 * V_stall;
V_tos = 1.2 * V_stall;

%% Lift Calculation
Lift = Cl_max * ((d * V_lof^2) / 2) * A;

%% Drag Calculation
drag = 0.5 * d * V_lof^2 * Cd * A_csa;

%% Ground Run
S_g = (-W/(d * g * A_csa)) * (1/(Cd - (mu * Cl_max))) * log(1 - ((Cd - mu * Cl_max) / ((T/W)-mu) * Cl_max));

%% Graphing
figure(1)
clf
rwx = [0 750]; %runway x
rwy = [-2 -2]; %runway y
S_point = [0 0]; %starting point
Dis = [0 S_g]; %takeoff distance
TOVy = [0 15.24]; %takeoff vector
TOVx = [S_g 290+S_g]; %takeoff vector for 3 degree climb
txt1 = 'Take off distance';

hold on;
p = plot(rwx, rwy, TOVx, TOVy, '--b', Dis, S_point, 'red');
text(0,50,txt1,'HorizontalAlignment','left');
xlim([-290 750]);
ylim([-10 100]);
p(1).LineWidth = 3;
p(1).Color = 'black';
p(2).LineWidth = 2;
title('Take off path');
xlabel('Distance (Meters)');
ylabel('Altitude (Meters)');
hold off
end