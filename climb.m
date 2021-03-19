function [C_a] = climb(W)
%% Variables
p = 101325; %pressure in pascals
d = 1.225; % density at sea level kg/m^3
A = 31.25; %wing area in m^2
Cl_max = 1.5; %cl max according to airfoil tools, around 20 AoA AoA
Cd = 0.015; %Cd from initial sizing sheet
MTOW = 15580; %Max take off weight
g = 9.81; %acceleration due to gravity
span = 18.5; %wing span
Eng_Power = 1625000; %Watts at sea lvl per engine
T = 18450; % static thrust per engine sea lvl

%% Weight defaulting, defaults to MLW if 0 is given as an input
if W == 0
   fprintf("no weight value assinged, using MTOW");
   W = MTOW;
end

%% Velocity Calculation
V = T - D

%% rate of climb
ROC = T - 



end