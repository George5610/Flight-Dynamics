function [Sa_land, S_land, G_run] = landing(W)

%%Variables
d = 101325; %density in pascals
A = 31.25; %wing area in m^2
Cl_max = 1.5; %cl max according to airfoil tools, around 20 AoA AoA
Cd = 0.015; %Cd from initial sizing sheet
MW_landing = 15158; %for 28 seat, for 35 seat use 15570, in kg
mu = 0.45; %best braking conditions
g = 9.81; %acceleration due to gravity
span = 18.5; %wing span

%%Area Calculations
WRT = 0.12 * 2.143; % wing root thickness
WTT = 0.12 *  0.965; % wing tip thickness
FA = pi * (0.5 * 2.5)^2; %fuselage area
A_csa = (2 * (0.5 * (0.5 * span) * (WRT + WTT))) + FA; %front cross sectional area

%%Weight calculation
if W > 0
    W = W;
else
   fprintf("no weight value assinged, using MLW");
   W = MW_landing;
end
    
%%Stall and velocity calculation
V_stall = sqrt((2 * W) / (d * A * Cl_max));
V_app = 1.3 * V_stall;
V_tran = 0.95 * V_app;
V_land = 0.95 * V_tran;

%%Lift Calculation
L = Cl_max * ((d * V_app^2) / 2) * A;
%% First order approximation
Sa_land_feet = 0.3 * V_app; %approximation in feet
Sa_land = Sa_land_feet * 0.3048; %conversion to meters

%%Landing distance from a clearance height of 50ft
D_eff = 0.5 * d * V_app^2 * Cd * A_csa;
S_land = (D_eff / L) * (50 + (V_app^2 - V_land^2) / 2 * g);

%% Ground Run

G_run = V_land^2 / (2 * mu * g);

end