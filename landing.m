
function [Sa_land, S_land, G_run, V_stall, V_app, V_tran, V_land] = landing(W)
%% Variables
p = 101325; %pressure in pascals
d = 1.225; % density at sea level kg/m^3
A = 31.25; %wing area in m^2
Cl_max = 1.5; %cl max according to airfoil tools, around 20 AoA AoA
Cd = 0.015; %Cd from initial sizing sheet
MW_landing = 15570; %use 15158 for 28 seat, for 35 seat use 15570, in kg
mu = 0.45; %best braking conditions, coefficent of braking
g = 9.81; %acceleration due to gravity
span = 18.5; %wing span

%% Area Calculations
WRT = 0.12 * 2.143; % wing root thickness
WTT = 0.12 *  0.965; % wing tip thickness
FA = pi * (0.5 * 2.5)^2; %fuselage area
A_csa = (2 * (0.5 * (0.5 * span) * (WRT + WTT))) + FA; %front cross sectional area

%% Weight defaulting
if W == 0
   fprintf("no weight value assinged, using MLW");
   W = MW_landing;
end
    
%% Stall and velocity calculation
V_stall = sqrt((2 * W) / (d * A * Cl_max));
V_app = 1.3 * V_stall;
V_tran = 0.95 * V_app;
V_land = 0.95 * V_tran;

%% Lift Calculation
L = Cl_max * ((d * V_app^2) / 2) * A;

%% First order approximation
Sa_land = 0.3 * V_app^2; %approximation in meters

%% Landing distance from a clearance height of 50ft
D_eff = 0.5 * d * V_app^2 * Cd * A_csa;
S_land = (D_eff / L) * (50 + (V_app^2 - V_land^2) / 2 * g);

%% Ground Run
G_run = V_land^2 / (2 * mu * g);

%% Graphing landing Approximation

figure(1)
clf
App_Vx = [-290, 0]; %approach x
App_Vy = [15.24, 0]; %approach y
rwx = [0 750]; %runway x
rwy = [-2 -2]; %runway x
L_point = [0 0]; %landing point
L_approx = [Sa_land 0]; %landing distance approx
txt1 = 'Landing approximation with 3 degree aproach vector \newline starting at 15.24m';

hold on;
p = plot(rwx, rwy, App_Vx, App_Vy, '--b', L_approx, L_point, 'red');
text(0,100,txt1,'HorizontalAlignment','left');
xlim([-290 750]);
ylim([-10 250]);
p(1).LineWidth = 3;
p(1).Color = 'black';
p(3).LineWidth = 2;
title('Landing Approximation');
xlabel('Distance (Meters)');
ylabel('Altitude (Meters)');
hold off

%% Graphing landing
figure(2)
clf
App_Vx = [-290, 0]; %approach x
App_Vy = [15.24, 0]; %approach y
rwx = [0 750]; %runway x
rwy = [-2 -2]; %runway x
L_point = [0 0]; %landing point
L_dis = [S_land 0]; %landing distance approx
txt2 = 'Landing calculation with 3 degree aproach vector \newline starting at 15.24m';

hold on
p = plot(rwx, rwy, App_Vx, App_Vy, '--b', L_dis, L_point, 'red');
text(0,100,txt2,'HorizontalAlignment','left');
xlim([-290 750]);
ylim([-10 250]);
p(1).LineWidth = 3;
p(1).Color = 'black';
p(3).LineWidth = 2;
title('Landing, Accurate');
xlabel('Distance (Meters)');
ylabel('Altitude (Meters)');
hold off

%% Graphing ground run
figure(3)
clf
rwx = [0 750]; %runway x
rwy = [-2 -2]; %runway x
L_point = [0 0]; %landing point
L_gr = [G_run 0]; %landing distance approx
txt3 = 'Ground run calculation';

hold on
p = plot(rwx, rwy, App_Vx, App_Vy, '--b', L_gr, L_point, 'red');
text(0,100,txt3,'HorizontalAlignment','left');
xlim([-290 750]);
ylim([-10 250]);
p(1).LineWidth = 3;
p(1).Color = 'black';
p(3).LineWidth = 2;
title('Ground Run Distance');
xlabel('Distance (Meters)');
ylabel('Altitude (Meters)');
hold off

end