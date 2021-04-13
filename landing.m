function [S_land, G_run, Vs_knots, S_tot] = landing(W, flaps)
%% Variables
p = 101325; %pressure in pascals
d = 1.225; % density at sea level kg/m^3
A = 31.25; %wing area in m^2
Cl_max= 1.5; %cl max according to airfoil tools, around 20 AoA
Cd = 0.015; %Cd from initial sizing sheet
MW_landing = 15570; %use 15158 for 28 seat, for 35 seat use 15570, in kg
mu = 0.45; %best braking conditions, coefficent of braking
g = 9.81; %acceleration due to gravity
span = 18.5; %wing span
Cl = 0; %default

% Flap settings
%delta Cl = 0.8 at 60 degrees deflection
Cl_flaps10 = Cl_max + (0.8 * (10/60));
Cl_flaps20 = Cl_max + (0.8 * (20/60));
Cl_flaps30 = Cl_max + (0.8 * (30/60));
% http://wpage.unina.it/fabrnico/DIDATTICA/PGV_2012/MAT_DID_CORSO/09_Progetto_Ala/Wing_Design_Sadraey.pdf
if flaps == 0
    Cl = Cl_max;
elseif flaps == 1
    Cl = Cl_flaps10;
elseif flaps == 2
    Cl = Cl_flaps20;
elseif flaps == 3
    Cl = Cl_flaps30;
else
    fprintf("invalid flap setting");
end
    

%% Area Calculations
WRT = 0.12 * 2.143; % wing root thickness
WTT = 0.12 *  0.965; % wing tip thickness
FA = pi * (0.5 * 2.5)^2; %fuselage area
A_csa = (2 * (0.5 * (0.5 * span) * (WRT + WTT))) + FA; %front cross sectional area


%% Weight defaulting, defaults to MLW if 0 is given as an input
if W == 0
   fprintf("no weight value assinged, using MLW");
   W = MW_landing * g;
else 
    W = W * g;
end


%% Stall and velocity calculations
V_stall = sqrt((2 * W) / (d * A * Cl));
V_app = 1.3 * V_stall;
V_tran = 0.95 * V_app;
V_land = 0.95 * V_tran;
Vs_knots = V_stall * 1.944;

%% Lift Calculation
L = Cl * ((d * V_app^2) / 2) * A;

%% Landing distance from a clearance height of 50ft to ground, equation from performace sheet
D_eff = 0.5 * d * V_app^2 * Cd * A_csa;
S_land = (D_eff/L) * (15.24 + ((V_app^2 - V_land^2)) / 2 * g);

%% Ground Run
G_run = V_land^2 / (2 * mu * g);

%% Total landing distance
S_tot = G_run + S_land;

end